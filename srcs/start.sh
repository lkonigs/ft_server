# Init SSL
mkdir /etc/nginx/ssl
# rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=FR/L=PARIS/O=42/OU=lkonig/CN=localhost"
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/localhost.pem -keyout /etc/nginx/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=lkonig/CN=localhost"

# Init nginx
mkdir var/www/localhost
# RUN chown -R www-data:www-data /var/www/localhost
mv ./default etc/nginx/sites-available
# mv /tmp/nginx-conf /etc/nginx/sites-available/localhost
ln -s etc/nginx/sites-available/default etc/nginx/sites-enabled
# ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
# rm -rf /etc/nginx/sites-enabled/default

# Access rights
#chown -R www-data:www-data /var/www/*
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Config MYSQL for Wordpress
service mysql start
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
# echo "CREATE DATABASE wordpress;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
# echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# Install and init phpmyadmin
# cd /var/www/localhost/
# wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
# wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-english.tar.gz
# tar xvf /var/www/localhost/phpMyAdmin-4.9.7-english.tar.gz
# mv phpMyAdmin-4.9.7-english var/www/localhost/phpmyadmin
# mv phpMyAdmin-4.9.7-english phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz
mv phpMyAdmin-5.0.4-all-languages var/www/localhost/phpmyadmin
# wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
# tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
# mv phpMyAdmin-4.9.0.1-all-languages var/www/localhost/phpmyadmin
mv ./config.inc.php var/www/localhost/phpmyadmin
chmod 660 /var/www/localhost/phpmyadmin/config.inc.php
chown -R www-data:www-data /var/www/localhost/phpmyadmin
# rm phpMyAdmin-4.9.7-english.tar.gz
# mv /tmp/phpmyadmin.inc.php /var/www/localhost/phpmyadmin/config.inc.php
service php7.3-fpm start
echo "GRANT ALL ON *.* TO 'lkonig'@'localhost' IDENTIFIED BY 'password'" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# Install and init wordpress
# cd /tmp/
wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
mkdir var/www/localhost/wordpress
cp -a wordpress/. /var/www/localhost/wordpress
mv ./wp-config.php /var/www/localhost/wordpress
# mv wordpress/ /var/www/localhost
# mv /tmp/wp-config.php /var/www/localhost/wordpress
# rm -rf latest.tar.gz


# Create website
# mkdir /var/www/localhost
# touch /var/www/localhost/index.php
# echo "<?php phpinfo(); ?>" >> /var/www/localhost/info.php
#mv /tmp/info.php /var/www/localhost


# Create and launch website
#nginx ?
# cd ..
#service php7.0-fpm start
service nginx start
service mysql restart
service php7.3-fpm restart
sleep infinity
#service php7.3-fpm start

#bash