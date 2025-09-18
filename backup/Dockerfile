# Use the same MariaDB image as the base
ARG MARIADB_VERSION=10.6
FROM mariadb:${MARIADB_VERSION}

# Install cron
RUN apt-get update && apt-get install -y cron

# Create a script to run the backup
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Add the cron job
COPY crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron
RUN crontab /etc/cron.d/backup-cron

# Create a log file for the cron job
RUN touch /var/log/cron.log

# Run the cron daemon in the foreground
CMD ["cron", "-f"]