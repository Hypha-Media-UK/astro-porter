# Porter Management System - Database Backup & Restore

This directory contains scripts for backing up and restoring the Porter Management System database.

## 📋 Available Scripts

### 🗄️ `backup-database.sh`
Creates a complete backup of the MySQL database with timestamp.

**Usage:**
```bash
cd backend
./scripts/backup-database.sh
```

**Features:**
- Timestamped backup files (`porter_management_backup_YYYYMMDD_HHMMSS.sql`)
- Automatic compression (creates both `.sql` and `.sql.gz` versions)
- File size reporting
- Complete database structure and data export
- Works with Docker containerized database

**Output:**
- Original backup: `./backups/porter_management_backup_YYYYMMDD_HHMMSS.sql`
- Compressed backup: `./backups/porter_management_backup_YYYYMMDD_HHMMSS.sql.gz`

### 🔄 `restore-database.sh`
Restores a database backup from the backups directory.

**Usage:**
```bash
cd backend
./scripts/restore-database.sh <backup_filename>
```

**Examples:**
```bash
# Restore from uncompressed backup
./scripts/restore-database.sh porter_management_backup_20251020_122631.sql

# Restore from compressed backup
./scripts/restore-database.sh porter_management_backup_20251020_122631.sql.gz
```

**Features:**
- Supports both compressed (`.gz`) and uncompressed (`.sql`) backups
- Safety confirmation prompt before restore
- Automatic backup file detection in `./backups/` directory
- Post-restore verification with record counts
- Lists available backups if no file specified

## 📁 Backup Directory Structure

```
backend/
├── backups/
│   ├── porter_management_backup_20251020_122631.sql     (54K)
│   └── porter_management_backup_20251020_122631.sql.gz  (10K)
└── scripts/
    ├── backup-database.sh
    ├── restore-database.sh
    └── README.md
```

## 🔧 Database Configuration

The scripts use the following database configuration:
- **Host:** localhost (via Docker container `porter-db`)
- **Port:** 3306
- **Database:** porter_management
- **User:** porter_user
- **Password:** porter_password

## 📊 Current Backup Contents

The latest backup contains:
- **93 Porters** (including 5 supervisors, 6 relief staff, 82 general porters)
- **16 Buildings** (Charlesworth, Hartshead, Ladysmith, etc.)
- **66 Departments** (ED A+E, AMU, ITU, various wards and units)
- **10 Services** (Patient Transport, District Drivers, Medical Records, etc.)
- **28 Service Allocations** (porter assignments to specific services)

## ⚠️ Important Notes

1. **Docker Dependency:** Scripts require the `porter-db` Docker container to be running
2. **Backup Safety:** Always verify backups before relying on them for recovery
3. **Restore Warning:** Restore operations will **completely replace** existing data
4. **File Permissions:** Scripts are executable (`chmod +x`) and ready to use
5. **Compression:** Compressed backups save ~80% space (54K → 10K)

## 🚀 Quick Start

```bash
# Create a backup
cd backend
./scripts/backup-database.sh

# List available backups
ls -la ./backups/

# Restore a backup (with confirmation)
./scripts/restore-database.sh porter_management_backup_20251020_122631.sql.gz
```
