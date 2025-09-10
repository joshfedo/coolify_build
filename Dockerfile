FROM docker:24-dind

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
COPY deploy.sh /deploy.sh
COPY Dockerfile.init /Dockerfile.init

RUN chmod +x /scripts/*.sh
RUN chmod +x /scripts/**/*.sh
RUN chmod +x /deploy.sh

WORKDIR /workspace

CMD ["/deploy.sh"]
