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

# Copy the script files from the scripts directory
COPY --chown=mc:mc scripts/update.sh /scripts/update.sh
COPY --chown=mc:mc scripts/backup.sh /scripts/backup.sh
COPY --chown=mc:mc scripts/command.sh /scripts/command.sh
COPY --chown=mc:mc scripts/run.sh /scripts/run.sh

# Fix line endings for all scripts (convert Windows CRLF to Unix LF)
RUN sed -i 's/\r$//' /scripts/*.sh

# Make all scripts executable
RUN chmod +x /scripts/*.sh

# Simple entrypoint
ENTRYPOINT ["/bin/bash", "-c", "cron && /scripts/run.sh"]