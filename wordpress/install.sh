#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo "Please run as root"
	exit 1
fi

read -p "Password for MySQL root: " root_passw

echo "Please enter NEW wordpress user credentials"
read -p "Wordpress admin username: " wp_user
read -p "Wordpress admin password: " wp_passw

if [[ -z $wp_user || -z $wp_passw ]]; then
	echo "Credentials not set, please try again"
	exit 1
fi

mysql -u root -p"$root_passw" <<EOF
CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS "$wp_user"@'localhost' IDENTIFIED BY "$wp_passw";
GRANT ALL ON wordpress.* TO "$wp_user"@'localhost' IDENTIFIED BY "$wp_passw";
EXIT
EOF

mkdir -p /var/www/html/wordpress
wget https://wordpress.org/latest.tar.gz -P /tmp
tar xf /tmp/latest.tar.gz -C /tmp
mv /tmp/wordpress/* /var/www/html/wordpress/
chown -R www-data: /var/www/html/wordpress
echo "Cleaning up..."
rm /tmp/latest.tar.gz

systemctl restart apache2
echo "Wordpress user set - $wp_user:$wp_passw"
echo "Wordpress database created: wordpress"
echo "DONE! - Navigate to http://localhost/wordpress to finish set-up"
echo "Use parameters above to complete set-up"
