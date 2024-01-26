FROM dind-ansible:latest

RUN apk add --no-cache wget git rsync

RUN adduser -D -u 1001 -G root -G docker distro && \
    mkdir -p /tmp/distro && \
    mkdir -p /etc/distro && \
    mkdir -p /var/lib/distro && \
    chown -R distro:0 /tmp/distro && \
    chown -R distro:0 /etc/distro && \
    chown -R distro:0 /var/lib/distro

RUN wget https://raw.githubusercontent.com/khulnasoft-lab/distro/develop/deployment/docker/common/runner-wrapper -P /usr/local/bin/ && chmod +x /usr/local/bin/runner-wrapper
RUN wget https://github.com/khulnasoft-lab/distro/releases/download/v2.9.37/distro_2.9.37_linux_amd64.tar.gz -O - | tar -xz -C /usr/local/bin/ distro

RUN chown -R distro:0 /usr/local/bin/runner-wrapper &&\
    chown -R distro:0 /usr/local/bin/distro &&\
    chmod +x /usr/local/bin/runner-wrapper &&\
    chmod +x /usr/local/bin/distro

WORKDIR /home/distro
USER 1001

RUN mkdir ./venv

RUN python3 -m venv ./venv --system-site-packages && \
    source ./venv/bin/activate && \
    pip3 install --upgrade pip boto3 botocore requests

RUN echo '{"tmp_path": "/tmp/distro","dialect": "bolt", "runner": {"config_file": "/var/lib/distro/runner.json"}}' > /etc/distro/config.json

CMD [ "/usr/local/bin/runner-wrapper" ]