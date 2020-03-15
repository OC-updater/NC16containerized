#!/bin/bash
#
# new bash-script 4 getting letsencrypt signed certs.
# written by dt, 15.3.2020
#
# this script is the successor of acme-config.sh (the used version of acmetools only supports the old protocol ACME-V1)
# now: https://github.com/kshcherban/acme-nginx
#



NC_FQDN=("nc.dtx.at" "nextcloud.dtx.at")
NGINX_SSL_CONF="/etc/nginx/ssl.conf"
ACMETOOL=$(which acme-nginx)

VHOST="${NGINX_VHOST:-/etc/nginx/conf.d/letsencrypt.conf}"
DOMKEY="${NC_DOMKEY:-/etc/ssl/private/nc.key}"
DOMCRT="${NC_DOMCRT:-/etc/ssl/certs/nc.crt}"

--virtual-host /etc/nginx/conf.d/letsencrypt-V2.conf --domain-private-key /etc/ssl/private/nc.key -o /etc/ssl/certs/nc.crt -d nc.dtx.at -d nextcloud.dtx.at

service nginx status
case "$?" in
	0) echo "service nginx already started" ;;
	3) echo "service nginx not started yet" && service nginx start ;;
esac 

$ACMETOOL --virtual-host ${VHOST} --domain-private-key ${DOMKEY} -o ${DOMCRT} -d ${NC_FQDN[1]} -d ${NC_FQDN[2]}

# Later the nginx service will be started in foreground
# be sure, we dont leave a running nginx
echo "Service nginx stop. Will be started later again." && service nginx stop




