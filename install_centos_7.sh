# This installs the epel and remi repos for php7 support
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php72

# If you currently have apache2 installed you will not be able to use nginx as well. Please plan accordingly.
yum update
yum install nginx mariadb-server mariadb php-fpm php-common php-cli php-pdo php-mysqlnd -y

# Make sure to run these commands to make sure the services start on reboot
systemctl enable nginx
systemctl start nginx

systemctl enable mariadb
systemctl start mariadb

systemctl enable php-fpm
systemctl start php-fpm

## Make sure to set the MySQL root password when running this
mysql_secure_installation

## Add rule for selinux so nginx can reach our files
mkdir -p /srv/pufferpanel
chcon -Rt httpd_sys_content_t /srv/pufferpanel
## Allow http to connect to networks (to reach pufferd)
setsebool -P httpd_can_network_connect 1


# Please run these with either sudo in front of them, or as the root user (sudo -i)
mkdir -p /srv && cd /srv
curl -L -o pufferpanel.tar.gz https://git.io/fNZYg
tar -xf pufferpanel.tar.gz
cd pufferpanel 
chmod +x pufferpanel
./pufferpanel install
