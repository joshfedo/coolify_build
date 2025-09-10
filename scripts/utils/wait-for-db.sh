#!/bin/bash

wait_for_database() {
    log "Waiting for database connection"
    for i in {1..120}; do
        if mysqladmin ping -h "$DB_HOST" --silent 2>/dev/null; then
            log "Database connection established"
            return 0
        fi
        if [ $i -eq 120 ]; then
            log "Database connection timeout after 2 minutes"
            exit 1
        fi
        sleep 1
    done
}

wait_for_service() {
    local host=$1
    local port=$2
    local timeout=${3:-60}
    
    log "Waiting for $host:$port"
    for i in $(seq 1 $timeout); do
        if nc -z "$host" "$port" 2>/dev/null; then
            log "Service $host:$port is ready"
            return 0
        fi
        if [ $i -eq $timeout ]; then
            log "Service $host:$port timeout"
            exit 1
        fi
        sleep 1
    done
}
