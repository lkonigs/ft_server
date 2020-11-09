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
# COPY ./tmp/phpmyadmin.inc.php
# COPY srcs/info.php srcs/wordpress.sql /config/
COPY srcs/nginx-conf srcs/wp-config.php phpmyadmin.inc.php /config/
# COPY  #### /var/www/localhost/files/

# Init nginx
RUN mkdir -p /var/www/localhost
RUN chown -R www-data:www-data /var/www/localhost
RUN mv /config/nginx-conf /etc/nginx/sites-available/localhost
# RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled
RUN mv /config/info.php var/www/localhost

# Init SSL
RUN wget -O /cert/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.3.0/mkcert-v1.3.0-linux-amd64
# RUN chmod +x /cert/mkcert
RUN /cert/mkcert -install
RUN /cert/mkcert localhost
RUN mv /localhost.pem /localhost-key.pem /cert

# Install and init phpmyadmin
RUN cd /var/www/localhost/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN tar xzf /var/www/localhost/phpMyAdmin-4.9.0.1-english.tar.gz
RUN mv phpMyAdmin-4.9.0.1-english phpmyadmin
RUN rm phpMyAdmin-4.9.0.1-english.tar.gz
RUN cp /config/phpmyadmin.inc.php /var/www/localhost/phpmyadmin/

# Install and init wordpress
RUN service mysql restart
# echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
# echo "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
# echo "FLUSH PRIVILEGES;" | mysql -u root
RUN cd /tmp
RUN wget https://wordpress.org/latest.tar.gz
RUN tar xzf latest.tar.gz
RUN mkdir -p /var/www/localhost/wordpress
RUN cp -r /tmp/wordpress/. /var/www/localhost/wordpress
RUN rm latest.tar.gz
RUN rm -rf wordpress
RUN cp /config/wp-config.php /var/www/localhost/wordpress/wp-config.php
# mkdir -p /var/www/localhost/wordpress/wp-content/uploads/2020/05
# cp /var/www/localhost/files/mj.jpg /var/www/localhost/wordpress/wp-content/uploads/2020/05
RUN mysql wordpress -u root --password= < /config/wordpress.sql

# Start server
# CMD bash start.sh
# service php7.3-fpm start && service mysql restart && nginx -g 'daemon off;'
# bash init_container.sh
