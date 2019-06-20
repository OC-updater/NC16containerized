#!/bin/bash

# Load Nextcloud environment variables
if [ -f nextcloud_env ]; then
   eval "$(nextcloud_env)"
fi

BIN_SH="${NC_BIN_SH:=/usr/local/bin}"
NC_ROOT="${NC_ROOTDIR:-/opt/nextcloud}"
NC_CONF="${NC_ROOT}/config"

setup() {
   for NC_CONF in php_configure.sh acme-config.sh nextcloud.sh; do
       if [ -f "$BIN_SH/$NC_CONF" ]; then
	   echo "----------- Install: $NC_CONF -----------"
           . $BIN_SH/$NC_CONF
       fi
   done
   echo " ----------- ------------ -----------"
   echo "|  Installation successful finished  |"
   echo " ----------- ------------ -----------"
}


if [ ! -f "$NC_CONF/config.php" ]; then
   echo "----------- Setup started -----------"
   setup
fi

for SERV in php7.3-fpm nginx; do 
   service $SERV start
done

#nginx -g 'daemon off;'

#exec /bin/bash
bash

#sleep 1d
