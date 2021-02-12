sudo docker stop ft_server
sudo docker rm ft_server
sudo docker rmi server
sudo service nginx stop
sudo service mysql stop
# service php7.3-fpm stop
sudo docker build -t server .
sudo docker run -e AUTOINDEX=on -d -p 80:80 -p 443:443 --name=ft_server server
# sudo docker run --env AUTOINDEX=off -d -p 80:80 -p 443:443 --name=ft_server server
nmap localhost
curl localhost:80