FROM debian:buster

RUN apt-get update 
RUN apt-get -y install nginx
# RUN apt-get install -y php-fpm php-mysql php-mbstring php-mysql
RUN apt-get install -y mariadb-server

COPY 

# COPY ./srcs/init_container.sh ./
# COPY ./srcs/nginx-conf ./tmp/nginx-conf
# COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
# COPY ./srcs/wp-config.php ./tmp/wp-config.php

CMD
# service php7.3-fpm start && service mysql restart && nginx -g 'daemon off;'
# bash init_container.sh