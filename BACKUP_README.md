# Porter Management System - Database Backup & Restore Guide

This document provides comprehensive instructions for backing up and restoring the Porter Management System database.

## 📁 Backup Files Created

The following backup files have been created in the `backups/` directory:

### Current Backups (2025-10-19)

1. **Full Database Backup (All Databases)**
   - File: `full_database_backup_root_20251019_085507.sql` (5.2MB)
   - Contains: All databases including system databases
   - Use case: Complete system restore

2. **Porter Management Database Backup (With Data)**
   - File: `porter_management_backup_20251019_085513.sql` (23KB)
   - Contains: Complete Porter Management database with all data
   - Use case: Standard restore of the application database

3. **Schema-Only Backup**
   - File: `porter_management_schema_only_20251019_085520.sql`
   - Contains: Database structure without data
   - Use case: Setting up new environments, development

## 🛠️ Automated Backup Scripts

### Backup Script: `scripts/backup_database.sh`

Creates comprehensive backups automatically:

```bash
# Run the backup script
./scripts/backup_database.sh
```

**Features:**
- Creates 4 types of backups:
  - Full database backup (all databases)
  - Porter Management database backup (with data)
  - Schema-only backup
  - Data-only backup
- Automatic timestamping
- Optional compression
- Colored output and progress indicators
- Error handling and validation

### Restore Script: `scripts/restore_database.sh`

Restores database from backup files:

```bash
# Interactive mode
./scripts/restore_database.sh

# Specify backup file directly
./scripts/restore_database.sh -f backups/porter_management_backup_20251019_085513.sql

# List available backups
./scripts/restore_database.sh -l
```

**Features:**
- Interactive file selection
- Pre-restore backup creation
- Validation of backup files
- Safety confirmations
- Colored output and error handling

## 📋 Manual Backup Commands

### Create Full Backup
```bash
docker exec porter-db mysqldump \
  -u root -pporter_root_password \
  --single-transaction \
  --routines \
  --triggers \
  --all-databases > backups/full_backup_$(date +%Y%m%d_%H%M%S).sql
```

### Create Porter Management Database Backup
```bash
docker exec porter-db mysqldump \
  -u root -pporter_root_password \
  --single-transaction \
  --routines \
  --triggers \
  porter_management > backups/porter_backup_$(date +%Y%m%d_%H%M%S).sql
```

### Create Schema-Only Backup
```bash
docker exec porter-db mysqldump \
  -u root -pporter_root_password \
  --no-data \
  --routines \
  --triggers \
  porter_management > backups/schema_backup_$(date +%Y%m%d_%H%M%S).sql
```

## 🔄 Manual Restore Commands

### Restore Porter Management Database
```bash
cat backups/porter_management_backup_20251019_085513.sql | \
  docker exec -i porter-db mysql -u root -pporter_root_password
```

### Restore Specific Database
```bash
cat backups/your_backup_file.sql | \
  docker exec -i porter-db mysql -u root -pporter_root_password porter_management
```

## 🗂️ Database Structure

The Porter Management database contains the following tables:

- `allocations` - Porter assignments to departments/services
- `availability` - Porter availability and absence records
- `buildings` - Building information
- `capabilities` - Available capabilities/skills
- `department_capabilities` - Required capabilities per department
- `department_schedule_periods` - Department operational schedules
- `department_schedules` - Department schedule configurations
- `departments` - Department information
- `porter_capabilities` - Porter skill assignments
- `porters` - Porter profiles and information
- `service_capabilities` - Required capabilities per service
- `services` - Service definitions
- `shift_patterns` - Shift rotation patterns
- `shifts` - Shift configurations
- `system_settings` - Application configuration

## 🔐 Database Credentials

- **Container Name**: `porter-db`
- **Database Name**: `porter_management`
- **Root User**: `root`
- **Root Password**: `porter_root_password`
- **App User**: `porter_user`
- **App Password**: `porter_password`

## ⚠️ Important Notes

1. **Before Restore**: Always create a backup of the current state before restoring
2. **Container Status**: Ensure the database container is running before backup/restore
3. **File Validation**: Verify backup files are not corrupted before restoring
4. **Data Loss Warning**: Restore operations will replace existing data
5. **Permissions**: Ensure scripts have execute permissions (`chmod +x`)

## 🚀 Quick Start

### Create a Backup
```bash
./scripts/backup_database.sh
```

### Restore from Backup
```bash
./scripts/restore_database.sh -l  # List available backups
./scripts/restore_database.sh    # Interactive restore
```

## 📊 Backup File Sizes

Current backup files (as of 2025-10-19):
- Full database: ~5.2MB
- Porter Management: ~23KB
- Schema only: ~15KB

## 🔧 Troubleshooting

### Container Not Running
```bash
docker-compose up -d database
```

### Permission Denied
```bash
chmod +x scripts/backup_database.sh
chmod +x scripts/restore_database.sh
```

### Backup File Corruption
- Check file size: `ls -lh backups/`
- Validate SQL syntax: `head -20 backups/your_file.sql`
- Test restore on development environment first

---

**Last Updated**: 2025-10-19  
**System Version**: Porter Management System v1.0
