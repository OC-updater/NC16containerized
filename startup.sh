#!/bin/bash
#

# this startup-script will build all container in each subdirectory
# and start them up in a correct manner in a docker environment.
#
# we are using following vars and secrets:
#
# redis:
# REDIS_CONTAINER=<container name>
# REDIS_MYPASSWORD=<password>
# REDIS_NAME=<docker-server-name>
# REDIS_PV=<Path to PV of redis DB>
#
# mysql:
# MARIADB_CONTAINER=<container name>
# MARIADB_NAME=<docker-server-name>
# MARIADB_DBROOTPWD=<datenbank admin password>
# MARIADB_DB=<database name>
# MARIADB_DBUSER=<database user>
# MARIADB_DBPASSWD=<database user password>
# MARIADB_PV=<Path to PV of mysql DB>

# nginx:
# NC_LETSENCRYPT=<0|1>  1 ... getting real certs, 0 ... getting test certs
# NC_CONTAINER=<container name>
# NC_NAME=<docker-server-name>
# NC_PV=<Path to PV of nextcloud-data>


# Creating the container:
# 1. redis
# docker build -t ${REDIS_CONTAINER:=redis} .
# 2. mysql
# docker build -t ${MARIADB_CONTAINER:=bmdb} .
# 3. nginx
# docker build -t ${NC_CONTAINER:=nc} .


# Starting the container:
# 1. redis
# docker run --name ${REDIS_NAME:=redis-server} -e REDIS_PASSWORD=${REDIS_MYPASSWORD} -v ${REDIS_PV}:/bitnami/redis/data ${REDIS_CONTAINER:=redis}:latest
# 2. mysql
# docker run --name ${MARIADB_NAME:=mariadb-server} -e MARIADB_ROOT_PASSWORD=${MARIADB_DBROOTPWD} \
#	-e MARIADB_DATABASE=${MARIADB_DB:=nextcloud} -e MARIADB_USER=${MARIADB_DBUSER:=nextcloud} -e MARIADB_PASSWORD=${MARIADB_DBPASSWD} \
#	-v ${MARIADB_PV}:/bitnami/mariadb ${MARIADB_CONTAINER:=bmdb}:latest
# 3. nginx
# docker run --name ${NC_NAME:=nextcloud} -e LETSENCRYPT=${NC_LETSENCRYPT:=0} -p 80:80 -p 443:443 -v ${NC_PV}:/opt/nextcloud/data ${NC_CONTAINER:=nc}:latest
#

