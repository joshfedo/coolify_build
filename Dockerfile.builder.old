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
RUN chmod +x /scripts/*.sh
RUN chmod +x /scripts/**/*.sh
RUN chmod +x /deploy.sh

WORKDIR /scripts

CMD ["/deploy.sh"]
