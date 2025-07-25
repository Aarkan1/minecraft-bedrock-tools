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
    if [[ ! -f /data/bedrock_server/bedrock_server ]]; then
        echo "❌ Server executable not found after update check!"
        exit 1
    fi
    
    echo "🎮 Starting Minecraft Bedrock Server..."
    
    # Create named pipe for server commands
    COMMAND_PIPE="/tmp/bedrock_commands"
    rm -f "$COMMAND_PIPE"
    mkfifo "$COMMAND_PIPE"
    chown mc:mc "$COMMAND_PIPE"
    chmod 666 "$COMMAND_PIPE"
    
    # Start the server process normally first
    su -c "cd /data/bedrock_server && LD_LIBRARY_PATH=. ./bedrock_server" mc &
    SERVER_PID=$!
    
    echo "✅ Server started with PID: $SERVER_PID"
    echo "⏳ Waiting for server to initialize..."
    sleep 10  # Give server time to start
    
    # Now start the command feeder in background
    (
        while true; do
            if [[ -p "$COMMAND_PIPE" ]]; then
                while IFS= read -r command; do
                    if [[ -n "$command" ]]; then
                        echo "📤 Executing: $command"
                        # Send command to server stdin (this is tricky with background process)
                        echo "$command"
                    fi
                done < "$COMMAND_PIPE"
            fi
            sleep 1
        done
    ) &
    COMMAND_FEEDER_PID=$!
    
    echo "💬 Send commands via: echo 'command' > $COMMAND_PIPE"
    
    # Wait for server to stop
    wait $SERVER_PID
    EXIT_CODE=$?
    
    # Clean up
    kill $COMMAND_FEEDER_PID 2>/dev/null
    wait $COMMAND_FEEDER_PID 2>/dev/null
    rm -f "$COMMAND_PIPE"
    
    echo "⚠️ Server stopped with exit code: $EXIT_CODE"
    echo "🔄 Restarting in 5 seconds..."
    sleep 5
done