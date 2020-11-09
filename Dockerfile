FROM debian:buster

# Updates
RUN apt-get update 
RUN apt-get upgrade -y

# Install nginx, mysql, php and tools
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-mbstring php-fpm
RUN apt-get -y install wget

# Create directory
RUN mkdir -p /config/ /cert/ /var/www/localhost/files

# Copy content in working directory
COPY ./srcs/start.sh ./
# COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
# COPY srcs/info.php srcs/config-inc.php srcs/wordpress.sql /home/
COPY srcs/nginx-conf srcs/wp-config.php /config/
COPY  #### /var/www/localhost/files/

# Init nginx
mkdir -p /var/www/localhost
chown -R www-data:www-data /var/www/localhost
mv /home/nginx-conf /etc/nginx/sites-available/localhost
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled
mv /home/info.php var/www/localhost


# Init SSL
wget -O /cert/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64
chmod +x /cert/mkcert
/cert/mkcert -install
/cert/mkcert localhost
mv /localhost.pem /localhost-key.pem /cert

# Install and init phpmyadmin
cd /var/www/localhost/
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
tar xzf /var/www/localhost/phpMyAdmin-4.9.0.1-english.tar.gz
mv phpMyAdmin-4.9.0.1-english phpmyadmin
rm phpMyAdmin-4.9.0.1-english.tar.gz
cp /home/config-inc.php /var/www/localhost/phpmyadmin/

# Install and init wordpress
service mysql restart
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz
mkdir -p /var/www/localhost/wordpress
cp -r /tmp/wordpress/. /var/www/localhost/wordpress
rm latest.tar.gz
rm -rf wordpress
cp /home/wp-config.php /var/www/localhost/wordpress/wp-config.php
mkdir -p /var/www/localhost/wordpress/wp-content/uploads/2020/05
cp /var/www/localhost/files/mj.jpg /var/www/localhost/wordpress/wp-content/uploads/2020/05
mysql wordpress -u root --password= < /home/wordpress.sql

# Start server
CMD bash start.sh
# service php7.3-fpm start && service mysql restart && nginx -g 'daemon off;'
# bash init_container.sh
