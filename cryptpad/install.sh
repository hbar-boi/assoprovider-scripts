#!/bin/sh
set -e # Fallisci in caso di errore

apt update
apt -y install git nodejs npm
npm install -g bower

git clone https://github.com/xwiki-labs/cryptpad.git /var/cryptpad

cp config.js /var/cryptpad/config/config.js

cd /var/cryptpad

npm install
bower install --allow-root

#sudo ufw allow 3000
#sudo ufw allow 3001

cat > /etc/systemd/system/cryptpad.service <<EOF
[Unit]
Description = Cryptpad service

[Service]
ExecStart = /usr/bin/node /var/cryptpad/server

TimeoutStartSec = 0s
WorkingDirectory=/var/cryptpad
[Install]
WantedBy = multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now cryptpad.service
