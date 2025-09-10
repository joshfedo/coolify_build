# Download & Merge Setup for Magento Projects

## 🎯 **How It Works**

1. **Download modules** from coolify_build repo during build
2. **Merge with local overrides** using Docker Compose's native `-f` flag support  
3. **Deploy complete stack** with centralized updates + project customizations

## 🚀 **Setup in Your Magento Project**

### **Step 1: Create docker-compose.yml (Local Overrides)**

```yaml
version: '3.8'

# Local project overrides and customizations
# This file merges LAST, so it can override anything from downloaded modules

services:
  magento:
    # Override PHP version for this project
    image: shinsenter/magento:${PHP_IMAGE_TAG:-php8.3-nginx}
    environment:
      # Add project-specific environment variables
      - CUSTOM_MODULE_ENABLED=${CUSTOM_MODULE_ENABLED:-true}
      - PROJECT_MODE=${PROJECT_MODE:-development}
      # You can still use magic variables
      - ADMIN_PASSWORD=${SERVICE_PASSWORD_MAGENTO}
    # Add project-specific volumes
    volumes:
      - magento-code:/var/www/html
      - ./custom-config:/var/www/html/app/etc/custom

  # Add project-specific services if needed
  # redis:
  #   environment:
  #     - REDIS_PASSWORD=${SERVICE_PASSWORD_REDIS}

# Project-specific volumes
volumes:
  custom-config:
```

### **Step 2: Configure Coolify Custom Build Command**

In Coolify, set your **Custom Build Command** to:

```bash
curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/base.yml -o coolify-base.yml && \
curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/database.yml -o coolify-database.yml && \
curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/cache.yml -o coolify-cache.yml && \
curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/search.yml -o coolify-search.yml && \
curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/application.yml -o coolify-application.yml && \
curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/services/backup.yml -o coolify-backup.yml && \
docker compose -f coolify-base.yml -f coolify-database.yml -f coolify-cache.yml -f coolify-search.yml -f coolify-application.yml -f coolify-backup.yml -f docker-compose.yml build
```

**Or use the download script** (shorter command):

```bash
curl -s https://raw.githubusercontent.com/joshfedo/coolify_build/main/download.sh | bash && \
docker compose -f coolify-base.yml -f coolify-database.yml -f coolify-cache.yml -f coolify-search.yml -f coolify-application.yml -f coolify-backup.yml -f docker-compose.yml build
```

## 📋 **File Merge Order**

Files are merged in this order (later files override earlier ones):

1. **coolify-base.yml** - Networks, volumes, base config
2. **coolify-database.yml** - MariaDB service
3. **coolify-cache.yml** - Redis service  
4. **coolify-search.yml** - OpenSearch service
5. **coolify-application.yml** - Magento application
6. **coolify-backup.yml** - Backup service (optional)
7. **docker-compose.yml** - Your project overrides (FINAL)

## ✨ **Benefits**

✅ **Centralized Updates**: Update modules once, applies to all projects  
✅ **Project Flexibility**: Override anything in local docker-compose.yml  
✅ **Native Docker Compose**: Uses built-in merging, no hacks  
✅ **Coolify Magic Variables**: Works with SERVICE_FQDN_*, etc.  
✅ **No Build Scripts**: Direct docker-compose commands  
✅ **Version Control**: Local overrides are tracked in your repo  

## 🎛️ **Common Override Examples**

### **Different PHP Version**
```yaml
services:
  magento:
    image: shinsenter/magento:${PHP_IMAGE_TAG:-php8.1-nginx}
```

### **Add Custom Environment Variables**
```yaml
services:
  magento:
    environment:
      - XDEBUG_ENABLED=${XDEBUG_ENABLED:-false}
      - CUSTOM_API_KEY=${CUSTOM_API_KEY}
```

### **Mount Custom Configuration**
```yaml
services:
  magento:
    volumes:
      - ./config/local.xml:/var/www/html/app/etc/local.xml
```

### **Override Database Configuration**
```yaml
services:
  db:
    environment:
      - MYSQL_ROOT_PASSWORD=${CUSTOM_ROOT_PASSWORD}
    command: >
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
```

### **Add Development Tools**
```yaml
services:
  mailhog:
    image: mailhog/mailhog:latest
    expose:
      - "8025"
    networks:
      - magento-network
```

## 🔧 **Environment Variables**

Set these in Coolify for all projects:

**Required:**
- `COOLIFY_DATABASE_PASSWORD` 
- `COOLIFY_DATABASE_ROOT_PASSWORD`
- `COOLIFY_ENV_ADMIN_PASSWORD`

**Optional with Defaults:**
- `DB_IMAGE_TAG=10.6`
- `PHP_IMAGE_TAG=php8.2-nginx`
- `REDIS_IMAGE_TAG=6.2-alpine` 
- `OPENSEARCH_IMAGE_TAG=2.5.0`

**Magic Variables** (auto-generated):
- `SERVICE_FQDN_MAGENTO` - Auto domain
- `SERVICE_URL_MAGENTO` - Auto URL
- `SERVICE_PASSWORD_MAGENTO` - Auto password

## 🎯 **Deployment Flow**

1. **Build Phase**: Downloads modules + merges with local overrides
2. **Coolify Parses**: Sees complete merged docker-compose with all services
3. **Magic Variables**: Generated for services (domains, passwords, etc.)
4. **Deploy**: Complete Magento stack with your customizations

This approach gives you **the best of both worlds**: centralized module management with complete project customization flexibility!
