FROM debian:buster

# WORKDIR ?

# Updates
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get clean

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
COPY ./srcs/start.sh ./
COPY ./srcs/wp-config.php ./tmp/wp-config.php
COPY ./srcs/nginx-conf ./tmp/nginx-conf
COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
# COPY ./srcs/nginx-conf /etc/nginx/sites-enabled

EXPOSE 80 443

# Start server
CMD bash start.sh
