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
# RUN mkdir -p /home/ /cert/ /scripts/ /var/www/localhost/files

# Copy content in working directory
# COPY ./srcs/init_container.sh ./
# COPY ./srcs/nginx-conf ./tmp/nginx-conf
# COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
# COPY ./srcs/wp-config.php ./tmp/wp-config.php

# Install phpmyadmin

# Install wordpress

# Start server
CMD
# service php7.3-fpm start && service mysql restart && nginx -g 'daemon off;'
# bash init_container.sh
bash init.sh