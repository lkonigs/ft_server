sudo docker build . --tag ft_server
sudo docker run -it -p 8080:80 -p 8443:443 ft_server