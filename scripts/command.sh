#!/bin/bash
# Send command to bedrock server

# Example:
# Run the command script as the mc user
docker exec -it -u mc bedrock-server /scripts/command.sh 'list'

if [ $# -eq 0 ]; then
    echo "Usage: $0 'command'"
    echo "Example: $0 'list'"
    exit 1
fi

COMMAND_PIPE="/tmp/bedrock_commands"

if [ ! -p "$COMMAND_PIPE" ]; then
    echo "❌ Server command pipe not found. Is the server running?"
    exit 1
fi

echo "📤 Sending command: $1"
echo "$1" > "$COMMAND_PIPE"
echo "✅ Command sent!"