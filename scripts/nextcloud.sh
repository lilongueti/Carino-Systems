#!/bin/bash

# Update system packages
sudo dnf update -y

# Install required packages
sudo dnf install -y httpd mariadb-server php php-mysqlnd php-json php-gd php-mbstring php-intl php-xml php-zip php-curl php-apcu php-dom php-xmlreader php-xmlwriter php-posix php-ctype php-fileinfo php-tokenizer php-zlib php-simplexml php-ldap wget unzip

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation

# Create a database and user for Nextcloud
MYSQL_ROOT_PASS="your_mysql_root_password"
NEXTCLOUD_DB="nextcloud_db"
NEXTCLOUD_USER="nextcloud_user"
NEXTCLOUD_PASS="your_nextcloud_password"

sudo mysql -u root -p$MYSQL_ROOT_PASS <<EOF
CREATE DATABASE $NEXTCLOUD_DB;
CREATE USER '$NEXTCLOUD_USER'@'localhost' IDENTIFIED BY '$NEXTCLOUD_PASS';
GRANT ALL PRIVILEGES ON $NEXTCLOUD_DB.* TO '$NEXTCLOUD_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Download and extract Nextcloud
wget https://download.nextcloud.com/server/releases/latest.zip
unzip latest.zip -d /var/www/html/
sudo chown -R apache:apache /var/www/html/nextcloud/
rm latest.zip

# Configure Apache for Nextcloud
sudo tee /etc/httpd/conf.d/nextcloud.conf <<EOF
Alias /nextcloud "/var/www/html/nextcloud/"

<Directory /var/www/html/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All
 <IfModule mod_dav.c>
  Dav off
 </IfModule>
 SetEnv HOME /var/www/html/nextcloud
 SetEnv HTTP_HOME /var/www/html/nextcloud
</Directory>
EOF

# Enable required Apache modules
sudo dnf install -y php-fpm
sudo dnf install -y php-json php-zip php-xml php-mbstring
sudo systemctl restart httpd

# Set SELinux permissions for Nextcloud
sudo setsebool -P httpd_unified 1
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/nextcloud/data(/.*)?"
sudo restorecon -Rv /var/www/html/nextcloud/

# Restart Apache
sudo systemctl restart httpd

# Display Nextcloud installation instructions
echo "Nextcloud installed successfully. Please complete the setup by accessing your server's IP or domain name in a web browser."
