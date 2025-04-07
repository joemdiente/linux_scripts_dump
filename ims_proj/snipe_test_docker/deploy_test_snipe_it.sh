#!/bin/sh
#
# Easy Deploy script snipe-it for testing purposes
# Access snipe-it using localhost:8080
# OLD!!
# sudo apt-get install docker.io
# sudo docker pull snipe/snipe-it:v6.1.0
# sudo docker run --name snipe-mysql --env-file=test_snipe_it_env --mount source=snipesql-vol,target=/var/lib/mysql -d -P mysql:5.6
# sudo docker run -d -p 8080:80 --name="snipeit" --link snipe-mysql:mysql --env-file=test_snipe_it_env --mount source=snipe-vol,dst=/var/lib/snipeit snipe/snipe-it:v6.1.0

# New
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

mkdir snipe_test_sandbox
cd snipe_test_sandbox
curl https://raw.githubusercontent.com/snipe/snipe-it/master/docker-compose.yml --output docker-compose.yml
curl https://raw.githubusercontent.com/snipe/snipe-it/master/.env.docker --output .env

echo "Modify .env and docker-compose.yml!!!"

docker compose run --rm app php artisan key:generate --show
docker compose up -d