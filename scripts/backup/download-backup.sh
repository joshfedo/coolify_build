#!/bin/bash
set -e

source /scripts/utils/env.sh

if [ -n "$MAIN_APP_URL" ]; then
    log "Attempting to download backup from: $MAIN_APP_URL/backup/latest.sql"
    
    for i in {1..30}; do
        if curl -f -o "$BACKUP_DIR/latest.sql" "$MAIN_APP_URL/backup/latest.sql" 2>/dev/null; then
            log "Backup downloaded from main environment"
            return 0
        fi
        if [ $i -eq 30 ]; then
            log "Could not download backup from main environment"
            touch "$BACKUP_DIR/latest.sql"
            return 1
        fi
        sleep 2
    done
else
    log "MAIN_APP_URL not set, cannot fetch backup"
    touch "$BACKUP_DIR/latest.sql"
    return 1
fi
