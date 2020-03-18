#!/bin/sh
set -e # Fallisci in caso di errore

#
# Root check
#

if [ "$(id -u)" != "0" ]; then
  echo 'Lancia come root' > /dev/stderr && exit 1
fi

#
# Docker check
#

if ! [ -x "$(command -v docker)" ]; then
  echo "Installare Docker" > /dev/stderr && exit 1
fi

#
# Lancia il servizio
#
cat > /etc/systemd/system/frontend.service <<EOF
[Unit]
Description = Services frontend

Requires = docker.service
After = docker.service

After = moodle.service
After = wordpress.service

[Service]
ExecStartPre = $(command -v docker-compose) pull --ignore-pull-failures
ExecStart = $(command -v docker-compose) up --remove-orphans

TimeoutStartSec = 0s

WorkingDirectory = $(pwd)

[Install]
WantedBy = multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now frontend.service
