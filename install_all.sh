#!/bin/bash

UNATTENDED=1

export DEBIAN_FRONTEND=noninteractive


## Installazione dipendenze
cd setup
sudo bash ./install.sh
cd ..

cd wordpress
sudo bash ./install.sh
cd ..

cd moodle
sudo bash ./install.sh
cd ..

cd docker
sudo bash ./install.sh
cd ..

cd jitsi
sudo bash ./install.sh
cd ..

cd cryptpad
bash ./install.sh
cd ..
