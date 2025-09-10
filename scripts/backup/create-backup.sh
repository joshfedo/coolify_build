#!/bin/bash
set -e

source /scripts/utils/env.sh

BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql"

log "Creating database backup"
mysqldump --no-tablespaces -h "$DB_HOST" -u root -p"$DB_ROOT_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"
cp "$BACKUP_FILE" "$BACKUP_DIR/latest.sql"
log "Backup completed: $BACKUP_FILE"

find "$BACKUP_DIR" -name 'backup_*.sql' -mtime +7 -delete 2>/dev/null || true
log "Old backups cleaned up"
