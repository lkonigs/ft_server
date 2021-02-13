# Init SSL
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/localhost.pem -keyout /etc/nginx/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=lkonig/CN=localhost"

# Access rights
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Init nginx and set autoindex
if [ "$AUTOINDEX" = "off" ] ;
    then mv ./default_off etc/nginx/sites-available/default
    else mv ./default etc/nginx/sites-available/default
fi
ln -s etc/nginx/sites-available/default etc/nginx/sites-enabled/

# Config MYSQL for Wordpress
service mysql start
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root


# Install and config phpmyadmin
chmod 660 /var/www/localhost/phpmyadmin/config.inc.php
chown -R www-data:www-data /var/www/localhost/phpmyadmin
service php7.3-fpm start
echo "CREATE USER 'lkonig'@'localhost' IDENTIFIED BY 'password'" | mysql -u root
echo "GRANT ALL ON *.* TO 'lkonig'@'localhost' IDENTIFIED BY 'password'" | mysql -u root
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
echo "<?php phpinfo(); ?>" >> /var/www/localhost/info.php

# Config wordpress
mv ./wp-config.php /var/www/localhost/wordpress

# Create and launch website
service nginx start
service mysql restart
service php7.3-fpm restart
 
sleep infinity