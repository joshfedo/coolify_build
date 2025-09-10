#!/bin/bash
set -e

source /scripts/utils/env.sh

log "Sanitizing database for preview environment"

if [ -n "$COOLIFY_FQDN" ]; then
    log "Updating base URLs to: $COOLIFY_FQDN"
    mysql -h "$DB_HOST" -u root -p"$DB_ROOT_PASSWORD" "$DB_NAME" -e "
        UPDATE core_config_data SET value = 'https://$COOLIFY_FQDN/' WHERE path IN ('web/unsecure/base_url', 'web/secure/base_url');
    "
else
    log "COOLIFY_FQDN is empty, skipping base URL update"
fi

mysql -h "$DB_HOST" -u root -p"$DB_ROOT_PASSWORD" "$DB_NAME" -e "
    UPDATE core_config_data SET value = '1' WHERE path LIKE '%dev/debug%';
    UPDATE core_config_data SET value = 'sandbox' WHERE path LIKE '%payment%mode%';
    UPDATE core_config_data SET value = '0' WHERE path = 'web/cookie/cookie_domain';
    UPDATE core_config_data SET value = '0' WHERE path = 'system/full_page_cache/caching_application';
"

log "Database sanitization complete"
