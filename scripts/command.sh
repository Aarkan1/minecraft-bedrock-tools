#!/bin/bash
# Send command to bedrock server

# Example:
# Run the command script as the mc user
# docker exec -it -u mc bedrock-server /scripts/command.sh 'list'

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

# Check if this is a special backup command
if [ "$1" = "backup-server" ]; then
    echo "🔄 Running backup script..."
    /scripts/backup.sh
    exit 0
fi

# Check if this is a restore backup command
if [[ "$1" == restore-backup* ]]; then
    echo "🔄 Running restore backup script..."
    # Extract the backup filename if provided (everything after "restore-backup ")
    backup_file=""
    if [[ "$1" =~ ^restore-backup[[:space:]]+(.+)$ ]]; then
        backup_file="${BASH_REMATCH[1]}"
        /scripts/restore-backup.sh "$backup_file"
    else
        # No backup file specified, use latest
        /scripts/restore-backup.sh
    fi
    exit 0
fi


# Send regular command to server pipe
echo "$1" > "$COMMAND_PIPE"