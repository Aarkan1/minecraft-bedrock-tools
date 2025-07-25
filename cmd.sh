#!/bin/bash
# Convenient wrapper for sending bedrock server commands

# chmod +x cmd.sh
# ./cmd.sh 'list'

if [ $# -eq 0 ]; then
    echo "Usage: $0 'command'"
    echo "Example: $0 'list'"
    echo "Example: $0 'say Hello everyone!'"
    exit 1
fi

echo "📤 Sending bedrock command: $1"
docker exec -u mc bedrock-server /scripts/command.sh "$1"

# Show recent logs to see the response
echo ""
echo "📋 Recent server output:"
docker compose logs --tail 5