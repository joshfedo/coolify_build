#!/bin/bash
set -e

source /scripts/utils/env.sh

log "Starting backup service setup"

cat > /tmp/backup-cron.sh << 'EOF'
#!/bin/bash
source /scripts/utils/env.sh
/scripts/backup/create-backup.sh
EOF

chmod +x /tmp/backup-cron.sh

echo "0 2 * * * /tmp/backup-cron.sh" > /tmp/crontab
crontab /tmp/crontab

log "Backup service configured for daily 2 AM runs"
