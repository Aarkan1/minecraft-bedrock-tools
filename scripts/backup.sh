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