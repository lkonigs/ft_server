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
RUN mkdir -p /config/ /cert/ /install/
# RUN mkdir -p /var/www/localhost/files

# Copy content in working di -xrectory
COPY ./srcs/start.sh ./
# COPY ./tmp/phpmyadmin.inc.php
# COPY srcs/info.php /config/
COPY srcs/nginx-conf srcs/wp-config.php srcs/phpmyadmin.inc.php srcs/wordpress.sql /config/
# COPY  #### /var/www/localhost/files/
COPY srcs/install_phpmyadmin.sh srcs/install_wordpress.sh /install/

# Start server
CMD bash start.sh
# service php7.3-fpm start && service mysql restart && nginx -g 'daemon off;'
# bash init_container.sh
