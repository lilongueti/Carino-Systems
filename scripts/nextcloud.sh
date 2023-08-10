podman network create nextcloud-net
podman volume create nextcloud-app
podman volume create nextcloud-data
podman volume create nextcloud-db

podman run --detach --env MYSQL_DATABASE=nextcloud --env MYSQL_USER=nextcloud --env MYSQL_PASSWORD=NINO$18#habi  --env MYSQL_ROOT_PASSWORD=NINO$18#habi --volume nextcloud-db:/var/lib/mysql --network nextcloud-net --restart on-failure --name nextcloud-db docker.io/library/mariadb:11

podman run --detach --env MYSQL_HOST=nextcloud-db.dns.podman --env MYSQL_DATABASE=nextcloud --env MYSQL_USER=nextcloud --env MYSQL_PASSWORD=NINO$18#habi --env NEXTCLOUD_ADMIN_USER=carino --env NEXTCLOUD_ADMIN_PASSWORD=NINO$18#habi --volume nextcloud-app:/var/www/html --volume nextcloud-data:/var/www/html/data --network nextcloud-net --restart on-failure --name nextcloud --publish 8080:80 docker.io/library/nextcloud:25