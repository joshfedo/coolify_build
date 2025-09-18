#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# If this is a preview deployment, do nothing.
if [ "$COOLIFY_PREVIEW_DEPLOYMENT" = "true" ]; then
  echo "Backup script disabled for preview deployments."
  exit 0
fi

# Variables
BACKUP_DIR="/backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/dump-$DATE.sql.gz"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Create a gzipped database dump
echo "Creating backup of $MYSQL_DATABASE database..."
mysqldump -h db -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" | gzip > "$BACKUP_FILE"

echo "Backup created: $BACKUP_FILE"