# Coolify Build - Modular Magento Docker Compose

This repository provides a modular Docker Compose setup for deploying Magento applications on Coolify. It separates services into individual files for better maintainability and allows projects to include a complete stack with minimal configuration.

## 🎯 Goals

- **Centralized Configuration**: Update the master compose files once, apply to all projects
- **Minimal Project Setup**: New projects need only a simple docker-compose.yml include
- **Coolify Integration**: Designed specifically for Coolify with proper defaults and variable handling
- **Easy Customization**: Override specific services as needed per project

## 📁 Repository Structure

```
/services/
├── database.yml      # MariaDB with preview environment support
├── backup.yml        # Automated nightly database backups  
├── cache.yml         # Redis cache service
├── search.yml        # OpenSearch for Magento
├── application.yml   # Magento application container
├── networks.yml      # Network definitions
└── volumes.yml       # Persistent volume definitions

docker-compose.master.yml  # Includes all services
docker-compose.yml         # Example project file
```

## 🚀 Quick Start

### For New Projects

Create a `docker-compose.yml` in your Magento project root:

```yaml
version: '3.8'

include:
  - https://raw.githubusercontent.com/joshfedo/coolify_build/main/docker-compose.master.yml
```

That's it! Deploy in Coolify and you'll get:
- MariaDB with backup/restore for preview environments
- Redis cache
- OpenSearch
- Magento application container
- Automated nightly backups

### With Custom Overrides

```yaml
version: '3.8'

include:
  - https://raw.githubusercontent.com/joshfedo/coolify_build/main/docker-compose.master.yml

# Override specific services
services:
  magento:
    image: shinsenter/magento:${PHP_IMAGE_TAG:-php8.3-nginx}  # Different PHP version
    environment:
      - CUSTOM_VAR=value
```

## 🔧 Coolify Configuration

### Environment Variables

All key settings are configurable via Coolify environment variables:

**Database:**
- `DB_IMAGE_TAG` (default: 10.6)
- `COOLIFY_DATABASE_NAME` (default: magento)
- `COOLIFY_DATABASE_USER` (default: magento) 
- `COOLIFY_DATABASE_PASSWORD` (default: magento_password)
- `COOLIFY_DATABASE_ROOT_PASSWORD` (default: root_password)

**Application:**
- `PHP_IMAGE_TAG` (default: php8.2-nginx)
- `COOLIFY_ENV_ADMIN_USER` (default: admin)
- `COOLIFY_ENV_ADMIN_PASSWORD` (default: Password123!)

**Infrastructure:**
- `REDIS_IMAGE_TAG` (default: 6.2-alpine)
- `OPENSEARCH_IMAGE_TAG` (default: 2.5.0)

### Preview Environments

The stack automatically handles preview deployments:
- Database imports from latest backup if available
- Sanitizes URLs for the preview domain
- Enables debug mode
- Sets payment modes to sandbox

### Backup Service

Enable automated backups by adding the `backup` profile in Coolify:
- Runs nightly at midnight
- Creates `/backups/latest.sql`
- Used by preview environments for seeding

## 🔄 Service Details

### Database (MariaDB)
- Automatic backup import for preview environments
- URL sanitization for preview domains
- Debug mode enablement for development

### Backup Service
- Nightly automated backups
- Skipped on preview environments
- 2-minute connection timeout with retry logic

### Application (Magento)
- Traefik labels for automatic SSL and routing
- Connects to all infrastructure services
- Configurable PHP version via environment variable

### Cache & Search
- Redis for session and cache storage
- OpenSearch for product search and catalog

## 🛠 Development Workflow

1. **Update Master**: Make changes to service files in this repo
2. **Automatic Propagation**: All projects using the master file get updates
3. **Project Overrides**: Individual projects can override specific services
4. **Version Control**: Tag releases for stable deployments

## 📋 Example Project Setup

1. Create new Magento project repository
2. Add this docker-compose.yml:
   ```yaml
   version: '3.8'
   include:
     - https://raw.githubusercontent.com/joshfedo/coolify_build/main/docker-compose.master.yml
   ```
3. Set up in Coolify using Docker Compose build pack
4. Configure environment variables as needed
5. Deploy!

## 🔧 Customization Examples

### Different PHP Version
```yaml
services:
  magento:
    image: shinsenter/magento:${PHP_IMAGE_TAG:-php8.3-nginx}
```

### Additional Environment Variables
```yaml
services:
  magento:
    environment:
      - CUSTOM_MODULE_ENABLED=true
      - DEBUG_MODE=${DEBUG_MODE:-false}
```

### Custom Volumes
```yaml
services:
  magento:
    volumes:
      - ./custom-config:/var/www/html/app/etc
```

## 🆘 Troubleshooting

### Include Chain Issues
If Docker Compose can't resolve includes, ensure:
- GitHub URLs are accessible from your Coolify server
- File paths in includes are correct
- Network connectivity to GitHub

### Preview Environment Issues
- Check `COOLIFY_PREVIEW_DEPLOYMENT` environment variable
- Verify backup file exists at `/backups/latest.sql`
- Check database connection logs

### Backup Service Not Running
- Ensure `backup` profile is enabled in Coolify
- Check database connectivity
- Verify credentials and permissions

## 📚 References

- [Coolify Documentation](https://coolify.io/docs)
- [Docker Compose Include](https://docs.docker.com/compose/multiple-compose-files/include/)
- [Magento Docker Images](https://github.com/shinsenter/php)
