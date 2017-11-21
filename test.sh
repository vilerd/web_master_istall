#!/bin/bash

echo
echo -n -e "\e[1;32mEnter password for root user mysql:\e[0m"
read -s MYSQL
echo
echo -n -e "\e[1;32mEnter name wordpress database:\e[0m"
read -s BASENAME
echo
echo -n -e "\e[1;32mEnter name user database:\e[0m"
read -s USERNAME
echo
echo -n -e "\e[1;32mEnter password for database:\e[0m"
read -s PASSWD
echo

echo -e "\e[1;34mMySQL-password ='$MYSQL'\e[0m"
echo -e "\e[1;34mName wordpress database = '$BASENAME'\e[0m"
echo -e "\e[1;34mName user database = '$USERNAME'\e[0m"
echo -e "\e[1;34mPassword database = '$PASSWD'\e[0m"

echo "Are the entered data correct? (y/N) "
read item
case "$item" in
    y|Y) echo -e "\e[1;32mGO!\e[0m"
        ;;
    n|N) echo -e "\e[1;31mGoodbye!\e[0m" && exit
        exit 0
        ;;
    *) echo -e "\e[1;31mError!!! Incorrect choice! Try again!\e[0m" && exit
        ;;
esac

mkdir /tmp/boot

sudo apt-get update && apt-get upgrade -y

sudo apt install nginx -y

sudo apt install apache2 -y



sudo apt install -y php7.0
sudo apt install -y php7.0-db
sudo apt install -y php7.0-fpm 
sudo apt install -y php7.0-mysql
sudo apt install -y php7.0-mbstring
sudo apt install -y php7.0-xml
sudo apt install -y php7.0-curl
sudo apt install -y php7.0-zip
sudo apt install -y php7.0-gd
sudo apt install -y php7.0-xmlrpc
sudo apt install -y php7.0-cli
sudo apt install -y php7.0-curl


sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password password '$MYSQL''
sudo debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password_again password '$MYSQL''
sudo apt-get install -y mysql-server mysql-client
echo -e "\e[1;32mInstall MySQL\e[0m"


mysql -u root -p$MYSQL <<EOF
CREATE DATABASE $BASENAME;
CREATE USER $USERNAME@localhost IDENTIFIED BY '$PASSWD';
grant all privileges on $BASENAME.* to '$USERNAME'@'localhost';
FLUSH PRIVILEGES;
EOF
echo -e "\e[1;32mDatabase WordPress created\e[0m"


wget http://wordpress.org/latest.tar.gz -q -P /tmp/boot
tar xzfC /tmp/boot/latest.tar.gz /tmp/boot
sudo cp /tmp/boot/wordpress/wp-config-sample.php  /tmp/boot/wordpress/wp-config.php



sudo rm /etc/apache2/sites-enabled/000-default.conf
sudo mv Apache2_virtual_host /etc/apache2/sites-available/wordpress_a
sudo ln -s /etc/apache2/sites-available/wordpress_a /etc/nginx/sites-enabled/wordpress_a


sudo rm /etc/nginx/sites-enabled/default
sudo mv nginx-virtual_host /etc/nginx/sites-available/wordpress_n
sudo ln -s /etc/nginx/sites-available/wordpress_n /etc/nginx/sites-enabled/wordpress_n
