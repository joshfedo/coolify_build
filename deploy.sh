#!/bin/bash
set -e

REGISTRY_URL=${REGISTRY_URL:-docker-reg.ubuntu.orb.local}
REGISTRY_USER=${REGISTRY_USER:-testuser}
REGISTRY_PASS=${REGISTRY_PASS:-testpassword}
IMAGE_NAME="magento-init"
VERSION=${COMMIT_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo "latest")}

echo "Building Magento Init Container"
echo "Version: $VERSION"
echo "Registry: $REGISTRY_URL"

docker build -t "$REGISTRY_URL/$IMAGE_NAME:$VERSION" .

echo "Logging into registry"
echo "$REGISTRY_PASS" | docker login "$REGISTRY_URL" -u "$REGISTRY_USER" --password-stdin

echo "Tagging and pushing"
docker tag "$REGISTRY_URL/$IMAGE_NAME:$VERSION" "$REGISTRY_URL/$IMAGE_NAME:latest"
docker push "$REGISTRY_URL/$IMAGE_NAME:$VERSION"
docker push "$REGISTRY_URL/$IMAGE_NAME:latest"

echo "Build complete: $REGISTRY_URL/$IMAGE_NAME:$VERSION"
