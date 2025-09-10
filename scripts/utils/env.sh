#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

export DB_HOST="${M2_DB_HOST:-db}"
export DB_NAME="${COOLIFY_DATABASE_NAME:-magento}"
export DB_USER="${COOLIFY_DATABASE_USER:-magento}"
export DB_PASSWORD="${COOLIFY_DATABASE_PASSWORD:-magento_password}"
export DB_ROOT_PASSWORD="${COOLIFY_DATABASE_ROOT_PASSWORD:-root_password}"

export REDIS_HOST="${M2_REDIS_HOST:-redis}"
export OPENSEARCH_HOST="${M2_OPENSEARCH_HOST:-opensearch}"

export BASE_URL="${M2_BASE_URL:-https://${COOLIFY_FQDN}/}"
export ADMIN_USER="${M2_ADMIN_USER:-admin}"
export ADMIN_PASSWORD="${M2_ADMIN_PASSWORD:-Password123!}"

export BACKUP_DIR="/backups"
export MAGENTO_DIR="/var/www/html"
