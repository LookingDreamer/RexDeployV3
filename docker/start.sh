#!/bin/bash 


cd /usr ; /usr/bin/mysqld_safe &
sleep 2
mysqladmin -u root password 'root' 
mysql -uroot -p'root'  -e 'CREATE DATABASE autotask DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci'
cd /data/RexDeployV3
/bin/bash install/dockerinit.sh setConfig
mysqladmin -uroot -p'root' shutdown
cd /usr ; /usr/bin/mysqld_safe 
