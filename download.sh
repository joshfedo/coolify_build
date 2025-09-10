#!/bin/bash

# Coolify Download & Merge Script
# Downloads modular docker-compose files from coolify_build repo
# Use this in Coolify's Custom Build Command

set -e

echo "📦 Downloading Coolify modules..."

BASE_URL="https://raw.githubusercontent.com/joshfedo/coolify_build/main"

# Download base configuration
curl -s "$BASE_URL/base.yml" -o coolify-base.yml

# Download service modules
curl -s "$BASE_URL/services/database.yml" -o coolify-database.yml
curl -s "$BASE_URL/services/cache.yml" -o coolify-cache.yml
curl -s "$BASE_URL/services/search.yml" -o coolify-search.yml
curl -s "$BASE_URL/services/application.yml" -o coolify-application.yml
curl -s "$BASE_URL/services/backup.yml" -o coolify-backup.yml

echo "✅ Downloaded all modules"

# Test the merge (optional validation)
if command -v docker-compose &> /dev/null; then
    echo "🔍 Validating merged configuration..."
    docker compose \
        -f coolify-base.yml \
        -f coolify-database.yml \
        -f coolify-cache.yml \
        -f coolify-search.yml \
        -f coolify-application.yml \
        -f coolify-backup.yml \
        -f docker-compose.yml \
        config > /dev/null
    echo "✅ Merge validation successful"
fi

echo "🚀 Ready for docker compose build with merged files!"
