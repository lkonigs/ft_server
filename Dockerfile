FROM debian:buster

# Updates
RUN apt-get update 
RUN apt-get upgrade -y

# Install nginx, mysql, php and tools
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server
RUN apt-get -y install php php7.3 php-mysql php-mbstring php-fpm
RUN apt-get -y install wget
RUN apt-get -y install libnss3-tools

# Create directory
# RUN mkdir -p /config/
# RUN mkdir -p /var/www/localhost/files

# Copy content in working directory
# COPY ./srcs/start.sh ./
# COPY srcs/nginx-conf srcs/wp-config.php srcs/phpmyadmin.inc.php /config/
COPY ./srcs/start.sh ./srcs/nginx-conf ./srcs/wp-config.php ./srcs/phpmyadmin.inc.php ./
# COPY srcs/wordpress.sql /config/
# COPY  #### /var/www/localhost/files/

# Start mysql
RUN service mysql start

# Access rights
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

# Create website
RUN mkdir -p /var/www/localhost
RUN touch /var/www/localhost/index.php
RUN echo "<?php phpinfo(); ?>" >> /var/www/localhost/index.php

# Init SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=FR/L=PARIS/O=42/OU=lkonig/CN=localhost"

# Init nginx
# RUN chown -R www-data:www-data /var/www/localhost
RUN mv ./nginx-conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
RUN rm -rf /etc/nginx/sites-enabled/default

EXPOSE 80 443

# Start server
CMD bash start.sh
