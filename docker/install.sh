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

[ -x "$(command -v docker)" ] || apt-get install -y docker.io
[ -x "$(command -v docker-compose)" ] || apt-get install -y docker-compose

systemctl is-enabled docker.service > /dev/null || systemctl enable --now docker.service

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
systemctl is-enabled docker-cleanup.timer || systemctl enable --now docker-cleanup.timer
