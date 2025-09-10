#!/bin/bash

# Local test script for download & merge approach
# Tests with local files before pushing to GitHub

set -e

echo "🧪 Testing Coolify Download & Merge System (LOCAL)"
echo "================================================="

# Create a test directory
TEST_DIR="/tmp/coolify-merge-test-local"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "📁 Test directory: $TEST_DIR"

# Copy local files instead of downloading
BASE_DIR="/Users/Fedoryszyn/code/coolify_build"
cp "$BASE_DIR/base.yml" coolify-base.yml
cp "$BASE_DIR/services/database.yml" coolify-database.yml
cp "$BASE_DIR/services/cache.yml" coolify-cache.yml
cp "$BASE_DIR/services/search.yml" coolify-search.yml
cp "$BASE_DIR/services/application.yml" coolify-application.yml
cp "$BASE_DIR/services/backup.yml" coolify-backup.yml

echo "📦 Copied all local modules"

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

echo "📄 Created sample project docker-compose.yml"

# Test the merge
echo "🔍 Testing merge configuration..."
if docker-compose -f coolify-base.yml -f coolify-database.yml -f coolify-cache.yml -f coolify-search.yml -f coolify-application.yml -f coolify-backup.yml -f docker-compose.yml config > merged-result.yml 2>/dev/null; then
    echo "✅ Merge successful!"
    
    # Count services
    service_count=$(yq eval '.services | keys | length' merged-result.yml 2>/dev/null || grep -c "^  [a-zA-Z]" merged-result.yml || echo "0")
    echo "📊 Total services in merged file: $service_count"
    
    if [ "$service_count" -gt 0 ]; then
        echo "📋 Services found:"
        grep "^  [a-zA-Z]" merged-result.yml | sed 's/^  /   - /' | sed 's/:.*$//'
        
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
        echo "💡 Next steps:"
        echo "   1. Push files to GitHub"
        echo "   2. Use in Coolify Custom Build Command"
        echo "   3. Test with real Magento project"
        
    else
        echo "❌ No services found in merged result"
        cat merged-result.yml
        exit 1
    fi
    
else
    echo "❌ Merge failed with errors:"
    docker-compose -f coolify-base.yml -f coolify-database.yml -f coolify-cache.yml -f coolify-search.yml -f coolify-application.yml -f coolify-backup.yml -f docker-compose.yml config
    exit 1
fi

# Show a preview of the merged result
echo ""
echo "📄 Preview of merged configuration:"
echo "=================================="
head -20 merged-result.yml

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo "🚀 Ready to push to GitHub and test in Coolify!"
