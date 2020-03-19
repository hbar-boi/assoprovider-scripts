#!/bin/sh
set -e # Fallisci in caso di errore

sudo -v

sudo apt update
sudo apt -y install git nodejs ufw
sudo npm install -g bower

git clone https://github.com/xwiki-labs/cryptpad.git $HOME/.cryptpad

cp config.js $HOME/.cryptpad/config/config.js

cd $HOME/.cryptpad

npm install
bower install

sudo ufw allow 3000
sudo ufw allow 3001

sudo bash -c "cat > /etc/systemd/system/cryptpad.service" <<EOF
[Unit]
Description = Cryptpad service

[Service]
ExecStart = /usr/bin/node $HOME/.cryptpad/server

TimeoutStartSec = 0s
WorkingDirectory=$HOME/.cryptpad
[Install]
WantedBy = multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now cryptpad.service
