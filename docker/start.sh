#!/bin/bash 
rm /var/lib/mysql/* -rf
mysql_install_db --user=mysql
mysqld_safe &
mysqladmin -u root password 'root' 
mysql -u root -p 'root'  -e 'CREATE DATABASE autotask DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci'
/bin/bash  install/dockerinit.sh setConfig
mysqladmin -u root -p 'root' shutdown
mysqld_safe