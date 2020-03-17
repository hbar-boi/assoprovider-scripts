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

if [ -z "$DB_PASS" ]; then
  while [ -z "$DB_PASS" ]; do
    printf 'Database password? ' && read -r DB_PASS
  done
  echo "DB_PASS=$DB_PASS" >> .env
fi

#
# Setup service
#
cat > /etc/systemd/system/wordpress.service <<EOF
[Unit]
Description = Wordpress in Docker

Requires = docker.service
After = docker.service

[Service]
ExecStart = $(command -v docker-compose) up

WorkingDirectory = $(pwd)

[Install]
WantedBy = multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now wordpress.service
