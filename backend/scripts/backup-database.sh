#!/bin/bash

# Porter Management System Database Backup Script
# Creates a complete backup of the MySQL database with timestamp

# Configuration
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="porter_management"
DB_USER="porter_user"
DB_PASSWORD="porter_password"

# Create backup directory if it doesn't exist
BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

# Generate timestamp for backup filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/porter_management_backup_$TIMESTAMP.sql"

echo "🗄️  Creating database backup..."
echo "📅 Timestamp: $TIMESTAMP"
echo "📁 Backup file: $BACKUP_FILE"

# Create the backup using Docker exec with mysqldump
docker exec porter-db mysqldump \
  --user="$DB_USER" \
  --password="$DB_PASSWORD" \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --add-drop-table \
  --add-locks \
  --extended-insert \
  --quick \
  --lock-tables=false \
  "$DB_NAME" > "$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ]; then
    # Get file size
    FILE_SIZE=$(ls -lh "$BACKUP_FILE" | awk '{print $5}')
    
    echo "✅ Database backup completed successfully!"
    echo "📊 Backup file size: $FILE_SIZE"
    echo "📍 Location: $BACKUP_FILE"
    
    # Create a compressed version
    COMPRESSED_FILE="$BACKUP_FILE.gz"
    gzip -c "$BACKUP_FILE" > "$COMPRESSED_FILE"
    COMPRESSED_SIZE=$(ls -lh "$COMPRESSED_FILE" | awk '{print $5}')
    
    echo "🗜️  Compressed backup created: $COMPRESSED_SIZE"
    echo "📍 Compressed location: $COMPRESSED_FILE"
    
    # Show backup summary
    echo ""
    echo "📋 Backup Summary:"
    echo "   Original: $BACKUP_FILE ($FILE_SIZE)"
    echo "   Compressed: $COMPRESSED_FILE ($COMPRESSED_SIZE)"
    echo ""
    echo "🔄 To restore this backup, use:"
    echo "   docker exec -i porter-db mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < $BACKUP_FILE"
    echo ""
    echo "🔄 To restore from compressed backup, use:"
    echo "   gunzip -c $COMPRESSED_FILE | docker exec -i porter-db mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME"
    
else
    echo "❌ Database backup failed!"
    exit 1
fi
