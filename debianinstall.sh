if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
apt-get update && apt-get upgrade -y 
apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
if [ ! "$(ls -A </usr/bin/curl>)" ]; then echo apt-get install curl; fi
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:chris-lea/redis-server
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update && apt-get upgrade -y 
apt-add-repository universe
apt -y install php7.4 php7.4-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz
chmod -R 755 storage/* bootstrap/cache/
mysql -u root -p
USE mysql;

# Remember to change 'somePassword' below to be a unique password specific to this account.
CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY '0K4ueC(iO{1';
CREATE DATABASE panel;
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
USE mysql;

# You should change the username and password below to something unique.
CREATE USER 'pterodactyluser'@'127.0.0.1' IDENTIFIED BY '0K4ueC(iO{1';
GRANT ALL PRIVILEGES ON *.* TO 'pterodactyluser'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
cp .env.example .env
composer install --no-dev --optimize-autoloader

# Only run the command below if you are installing this Panel for
# the first time and do not have any Pterodactyl Panel data in the database.
php artisan key:generate --force
php artisan p:environment:setup
php artisan p:environment:database

# To use PHP's internal mail sending (not recommended), select "mail". To use a
# custom SMTP server, select "smtp".
php artisan p:environment:mail
php artisan migrate --seed --force
php artisan p:user:make
# If using NGINX or Apache (not on CentOS):
chown -R www-data:www-data * 
systemctl enable --now redis-server

echo "##################################################################"
echo "##################################################################"
echo "##################################################################"
echo "Installing panel => OK"
sleep 2
echo "Database user ====> pterodactyluser 
      Database password ====> 0K4ueC(iO{1 "
sleep 3
echo "##################################################################"
echo "##################################################################"
echo "##################################################################"
echo "Installation of Daemon"
sleep 2
echo "##################################################################"
echo "##################################################################"
echo "##################################################################"

curl -sSL https://get.docker.com/ | CHANNEL=stable bash
enable docker
GRUB_CMDLINE_LINUX_DEFAULT="swapaccount=1"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt -y install nodejs make gcc g++
mkdir -p /srv/daemon /srv/daemon-data
cd /srv/daemon
curl -L https://github.com/pterodactyl/daemon/releases/download/v0.6.13/daemon.tar.gz | tar --strip-components=1 -xzv
npm install --only=production --no-audit --unsafe-perm
npm start
systemctl enable --now wings