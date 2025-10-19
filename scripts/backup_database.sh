#!/bin/bash

# Porter Management System Database Backup Script
# This script creates comprehensive backups of the Porter Management database

set -e  # Exit on any error

# Configuration
BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="porter-db"
DB_NAME="porter_management"
DB_USER="root"
DB_PASSWORD="porter_root_password"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

print_status "Starting Porter Management System database backup..."

# Check if container is running
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    print_error "Database container '$CONTAINER_NAME' is not running!"
    exit 1
fi

print_status "Database container is running. Proceeding with backup..."

# 1. Full database backup (all databases)
print_status "Creating full database backup (all databases)..."
FULL_BACKUP_FILE="$BACKUP_DIR/full_database_backup_$TIMESTAMP.sql"
docker exec "$CONTAINER_NAME" mysqldump \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    --single-transaction \
    --routines \
    --triggers \
    --all-databases > "$FULL_BACKUP_FILE"

if [ $? -eq 0 ]; then
    print_success "Full database backup created: $FULL_BACKUP_FILE"
else
    print_error "Failed to create full database backup"
    exit 1
fi

# 2. Porter Management database backup (with data)
print_status "Creating Porter Management database backup (with data)..."
PORTER_BACKUP_FILE="$BACKUP_DIR/porter_management_backup_$TIMESTAMP.sql"
docker exec "$CONTAINER_NAME" mysqldump \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    --single-transaction \
    --routines \
    --triggers \
    "$DB_NAME" > "$PORTER_BACKUP_FILE"

if [ $? -eq 0 ]; then
    print_success "Porter Management backup created: $PORTER_BACKUP_FILE"
else
    print_error "Failed to create Porter Management backup"
    exit 1
fi

# 3. Schema-only backup
print_status "Creating schema-only backup..."
SCHEMA_BACKUP_FILE="$BACKUP_DIR/porter_management_schema_$TIMESTAMP.sql"
docker exec "$CONTAINER_NAME" mysqldump \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    --no-data \
    --routines \
    --triggers \
    "$DB_NAME" > "$SCHEMA_BACKUP_FILE"

if [ $? -eq 0 ]; then
    print_success "Schema-only backup created: $SCHEMA_BACKUP_FILE"
else
    print_error "Failed to create schema-only backup"
    exit 1
fi

# 4. Data-only backup
print_status "Creating data-only backup..."
DATA_BACKUP_FILE="$BACKUP_DIR/porter_management_data_$TIMESTAMP.sql"
docker exec "$CONTAINER_NAME" mysqldump \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    --no-create-info \
    --single-transaction \
    "$DB_NAME" > "$DATA_BACKUP_FILE"

if [ $? -eq 0 ]; then
    print_success "Data-only backup created: $DATA_BACKUP_FILE"
else
    print_error "Failed to create data-only backup"
    exit 1
fi

# Display backup summary
print_status "Backup Summary:"
echo "----------------------------------------"
ls -lh "$BACKUP_DIR"/*"$TIMESTAMP"* | while read line; do
    echo "  $line"
done
echo "----------------------------------------"

# Calculate total backup size
TOTAL_SIZE=$(du -sh "$BACKUP_DIR"/*"$TIMESTAMP"* | awk '{sum+=$1} END {print sum}')
print_success "Backup completed successfully!"
print_status "Total backup size: $(du -sh "$BACKUP_DIR"/*"$TIMESTAMP"* | awk '{total+=$1} END {print total "K"}')"

# Optional: Compress backups
read -p "Do you want to compress the backups? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Compressing backups..."
    tar -czf "$BACKUP_DIR/porter_management_backups_$TIMESTAMP.tar.gz" "$BACKUP_DIR"/*"$TIMESTAMP"*.sql
    if [ $? -eq 0 ]; then
        print_success "Backups compressed to: $BACKUP_DIR/porter_management_backups_$TIMESTAMP.tar.gz"
        print_warning "Original SQL files are still available. You can delete them manually if needed."
    else
        print_error "Failed to compress backups"
    fi
fi

print_success "Database backup process completed!"
