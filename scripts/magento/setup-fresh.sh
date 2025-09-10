#!/bin/bash
set -e

source /scripts/utils/env.sh

log "Setting up fresh Magento installation"

if [ ! -f "$MAGENTO_DIR/app/etc/env.php" ]; then
    log "Installing Magento"
    
    cd "$MAGENTO_DIR"
    
    bin/magento setup:install \
        --base-url="$BASE_URL" \
        --db-host="$DB_HOST" \
        --db-name="$DB_NAME" \
        --db-user="$DB_USER" \
        --db-password="$DB_PASSWORD" \
        --admin-firstname="Admin" \
        --admin-lastname="User" \
        --admin-email="admin@example.com" \
        --admin-user="$ADMIN_USER" \
        --admin-password="$ADMIN_PASSWORD" \
        --language="en_US" \
        --currency="USD" \
        --timezone="America/Chicago" \
        --use-rewrites=1 \
        --search-engine="opensearch" \
        --opensearch-host="$OPENSEARCH_HOST" \
        --opensearch-port=9200
    
    log "Magento installation complete"
else
    log "Magento already installed, updating configuration"
    /scripts/magento/setup-from-backup.sh
fi
