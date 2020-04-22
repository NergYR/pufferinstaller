# This adds the https://packages.sury.org/php/ repo in order to install php7
apt -y install apt-transport-https lsb-release ca-certificates wget
wget https://packages.sury.org/php/apt.gpg -O - | sudo apt-key add -
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# If you currently have apache2 installed you will not be able to use nginx as well. Please plan accordingly.
apt update
apt install -y openssl curl nginx mysql-client mysql-server php-fpm php-cli php-curl php-mysql

## Make sure to set the MySQL root password when running this
mysql_secure_installation

# Please run these with either sudo in front of them, or as the root user (sudo -i)
mkdir -p /srv && cd /srv
curl -L -o pufferpanel.tar.gz https://git.io/fNZYg
tar -xf pufferpanel.tar.gz
cd pufferpanel 
chmod +x pufferpanel
./pufferpanel install