#!/bin/bash
set -e

REGISTRY_URL="docker-reg.ubuntu.orb.local"
REGISTRY_USER="testuser"
REGISTRY_PASS="testpassword"
IMAGE_NAME="magento-init"
VERSION=${1:-latest}

echo "Building Magento Init Container v$VERSION"

docker build -t "$REGISTRY_URL/$IMAGE_NAME:$VERSION" .
docker tag "$REGISTRY_URL/$IMAGE_NAME:$VERSION" "$REGISTRY_URL/$IMAGE_NAME:latest"

echo "Logging into registry"
echo "$REGISTRY_PASS" | docker login "$REGISTRY_URL" -u "$REGISTRY_USER" --password-stdin

echo "Pushing images"
docker push "$REGISTRY_URL/$IMAGE_NAME:$VERSION"
docker push "$REGISTRY_URL/$IMAGE_NAME:latest"

echo "Build and push complete"
echo "Image: $REGISTRY_URL/$IMAGE_NAME:$VERSION"
