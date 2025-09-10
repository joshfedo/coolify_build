#!/bin/bash

# Validation script for Coolify Build modular Docker Compose setup
# Run this to test that all includes work correctly

echo "🔍 Validating Coolify Build Docker Compose Setup"
echo "================================================"

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not installed"
    exit 1
fi

echo "✅ Docker Compose found"

# Validate master compose file
echo "🔍 Validating master compose file..."
if docker-compose -f docker-compose.master.yml config > /dev/null 2>&1; then
    echo "✅ Master compose file is valid"
else
    echo "❌ Master compose file has errors:"
    docker-compose -f docker-compose.master.yml config
    exit 1
fi

# Validate project compose file
echo "🔍 Validating project compose file..."
if docker-compose -f docker-compose.yml config > /dev/null 2>&1; then
    echo "✅ Project compose file is valid"
else
    echo "❌ Project compose file has errors:"
    docker-compose -f docker-compose.yml config
    exit 1
fi

# Validate individual service files
echo "🔍 Validating individual service files..."
for service_file in services/*.yml; do
    if [ -f "$service_file" ]; then
        service_name=$(basename "$service_file" .yml)
        if docker-compose -f "$service_file" config > /dev/null 2>&1; then
            echo "✅ $service_name service file is valid"
        else
            echo "❌ $service_name service file has errors:"
            docker-compose -f "$service_file" config
            exit 1
        fi
    fi
done

echo ""
echo "🎉 All validation checks passed!"
echo ""
echo "📋 Next Steps:"
echo "1. Push these files to your GitHub repository"
echo "2. Test the GitHub URL includes in a Coolify deployment"
echo "3. Configure environment variables in Coolify UI"
echo ""
echo "📖 For usage instructions, see README.md"
