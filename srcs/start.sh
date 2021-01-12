# Init SSL
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/localhost.pem -keyout /etc/nginx/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=lkonig/CN=localhost"

# Init nginx
mv ./default etc/nginx/sites-available
ln -s etc/nginx/sites-available/default etc/nginx/sites-enabled
# ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
# rm -rf /etc/nginx/sites-enabled/default

# Access rights
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Config MYSQL for Wordpress
service mysql start
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# Install and config phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz
mv phpMyAdmin-5.0.4-all-languages var/www/localhost/phpmyadmin
mv ./config.inc.php var/www/localhost/phpmyadmin
chmod 660 /var/www/localhost/phpmyadmin/config.inc.php
chown -R www-data:www-data /var/www/localhost/phpmyadmin
rm phpMyAdmin-5.0.4-all-languages.tar.gz
service php7.3-fpm start
echo "GRANT ALL ON *.* TO 'lkonig'@'localhost' IDENTIFIED BY 'password'" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
echo "<?php phpinfo(); ?>" >> /var/www/localhost/info.php

# Install and init wordpress
wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
mkdir var/www/localhost/wordpress
cp -a wordpress/. /var/www/localhost/wordpress
mv ./wp-config.php /var/www/localhost/wordpress
rm -rf latest.tar.gz

# Create and launch website
service nginx start
service mysql restart
service php7.3-fpm restart
sleep infinity