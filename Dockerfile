# Start from a minimal Debian Linux image.
FROM debian:12-slim

# Install necessary tools:
# curl: to find the latest version URL
# wget: to download files
# unzip: to extract the server
# zip: to create backups
# cron: to schedule periodic tasks (backups, update checks)
# procps: for 'pkill' to gracefully restart the server for updates
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    zip \
    cron \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user 'mc' to run the server for better security.
# Also create the directories for the server data and our management scripts.
RUN useradd -m -s /bin/bash mc && \
    mkdir -p /data /scripts && \
    chown -R mc:mc /data /scripts

# Switch to the non-root user.
USER mc
# Set the working directory to /data. All server files will live here.
WORKDIR /data


# --- Embed Management Scripts ---
# We use 'COPY --chown' with a HEREDOC (<<-'EOF') to create script files
# inside the image owned by our 'mc' user.

# 1. The Update Script
COPY --chown=mc:mc <<-'EOF' /scripts/update.sh
#!/bin/bash
set -e
echo "🔎 Checking for latest server version..."

# Scrape the official Minecraft website to find the download URL for the Linux server.
DOWNLOAD_URL=$(curl -sL https://www.minecraft.net/en-us/download/server/bedrock | grep -o 'https://minecraft.azureedge.net/bin-linux/bedrock-server-[0-9\.]*\.zip' | head -n 1)

if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "❌ Could not find the latest version download URL. Exiting."
    # If the check fails, we still try to run with what we have.
    exit 0
fi

LATEST_VERSION=$(echo "$DOWNLOAD_URL" | grep -o '[0-9\.]*\.zip' | sed 's/\.zip//')
# Read the currently installed version from a file in our data volume.
CURRENT_VERSION=$(cat version.txt 2>/dev/null || echo "0.0.0")

echo "Latest version: $LATEST_VERSION | Current version: $CURRENT_VERSION"

# If versions match, there's nothing to do.
if [[ "$LATEST_VERSION" == "$CURRENT_VERSION" ]]; then
    echo "👍 Server is already up to date."
    exit 0
fi

echo "🔽 Downloading new version: $LATEST_VERSION..."
wget -qO bedrock.zip "$DOWNLOAD_URL"

# The unzip command will overwrite old server files but leave your 'worlds',
# 'server.properties', and other data files untouched.
echo "📦 Extracting server files..."
unzip -o bedrock.zip
rm bedrock.zip

# Save the new version number to our data volume for future checks.
echo "$LATEST_VERSION" > version.txt
echo "✅ Update to $LATEST_VERSION complete."
EOF

# 2. The Backup Script (keeps 30 backups at 20 min intervals)
COPY --chown=mc:mc <<-'EOF' /scripts/backup.sh
#!/bin/bash
MAX_BACKUPS=30
BACKUP_DIR="/data/backups"
SOURCE_DIR="/data/worlds"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="$BACKUP_DIR/backup-$TIMESTAMP.zip"

# Create the backups directory if it doesn't exist.
mkdir -p $BACKUP_DIR

if [ -z "$(ls -A $SOURCE_DIR 2>/dev/null)" ]; then
    echo "⏩ Worlds directory is empty, skipping backup."
    exit 0
fi

echo "Backing up worlds to $ARCHIVE_NAME..."
# Create a zip archive of the worlds folder.
zip -r "$ARCHIVE_NAME" "$SOURCE_DIR" > /dev/null

echo "Cleaning up old backups (keeping last $MAX_BACKUPS)..."
# Find all zip files, sort by time, skip the newest 30, and delete the rest.
ls -tp "$BACKUP_DIR" | grep '\.zip$' | tail -n +$((MAX_BACKUPS + 1)) | xargs -I {} rm -- "$BACKUP_DIR/{}"
EOF

# 3. The Main Run Script (Server Supervisor)
COPY --chown=mc:mc <<-'EOF' /scripts/run.sh
#!/bin/bash
# This script is the container's entrypoint. It supervises the server process.

# Set up a trap to gracefully shut down the server when the container is stopped.
trap 'echo "Stopping server..."; kill -SIGTERM $SERVER_PID; wait $SERVER_PID; exit 143' SIGTERM SIGINT

# Set up the scheduled tasks (cron jobs).
# This creates a crontab file that runs as the 'mc' user.
(crontab -l 2>/dev/null; echo "*/20 * * * * /bin/bash /scripts/backup.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 * * * * /bin/bash /scripts/check_and_restart.sh") | crontab -

# This is the main loop. If the server crashes or is stopped for an update,
# this loop will ensure it comes back online automatically.
while true; do
    # Run the update script every time before starting.
    # This ensures on the very first run, and after every restart, we have the latest version.
    /bin/bash /scripts/update.sh

    # Start the server in the background. The LD_LIBRARY_PATH is required by the executable.
    LD_LIBRARY_PATH=. ./bedrock_server &
    # Store the Process ID (PID) of the server.
    SERVER_PID=$!
    echo "✅ Server started with PID: $SERVER_PID"

    # Wait here until the server process stops for any reason.
    wait $SERVER_PID

    echo "Server process stopped. Restarting in 5 seconds..."
    sleep 5
done
EOF

# 4. The Update Check Script (for Cron)
COPY --chown=mc:mc <<-'EOF' /scripts/check_and_restart.sh
#!/bin/bash
# This script is run by cron every hour to check for updates.
echo "Running periodic update check..."
DOWNLOAD_URL=$(curl -sL https://www.minecraft.net/en-us/download/server/bedrock | grep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-[0-9\.]*\.zip' | head -n 1)
LATEST_VERSION=$(echo "$DOWNLOAD_URL" | grep -o '[0-9\.]*\.zip' | sed 's/\.zip//')
CURRENT_VERSION=$(cat /data/version.txt 2>/dev/null)

if [[ ! -z "$LATEST_VERSION" ]] && [[ "$LATEST_VERSION" != "$CURRENT_VERSION" ]]; then
    echo "A new version ($LATEST_VERSION) is available. Restarting server to apply update."
    # This command finds and terminates the running server process.
    # The main 'run.sh' script will then detect this, loop, and restart the server,
    # which automatically triggers the update script.
    pkill bedrock_server
fi
EOF

# Make all our scripts executable.
RUN chmod +x /scripts/*.sh

# Finally, set the entrypoint of the container to our main run script.
# We run this through a root script to start the cron service first.
# The actual server will still run as the 'mc' user.
ENTRYPOINT ["/bin/bash", "-c", "sudo cron && /scripts/run.sh"]