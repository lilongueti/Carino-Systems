#!/bin/bash

## Update system packages
#sudo dnf update -y
#
## Install required packages
#sudo dnf install -y httpd mariadb-server php php-mysqlnd php-json php-gd php-mbstring php-intl php-xml php-zip php-curl php-apcu php-dom php-xmlreader php-xmlwriter php-posix php-ctype php-fileinfo php-tokenizer php-zlib php-simplexml php-ldap wget unzip
#
## Start and enable Apache
#sudo systemctl start httpd
#sudo systemctl enable httpd
#
## Start and enable MariaDB
#sudo systemctl start mariadb
#sudo systemctl enable mariadb
#
## Secure MariaDB installation
#sudo mysql_secure_installation
#
## Create a database and user for Nextcloud
#MYSQL_ROOT_PASS="your_mysql_root_password"
#NEXTCLOUD_DB="nextcloud_db"
#NEXTCLOUD_USER="nextcloud_user"
#NEXTCLOUD_PASS="your_nextcloud_password"
#
#sudo mysql -u root -p$MYSQL_ROOT_PASS <<EOF
#CREATE DATABASE $NEXTCLOUD_DB;
#CREATE USER '$NEXTCLOUD_USER'@'localhost' IDENTIFIED BY '$NEXTCLOUD_PASS';
#GRANT ALL PRIVILEGES ON $NEXTCLOUD_DB.* TO '$NEXTCLOUD_USER'@'localhost';
#FLUSH PRIVILEGES;
#EXIT;
#EOF
#
## Download and extract Nextcloud
#wget https://download.nextcloud.com/server/releases/latest.zip
#unzip latest.zip -d /var/www/html/
#sudo chown -R apache:apache /var/www/html/nextcloud/
#rm latest.zip

# Configure Apache for Nextcloud
#sudo mkdir -p /var/www/html/nextcloud/
#sudo tee /etc/httpd/conf.d/nextcloud.conf <<EOF
#Alias /nextcloud "/var/www/html/nextcloud/"
#
#<Directory /var/www/html/nextcloud/>
#  Options +FollowSymlinks
#  AllowOverride All
# <IfModule mod_dav.c>
#  Dav off
# </IfModule>
# SetEnv HOME /var/www/html/nextcloud
# SetEnv HTTP_HOME /var/www/html/nextcloud
#</Directory>
#EOF
#
## Enable required Apache modules
#sudo dnf install -y php-fpm
#sudo dnf install -y php-json php-zip php-xml php-mbstring
#sudo systemctl restart httpd
#
## Set SELinux permissions for Nextcloud
#sudo setsebool -P httpd_unified 1
#sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/nextcloud/data(/.*)?"
#sudo restorecon -Rv /var/www/html/nextcloud/
#
## Restart Apache
#sudo systemctl restart httpd
#
## Display Nextcloud installation instructions
#echo "Nextcloud installed successfully. Please complete the setup by accessing your server's IP or domain name in a web browser."
#

#!/bin/bash

# Installation Script by Scott Alan Miller
# Based on Installation Instructions by Jared Busch
# https://mangolassi.it/topic/16380/
# https://raw.githubusercontent.com/sorvani/scripts/master/Nextcloud/selinux_config.sh
#
# Example Use:
# source <(curl -s https://gitlab.com/scottalanmiller/nextcloud_fedora_installer/raw/master/nextcloud_fedora.sh)
#
# Current Version: NextCloud 13
# For: Fedora 27 Linux
#
# Script discussion link: https://mangolassi.it/topic/16389/nextcloud-automated-installation

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Installing NextCloud 13 for Fedora 27 Server or Minimal"
echo "If you have not made a DNS entry for the system,"
echo "it is recommended that you do so now."
echo ""
echo "Enter the database password for NextCloud: "
read ncpass
echo "Enter the root MariaDB user password: "
read rootpass
echo "Enter the name of your web admin user account (ex. admin)"
read adminuser
echo "Enter the initial password for admin"
read adminpass
echo "Enter the FQDN you setup for Nextcloud (ex. nc.domain.com)"
read ncfqdn

export ncpath='/var/www/html/nextcloud'
export datapath='/data'
export httpdrw='httpd_sys_rw_content_t'

dnf -y install wget unzip firewalld net-tools php mariadb mariadb-server mod_ssl php-pecl-apcu httpd php-xml php-gd php-pecl-zip php-mbstring redis php-pecl-redis php-process php-pdo certbot python2-certbot-apache php-mysqlnd policycoreutils policycoreutils-python policycoreutils-python-utils dnf-automatic sysstat php-ldap php-opcache libreoffice fail2ban
dnf -y update

cd /var/www/html
wget https://download.nextcloud.com/server/releases/nextcloud-13.0.0.zip
unzip nextcloud-13.0.0.zip
mkdir /var/www/html/nextcloud/data
chown apache:apache -R /var/www/html/nextcloud
mkdir /data
chown apache:apache -R /data
firewall-cmd --zone=FedoraServer --add-port=https/tcp --permanent #Server
firewall-cmd --zone=public --add-port=https/tcp --permanent       #Minimal
firewall-cmd --reload
systemctl start mariadb
systemctl enable mariadb
systemctl start redis
systemctl enable redis
mysql -e "CREATE DATABASE nextcloud;"
mysql -e "CREATE USER 'ncuser'@'localhost' IDENTIFIED BY '$ncpass';"
mysql -e "GRANT ALL ON nextcloud.* TO 'ncuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "UPDATE mysql.user SET Password=PASSWORD('$rootpass') WHERE User='root';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DROP DATABASE test;"
mysql -e "FLUSH PRIVILEGES;"

setsebool -P httpd_can_sendmail 1
setsebool -P httpd_can_network_connect 1
semanage fcontext -a -t ${httpdrw} "${ncpath}/config(/.*)?"
restorecon -R ${ncpath}/config
semanage fcontext -a -t ${httpdrw} "${ncpath}/apps(/.*)?"
restorecon -R ${ncpath}/apps
semanage fcontext -a -t ${httpdrw} "${ncpath}/data(/.*)?"
restorecon -R ${ncpath}/data
semanage fcontext -a -t ${httpdrw} "${ncpath}/updater(/.*)?"
restorecon -R ${ncpath}/updater
semanage fcontext -a -t ${httpdrw} "${datapath}(/.*)?"
restorecon -R ${datapath}
systemctl restart httpd
systemctl enable httpd

sed -i -e 's/;opcache.enable_cli=0/opcache.enable_cli=1/'                             /etc/php.d/10-opcache.ini;
sed -i -e 's/opcache.max_accelerated_files=4000/opcache.max_accelerated_files=10000/' /etc/php.d/10-opcache.ini;
sed -i -e 's/;opcache.save_comments=1/opcache.save_comments=1/'                       /etc/php.d/10-opcache.ini;
sed -i -e 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=1/'                   /etc/php.d/10-opcache.ini;
systemctl restart php-fpm

cd $ncpath
sudo -u apache php occ maintenance:install --database "mysql" --database-name "nextcloud" --database-user "ncuser" --database-pass $ncpass --admin-user $adminuser --admin-pass $adminpass --data-dir $datapath
sudo -u apache php occ config:system:set trusted_domains 1 --value=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
if [ -n "$ncfqdn" ]
then
  sudo -u apache php occ config:system:set trusted_domains 2 --value=$ncfqdn
fi

sed -i "$ d" /var/www/html/nextcloud/config/config.php
echo "  'memcache.locking' => '\OC\Memcache\Redis'," >> /var/www/html/nextcloud/config/config.php
echo "  'memcache.local' => '\OC\Memcache\Redis',"   >> /var/www/html/nextcloud/config/config.php
echo "      'redis' => array("                       >> /var/www/html/nextcloud/config/config.php
echo "      'host' => 'localhost',"                  >> /var/www/html/nextcloud/config/config.php
echo "      'port' => 6379,"                         >> /var/www/html/nextcloud/config/config.php
echo "      ),"                                      >> /var/www/html/nextcloud/config/config.php
echo ");"                                            >> /var/www/html/nextcloud/config/config.php

systemctl restart httpd
systemctl start fail2ban
systemctl enable fail2ban

echo "Your installation is now complete.  You can begin using your system."
echo "It is recommended that you now setup backups, and consider installing"
echo "a certificate for your site; we recommend LetsEncrypt, it is free."

#####################################
#
# ToDo
#
# 1. Automate the root and db passwords randomization
# 2. Fix SSL Warning
# 3. Data location option
# 4. Verify Fedora version
# 5. Add automated system updates
# 6. Move to BZip
# 7. Delete installer file
# 8. Optionally expose port 9090
# 9. Move output to logs
# 10. Improve verbosity of final message
