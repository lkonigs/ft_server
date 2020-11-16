# Start mysql
service mysql start

# Access rights
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# Create website
mkdir /var/www/localhost
touch /var/www/localhost/index.php
echo "<?php phpinfo(); ?>" >> /var/www/localhost/index.php

# Init SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=FR/L=PARIS/O=42/OU=lkonig/CN=localhost"

# Init nginx
# RUN chown -R www-data:www-data /var/www/localhost
mv /tmp/nginx-conf /etc/nginx/sites-available/localhost
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
rm -rf /etc/nginx/sites-enabled/default

# Config MYSQL for Wordpress
# service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
#service mysql restart

# Install and init phpmyadmin
cd /var/www/localhost/
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
tar -xvzf /var/www/localhost/phpMyAdmin-4.9.0.1-english.tar.gz
mv phpMyAdmin-4.9.0.1-english phpmyadmin
rm phpMyAdmin-4.9.0.1-english.tar.gz
mv /tmp/phpmyadmin.inc.php /var/www/localhost/phpmyadmin/config.inc.php

# Install and init wordpress
cd /tmp/
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/localhost
mv /tmp/wp-config.php /var/www/localhost/wordpress
rm -rf latest.tar.gz

#nginx ?
service php7.3-fpm start
service nginx start

bash