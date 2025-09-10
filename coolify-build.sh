#!/bin/bash

# Coolify Build Script - Downloads and merges modular docker-compose files
# Use this in Coolify Custom Build Command: curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/coolify-build.sh | bash

set -e

echo "📦 Coolify: Downloading modular docker-compose files..."

BASE_URL="https://raw.githubusercontent.com/joshfedo/coolify_build/main"

# Download all modules
curl -s "$BASE_URL/base.yml" -o coolify-base.yml
curl -s "$BASE_URL/services/database.yml" -o coolify-database.yml
curl -s "$BASE_URL/services/cache.yml" -o coolify-cache.yml
curl -s "$BASE_URL/services/search.yml" -o coolify-search.yml
curl -s "$BASE_URL/services/application.yml" -o coolify-application.yml
curl -s "$BASE_URL/services/backup.yml" -o coolify-backup.yml

echo "✅ Downloaded all modules"

# Validate merge
echo "🔍 Validating merge..."
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

# Build
echo "🚀 Building with merged configuration..."
docker compose \
    -f coolify-base.yml \
    -f coolify-database.yml \
    -f coolify-cache.yml \
    -f coolify-search.yml \
    -f coolify-application.yml \
    -f coolify-backup.yml \
    -f docker-compose.yml \
    build

echo "✅ Build completed successfully"
