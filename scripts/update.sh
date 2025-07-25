#!/bin/bash
set -e

# Always ensure we're in the correct directory
cd /data

echo "🔎 Checking server status..."

# Get the latest version from Minecraft website
DOWNLOAD_URL=$(curl -s https://net-secondary.web.minecraft-services.net/api/v1.0/download/links | grep -oP '"downloadType":"serverBedrockLinux"[^}]*"downloadUrl":"\K[^"]+')
echo "Download URL: $DOWNLOAD_URL" || echo "No download URL found"
if [[ ! -z "$DOWNLOAD_URL" ]]; then
    LATEST_VERSION=$(echo "$DOWNLOAD_URL" | grep -o '[0-9\.]*\.zip' | sed 's/\.zip//')
    echo "Latest version: $LATEST_VERSION" || echo "No latest version found"
fi

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
    echo "Download URL: $DOWNLOAD_URL"

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