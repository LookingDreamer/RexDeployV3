#!/bin/bash 
rm /var/lib/mysql/* -rf 
mysql_install_db --user=mysql
cd /usr ; /usr/bin/mysqld_safe &
sleep 1
mysqladmin -u root password 'root' 
mysql -uroot -p'root'  -e 'CREATE DATABASE autotask DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci'
mysql -uroot -p'root'  -e "grant all privileges on *.* to 'root'@'%' identified by 'root'"
cd /data/RexDeployV3
/bin/bash install/dockerinit.sh setConfig
mysql -uroot -p'root'  -e "use autotask ; ALTER TABLE pre_server_detail ADD COLUMN logfile  varchar(255) NULL COMMENT '日志文件' AFTER configure_file_status;"
mysql -uroot -p'root'  -e "use autotask ; update pre_server_detail set logfile='catalina.#%Y-%m-%d' ;"
mysqladmin -uroot -p'root' shutdown
adduser autotask -g wheel
echo "autotask" |passwd --stdin  autotask
echo "autotask2015" |passwd --stdin  root
chmod a+x /usr/local/tomcat-*/bin/*.sh
echo "${getLocalIp}" >> /data/RexDeployV3/config/ip_lists.ini
chmod 600 /etc/rsyncd.secrets 
httpd 
rsync --daemon
/usr/sbin/sshd -D &
cd /usr ; /usr/bin/mysqld_safe 



