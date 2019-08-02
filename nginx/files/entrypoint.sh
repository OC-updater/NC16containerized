#!/bin/bash

# Load Nextcloud environment variables
if [ -f nextcloud_env ]; then
   eval "$(nextcloud_env)"
fi

BIN_SH="${NC_BIN_SH:=/usr/local/bin}"
NC_ROOT="${NC_ROOTDIR:-/opt/nextcloud}"
NC_CONF="${NC_ROOT}/config"

# setup always
setupgeneral() {
   for NC_CONF in php_configure.sh acme-config.sh; do
       if [ -f "$BIN_SH/$NC_CONF" ]; then
	   echo "----------- Install: $NC_CONF -----------"
           . $BIN_SH/$NC_CONF
	   echo "---------- Finished: $NC_CONF -----------"
	   echo
       fi
   done
   echo " ----------- ------------ -----------"
   echo "|  Installation successful finished  |"
   echo " ----------- ------------ -----------"
}
# setup only one time, if there is no nextcloud config.php yet
setupnc() {
   for NC_CONF in php_configure.sh acme-config.sh nextcloud.sh; do
       if [ -f "$BIN_SH/$NC_CONF" ]; then
	   echo "----------- Install: $NC_CONF -----------"
           . $BIN_SH/$NC_CONF
	   echo "---------- Finished: $NC_CONF -----------"
	   echo
       fi
   done
   echo " ----------- ------------ -----------"
   echo "|  Installation successful finished  |"
   echo " ----------- ------------ -----------"
}


if [ ! -f "$NC_CONF/config.php" ]; then
   echo "-------- Setup started: new NC -----------"
   echo
   setupnc
else
   echo "-------- Setup started: existent NC -----------"
   echo
   setupgeneral
fi

#for SERV in php7.3-fpm nginx; do 
for SERV in cron php7.3-fpm; do
   echo "-------- Starting: $SERV -----------"	
   service $SERV start
done

# nginx will be started in Dockerfile by CMD
nginx -g 'daemon off;'

#exec /bin/bash
#bash

#sleep 1d
