apt install software-properties-common
apt-add-repository universe
## Because people may have trouble installing the php-fpm. But this work around worked for my install.

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