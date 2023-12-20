#!/usr/bin/env bash
set -e

systemctl stop distro.service
systemctl disable distro.service
rm /etc/systemd/system/distro.service
rm -rf /etc/distro