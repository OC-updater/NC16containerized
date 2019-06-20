#!/bin/bash


DB_TMP="/var/tmp/mysql-tmp.sql"
DB_LOG="/var/tmp/mysql-tmp.log"
DB_HOST="172.17.0.2"
DB_USER="root"
DB_NAME="nextcloud"
MYSQL=$(which mysql)


rm -f $DB_TMP
cat <<EOF >>$DB_TMP
delete from oc_accounts where uid='admin';
delete from oc_users where uid='admin';
select count(*) from oc_users;
EOF

$MYSQL -h $DB_HOST -u $DB_USER -D $DB_NAME < $DB_TMP > $DB_LOG

rm -f $DB_TMP

