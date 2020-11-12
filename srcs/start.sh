# PERMISSIONS
# chown -R www-data:www-data /var/www/*
# chmod -R 755 /var/www/*
# nginx -g 'daemon off;'

# Start mysql
service mysql start

# Access rights
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# Create website
mkdir -p /var/www/localhost
touch /var/www/localhost/index.php
# RUN mv /config/info.php var/www/localhost
echo "<?php phpinfo(); ?>" >> /var/www/localhost/index.php

# Init SSL
# RUN wget -O /cert/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64
# RUN chmod +x /cert/mkcert
# RUN /cert/mkcert -install
# RUN /cert/mkcert localhost
# RUN mv /localhost.pem /localhost.key /cert
mkdir /etc/nginx/ssl
openssl req -new -newkey rsa:4096 -x509 -days 365 -nodes -keyout /etc/nginx/ssl/localhost.key -out /etc/nginx/ssl/localhost.pem -subj "/C=FR/ST=France/L=Paris/O=42/OU=lkonig/CN=localhost"

# Init nginx
# RUN chown -R www-data:www-data /var/www/localhost
mv ./config/nginx-conf /etc/nginx/sites-available/localhost
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

# Config MYSQL for Wordpress
echo "CREATE DATABASE wordpress;" | mysql -u root
# echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;" | mysql -u root
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# Install and init phpmyadmin
bash /install/install_phpmyadmin.sh

# Install and init wordpress
# RUN service mysql restart
bash /install/install_wordpress.sh

service php7.3-fpm start

service nginx start

bash