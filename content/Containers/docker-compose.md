+++
title = "Docker-Compose"
insert_anchor_links = "left"
+++

- Spin up a compose file as a daemon
```
docker-compose up -d
```

- Raise down a compose set of containers
```
docker-compose down
```

- Pull new container image
```
docker pull wonderfall/nextcloud:18
```

- Docker Compose sample (Nextcloud Installation

```
caddy:
  image: abiosoft/caddy:latest
  container_name: Caddy
  restart: always
  environment:
    CADDYPATH: "/etc/caddycerts"
  links:
    - nextcloud:nextcloud
  volumes:
    - /home/docker/caddy/Caddyfile:/etc/Caddyfile
    - /home/docker/caddy/caddycerts:/etc/caddycerts
  ports:
    - "80:80"
    - "443:443"

nextcloud:
  image: wonderfall/nextcloud:latest
  container_name: nextcloud
  links:
    - db_nextcloud:db_nextcloud
  environment:
    - UID=1000
    - GID=1000
    - UPLOAD_MAX_SIZE=10G
    - APC_SHM_SIZE=128M
    - OPCACHE_MEM_SIZE=128
    - CRON_PERIOD=15m
  volumes:
    - /home/docker/nextcloud/data:/data
    - /home/docker/nextcloud/config:/config
    - /home/docker/nextcloud/apps:/apps2

db_nextcloud:
  image: mariadb:10
  container_name: db_nextcloud
  volumes:
    - /home/docker/nextcloud/db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=Aw3s0m3P4ssw0rd2!#
    - MYSQL_DATABASE=nextcloud
    - MYSQL_USER=r00t
    - MYSQL_PASSWORD=Aw3s0m3P4ssw0rd!#
```
