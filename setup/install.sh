#!/bin/bash

UNATTENDED=1

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "Setup script running"
echo "Updating system"
apt -y update
apt -y upgrade
echo "Installing git and LAMP stack"
sleep 3
apt -y install git apache2
#ufw enable
#ufw allow 22
#ufw allow 3306
#ufw allow 80
#ufw allow 443
apt install -y mysql-server
echo "Please enter password for MySQL root user"

mysql_passw="ciccione"
if [[ UNATTENDED -ne 1 ]]; then
	read -sp 'MySQL password: ' mysql_passw
fi


if [[ -z "$mysql_passw" ]]; then
	echo "Credentials not set, please try again"
	exit 1
fi

echo "MySQL credentials set - root:$mysql_passw"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_passw"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_passw"
sleep 3
apt -y install php libapache2-mod-php php-mysql
mysql -u root -p"$mysql_passw" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY "$mysql_passw";
FLUSH PRIVILEGES;
EXIT
EOF
systemctl restart apache2
rm /var/www/html/index.html
cp index.php /var/www/html/index.php
echo "DONE! - MySQL username: root"
