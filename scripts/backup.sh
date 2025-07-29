#!/bin/bash

MAX_BACKUPS=30
BACKUP_DIR="/data/backups"
WORLD_DIR="/data/bedrock_server/worlds"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="$BACKUP_DIR/backup-$TIMESTAMP.zip"

mkdir -p $BACKUP_DIR

if [ -z "$(ls -A $WORLD_DIR 2>/dev/null)" ]; then
    echo "⏩ Worlds directory is empty, skipping backup."
    exit 0
fi

cd $WORLD_DIR

/scripts/command.sh 'save hold'

sleep 1

echo "🗜️ Backing up worlds to $ARCHIVE_NAME..."
zip -r "$ARCHIVE_NAME" ./* > /dev/null

/scripts/command.sh 'save resume'

echo "🧹 Cleaning up old backups (keeping last $MAX_BACKUPS)..."
ls -tp "$BACKUP_DIR" | grep '\.zip$' | tail -n +$((MAX_BACKUPS + 1)) | xargs -I {} rm -- "$BACKUP_DIR/{}"
echo "✅ Backup complete"