#!/bin/bash

# Test script for download & merge approach
# Simulates what happens in Coolify's build process

set -e

echo "🧪 Testing Coolify Download & Merge System"
echo "=========================================="

# Create a test directory
TEST_DIR="/tmp/coolify-merge-test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "📁 Test directory: $TEST_DIR"

# Create a sample project docker-compose.yml (with overrides)
cat > docker-compose.yml << 'EOF'
version: '3.8'

# Sample project overrides
services:
  magento:
    image: shinsenter/magento:${PHP_IMAGE_TAG:-php8.3-nginx}
    environment:
      - CUSTOM_PROJECT_VAR=test-value
      - SERVICE_FQDN_MAGENTO
      - SERVICE_PASSWORD_MAGENTO

  # Add a project-specific service
  mailhog:
    image: mailhog/mailhog:latest
    expose:
      - "8025"
    networks:
      - magento-network
EOF

# Download modules (simulate Coolify build command)
echo "📦 Downloading modules from GitHub..."
BASE_URL="https://raw.githubusercontent.com/joshfedo/coolify_build/main"

curl -s "$BASE_URL/base.yml" -o coolify-base.yml
curl -s "$BASE_URL/services/database.yml" -o coolify-database.yml  
curl -s "$BASE_URL/services/cache.yml" -o coolify-cache.yml
curl -s "$BASE_URL/services/search.yml" -o coolify-search.yml
curl -s "$BASE_URL/services/application.yml" -o coolify-application.yml
curl -s "$BASE_URL/services/backup.yml" -o coolify-backup.yml

echo "✅ Downloaded all modules"

# Test the merge
echo "🔍 Testing merge configuration..."
if docker-compose -f coolify-base.yml -f coolify-database.yml -f coolify-cache.yml -f coolify-search.yml -f coolify-application.yml -f coolify-backup.yml -f docker-compose.yml config > merged-result.yml 2>/dev/null; then
    echo "✅ Merge successful!"
    
    # Count services
    service_count=$(yq eval '.services | keys | length' merged-result.yml 2>/dev/null || echo "0")
    echo "📊 Total services in merged file: $service_count"
    
    if [ "$service_count" -gt 0 ]; then
        echo "📋 Services found:"
        yq eval '.services | keys | .[]' merged-result.yml 2>/dev/null | sed 's/^/   - /'
        
        # Check for magic variables
        if grep -q "SERVICE_FQDN_MAGENTO" merged-result.yml; then
            echo "✅ Magic variables preserved"
        fi
        
        # Check for project override
        if grep -q "CUSTOM_PROJECT_VAR" merged-result.yml; then
            echo "✅ Project overrides applied"
        fi
        
        # Check for mailhog (project-specific service)
        if grep -q "mailhog" merged-result.yml; then
            echo "✅ Project-specific services added"
        fi
        
        echo ""
        echo "🎉 Download & Merge test PASSED!"
        echo ""
        echo "💡 To use in Coolify:"
        echo "   1. Add docker-compose.yml with overrides to your project"
        echo "   2. Set Custom Build Command to download & merge"
        echo "   3. Deploy with complete merged configuration"
        
    else
        echo "❌ No services found in merged result"
        exit 1
    fi
    
else
    echo "❌ Merge failed with errors:"
    docker-compose -f coolify-base.yml -f coolify-database.yml -f coolify-cache.yml -f coolify-search.yml -f coolify-application.yml -f coolify-backup.yml -f docker-compose.yml config
    exit 1
fi

# Show the actual custom build command to use
echo ""
echo "📋 Coolify Custom Build Command:"
echo "curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/base.yml -o coolify-base.yml && curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/database.yml -o coolify-database.yml && curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/cache.yml -o coolify-cache.yml && curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/search.yml -o coolify-search.yml && curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/application.yml -o coolify-application.yml && curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/backup.yml -o coolify-backup.yml && docker compose -f coolify-base.yml -f coolify-database.yml -f coolify-cache.yml -f coolify-search.yml -f coolify-application.yml -f coolify-backup.yml -f docker-compose.yml build"

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo "🚀 Ready to implement in your Magento projects!"
