FROM nginx:alpine

LABEL maintainer="KhulnaSoft DevOps <security@khulnasoft.com>"

COPY nginx.conf /etc/nginx/nginx.conf
COPY cert/ /etc/nginx/cert
COPY bin /usr/local/bin
RUN apk add --no-cache openssl && \
    /usr/local/bin/install && \
    apk del openssl && \
    rm -rf /var/cache/apk/*
