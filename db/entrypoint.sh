#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# If this is a preview deployment, restore the database
if [ "$COOLIFY_PREVIEW_DEPLOYMENT" = "true" ]; then
  /usr/local/bin/restore.sh
fi

# Execute the original entrypoint
exec docker-entrypoint.sh "$@"