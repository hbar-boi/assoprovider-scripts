#!/bin/bash

UNATTENDED=1

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

#
inst_dir="/var/opendidattica/"
if [[ UNATTENDED -ne 1 ]]; then
	read -p "Install Dir for JITSI: " inst_dir
fi

mkdir inst_dir

cd instdir

git clone https://github.com/jitsi/docker-jitsi-meet && cd docker-jitsi-meet

cp  env.example .env

docker-compose up -d

# Install  service
#

cat > "/etc/systemd/system/docker-jitsi-meet.service" <<EOF

[Unit]
Description=Jitsi Meet con Docker

Requires=docker.service
After=docker.service

[Service]
Type = oneshot

# Sostituire con il path ASSOLUTO a dove abbiamo eseguito il git clone
WorkingDirectory=/home/mioutente/docker-jitsi-meet

ExecStart = /usr/bin/docker-compose up -d

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now docker-jitsi-meet.service
