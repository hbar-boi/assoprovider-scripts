#!/bin/sh
set -e # Fallisci in caso di errore

#
# Root check
#

if [ "$(id -u)" != "0" ]; then
  echo 'Lancia come root' > /dev/stderr && exit 1
fi

#
# Install Docker
#

apt-get install -y \
  docker.io \
  docker-compose
systemctl enable --now docker.service

#
# Install Docker cleanup service
#

cat > "/etc/systemd/system/docker-cleanup.timer" <<EOF
[Unit]
Description = Periodic cleanup of Docker containers

Requires = docker.service

[Timer]
OnCalendar = daily

[Install]
WantedBy = multi-user.target
EOF

cat > "/etc/systemd/system/docker-cleanup.service" <<EOF
[Unit]
Description = Periodic cleanup of Docker containers

Requires = docker.service

[Service]
ExecStart = $(command -v docker) system prune --all --force
EOF

systemctl daemon-reload
systemctl enable --now docker-cleanup.timer
