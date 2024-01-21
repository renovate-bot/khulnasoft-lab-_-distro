FROM golang:1.20-alpine3.18

ENV DISTRO_VERSION="development" DISTRO_ARCH="linux_amd64" \
    DISTRO_CONFIG_PATH="${DISTRO_CONFIG_PATH:-/etc/distro}" \
    APP_ROOT="/go/src/github.com/khulnasoft-lab/distro/"

# hadolint ignore=DL3013
RUN apk add --no-cache gcc g++ sshpass git mysql-client python3 py3-pip py-openssl openssl ca-certificates curl curl-dev openssh-client-default tini nodejs npm bash rsync && \
    apk --update add --virtual build-dependencies python3-dev libffi-dev openssl-dev build-base &&\
    rm -rf /var/cache/apk/*

RUN pip3 install --upgrade pip cffi &&\
    apk del build-dependencies   && \
    pip3 install ansible

RUN adduser -D -u 1002 -g 0 distro && \
    mkdir -p /go/src/github.com/khulnasoft-lab/distro && \
    mkdir -p /tmp/distro && \
    mkdir -p /etc/distro && \
    mkdir -p /var/lib/distro && \
    chown -R distro:0 /go && \
    chown -R distro:0 /tmp/distro && \
    chown -R distro:0 /etc/distro && \
    chown -R distro:0 /var/lib/distro && \
    ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N ""       && \
    ssh-keyscan -H github.com > /root/.ssh/known_hosts

RUN cd $(go env GOPATH) && curl -sL https://taskfile.dev/install.sh | sh

RUN git config --global --add safe.directory /go/src/github.com/khulnasoft-lab/distro

# Copy in app source
WORKDIR ${APP_ROOT}
COPY . ${APP_ROOT}
RUN deployment/docker/dev/bin/install

USER distro
EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/distro-wrapper"]
CMD ["./bin/distro", "server", "--config", "/etc/distro/config.json"]
