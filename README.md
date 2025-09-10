# Magento Init Container

Production-ready Docker init container for automated Magento 2 deployment with Coolify.

## Build and Deploy

### Local Build
```bash
chmod +x build-and-push.sh
./build-and-push.sh [version]
```

### Coolify Auto-Build
Deploy this repo to Coolify using `docker-compose.builder.yml` as the compose file.
Set environment variables:
```
REGISTRY_URL=docker-reg.ubuntu.orb.local
REGISTRY_USER=testuser
REGISTRY_PASS=testpassword
```

## Usage

Set environment variables in Coolify:

```
REGISTRY_URL=docker-reg.ubuntu.orb.local
INIT_VERSION=latest
SETUP_MODE=auto
MAIN_APP_URL=https://production-site.com
```

## Setup Modes

- `auto`: Automatically detects preview vs production
- `fresh`: Clean Magento installation
- `clone`: Clone from another environment
- `preview`: Preview environment with sanitized data

## Directory Structure

```
scripts/
├── orchestrator.sh          # Main coordinator
├── backup/                  # Database backup operations
├── magento/                 # Magento setup scripts
└── utils/                   # Utility functions

docker-compose/
└── base-compose.yml         # Template compose file
```
