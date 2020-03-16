#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt -y purge --auto-remove git apache2 mysql* php libapache2-mod-php php-mysql
apt autoclean
apt remove dbconfig-mysql

echo "DONE! - LAMP stack and git successfully removed"

