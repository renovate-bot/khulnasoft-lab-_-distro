#!/usr/bin/env bash
set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p /etc/distro
cp ${HERE}/../distro.service /etc/systemd/system
cp ${HERE}/../env /etc/distro/env
systemctl daemon-reload
systemctl start distro.service