#!/bin/bash

UNATTENDED=1

if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

#
root_passw="ciccione"
if [[ UNATTENDED -ne 1 ]]; then
	read -sp "Password for MySQL root: " root_passw
fi

echo "Please enter NEW moodle user credentials"
m_user="mymoodle"
if [[ UNATTENDED -ne 1 ]]; then
	read -p "Moodle admin username: " m_user
fi


#r
m_passw="ciccione"
if [[ UNATTENDED -ne 1 ]]; then
	read -sp "Moodle admin password: " m_passw
fi


if [[ -z $m_user || -z $m_passw ]]; then
	echo "Credentials not set, please try again"
	exit 1
fi

mysql -u root -p"$root_passw" <<EOF
CREATE DATABASE IF NOT EXISTS moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS "$m_user"@'localhost' IDENTIFIED BY "$m_passw";
GRANT ALL ON moodle.* TO "$m_user"@'localhost' IDENTIFIED BY "$m_passw";
EXIT
EOF

mkdir -p /var/www/html/moodle
git clone git://git.moodle.org/moodle.git /tmp/moodle
cd /tmp/moodle
git branch --track MOODLE_37_STABLE origin/MOODLE_37_STABLE
git checkout MOODLE_37_STABLE
mv /tmp/moodle/* /var/www/html/moodle/
chown -R www-data: /var/www/html/moodle
mkdir -p /var/www/moodledata
chown -R www-data /var/www/moodledata
chmod -R 777 /var/www/moodledata
echo "Cleaning up..."
rm -rf /tmp/moodle
apt -y install php-xml php-soap php-xmlrpc php-mbstring php-intl php-gd php-zip php-curl

systemctl restart apache2
echo "Moodle user set - $m_user"
echo "Moodle database created: moodle, moodledata path: /var/www/moodledata"
echo "DONE! - Navigate to http://localhost/moodle to finish set-up"
echo "Use parameters above to complete set-up"
