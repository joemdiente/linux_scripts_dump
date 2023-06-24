#!/bin/sh
#
# Startup script for docker snipeIT
# Access snipe-it using localhost:8080
#
sudo docker start snipe-mysql
sudo docker start /snipeit
echo "Done"