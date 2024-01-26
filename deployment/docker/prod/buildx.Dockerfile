# ansible-distro production image
FROM --platform=$BUILDPLATFORM golang:1.20-alpine3.18 as builder

COPY ./ /go/src/github.com/khulnasoft-lab/distro
WORKDIR /go/src/github.com/khulnasoft-lab/distro

ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache -U libc-dev curl nodejs npm git gcc
RUN ./deployment/docker/prod/bin/install ${TARGETOS} ${TARGETARCH}

FROM alpine:3.18 as runner
LABEL maintainer="Tom Whiston <tom.whiston@gmail.com>"

RUN apk add --no-cache sshpass git curl ansible mysql-client openssh-client-default tini py3-aiohttp && \
    adduser -D -u 1001 -G root distro && \
    mkdir -p /tmp/distro && \
    mkdir -p /etc/distro && \
    mkdir -p /var/lib/distro && \
    chown -R distro:0 /tmp/distro && \
    chown -R distro:0 /etc/distro && \
    chown -R distro:0 /var/lib/distro

COPY --from=builder /usr/local/bin/distro-wrapper /usr/local/bin/
COPY --from=builder /usr/local/bin/distro /usr/local/bin/

RUN chown -R distro:0 /usr/local/bin/distro-wrapper &&\
    chown -R distro:0 /usr/local/bin/distro &&\
    chmod +x /usr/local/bin/distro-wrapper &&\
    chmod +x /usr/local/bin/distro

WORKDIR /home/distro
USER 1001

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/distro-wrapper", "/usr/local/bin/distro", "server", "--config", "/etc/distro/config.json"]
