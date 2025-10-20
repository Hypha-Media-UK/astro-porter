#!/bin/bash

# Porter Management System Database Restore Script
# Restores a database backup from the backups directory

# Configuration
DB_NAME="porter_management"
DB_USER="porter_user"
DB_PASSWORD="porter_password"
BACKUP_DIR="./backups"

# Function to show usage
show_usage() {
    echo "Usage: $0 <backup_file>"
    echo ""
    echo "Examples:"
    echo "  $0 porter_management_backup_20251020_122631.sql"
    echo "  $0 porter_management_backup_20251020_122631.sql.gz"
    echo ""
    echo "Available backups:"
    ls -la "$BACKUP_DIR"/ 2>/dev/null | grep -E "\.(sql|sql\.gz)$" | awk '{print "  " $9 " (" $5 " - " $6 " " $7 " " $8 ")"}'
}

# Check if backup file is provided
if [ $# -eq 0 ]; then
    echo "❌ Error: No backup file specified"
    echo ""
    show_usage
    exit 1
fi

BACKUP_FILE="$1"

# Check if file exists in backup directory
if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    echo "❌ Error: Backup file not found: $BACKUP_DIR/$BACKUP_FILE"
    echo ""
    show_usage
    exit 1
fi

FULL_BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"

echo "🔄 Restoring database from backup..."
echo "📁 Backup file: $FULL_BACKUP_PATH"
echo "🗄️  Target database: $DB_NAME"

# Ask for confirmation
read -p "⚠️  This will REPLACE all data in the database. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled"
    exit 1
fi

# Check if file is compressed
if [[ "$BACKUP_FILE" == *.gz ]]; then
    echo "🗜️  Detected compressed backup file"
    echo "📤 Decompressing and restoring..."
    
    gunzip -c "$FULL_BACKUP_PATH" | docker exec -i porter-db mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME"
    
else
    echo "📤 Restoring from uncompressed backup..."
    
    docker exec -i porter-db mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$FULL_BACKUP_PATH"
fi

# Check if restore was successful
if [ $? -eq 0 ]; then
    echo "✅ Database restore completed successfully!"
    echo ""
    echo "🔍 Verifying restore..."
    
    # Quick verification - count tables
    TABLE_COUNT=$(docker exec porter-db mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME; SHOW TABLES;" | wc -l)
    TABLE_COUNT=$((TABLE_COUNT - 1)) # Subtract header line
    
    echo "📊 Tables restored: $TABLE_COUNT"
    
    # Count some key records
    PORTER_COUNT=$(docker exec porter-db mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME; SELECT COUNT(*) FROM porters;" | tail -1)
    BUILDING_COUNT=$(docker exec porter-db mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME; SELECT COUNT(*) FROM buildings;" | tail -1)
    SERVICE_COUNT=$(docker exec porter-db mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME; SELECT COUNT(*) FROM services;" | tail -1)
    
    echo "👥 Porters: $PORTER_COUNT"
    echo "🏢 Buildings: $BUILDING_COUNT"
    echo "🔧 Services: $SERVICE_COUNT"
    echo ""
    echo "🎉 Database restore verification complete!"
    
else
    echo "❌ Database restore failed!"
    exit 1
fi
