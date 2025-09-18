# Use the same MariaDB image as the base
ARG MARIADB_VERSION=10.6
FROM mariadb:${MARIADB_VERSION}

# Copy the entrypoint and restore scripts
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY restore.sh /usr/local/bin/restore.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/restore.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# The default command for the mariadb image
CMD ["mysqld"]
