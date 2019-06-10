#!/bin/sh


# -------------------- configs 4 PHP -------------------------
WWW_CONF    = "/etc/php/7.3/fpm/pool.d/www.conf"
CLI_PHP_INI = "/etc/php/7.3/cli/php.ini"
FPM_PHP_INI = "/etc/php/7.3/fpm/php.ini"
FPM_PHP_FPM = "/etc/php/7.3/fpm/php-fpm.conf"

cp $WWW_CONF $WWW_CONF.bak
cp $CLI_PHP_INI $CLI_PHP_INI.bak
cp $FPM_PHP_INI $FPM_PHP_INI.bak
cp $FPM_PHP_INI $FPM_PHP_INI.bak

sed -i "s/;env\[HOSTNAME\] = /env[HOSTNAME] = /" $WWW_CONF
sed -i "s/;env\[TMP\] = /env[TMP] = /" $WWW_CONF
sed -i "s/;env\[TMPDIR\] = /env[TMPDIR] = /" $WWW_CONF
sed -i "s/;env\[TEMP\] = /env[TEMP] = /" $WWW_CONF
sed -i "s/;env\[PATH\] = /env[PATH] = /" $WWW_CONF
sed -i "s/pm.max_children = .*/pm.max_children = 240/" $WWW_CONF
sed -i "s/pm.start_servers = .*/pm.start_servers = 20/" $WWW_CONF
sed -i "s/pm.min_spare_servers = .*/pm.min_spare_servers = 10/" $WWW_CONF
sed -i "s/pm.max_spare_servers = .*/pm.max_spare_servers = 20/" $WWW_CONF
sed -i "s/;pm.max_requests = 500/pm.max_requests = 500/" $WWW_CONF
sed -i "s/output_buffering =.*/output_buffering = 'Off'/" $CLI_PHP_INI
sed -i "s/max_execution_time =.*/max_execution_time = 1800/" $CLI_PHP_INI
sed -i "s/max_input_time =.*/max_input_time = 3600/" $CLI_PHP_INI
sed -i "s/post_max_size =.*/post_max_size = 10240M/" $CLI_PHP_INI
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" $CLI_PHP_INI
sed -i "s/max_file_uploads =.*/max_file_uploads = 100/" $CLI_PHP_INI
sed -i "s/;date.timezone.*/date.timezone = Europe\/\Berlin/" $CLI_PHP_INI
sed -i "s/;session.cookie_secure.*/session.cookie_secure = True/" $CLI_PHP_INI
sed -i "s/;session.save_path =.*/session.save_path = \"N;700;\/var\/local\/tmp\/sessions\"/" $CLI_PHP_INI
sed -i '$aapc.enable_cli = 1' $CLI_PHP_INI
sed -i "s/memory_limit = 128M/memory_limit = 512M/" $FPM_PHP_INI
sed -i "s/output_buffering =.*/output_buffering = 'Off'/" $FPM_PHP_INI
sed -i "s/max_execution_time =.*/max_execution_time = 1800/" $FPM_PHP_INI
sed -i "s/max_input_time =.*/max_input_time = 3600/" $FPM_PHP_INI
sed -i "s/post_max_size =.*/post_max_size = 10240M/" $FPM_PHP_INI
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" $FPM_PHP_INI
sed -i "s/max_file_uploads =.*/max_file_uploads = 100/" $FPM_PHP_INI
sed -i "s/;date.timezone.*/date.timezone = Europe\/\Berlin/" $FPM_PHP_INI
sed -i "s/;session.cookie_secure.*/session.cookie_secure = True/" $FPM_PHP_INI
sed -i "s/;opcache.enable=.*/opcache.enable=1/" $FPM_PHP_INI
sed -i "s/;opcache.enable_cli=.*/opcache.enable_cli=1/" $FPM_PHP_INI
sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=128/" $FPM_PHP_INI
sed -i "s/;opcache.interned_strings_buffer=.*/opcache.interned_strings_buffer=8/" $FPM_PHP_INI
sed -i "s/;opcache.max_accelerated_files=.*/opcache.max_accelerated_files=10000/" $FPM_PHP_INI
sed -i "s/;opcache.revalidate_freq=.*/opcache.revalidate_freq=1/" $FPM_PHP_INI
sed -i "s/;opcache.save_comments=.*/opcache.save_comments=1/" $FPM_PHP_INI
sed -i "s/;session.save_path =.*/session.save_path = \"N;700;\/var\/local\/tmp\/sessions\"/" $FPM_PHP_INI
sed -i "s/;emergency_restart_threshold =.*/emergency_restart_threshold = 10/" $FPM_PHP_INI
sed -i "s/;emergency_restart_interval =.*/emergency_restart_interval = 1m/" $FPM_PHP_INI
sed -i "s/;process_control_timeout =.*/process_control_timeout = 10s/" $FPM_PHP_INI
sed -i '$aapc.enabled=1' $FPM_PHP_INI
sed -i '$aapc.file_update_protection=2' $FPM_PHP_INI
sed -i '$aapc.optimization=0' $FPM_PHP_INI
sed -i '$aapc.shm_size=256M' $FPM_PHP_INI
sed -i '$aapc.include_once_override=0' $FPM_PHP_INI
sed -i '$aapc.shm_segments=1' $FPM_PHP_INI
sed -i '$aapc.ttl=7200' $FPM_PHP_INI
sed -i '$aapc.user_ttl=7200' $FPM_PHP_INI
sed -i '$aapc.gc_ttl=3600' $FPM_PHP_INI
sed -i '$aapc.num_files_hint=1024' $FPM_PHP_INI
sed -i '$aapc.enable_cli=0' $FPM_PHP_INI
sed -i '$aapc.max_file_size=5M' $FPM_PHP_INI
sed -i '$aapc.cache_by_default=1' $FPM_PHP_INI
sed -i '$aapc.use_request_time=1' $FPM_PHP_INI
sed -i '$aapc.slam_defense=0' $FPM_PHP_INI
sed -i '$aapc.mmap_file_mask=/var/local/tmp/apc/apc.XXXXXX' $FPM_PHP_INI
sed -i '$aapc.stat_ctime=0' $FPM_PHP_INI
sed -i '$aapc.canonicalize=1' $FPM_PHP_INI
sed -i '$aapc.write_lock=1' $FPM_PHP_INI
sed -i '$aapc.report_autofilter=0' $FPM_PHP_INI
sed -i '$aapc.rfc1867=0' $FPM_PHP_INI
sed -i '$aapc.rfc1867_prefix =upload_' $FPM_PHP_INI
sed -i '$aapc.rfc1867_name=APC_UPLOAD_PROGRESS' $FPM_PHP_INI
sed -i '$aapc.rfc1867_freq=0' $FPM_PHP_INI
sed -i '$aapc.rfc1867_ttl=3600' $FPM_PHP_INI
sed -i '$aapc.lazy_classes=0' $FPM_PHP_INI
sed -i '$aapc.lazy_functions=0' $FPM_PHP_INI
sed -i "s/09,39.*/# &/" /etc/cron.d/php
sed -i "s/rights\=\"none\" pattern\=\"PDF\"/rights\=\"read\|write\" pattern\=\"PDF\"/" /etc/ImageMagick-6/policy.xml

(crontab -l ; echo "09,39 * * * * /usr/lib/php/sessionclean 2>&1") | crontab -u root -

# -------------------- configs 4 /etc/fstab -------------------------

UID_WWW_DATA = $(id www-data)
FILE_FSTAB   = /etc/fstab

sed -i '$atmpfs /var/local/tmp/apc tmpfs defaults,uid=${UID_WWW_DATA},size=300M,noatime,nosuid,nodev,noexec,mode=1777 0 0' $FILE_FSTAB
sed -i '$atmpfs /var/local/tmp/sessions tmpfs defaults,uid=${UID_WWW_DATA},size=300M,noatime,nosuid,nodev,noexec,mode=1777 0 0' $FILE_FSTAB
