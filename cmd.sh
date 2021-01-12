sudo docker stop lolo_cont
sudo docker rm lolo_cont
sudo docker rmi lolo
sudo service nginx stop
sudo service mysql stop
service php7.3-fpm stop
sudo docker build -t lolo .
sudo docker run -d -p 80:80 --name=lolo_cont lolo
nmap localhost
curl localhost:80