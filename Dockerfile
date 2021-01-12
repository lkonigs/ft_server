FROM debian:buster

# Updates
RUN apt-get update 
# RUN apt-get upgrade -y
# RUN apt-get clean
RUN apt-get -y install wget

# Install nginx, mysql, php and tools
RUN apt-get -y install nginx
# RUN apt-get -y install openssl
RUN apt-get install openssl
RUN apt-get -y install mariadb-server mariadb-client
# RUN apt-get -y install php-fpm php-mysql
RUN apt-get install -y php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline
RUN apt-get install -y php-mbstring php-zip php-gd
RUN apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

# RUN apt-get -y install libnss3-tools

# Create directory
# RUN mkdir -p /config/
# RUN mkdir -p /var/www/localhost/files
# RUN mkdir /var/www/localhost
# RUN chown -R 755 /var/www/localhost

# Copy content in working directory
COPY srcs/start.sh ./
COPY srcs/wp-config.php ./
COPY srcs/config.inc.php ./
COPY srcs/default ./
#COPY ./srcs/info.php ./tmp/info.php
#COPY ./srcs/nginx-conf ./tmp/nginx-conf
#COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
# COPY ./srcs/nginx-conf /etc/nginx/sites-enabled

# EXPOSE 80 443

# Start server
CMD bash /start.sh

EXPOSE 80
EXPOSE 443