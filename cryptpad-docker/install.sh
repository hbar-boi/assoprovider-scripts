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
# Ask for credentials
#

# Import existing settings
if [ -f .env ]; then
  . ./.env
fi

ufw allow 3000
ufw allow 3001

#
# Setup service
#
cat > /etc/systemd/system/cryptpad.service <<EOF
[Unit]
Description = Cryptpad in Docker

Requires = docker.service
After = docker.service

[Service]
ExecStartPre = $(command -v docker-compose) pull --ignore-pull-failures
ExecStart = $(command -v docker-compose) up --remove-orphans

TimeoutStartSec = 0s

WorkingDirectory = $(pwd)

[Install]
WantedBy = multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now cryptpad.service
