#!/bin/bash
set -e

source /scripts/utils/env.sh

if [ -f "$BACKUP_DIR/latest.sql" ] && [ -s "$BACKUP_DIR/latest.sql" ]; then
    log "Found database backup, starting import"
    mysql -h "$DB_HOST" -u root -p"$DB_ROOT_PASSWORD" "$DB_NAME" < "$BACKUP_DIR/latest.sql"
    log "Database import complete"
else
    log "No backup found or backup is empty"
    ls -la "$BACKUP_DIR/" || log "Backup directory is empty"
    return 1
fi
