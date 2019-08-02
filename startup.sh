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
# Run REDIS container, (0|1)
REDIS=0
# REDIS_CONTAINER=<container name>
# REDIS_MYPASSWORD=<password>
REDIS_MYPASSWORD="DFilT5gylH3EhrfKxLLa8SUHR9KO.pFfYvFtDrBgmi/"
# REDIS_NAME=<docker-server-name>
# REDIS_PV=<Path to PV of redis DB>
REDIS_PV="/opt/nextcloud/redis"
# REDIS_UID=<uid of running container>
REDIS_UID="1003"

#
# mysql:
# Run MARIADB container, (0|1)
MARIADB=0
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
# MARIADB_UID=<uid of running container>
MARIADB_UID="1003"

# nginx:
# Run NC container (0|1)
NC=0
# NC_LETSENCRYPT=<0|1>  1 ... getting real certs, 0 ... getting test certs
NC_LETSENCRYPT=0
# NC_CONTAINER=<container name>
# NC_NAME=<docker-server-name>
# NC_DATA_PV=<Path to PV of nextcloud-data>
NC_DATA_PV="/opt/nextcloud/data"
# NC_CONFIG_PV=<Path to PV of nextcloud-config>
NC_CONFIG_PV="/opt/nextcloud/config"
# NC_UID=<uid of running container>
NC_UID="1003"
# default values for admin user/pw of nextcloud container
NC_ADMIN_USER="admin"
NC_ADMIN_PASS="admin345"


# Creating the container:
# 1. redis
# docker build -t ${REDIS_CONTAINER:=redis} --build-arg NC_REDIS_UID=${REDIS_UID:-1003} .
# 2. mysql
# docker build -t ${MARIADB_CONTAINER:=bmdb} --build-arg NC_MARIADB_UID=${MARIADB_UID:-1003} .
# 3. nginx
# docker build -t ${NC_CONTAINER:=nc} --build-arg NC_UID=${NC_UID:-1003} .


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

#
# using some functions
#
function getnewpw() {
	mkpasswd -m sha256crypt | cut -d '$' -f 4
}

function usage() {
	echo "$0 [-p] [-h|-?] [-f <env_file>] [-r|--redis <0|1>] [-m|--mariadb <0|1>] [-n|--nextcloud <0|1>]"
	echo "option -p : asking for new Passwords, generating sha256 strings"
	echo "option -h,-? : show this help"
	echo "       -f <env_file> : path/filename to env-file"
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
	echo REDIS_MYPASSWORD=${REDIS_MYPASSWORD} >> $ENV_FILE
	echo MARIADB_DBPASSWD=${MARIADB_DBPASSWD} >> $ENV_FILE
	echo MARIADB_DBROOTPWD=${MARIADB_DBROOTPWD} >> $ENV_FILE
	echo NC_ADMIN_USER=${NC_ADMIN_USER:-admin} >> $ENV_FILE
	echo NC_ADMIN_PASS=${NC_ADMIN_PASS:-admin345} >> $ENV_FILE
}

#
# Starting main routine
#

# Call getopt to validate the provided input.
options=$(getopt -o pf:r:m:n:h? --long help --long redis: --long mariadb: --long nextcloud: -- "$@")
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
		-f)
			shift
			ENV_FILE=$1
			if [ -f $ENV_FILE ]; then {
				echo "Loading env-file . . ."
				source $ENV_FILE
			}
			else {
				echo "Incorrect argument of option -f <existing env-file> provided"
				exit 2
			}
			fi
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

if [[ $PASS -eq 1 ]]; then { 
	echo "Password for Redis should be: " \
	&& REDIS_MYPASSWORD=$(mkpasswd -m sha256crypt | cut -d '$' -f 4 ) && echo "RedisPassword = ${REDIS_MYPASSWORD}"
	echo "Password for MariaDB admin should be: " \
	&& MARIADB_DBROOTPWD=$(mkpasswd -m sha256crypt | cut -d '$' -f 4 ) && echo "MariaDB admin Password = ${MARIADB_DBROOTPWD}"
	echo "Password for MariaDB database should be: " \
	&& MARIADB_DBPASSWD=$(mkpasswd -m sha256crypt | cut -d '$' -f 4 ) && echo "MariaDB database Password = ${MARIADB_DBPASSWD}"
	read -p "Username for Nextcloud Admin should be: [${NC_ADMIN_USER}] " NC_ADMIN_USER 
	read -s -p "Password for Nextcloud Admin should be: " NC_ADMIN_PASS 
	writeenvfile
}
else
	if [ -f $ENV_FILE ]; then
		source $ENV_FILE
	else {
		echo "Error: could not load file: $ENV_FILE"
		echo "pls., provide an ENV_file with -f <filename> or"
		echo "with option -p creates new password ... "
		echo
		usage
		exit 2
	}
	fi
fi


test -z $DEBUG || { 
	echo "RedisPassword = ${REDIS_MYPASSWORD}"
	echo "MariaDB admin Password = ${MARIADB_DBROOTPWD}"
	echo "MariaDB database Password = ${MARIADB_DBPASSWD}"
	echo "Nextcloud Admin Username = ${NC_ADMIN_USER}"
	echo "Nextcloud Admin Password = ${NC_ADMIN_PASS}"
}

#################
# Start the docker build section
#################
pushd .
cd ${WORKING_DIR}

docker build -t ${REDIS_CONTAINER:=redis} --build-arg NC_REDIS_UID=${REDIS_UID:-1003} redis
docker build -t ${MARIADB_CONTAINER:=bmdb} --build-arg NC_MARIADB_UID=${MARIADB_UID:-1003} mariaDB
#docker build -t ${NC_CONTAINER:=nc} --build-arg NC_UID=${NC_UID:-1003} nginx
docker build -t ${NC_CONTAINER:=nc} nginx

popd

#################
# prepare firewalltables and nat
#################
#
# Both following commands are adjusted to this configuration
#nft add rule ip nat PREROUTING iif enp3s0 tcp dport { 80, 443 } dnat 172.17.0.4
#nft add rule ip nat PREROUTING iif enp5s0 tcp dport { 80, 443 } dnat 172.17.0.4
#
#################
# do the docker run section 
# depending on options
#################
pushd .
cd ${WORKING_DIR}


[[ $REDIS -eq 1 ]] && docker run -d --name ${REDIS_NAME:=redis-server} -e REDIS_PASSWORD=${REDIS_MYPASSWORD} -v ${REDIS_PV}:/bitnami/redis/data ${REDIS_CONTAINER:=redis}:latest

[[ $MARIADB -eq 1 ]] && docker run -d --name ${MARIADB_NAME:=mariadb-server} -e MARIADB_ROOT_PASSWORD=${MARIADB_DBROOTPWD} \
       -e MARIADB_DATABASE=${MARIADB_DB:=nextcloud} -e MARIADB_USER=${MARIADB_DBUSER:=nextcloud} -e MARIADB_PASSWORD=${MARIADB_DBPASSWD} \
       -v ${MARIADB_PV}:/bitnami/mariadb ${MARIADB_CONTAINER:=bmdb}:latest

[[ $NC -eq 1 ]] && docker run --name ${NC_NAME:=nextcloud} -e LETSENCRYPT=${NC_LETSENCRYPT:=0} \
	-e NC_REDIS_PASS=${REDIS_MYPASSWORD} -e NC_REDIS_HOST="172.17.0.2" \
	-e NC_DB_HOST="172.17.0.3" -e NC_DB_NAME="${MARIADB_DB:=nextcloud}" -e NC_DB_USER="${MARIADB_DBUSER:=nextcloud}" -e NC_DB_PASS=${MARIADB_DBPASSWD} \
	-e NC_ADMIN_USER="${NC_ADMIN_USER:=admin}" -e NC_ADMIN_PASS="${NC_ADMIN_PASS:=admin345admin}" \
	-p 80:80 -p 443:443 -v ${NC_CONFIG_PV}:/opt/nextcloud/config -v ${NC_DATA_PV}:/opt/nextcloud/data ${NC_CONTAINER:=nc}:latest

popd

# docker run --name ${NC_NAME:=nextcloud} -e LETSENCRYPT=${NC_LETSENCRYPT:=0} -e NC_REDIS_PASS=${REDIS_MYPASSWORD} -e NC_REDIS_HOST="172.17.0.2" -e NC_DB_HOST="172.17.0.3" -e NC_DB_NAME="${MARIADB_DB:=nextcloud}" -e NC_DB_USER="${MARIADB_DBUSER:=nextcloud}" -e NC_DB_PASS=${MARIADB_DBPASSWD} -e NC_ADMIN_USER="${NC_ADMIN_USER:=admin}" -e NC_ADMIN_PASS="${NC_ADMIN_PASS:=admin345admin}" -p 80:80 -p 443:443 -v ${NC_CONFIG_PV}:/opt/nextcloud/config -v ${NC_DATA_PV}:/opt/nextcloud/data ${NC_CONTAINER:=nc}:latest
