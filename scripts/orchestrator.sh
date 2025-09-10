#!/bin/bash
set -e

source /scripts/utils/env.sh
source /scripts/utils/wait-for-db.sh

log "Starting Magento initialization orchestrator"
log "Environment: ${COOLIFY_PREVIEW_DEPLOYMENT:-production}"
log "FQDN: ${COOLIFY_FQDN}"

if [ "$COOLIFY_PREVIEW_DEPLOYMENT" = "true" ]; then
    MODE="preview"
else
    MODE="${SETUP_MODE:-production}"
fi

case "$MODE" in
    "preview")
        log "Setting up preview environment"
        /scripts/backup/download-backup.sh
        wait_for_database
        /scripts/backup/restore-backup.sh
        /scripts/magento/sanitize-preview.sh
        ;;
    "fresh")
        log "Setting up fresh installation"
        wait_for_database
        /scripts/magento/setup-fresh.sh
        ;;
    "clone")
        log "Setting up from clone"
        /scripts/backup/download-backup.sh
        wait_for_database
        /scripts/backup/restore-backup.sh
        /scripts/magento/setup-from-backup.sh
        ;;
    "production")
        log "Setting up production environment"
        wait_for_database
        /scripts/backup/setup-backup-service.sh
        ;;
    *)
        log "Unknown setup mode: $MODE"
        exit 1
        ;;
esac

log "Initialization complete"
