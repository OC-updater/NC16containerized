#!/bin/bash

#
# not yet production ready, therefore let us exit here.
exit 0

# REMEMBER docker@nautlus has disabled auto-iptables.

# Some docker run call for mariadb-server
# 1st build it in the dir of the Dockerfile
docker build -t bmdb .

# Afterwards we are able to run this mariadb
#
# -e ENV-Vars of this image, see README.md
# -v connect persistent volume for database storage
# -p publish the network port 
docker run --name mariadb-server \
	-e ALLOW_EMPTY_PASSWORD=yes \
	--network bridge -p 192.168.21.100:3306:3306 \
	-v ~/work/NC16containerized/mariaDB/persistent:/bitnami/mariadb \
	-e MARIADB_DATABASE=nextcloud -e MARIADB_USER=nextcloud -e MARIADB_PASSWORD=nc123 \
	bmdb:latest

# Without creating a new database automagically
# MARIADB_ROOT_PASSWORD: The database admin user password. No defaults.

# if you want to run your container at an other bridge (named othernet)
# docker network create othernet

docker run --name mariadb-server \
        -e MARIADB_ROOT_PASSWORD=password123 \
        --network othernet -p 192.168.21.100:3306:3306 \
        -v ~/work/NC16containerized/mariaDB/persistent:/bitnami/mariadb \
        bmdb:latest
