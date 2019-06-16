#!/bin/bash

NC_ROOT="${NC_ROOTDIR:=/opt/nextcloud}"
NC_DATA="${NC_DATADIR:=/opt/nextcloud/data}"
OCC="${NC_ROOT}/occ"

su - www-data -s /bin/bash -c "php $OCC maintenance:install --database ${NC_DATABASE:-mysql} --database-name ${NC_DBNAME:-nextcloud} --database-host ${NC_DBHOST:-172.17.0.2} --database-user ${NC_DBUSER:-nextcloud} --database-pass ${NC_DBPASSWD:-next123cloud} --admin-user ${NC_ADMINUSER:-admin} --admin-pass ${NC_ADMINPASSWD:-admin345admin} --data-dir $NC_DATA"
su - www-data -s /bin/bash -c "php $OCC config:system:set trusted_domains 1 --value=nc.dtx.at"
su - www-data -s /bin/bash -c "php $OCC config:system:set overwrite.cli.url --value=https://nc.dtx.at"

# writeing config.php
sed -i 's/^[ ]*//' ${NC_ROOT}/config/config.php
sed -i '/);/d' ${NC_ROOT}/config/config.php

cat <<EOF >>$NC_ROOT/config/config.php
'activity_expire_days' => 14,
'auth.bruteforce.protection.enabled' => true,
'blacklisted_files' => 
	array (
		0 => '.htaccess',
		1 => 'Thumbs.db',
		2 => 'thumbs.db',
	),
'cron_log' => true,
'enable_previews' => true,
'enabledPreviewProviders' => 
	array (
		0 => 'OC\\Preview\\PNG',
		1 => 'OC\\Preview\\JPEG',
		2 => 'OC\\Preview\\GIF',
		3 => 'OC\\Preview\\BMP',
		4 => 'OC\\Preview\\XBitmap',
		5 => 'OC\\Preview\\Movie',
		6 => 'OC\\Preview\\PDF',
		7 => 'OC\\Preview\\MP3',
		8 => 'OC\\Preview\\TXT',
		9 => 'OC\\Preview\\MarkDown',
	),
'filesystem_check_changes' => 0,
'filelocking.enabled' => 'true',
'htaccess.RewriteBase' => '/',
'integrity.check.disabled' => false,
'knowledgebaseenabled' => false,
'logfile' => '/var/log/nextcloud/nextcloud.log',
'loglevel' => 2,
'logtimezone' => 'Europe/Vienna',
'log_rotate_size' => 104857600,
'maintenance' => false,
'memcache.local' => '\\OC\\Memcache\\APCu',
'memcache.locking' => '\\OC\\Memcache\\Redis',
'overwriteprotocol' => 'https',
'preview_max_x' => 1024,
'preview_max_y' => 768,
'preview_max_scale_factor' => 1,
'redis' => 
	array (
		'host' => '/var/run/redis/redis.sock',
		'port' => 0,
		'timeout' => 0.0,
	),
'quota_include_external_storage' => false,
'share_folder' => '/Shares',
'skeletondirectory' => '',
'theme' => '',
'trashbin_retention_obligation' => 'auto, 7',
'updater.release.channel' => 'stable',
);
EOF

# edit user.ini
sed -i "s/upload_max_filesize=.*/upload_max_filesize=10240M/" $NC_ROOT/.user.ini
sed -i "s/post_max_size=.*/post_max_size=10240M/" $NC_ROOT/.user.ini
sed -i "s/output_buffering=.*/output_buffering='Off'/" $NC_ROOT/.user.ini
#service php7.3-fpm restart && service redis-server restart && service nginx restart
service php7.3-fpm restart && service nginx restart

# adjust Nextcloud apps
su - www-data -s /bin/bash -c 'php $OCC app:disable survey_client'
su - www-data -s /bin/bash -c 'php $OCC app:disable firstrunwizard'
su - www-data -s /bin/bash -c 'php $OCC app:enable admin_audit'
su - www-data -s /bin/bash -c 'php $OCC app:enable files_pdfviewer'



