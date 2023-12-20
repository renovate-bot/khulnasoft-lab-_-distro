# ansible-distro production image
FROM --platform=$BUILDPLATFORM golang:1.19-alpine3.18 as builder

COPY ./ /go/src/github.com/khulnasoft-lab/distro
WORKDIR /go/src/github.com/khulnasoft-lab/distro

ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache -U libc-dev curl nodejs npm git gcc
RUN ./deployment/docker/prod/bin/install ${TARGETOS} ${TARGETARCH}

FROM alpine/ansible:latest

RUN apk add --no-cache wget git rsync

RUN adduser -D -u 1001 -G root distro && \
    mkdir -p /tmp/distro && \
    mkdir -p /etc/distro && \
    mkdir -p /var/lib/distro && \
    chown -R distro:0 /tmp/distro && \
    chown -R distro:0 /etc/distro && \
    chown -R distro:0 /var/lib/distro

COPY --from=builder /usr/local/bin/runner-wrapper /usr/local/bin/
COPY --from=builder /usr/local/bin/distro /usr/local/bin/

RUN chown -R distro:0 /usr/local/bin/runner-wrapper &&\
    chown -R distro:0 /usr/local/bin/distro &&\
    chmod +x /usr/local/bin/runner-wrapper &&\
    chmod +x /usr/local/bin/distro

WORKDIR /home/distro
USER 1001

RUN mkdir ./venv

RUN python3 -m venv ./venv --system-site-packages && \
    source ./venv/bin/activate && \
    pip3 install --upgrade pip

RUN pip3 install boto3 botocore

RUN echo '{"tmp_path": "/tmp/distro","dialect": "bolt", "runner": {"config_file": "/var/lib/distro/runner.json"}}' > /etc/distro/config.json

CMD [ "/usr/local/bin/runner-wrapper" ]