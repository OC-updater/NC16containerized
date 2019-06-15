#!/bin/bash

NC_FQDN=("nc.dtx.at" "nextcloud.dtx.at")
NGINX_SSL_CONF="/etc/nginx/ssl.conf"
ACMETOOL=$(which acmetool)
ACME_STATE_DIR=$($ACMETOOL status | grep ACME_STATE_DIR| cut -d' ' -f4)

$ACMETOOL --batch quickstart
$ACMETOOL want ${NC_FQDN[@]}

#copy certs and privkey to /etc/ssl/{certs,private}
for i in ${NC_FQDN[@]}; do
	ln -s $ACME_STATE_DIR/live/$i/chain /etc/ssl/certs/$i-chain.crt
	ln -s $ACME_STATE_DIR/live/$i/fullchain /etc/ssl/certs/$i-fullchain.crt
	ln -s $ACME_STATE_DIR/live/$i/privkey /etc/ssl/private/$i.key
done

sed -i "s/\(^ssl_certificate.*\/etc\/ssl\/certs\/\)nc.crt;/\1${NC_FQDN[0]}-fullchain.crt;/g" $NGINX_SSL_CONF
sed -i "s/\(^ssl_certificate_key.*\/etc\/ssl\/private\/\)nc.key;/\1${NC_FQDN[0]}.key;/g" $NGINX_SSL_CONF
sed -i "s/\(^ssl_trusted_certificate.*\/etc\/ssl\/certs\/\)nc.crt;/\1${NC_FQDN[0]}-chain.crt;/g" $NGINX_SSL_CONF

service nginx restart




