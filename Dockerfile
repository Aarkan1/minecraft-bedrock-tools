# Start from a minimal Debian Linux image.
FROM debian:12-slim

# Install necessary tools:
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    zip \
    cron \
    procps \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user 'mc' to run the server for better security.
RUN useradd -m -s /bin/bash mc && \
    mkdir -p /data /scripts && \
    chown -R mc:mc /data /scripts

# Set the working directory to /data. All server files will live here.
WORKDIR /data

# 1. Smart Update Script - Only downloads when needed
COPY --chown=mc:mc <<-'EOF' /scripts/update.sh
#!/bin/bash
set -e

# Always ensure we're in the correct directory
cd /data

echo "🔎 Checking server status..."

# Function to get the latest version from Minecraft's official API
get_latest_version() {
    # Try the official Minecraft API first
    LATEST_VERSION=$(curl -s "https://api.minecraft.net/v1/download/latest" | jq -r '.downloads.bedrock_server.version' 2>/dev/null)
    
    # Fallback: Try scraping the download page
    if [[ -z "$LATEST_VERSION" || "$LATEST_VERSION" == "null" ]]; then
        echo "📡 Trying alternative method to get version..." >&2
        DOWNLOAD_URL=$(curl -sL https://www.minecraft.net/en-us/download/server/bedrock | grep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-[0-9\.]*\.zip' | head -n 1)
        if [[ ! -z "$DOWNLOAD_URL" ]]; then
            LATEST_VERSION=$(echo "$DOWNLOAD_URL" | grep -o '[0-9\.]*\.zip' | sed 's/\.zip//')
        fi
    fi
    
    # Final fallback: Use a known stable version
    if [[ -z "$LATEST_VERSION" || "$LATEST_VERSION" == "null" ]]; then
        echo "⚠️ Could not determine latest version, using fallback version..." >&2
        LATEST_VERSION="1.21.51.02"
    fi
    
    echo "$LATEST_VERSION"
}

# Get the latest version (needed for both first install and updates)
LATEST_VERSION=$(get_latest_version)

# Check if server executable exists
if [[ ! -f "/data/bedrock_server" ]]; then
    echo "📥 No server found, downloading for the first time..."
    NEED_DOWNLOAD=true
else
    echo "✅ Server executable found, checking version..."
    CURRENT_VERSION=$(cat /data/version.txt 2>/dev/null || echo "unknown")
    
    echo "Current version: $CURRENT_VERSION"
    echo "Latest version: $LATEST_VERSION"
    
    if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
        echo "👍 Server is already up to date."
        NEED_DOWNLOAD=false
    else
        echo "🔄 Version mismatch, update needed..."
        NEED_DOWNLOAD=true
    fi
fi

# Download and extract only if needed
if [[ "$NEED_DOWNLOAD" == "true" ]]; then
    echo "🔽 Downloading Bedrock server version: $LATEST_VERSION..."
    
    # Construct download URL
    DOWNLOAD_URL="https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-${LATEST_VERSION}.zip"
    
    # Download with retry logic
    for i in {1..3}; do
        if wget --header="Referer: https://www.minecraft.net/en-us/download/server/bedrock" --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" --timeout=30 --tries=3 -O bedrock.zip "$DOWNLOAD_URL"; then
            echo "📦 Download successful, extracting..."
            break
        else
            echo "❌ Download attempt $i failed..."
            if [[ $i -eq 3 ]]; then
                echo "💥 All download attempts failed. Cannot update server."
                # If we have an existing server, use it; otherwise exit
                if [[ ! -f "/data/bedrock_server" ]]; then
                    exit 1
                else
                    echo "🔄 Using existing server installation..."
                    exit 0
                fi
            fi
            sleep 5
        fi
    done
    
    # Enable debug mode for this section
    set -x
    
    # Extract server files (preserves existing worlds and configs)
    unzip -o bedrock.zip -d bedrock_server
    rm bedrock.zip

    # Copy over the worlds, permissions, server.properties, and allowlist.json
    cp -r /data/worlds/* /data/bedrock_server/worlds/
    cp -r /data/permissions.json /data/bedrock_server/permissions.json
    cp -r /data/server.properties /data/bedrock_server/server.properties
    cp -r /data/allowlist.json /data/bedrock_server/allowlist.json
    
    # Make sure the server is executable
    chmod +x bedrock_server
    
    # Save the version info
    echo "$LATEST_VERSION" > version.txt
    echo "✅ Server updated to version $LATEST_VERSION"
else
    echo "✅ Server is ready (no download needed)"
fi

# Ensure proper ownership
chown -R mc:mc /data
EOF

# 2. The Backup Script (same as before)
COPY --chown=mc:mc <<-'EOF' /scripts/backup.sh
#!/bin/bash

# Always ensure we're in the correct directory  
cd /data

MAX_BACKUPS=30
BACKUP_DIR="/data/backups"
SOURCE_DIR="/data/worlds"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="$BACKUP_DIR/backup-$TIMESTAMP.zip"

mkdir -p $BACKUP_DIR

if [ -z "$(ls -A $SOURCE_DIR 2>/dev/null)" ]; then
    echo "⏩ Worlds directory is empty, skipping backup."
    exit 0
fi

echo "🗜️ Backing up worlds to $ARCHIVE_NAME..."
zip -r "$ARCHIVE_NAME" "$SOURCE_DIR" > /dev/null

echo "🧹 Cleaning up old backups (keeping last $MAX_BACKUPS)..."
ls -tp "$BACKUP_DIR" | grep '\.zip$' | tail -n +$((MAX_BACKUPS + 1)) | xargs -I {} rm -- "$BACKUP_DIR/{}"
echo "✅ Backup complete"
EOF

# 3. The Main Run Script with auto-restart loop
COPY --chown=mc:mc <<-'EOF' /scripts/run.sh
#!/bin/bash
echo "🚀 Starting Minecraft Bedrock Server Manager..."

# Always ensure we're in the correct directory  
cd /data

# Set up trap for graceful shutdown
trap 'echo "🛑 Shutting down server..."; kill -SIGTERM $SERVER_PID 2>/dev/null; wait $SERVER_PID 2>/dev/null; exit 143' SIGTERM SIGINT

# Set up scheduled tasks for the mc user
echo "⏰ Setting up scheduled tasks..."
echo "*/20 * * * * /bin/bash /scripts/backup.sh" | crontab -u mc -
echo "0 * * * * /bin/bash /scripts/update.sh" | crontab -u mc -

# Main server loop
while true; do
    echo "🔄 Running update check..."
    /bin/bash /scripts/update.sh
    
    # Verify server files exist before starting
    if [[ ! -f /data/bedrock_server ]]; then
        echo "❌ Server executable not found after update check!"
        exit 1
    fi
    
    echo "🎮 Starting Minecraft Bedrock Server..."
    # Start server as mc user in background
    su -c "cd /data && LD_LIBRARY_PATH=. ./bedrock_server" mc &
    SERVER_PID=$!
    
    echo "✅ Server started with PID: $SERVER_PID"
    
    # Wait for server to stop
    wait $SERVER_PID
    EXIT_CODE=$?
    
    echo "⚠️ Server stopped with exit code: $EXIT_CODE"
    echo "🔄 Restarting in 5 seconds..."
    sleep 5
done
EOF

# Make all scripts executable
RUN chmod +x /scripts/*.sh

# Run initial update during build (downloads server if needed)
RUN /bin/bash /scripts/update.sh

# Simple entrypoint
ENTRYPOINT ["/bin/bash", "-c", "cron && /scripts/run.sh"]