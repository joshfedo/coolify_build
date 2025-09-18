#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables
BACKUP_DIR="/backups"
LATEST_BACKUP=$(ls -t $BACKUP_DIR/dump-*.sql.gz | head -1)

# Check if a backup file exists
if [ -z "$LATEST_BACKUP" ]; then
  echo "No backup file found. Starting with an empty database."
  exit 0
fi

# Restore the latest backup
echo "Restoring database from $LATEST_BACKUP..."
gunzip < "$LATEST_BACKUP" | mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"

echo "Database restored."