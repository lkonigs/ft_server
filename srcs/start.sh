service mysql start
service nginx restart
service php7.3-fpm start

# PERMISSIONS
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

