#!/bin/bash

UNATTENDED=1

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive


## Installazione dipendenze
cd setup
bash ./install.sh
cd ..

cd wordpress
bash ./install.sh
cd ..

cd moodle
bash ./install.sh
cd ..

cd docker
bash ./install.sh
cd ..

cd jitsi
bash ./install.sh
cd ..
