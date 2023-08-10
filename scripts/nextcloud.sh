#!/bin/bash
echo "Creating nextcloud podman instance"
podman network create nextcloud-net
podman volume create nextcloud-app
podman volume create nextcloud-data
podman volume create nextcloud-db

echo "Provide a nextcloud admin username"
read user
echo "Provide a nextcloud admin password"
read password

echo "podman run --detach --env MYSQL_DATABASE=nextcloud --env MYSQL_USER=nextcloud --env MYSQL_PASSWORD=$password  --env MYSQL_ROOT_PASSWORD=$password --volume nextcloud-db:/var/lib/mysql --network nextcloud-net --restart on-failure --name nextcloud-db docker.io/library/mariadb:11"

echo "podman run --detach --env MYSQL_HOST=nextcloud-db.dns.podman --env MYSQL_DATABASE=nextcloud --env MYSQL_USER=nextcloud --env MYSQL_PASSWORD=$password --env NEXTCLOUD_ADMIN_USER=$user --env NEXTCLOUD_ADMIN_PASSWORD=$password --volume nextcloud-app:/var/www/html --volume nextcloud-data:/var/www/html/data --network nextcloud-net --restart on-failure --name nextcloud --publish 8080:80 docker.io/library/nextcloud:25"

echo "DONE"