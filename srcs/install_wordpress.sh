# service mysql restart
# echo "CREATE DATABASE wordpress" | mysql -u root
# echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
# echo "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
# echo "FLUSH PRIVILEGES;" | mysql -u root
# cd /var/www/localhost/
cd /tmp/
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
# mkdir -p /var/www/localhost/wordpress
# cp -r /tmp/wordpress/. /var/www/localhost/wordpress
mv wordpress/ /var/www/localhost
mv /config/wp-config.php /var/www/localhost/wordpress
rm latest.tar.gz
# cp /config/wp-config.php /var/www/localhost/wordpress/wp-config.php
# mkdir -p /var/www/localhost/wordpress/wp-content/uploads/2020/05
# cp /var/www/localhost/files/mj.jpg /var/www/localhost/wordpress/wp-content/uploads/2020/05
# mysql wordpress -u root --password= < /config/wordpress.sql