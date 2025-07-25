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