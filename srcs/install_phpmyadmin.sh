cd /var/www/localhost/
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
ls
tar -xvzf /var/www/localhost/phpMyAdmin-4.9.0.1-english.tar.gz
mv phpMyAdmin-4.9.0.1-english phpmyadmin
rm phpMyAdmin-4.9.0.1-english.tar.gz
cp /config/phpmyadmin.inc.php /var/www/localhost/phpmyadmin/config.inc.php