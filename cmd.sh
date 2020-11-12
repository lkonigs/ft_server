sudo docker build . --tag server
sudo docker run -it -p 8080:80 -p 8443:443 server