#!/bin/bash

# Porter Management System Database Restore Script
# This script restores the Porter Management database from backup files

set -e  # Exit on any error

# Configuration
BACKUP_DIR="backups"
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

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -f, --file BACKUP_FILE    Specify backup file to restore"
    echo "  -l, --list               List available backup files"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -l                                    # List available backups"
    echo "  $0 -f backups/porter_management_backup_20251019_085513.sql"
    echo "  $0                                       # Interactive mode"
}

# Function to list backup files
list_backups() {
    print_status "Available backup files:"
    echo "----------------------------------------"
    if [ -d "$BACKUP_DIR" ]; then
        ls -lht "$BACKUP_DIR"/*.sql 2>/dev/null | head -10 || echo "No backup files found in $BACKUP_DIR"
    else
        echo "Backup directory '$BACKUP_DIR' does not exist"
    fi
    echo "----------------------------------------"
}

# Function to validate backup file
validate_backup_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        print_error "Backup file '$file' does not exist!"
        return 1
    fi
    
    if [ ! -s "$file" ]; then
        print_error "Backup file '$file' is empty!"
        return 1
    fi
    
    # Check if it's a valid SQL dump
    if ! head -5 "$file" | grep -q "MariaDB dump\|MySQL dump"; then
        print_error "File '$file' does not appear to be a valid database dump!"
        return 1
    fi
    
    return 0
}

# Function to restore database
restore_database() {
    local backup_file="$1"
    
    print_status "Starting database restore from: $backup_file"
    
    # Check if container is running
    if ! docker ps | grep -q "$CONTAINER_NAME"; then
        print_error "Database container '$CONTAINER_NAME' is not running!"
        return 1
    fi
    
    # Validate backup file
    if ! validate_backup_file "$backup_file"; then
        return 1
    fi
    
    # Warning about data loss
    print_warning "WARNING: This will replace all existing data in the database!"
    read -p "Are you sure you want to continue? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        print_status "Restore cancelled by user."
        return 0
    fi
    
    # Create a backup of current state before restore
    print_status "Creating backup of current state before restore..."
    CURRENT_BACKUP="$BACKUP_DIR/pre_restore_backup_$(date +%Y%m%d_%H%M%S).sql"
    docker exec "$CONTAINER_NAME" mysqldump \
        -u "$DB_USER" \
        -p"$DB_PASSWORD" \
        --single-transaction \
        --routines \
        --triggers \
        "$DB_NAME" > "$CURRENT_BACKUP" 2>/dev/null || print_warning "Could not create pre-restore backup"
    
    # Restore the database
    print_status "Restoring database..."
    if cat "$backup_file" | docker exec -i "$CONTAINER_NAME" mysql -u "$DB_USER" -p"$DB_PASSWORD"; then
        print_success "Database restored successfully from: $backup_file"
        if [ -f "$CURRENT_BACKUP" ]; then
            print_status "Pre-restore backup saved as: $CURRENT_BACKUP"
        fi
        return 0
    else
        print_error "Failed to restore database!"
        if [ -f "$CURRENT_BACKUP" ]; then
            print_status "You can restore the previous state using: $CURRENT_BACKUP"
        fi
        return 1
    fi
}

# Parse command line arguments
BACKUP_FILE=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            BACKUP_FILE="$2"
            shift 2
            ;;
        -l|--list)
            list_backups
            exit 0
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Interactive mode if no file specified
if [ -z "$BACKUP_FILE" ]; then
    print_status "Porter Management System Database Restore"
    echo ""
    
    list_backups
    echo ""
    
    read -p "Enter the backup file path: " BACKUP_FILE
    
    if [ -z "$BACKUP_FILE" ]; then
        print_error "No backup file specified!"
        exit 1
    fi
fi

# Perform the restore
restore_database "$BACKUP_FILE"
