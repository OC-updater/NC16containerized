#!/bin/bash

# Load Nextcloud environment variables
eval "$(nextcloud_env)"

BIN_SH="${NC_BIN_SH:=/usr/local/bin}"
NC_ROOT="${NC_ROOTDIR:-/opt/nextcloud}"
NC_CONF="${NC_ROOT}/config"

setup() {
   for NC_CONF in php_configure.sh acme-config.sh nextcloud.sh; do
       if [ -f "$BIN_SH/$NC_CONF" ]; then
           . $BIN_SH/$NC_CONF
       fi
   done
   echo "Installation successful finished"
}


if [ ! -f "$NC_CONF/config.php" ]; then
	setup
fi

for SERV in php7.3-fpm nginx; do 
   service $SERV start
done


exec /bin/bash
