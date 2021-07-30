# ft_server
| | :white_check_mark: Finished |
|-----|---|
| **Result**  | [![jaeskim's 42Project Score](https://badge42.herokuapp.com/api/project/lkonig/Libft)](https://github.com/JaeSeoKim/badge42) |
| **Language** | ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white) |

## Description :fr:

**Objectif: installer un server web complet, capable de faire tourner plusieurs services, tel qu’un
Wordpress, Phpmyadmin, ainsi qu’une base de données. Ce serveur tournera dans un containeur Docker, sous Debian Buster.**

Il s'agit de créer un serveur web dynamique, composé des éléments suivants:

- **OS** (ex: Windows, Linux) → **Debian Buster**

Linux est une famille d'OS avec plusieurs versions, et chaque version est une distribution, comme c'est le cas de Debian
- **Serveur HTTP** (ex: Apache) → **Nginx**

Logiciel prenant en charge les requêtes client-serveur du protocole HTTP
Nginx: serveur open-source, notamment utilisé par Microsoft, Google ou IBM
- **Base de données** (ex: mySQL) → **Maria DB**
- **Langage de script** → **PHP**

Interprète les demandes du client, les traduit en html

Nous devons également installer **Phpmyadmin et Wordpress**

Ce serveur web doit être mis en place dans un seul container Docker.

### Docker
Docker est une plateforme de containers très utilisée, alternative moins gourmande en puissance de calcul que les VM, puisque contrairement à une VM, un conteneur n'embarque pas un OS complet.

Docker et les containers répondent à un problème de portabilité rencontré par les entreprises au cours du développement. Docker permet de créer et de gérer des containers d’applications sur un OS. Le container regroupe  les services, fichiers de configuration et autres composants liés  à l'application en question.

Chaque container est créé à partir d’une image Docker, déjà créée (à partir du DockerHub) ou, comme c'est le cas pour ft_server, créée par l'utilisateur à l'aide d'un fichier Dockerfile.

*Sources :*
- https://www.lebigdata.fr/docker-definition#:~:text=Il%20s'agit%20d'une,sur%20un%20syst%C3%A8me%20d'exploitation.&text=Initialement%20cr%C3%A9%C3%A9%20pour%20fonctionner%20avec,Microsoft%20Windows%20ou%20Apple%20macOS.
#### Le Dockerfile
Le Dockerfile est utilisé pour build l'image. C'est une liste de commandes envoyées au Docker Engine, qui lit les commandes à partir du haut du Dockerfile et les exécute une à une.

`FROM` : indique sur quelle image on va build

`RUN` : indique la commande à exécuter (par ex: RUN apt-get install nginx)

`COPY` : copie le fichier demandé dans l'image

`CMD` : commande par défaut, exécutée dans le container est lancé

`EXPOSE` : instruction qui précise à Docker le port du container à l'exécution

#### Les commandes à connaître
`docker images` : List images

`docker ps` : List containers

L'option -a permet de lister aussi les containers inactifs

`docker build` : Build an image from a Dockerfile

Exemple d'utilisation: `docker build -t nomimage .`

`docker run` : Run a command in a new container

La commande run s'utilise une fois l'image créée/disponible

Exemple d'utilisation, en ouvrant le port 80: `docker run -d -p 80:80 --name=nomcontainer nomimage`

`docker stop` : Stop one or more running containers

Exemple d'utilisation: `docker stop nomcontainerrid`

`docker start` : Start one or more stopped containers

`docker rm` : Remove one or more containers

Exemple d'utilisation: `docker rm $(docker ps -a -q)`

`docker rmi` : Remove one or more images

Exemple d'utilisation: 
```
docker rmi nomimageid
docker rmi $(docker images -a -q)
```
`docker exec` : Run a command in a running container

Exemple d'utilisation: `docker exec -ti nomcontainerid bash`

*Sources :*
- *Descriptions issues de:* https://docs.docker.com/engine/reference/commandline/docker/
- *Vidéo pour apprendre à se servir de Docker:* https://youtu.be/iqqDU2crIEQ

### Remarques générales
`apt-get` permet d'installer des paquets à partir des serveurs Debian:
- `apt-get update` nous permet de récupérer les listes de paquets disponibles
- `-y` permet de répondre oui aux demandes de confirmations

`sleep infinity` permet de faire que le container reste actif

### Nginx
#### Installation, configuration et lancement de Nginx
Installation de nginx : `apt-get -y install nginx`
Pour initialiser et mettre à jour la configuration de Nginx, il nous faut:
- créer un nouveau fichier dans sites-available: `RUN mkdir /var/www/localhost`
- sélectionner le bon fichier de configuration en fonction de la variable d'environnement AUTOINDEX. Par défaut, celle ci est sur "on", mais au moment d'exécuter le container on peut ajouter "-e AUTOINDEX=off". Si c'est le cas, c'est le fichier default_off qui est utilisé, dans lequel la seule différence avec default est la ligne `autoindex on;` remplacée par `autoindex off;`
- ajouter un lien symbolique dans sites-enabled
```
if [ "$AUTOINDEX" = "off" ] ;
    then mv ./default_off etc/nginx/sites-available/default
    else mv ./default etc/nginx/sites-available/default
fi
ln -s etc/nginx/sites-available/default etc/nginx/sites-enabled
```

Lancement de nginx : `service nginx start`

Si on ne fait rien de plus, "Welcome to Nginx" devrait s'afficher quand on run le container.

La configuration se trouve dans le fichier *default* dans etc/nginx/sites-available.

Le fichier de configuration de Nginx comporte la syntaxe suivante :
- `#` : commentaire
- `listen 80;` : directive
- `location / {try_files $uri $uri/ =404;}` : bloc

Explications des directives :
`listen 80 default_server;` indique que le port 80 est utilisé

`root /var/www/html;` indique que tous les documents qui sont concernés par ce groupe sont dans le dossier var/www/html

La page d'accueil est désignée par `index : index index.html index.htm index.nginx-debian.html;`

`server_name` permet d'indiquer quel est le nom de domaine ciblé. Le symbole `_` représente pour Nginx tous les noms de domaines.

`location` fait référence au chemin relatif qui est dans l'URL (l'URI). Dans notre cas, seule une barre oblique est indiquée : `/`. Cela signifie que toutes les requêtes dont l'URI commence par / devront appliquer les directives du bloc.

`try_files $uri $uri/ =404;` vérifie l'existence des fichiers passés en argument par ordre de priorité. Nginx cherche le fichier sur le serveur en suivant le chemin passé dans l'URL. Si le fichier est  absent, il renverra une erreur 404.

Pour la redirection vers https:// : https://linuxize.com/post/redirect-http-to-https-in-nginx/#:~:text=return%20301%20https%3A%2F%2F%24,domain%20name%20of%20the%20request.

*Sources :*
- *Les informations sur la configuration viennent de* https://openclassrooms.com/fr/courses/4425101-deployez-une-application-django/4688553-utilisez-le-serveur-http-nginx

#### Implémentation de SSL
Un certificat SSL est un fichier de données qui lie une clé cryptographique aux informations. Ce certificat active le protocole « https », afin d'assurer une connexion sécurisée entre le serveur web et le navigateur. 

Ce code permet la redirection vers HTTPS:
```
server {
	listen 80;
	listen [::]:80;
	server_name localhost www.localhost;
	return 301 https://localhost$request_uri;
}

server {
	listen 443 ssl;
	listen [::]:443 ssl;

	ssl_certificate /etc/nginx/ssl/localhost.pem;
	ssl_certificate_key /etc/nginx/ssl/localhost.key;
    ...
}
```
Pour cela, il faut tout d'abord installer openssl avec la commande `apt-get install openssl`

`openssl` permet ensuite de générer le certificat ssl composé de localhost.pem et de localhost.key

Il suffit donc ensuite d'ajouter ces fichiers dans le fichier de configuration de Nginx, comme on l'avait indiqué au dessus:
```
ssl_certificate /etc/nginx/ssl/localhost.pem;
ssl_certificate_key /etc/nginx/ssl/localhost.key;
```
*Sources :*
- https://nginx.org/en/docs/http/configuring_https_servers.html#single_http_https_server
- https://www.globalsign.com/fr/centre-information-ssl/definition-certificat-ssl#:~:text=Un certificat SSL est un,serveur web et le navigateur
- https://www.globalsign.com/fr/centre-information-ssl/definition-certificat-ssl#:~:text=Un%20certificat%20SSL%20est%20un,serveur%20web%20et%20le%20navigateur.

#### Autres commandes utiles pour Nginx
`nginx -t` permet de savoir si la configuration est ok ou si un problème est détecté

`service nginx stop` et `service nginx reload` permettent d'arrêter et de relancer nginx avec la bonne config

### Base de données
Pour accéder à une base de données il faut simplement installer MariaDB et lancer mysql.

Installation de mariadb : `apt-get install -y mariadb-server mariadb-client`
Lancement de mariadb : `service mysql start`

Pour l'étape de création de la base de données, on ne peut pas rentrer les commandes manuellement une fois le container lancé, donc cela doit être fait au moment du Dockerfile. On utilise la commande `echo` en précisant qu'il faut entrer ces commandes dans mysql.
```
echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
```
### PHP
Installation de PHP :
```
RUN apt-get install -y php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline
RUN apt-get install -y php-mbstring php-zip php-gd
RUN apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
```
Lancement de PHP : `service php7.3-fpm start`

L'ajout de info.php permet d'accéder à des informations de configuration une fois le container actif.

### phpmyadmin
phpMyAdmin est une application de gestion de base de données MySQL réalisée en PHP.

Installation de phpmyadmin :
```
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
tar xvf phpMyAdmin-5.0.4-all-languages.tar.gz
mv phpMyAdmin-5.0.4-all-languages var/www/localhost/phpmyadmin
rm phpMyAdmin-5.0.4-all-languages.tar.gz
```
Tout d'abord il faut éditer le fichier de configuration par défaut, et modifier ce qui est demandé.

Il suffit ensuite de déplacer le fichier de configuration édité dans le dossier var/www/localhost/phpmyadmin, d'ajouter index.php dans les index du fichier de configuration de nginx et d'ajouter l'utilisateur et lui donner la permission d'accéder à la base de données de phpmyadmin comme suit:
```
echo "GRANT ALL ON *.* TO 'username'@'localhost' IDENTIFIED BY 'password'" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
```
Pour se connecter à phpmyadmin une fois le container actif, il faudra utiliser les identifiants correspondant à username et password.

*Sources :*
- *Tuto :* https://www.itzgeek.com/how-tos/linux/debian/how-to-install-phpmyadmin-with-nginx-on-debian-10.html
- *Fichier de configuration :* https://docs.phpmyadmin.net/en/latest/config.html#config-examples
- *Trouver la dernière version de phpmyadmin :* https://www.phpmyadmin.net/downloads/

### Wordpress
WordPress permet de créer et de gérer différents types de sites Web gratuitement. C'est un logiciel écrit en PHP qui fonctionne avec une base de données MySQL.

Installation de wordpress :
```
wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
mkdir var/www/localhost/wordpress
cp -a wordpress/. /var/www/localhost/wordpress
rm -rf latest.tar.gz
```
Comme nous avons déjà configuré la base de données, il ne reste qu'à mettre la jour la configuration. Tout comme pour phpmyadmin, il faut d'abord éditer le fichier de configuration, puis déplacer ce fichier de configuration dans le dossier /var/www/localhost/wordpress.

*Sources :*
- *Tuto :* https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-nginx-mariadb-and-php-on-debian-10
- *Fichier de configuration :* https://wordpress.org/support/article/editing-wp-config-php/
