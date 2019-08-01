#!/bin/bash
#

DEBUG=1


#############
# Fixed Variables for this maschine
#############
MY_UID=nextcloud
MY_UID_N=$(id -u ${MY_UID})
WORKING_DIR="/home/${MY_UID}/work/NC16containerized"
ENV_FILE="$WORKING_DIR/.env-nc"

# autocreation of passwords if PASS=0
PASS=0


# this startup-script will build all container in each subdirectory
# and start them up in a correct manner in a docker environment.
#
# we are using following vars and secrets:
#
# redis:
# REDIS_CONTAINER=<container name>
# REDIS_MYPASSWORD=<password>
REDIS_MYPASSWORD="DFilT5gylH3EhrfKxLLa8SUHR9KO.pFfYvFtDrBgmi/"
# REDIS_NAME=<docker-server-name>
# REDIS_PV=<Path to PV of redis DB>
REDIS_PV="/opt/nextcloud/redis"
#
# mysql:
# MARIADB_CONTAINER=<container name>
# MARIADB_NAME=<docker-server-name>
# MARIADB_DBROOTPWD=<datenbank admin password>
MARIADB_DBROOTPWD="iExBsXOA0R0NgzIbFUVXFmy2upC9WdFXf49DOw8BAQX0"
# MARIADB_DB=<database name>
# MARIADB_DBUSER=<database user>
# MARIADB_DBPASSWD=<database user password>
MARIADB_DBPASSWD="jCPhOlM58KI4csXpou1JHv/imjAJaV2W7OR67DdZtY2"
# MARIADB_PV=<Path to PV of mysql DB>
MARIADB_PV="/opt/nextcloud/mariadb"

# nginx:
# NC_LETSENCRYPT=<0|1>  1 ... getting real certs, 0 ... getting test certs
NC_LETSENCRYPT=0
# NC_CONTAINER=<container name>
# NC_NAME=<docker-server-name>
# NC_DATA_PV=<Path to PV of nextcloud-data>
NC_DATA_PV="/opt/nextcloud/data"
# NC_CONFIG_PV=<Path to PV of nextcloud-config>
NC_CONFIG_PV="/opt/nextcloud/config"

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
# docker run --name ${NC_NAME:=nextcloud} -e LETSENCRYPT=${NC_LETSENCRYPT:=0} -p 80:80 -p 443:443 \ 
#	-v ${NC_CONFIG_PV}:/opt/nextcloud/config -v ${NC_DATA_PV}:/opt/nextcloud/data ${NC_CONTAINER:=nc}:latest
# docker run --name ${NC_NAME:=nextcloud} -e LETSENCRYPT=${NC_LETSENCRYPT:=0} -p 80:80 -p 443:443 -v ${NC_CONFIG_PV}:/opt/nextcloud/config -v ${NC_DATA_PV}:/opt/nextcloud/data ${NC_CONTAINER:=nc}:latest
#

function getnewpw() {
	mkpasswd -m sha256crypt | cut -d '$' -f 4
}

function usage() {
	echo "$0 [-p] [-h|-?] [-r|--redis <0|1>] [-m|--mariadb <0|1>] [-n|--nextcloud <0|1>]"
	echo "option -p : asking for new Passwords, generating sha256 strings"
	echo "option -h,-? : show this help"
	echo "       -r <0|1> : start docker container redis false or true"
	echo "       -m <0|1> : start docker container mariadb false or true"
	echo "       -n <0|1> : start docker container nextcloud false or true"
	echo
}

# clean old env-files
# and create new one with accurate values
function writeenvfile() {
	if [ -f $ENV_FILE ]; then
		rm -f $ENV_FILE;
	fi
	echo NC_REDIS_PASS=${REDIS_MYPASSWORD} >> $ENV_FILE
	echo NC_MARIADB_PASS=${MARIADB_DBPASSWD} >> $ENV_FILE
	echo NC_MARIADB_ROOT=${MARIADB_DBROOTPWD} >> $ENV_FILE
}

#
# Starting main routine
#
# Call getopt to validate the provided input.
options=$(getopt -o pr:m:n:h? --long help --long redis: --long mariadb: --long nextcloud: -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
while true; do
	case "$1" in
		-p)
			PASS=1
			;;
		-h|--help)
			usage
			exit 0
			;;
		-r|--redis)
			shift
			REDIS=$1
			[[ ! $REDIS =~ 0|1 ]] && {
				echo "Incorrect argument of option -r <0|1> provided"
				echo "0 .. do not start container redis"
				echo "1 .. start new instance container redis"
				exit 2
			}
			;;
		-m|--mariadb)
			shift
			MARIADB=$1
			[[ ! $MARIADB =~ 0|1 ]] && {
                                echo "Incorrect argument of option -m <0|1> provided"
                                echo "0 .. do not start container mariadb"
                                echo "1 .. start new instance container mariadb"
                                exit 2
                        }
                        ;;
		-n|--nextcloud)
			shift
			NC=$1
			[[ ! $NC =~ 0|1 ]] && {
                                echo "Incorrect argument of option -n <0|1> provided"
                                echo "0 .. do not start container nextcloud"
                                echo "1 .. start new instance container nextcloud"
                                exit 2
                        }
                        ;;
		--)
			shift
			break
			;;
	esac
	shift
done








if [ $UID -ne $MY_UID_N ]; then 
	echo "Wrong UID, pls. start $0 as User: $MY_UID($MY_UID_N)."
	usage
	exit 1;
fi

test $PASS -eq 1 || { echo "Password for Redis should be: " \
	&& REDIS_MYPASSWORD=$(mkpasswd -m sha256crypt | cut -d '$' -f 4 ) && echo "RedisPassword = ${REDIS_MYPASSWORD}"; }
test $PASS -eq 1 || { echo "Password for MariaDB admin should be: " \
	&& MARIADB_DBROOTPWD=$(mkpasswd -m sha256crypt | cut -d '$' -f 4 ) && echo "MariaDB admin Password = ${MARIADB_DBROOTPWD}"; }
test $PASS -eq 1 || { echo "Password for MariaDB database should be: " \
	&& MARIADB_DBPASSWD=$(mkpasswd -m sha256crypt | cut -d '$' -f 4 ) && echo "MariaDB database Password = ${MARIADB_DBPASSWD}"; }

test -z $DEBUG || { 
	echo "RedisPassword = ${REDIS_MYPASSWORD}"
	echo "MariaDB admin Password = ${MARIADB_DBROOTPWD}"
	echo "MariaDB database Password = ${MARIADB_DBPASSWD}"
}

#################
# Start the docker build section
#################
pushd .
cd ${WORKING_DIR}

docker build -t ${REDIS_CONTAINER:=redis} redis
docker build -t ${MARIADB_CONTAINER:=bmdb} mariaDB
docker build -t ${NC_CONTAINER:=nc} nginx

popd


#################
# do the docker run section 
# depending on options
#################
pushd .
cd ${WORKING_DIR}


[[ ! $REDIS -eq 1 ]] && docker run --name ${REDIS_NAME:=redis-server} -e REDIS_PASSWORD=${REDIS_MYPASSWORD} -v ${REDIS_PV}:/bitnami/redis/data ${REDIS_CONTAINER:=redis}:latest

[[ ! $MARIADB -eq 1 ]] && docker run --name ${MARIADB_NAME:=mariadb-server} -e MARIADB_ROOT_PASSWORD=${MARIADB_DBROOTPWD} \
       -e MARIADB_DATABASE=${MARIADB_DB:=nextcloud} -e MARIADB_USER=${MARIADB_DBUSER:=nextcloud} -e MARIADB_PASSWORD=${MARIADB_DBPASSWD} \
       -v ${MARIADB_PV}:/bitnami/mariadb ${MARIADB_CONTAINER:=bmdb}:latest

[[ ! $NC -eq 1 ]] && docker run --name ${NC_NAME:=nextcloud} -e LETSENCRYPT=${NC_LETSENCRYPT:=0} \
	-e NC_REDIS_PASS=${REDIS_MYPASSWORD} -e NC_REDIS_HOST="172.17.0.2" \
	-e NC_DB_HOST="172.17.0.3" -e NC_DB_NAME="${MARIADB_DB:=nextcloud}" -e NC_DB_USER="${MARIADB_DBUSER:=nextcloud}" -e NC_DB_PASS=${MARIADB_DBPASSWD} \
	-e NC_ADMIN_USER="admin" -e NC_ADMIN_PASS="admin345admin" \
	-p 80:80 -p 443:443 -v ${NC_CONFIG_PV}:/opt/nextcloud/config -v ${NC_DATA_PV}:/opt/nextcloud/data ${NC_CONTAINER:=nc}:latest

popd

