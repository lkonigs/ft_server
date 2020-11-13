# Config MYSQL for Wordpress
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# Install and init phpmyadmin
cd /var/www/localhost/
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
ls
tar -xvzf /var/www/localhost/phpMyAdmin-4.9.0.1-english.tar.gz
mv phpMyAdmin-4.9.0.1-english phpmyadmin
rm phpMyAdmin-4.9.0.1-english.tar.gz
cp ./phpmyadmin.inc.php /var/www/localhost/phpmyadmin/config.inc.php

# Install and init wordpress
cd /tmp/
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/localhost
cp ./wp-config.php /var/www/localhost/wordpress/wp-config.php
mv ./wp-config.php /var/www/localhost/wordpress
rm latest.tar.gz

service php7.3-fpm start

service nginx start

bash