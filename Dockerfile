# Get the base image
FROM debian:buster

# Autoindex
ENV AUTOINDEX on

# Updates
RUN apt-get update 
# RUN apt-get upgrade -y
# RUN apt-get clean

# Install nginx, mysql, php and tools
RUN apt-get install -y \
    wget \
    nginx \
    openssl \
    mariadb-server \
    mariadb-client 
RUN apt-get install -y php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline
RUN apt-get install -y php-mbstring php-zip php-gd
RUN apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

# Create directory
RUN mkdir /var/www/localhost

# Copy content in working directory
COPY srcs/start.sh ./
COPY srcs/wp-config.php ./
COPY srcs/config.inc.php ./
COPY srcs/default ./
COPY srcs/default_off ./

# Install and config phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz && \
    tar -xzvf phpMyAdmin-5.0.4-all-languages.tar.gz && \
    mv phpMyAdmin-5.0.4-all-languages /var/www/localhost/phpmyadmin && \
    rm phpMyAdmin-5.0.4-all-languages.tar.gz
COPY srcs/config.inc.php /var/www/localhost/phpmyadmin

# Install and init wordpress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && \
    mv wordpress /var/www/localhost/ && \
    rm -rf latest.tar.gz

EXPOSE 80 443

# Start server
CMD bash /start.sh

