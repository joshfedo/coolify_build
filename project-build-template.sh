#!/bin/bash

# Project-specific Coolify build script
# Add this to your Magento repo as coolify-build.sh

set -e

echo "📦 Downloading Coolify modules for this project..."

BASE_URL="https://raw.githubusercontent.com/joshfedo/coolify_build/main"

curl -s "$BASE_URL/base.yml" -o coolify-base.yml
curl -s "$BASE_URL/services/database.yml" -o coolify-database.yml
curl -s "$BASE_URL/services/cache.yml" -o coolify-cache.yml
curl -s "$BASE_URL/services/search.yml" -o coolify-search.yml
curl -s "$BASE_URL/services/application.yml" -o coolify-application.yml
curl -s "$BASE_URL/services/backup.yml" -o coolify-backup.yml

echo "✅ Downloaded all modules"

# Build with local project overrides
docker compose \
    -f coolify-base.yml \
    -f coolify-database.yml \
    -f coolify-cache.yml \
    -f coolify-search.yml \
    -f coolify-application.yml \
    -f coolify-backup.yml \
    -f docker-compose.yml \
    build

echo "✅ Build completed"
