#!/bin/sh
#
# Easy Deploy script snipe-it for testing purposes
# Access snipe-it using localhost:8080
#
sudo apt-get install docker.io
sudo docker pull snipe/snipe-it:v6.1.0
sudo docker run --name snipe-mysql --env-file=test_snipe_it_env --mount source=snipesql-vol,target=/var/lib/mysql -d -P mysql:5.6
sudo docker run -d -p 8080:80 --name="snipeit" --link snipe-mysql:mysql --env-file=test_snipe_it_env --mount source=snipe-vol,dst=/var/lib/snipeit snipe/snipe-it:v6.1.0