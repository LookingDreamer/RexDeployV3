#!/bin/bash 
rm /var/lib/mysql/* -rf 
mysql_install_db --user=mysql
cd /usr ; /usr/bin/mysqld_safe &
sleep 1
mysqladmin -u root password 'root' 
mysql -uroot -p'root'  -e 'CREATE DATABASE autotask DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci'
cd /data/RexDeployV3
/bin/bash install/dockerinit.sh setConfig
mysqladmin -uroot -p'root' shutdown
adduser autotask
echo "autotask" |passwd --stdin  autotask
/usr/sbin/sshd -D &
cd /usr ; /usr/bin/mysqld_safe 


