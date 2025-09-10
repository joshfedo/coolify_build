FROM alpine:3.18

RUN apk add --no-cache \
    bash \
    curl \
    mysql-client \
    git \
    jq \
    wget \
    tar \
    gzip

COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh
RUN chmod +x /scripts/**/*.sh

WORKDIR /scripts

ENTRYPOINT ["/scripts/orchestrator.sh"]
