#!/bin/bash
echo "🚀 Starting Minecraft Bedrock Server Manager..."

# Always ensure we're in the correct directory  
cd /data

# Global shutdown flag for clean exit
SHUTDOWN_REQUESTED=false

# Set up trap for graceful shutdown - only set flag, don't exit immediately
trap 'echo "🛑 Shutdown requested..."; SHUTDOWN_REQUESTED=true' SIGTERM SIGINT

# Set up scheduled tasks for the mc user
echo "⏰ Setting up scheduled tasks..."
cat << EOF | crontab -u mc -
* * * * * /bin/bash /scripts/backup.sh
0 * * * * /bin/bash /scripts/update.sh
EOF

# Start cron in the background
cron -f &
CRON_PID=$!

# Function to cleanup server process
cleanup_server() {
    local server_pid=$1
    if [[ -n "$server_pid" ]] && kill -0 "$server_pid" 2>/dev/null; then
        echo "🧹 Cleaning up server process $server_pid..."
        # Get the actual process group ID of the server
        local pgid=$(ps -o pgid= -p "$server_pid" 2>/dev/null | tr -d ' ')
        if [[ -n "$pgid" ]]; then
            # Kill only the server's process group, not our own
            kill -TERM -"$pgid" 2>/dev/null
            # Wait a bit for graceful shutdown
            sleep 2
            # Force kill if still running
            kill -KILL -"$pgid" 2>/dev/null
        fi
    fi
}

# Main server loop
while true; do
    # Check if shutdown was requested
    if [[ "$SHUTDOWN_REQUESTED" == "true" ]]; then
        # TODO - run backup script before shutting down
        echo "🛑 Shutdown requested, exiting main loop..."
        break
    fi

    echo "🔄 Running update check..."
    /bin/bash /scripts/update.sh
    
    # Verify server files exist before starting
    if [[ ! -f /data/bedrock_server/bedrock_server ]]; then
        echo "❌ Server executable not found after update check!"
        if [[ "$SHUTDOWN_REQUESTED" == "true" ]]; then
            break
        fi
        echo "⏳ Waiting 10 seconds before retry..."
        sleep 10
        continue
    fi
    
    echo "🎮 Starting Minecraft Bedrock Server..."

    # Remove and recreate the named pipe for commands
    COMMAND_PIPE="/tmp/bedrock_commands"
    rm -f "$COMMAND_PIPE"
    mkfifo "$COMMAND_PIPE"
    chown mc:mc "$COMMAND_PIPE"
    chmod 666 "$COMMAND_PIPE"

    # Start server pipeline in a new process group
    # Use exec to replace the shell process and avoid extra process layers
    setsid bash -c "
        cd /data/bedrock_server
        export LD_LIBRARY_PATH=.
        exec su -c 'tail -f $COMMAND_PIPE | exec ./bedrock_server' mc
    " &
    SERVER_PID=$!

    echo "✅ Server started with PID: $SERVER_PID"
    echo "💬 Send commands via: echo 'command' > $COMMAND_PIPE"

    # Wait for server to stop, but check periodically for shutdown requests
    while kill -0 "$SERVER_PID" 2>/dev/null; do
        if [[ "$SHUTDOWN_REQUESTED" == "true" ]]; then
            echo "🛑 Shutdown requested, stopping server..."
            cleanup_server "$SERVER_PID"
            break
        fi
        sleep 1
    done

    # Get exit code if server stopped naturally
    if kill -0 "$SERVER_PID" 2>/dev/null; then
        # Server is still running, we broke due to shutdown request
        wait "$SERVER_PID" 2>/dev/null
        EXIT_CODE=$?
    else
        # Server stopped naturally
        wait "$SERVER_PID" 2>/dev/null
        EXIT_CODE=$?
        echo "⚠️ Server stopped naturally with exit code: $EXIT_CODE"
    fi

    # Clean up any remaining processes
    cleanup_server "$SERVER_PID"

    # Clean up named pipe
    rm -f "$COMMAND_PIPE"

    # Break if shutdown was requested
    if [[ "$SHUTDOWN_REQUESTED" == "true" ]]; then
        echo "🛑 Exiting due to shutdown request"
        break
    fi

    echo "🔄 Restarting server in 5 seconds..."
    sleep 5
done

# Clean up cron if it's still running
if [[ -n "$CRON_PID" ]] && kill -0 "$CRON_PID" 2>/dev/null; then
    echo "🧹 Stopping cron..."
    kill "$CRON_PID" 2>/dev/null
fi

echo "👋 Server manager stopped"
exit 0