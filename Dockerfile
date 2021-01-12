FROM debian:buster

# Updates
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get clean
RUN apt-get -y install wget

# Install nginx, mysql, php and tools
RUN apt-get -y install nginx
RUN apt-get install openssl
RUN apt-get -y install mariadb-server mariadb-client
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

# Start server
CMD bash /start.sh

EXPOSE 80
EXPOSE 443