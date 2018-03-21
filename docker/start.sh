#!/bin/bash 
/bin/bash install/initStall.sh instalib 
rm /var/lib/mysql/* -rf
mysql_install_db --user=mysql
cd /usr ; /usr/bin/mysqld_safe &
mysqladmin -u root password 'root' 
mysql -uroot -p'root'  -e 'CREATE DATABASE autotask DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci'
/bin/bash  install/dockerinit.sh setConfig
mysqladmin -u root -p 'root' shutdown
cd /usr ; /usr/bin/mysqld_safe 