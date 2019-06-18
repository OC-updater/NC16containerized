#!/bin/bash

NC_ROOT="${NC_ROOTDIR:=/opt/nextcloud}"
NC_DATA="${NC_DATADIR:=/opt/nextcloud/data}"
OCC="${NC_ROOT}/occ"

/usr/sbin/service nginx stop
su - www-data -s /bin/bash -c "php $NC_ROOT/updater/updater.phar"
su - www-data -s /bin/bash -c "php $NC_ROOT/occ status"
su - www-data -s /bin/bash -c "php $NC_ROOT/occ -V"
su - www-data -s /bin/bash -c "php $NC_ROOT/occ db:add-missing-indices"
su - www-data -s /bin/bash -c "php $NC_ROOT/occ db:convert-filecache-bigint"
sed -i "s/upload_max_filesize=.*/upload_max_filesize=10240M/" $NC_ROOT/.user.ini
sed -i "s/post_max_size=.*/post_max_size=10240M/" $NC_ROOT/.user.ini
sed -i "s/output_buffering=.*/output_buffering="Off"/" $NC_ROOT/.user.ini
chown -R www-data:www-data $NC_ROOT
su - www-data -s /bin/bash -c "php $NC_ROOT/occ update:check"
su - www-data -s /bin/bash -c "php $NC_ROOT/occ app:update --all"
/usr/sbin/service php7.3-fpm restart
/usr/sbin/service nginx restart
exit 0
