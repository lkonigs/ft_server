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
service php7.3-fpm start
echo "GRANT ALL ON *.* TO 'lkonig'@'localhost' IDENTIFIED BY 'password'" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
echo "<?php phpinfo(); ?>" >> /var/www/localhost/info.php

# Create and launch website
service nginx start
service mysql restart
service php7.3-fpm restart
 
sleep infinity