#!/bin/bash

UNATTENDED=1

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi
apt update
apt -y install git

NEWUSER="opendidattica"

#user: opendidattica, passw: opendidattica
#TODO CHANGE THIS
#password generated using mkpasswd

useradd -m -p FFN98lJiCXnqs -s/bin/bash $NEWUSER
usermod -aG sudo $NEWUSER
echo "Utente scelto: $NEWUSER"
cd ~$NEWUSER
su -c "git clone https://github.com/hbar-boi/assoprovider-scripts.git" opendidattica
cd assoprovider-scripts
git checkout test-vm-no-docker-main
su -c "sudo -S ./install_all.sh" opendidattica

deluser $NEWUSER sudo
