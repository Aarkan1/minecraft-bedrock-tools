#!/bin/bash
# Restore Minecraft Bedrock Server worlds from backup

# Configuration variables
BACKUP_DIR="/data/backups"
WORLD_DIR="/data/bedrock_server/worlds"

# Function to display usage information
show_usage() {
    echo "Usage: $0 [backup-file]"
    echo "  backup-file: Optional specific backup file to restore (e.g., backup-2024-01-15_10-30-45.zip)"
    echo "  If no file specified, restores from the latest backup"
    echo ""
    echo "Examples:"
    echo "  $0                              # Restore from latest backup"
    echo "  $0 backup-2024-01-15_10-30-45.zip  # Restore from specific backup"
}

# Function to find the latest backup file
find_latest_backup() {
    # Find the most recent backup file in the backup directory
    local latest_backup=$(ls -t "$BACKUP_DIR"/backup-*.zip 2>/dev/null | head -n 1)
    echo "$latest_backup"
}

# Function to validate backup file exists
validate_backup_file() {
    local backup_file="$1"
    
    if [[ ! -f "$backup_file" ]]; then
        echo "❌ Backup file not found: $backup_file"
        return 1
    fi
    
    # Check if it's a valid zip file
    if ! unzip -t "$backup_file" >/dev/null 2>&1; then
        echo "❌ Invalid or corrupted backup file: $backup_file"
        return 1
    fi
    
    return 0
}

# Main restore logic
main() {
    local backup_file=""
    
    # Parse command line arguments
    if [[ $# -eq 0 ]]; then
        # No arguments - use latest backup
        echo "🔍 No backup file specified, finding latest backup..."
        backup_file=$(find_latest_backup)
        
        if [[ -z "$backup_file" ]]; then
            echo "❌ No backup files found in $BACKUP_DIR"
            exit 1
        fi
        
        echo "📦 Using latest backup: $(basename "$backup_file")"
        
    elif [[ $# -eq 1 ]]; then
        # One argument - specific backup file
        if [[ "$1" == "-h" || "$1" == "--help" ]]; then
            show_usage
            exit 0
        fi
        
        # Check if it's a full path or just filename
        if [[ "$1" == *"/"* ]]; then
            backup_file="$1"
        else
            backup_file="$BACKUP_DIR/$1"
        fi
        
        echo "📦 Using specified backup: $(basename "$backup_file")"
        
    else
        echo "❌ Too many arguments"
        show_usage
        exit 1
    fi
    
    # Validate the backup file exists and is valid
    if ! validate_backup_file "$backup_file"; then
        exit 1
    fi
    
    # 1. First do a named backup (create backup of current worlds before restoring)
    if [[ -d "$WORLD_DIR" && -n "$(ls -A "$WORLD_DIR" 2>/dev/null)" ]]; then
        local current_backup="$BACKUP_DIR/pre-restore-backup-$(date +"%Y-%m-%d_%H-%M-%S").zip"
        echo "💾 Step 1: Creating named backup of current worlds: $(basename "$current_backup")"
        cd "$WORLD_DIR"
        /scripts/command.sh 'save hold'
        sleep 1
        zip -r "$current_backup" ./* > /dev/null
        /scripts/command.sh 'save resume'
        echo "✅ Named backup created successfully"
    fi
    
    # 2. Stop the server
    echo "⏸️ Step 2: Stopping server for restoration..."
    /scripts/command.sh 'stop'
    
    # Wait for server to actually stop by checking if the command pipe still exists
    local wait_count=0
    while [[ -p "/tmp/bedrock_commands" ]] && [[ $wait_count -lt 30 ]]; do
        echo "⏳ Waiting for server to stop... ($wait_count/30)"
        sleep 1
        ((wait_count++))
    done
    
    if [[ -p "/tmp/bedrock_commands" ]]; then
        echo "⚠️ Server may still be running, but proceeding with restore..."
    else
        echo "✅ Server stopped successfully"
    fi
    
    # 3. Remove the /data/bedrock_server/worlds/ content
    echo "🗑️ Step 3: Removing current worlds content..."
    rm -rf "$WORLD_DIR"
    
    # Create fresh worlds directory
    mkdir -p "$WORLD_DIR"
    echo "✅ Worlds directory cleaned"
    
    # 4. Unzip the target backup zip into the worlds folder
    echo "📂 Step 4: Restoring worlds from backup..."
    cd "$WORLD_DIR"
    unzip -q "$backup_file"
    
    # Set proper ownership
    chown -R mc:mc "$WORLD_DIR"
    echo "✅ Worlds restored from backup"
    
    # 5. Server will start automatically via the main server loop in run.sh
    echo "🔄 Step 5: Server will restart automatically via main server loop"
    
    echo "✅ Backup restoration complete!"
    echo "📁 Restored from: $(basename "$backup_file")"
    echo "⏳ Please wait for the server to restart automatically..."
}

# Run main function with all arguments
main "$@"