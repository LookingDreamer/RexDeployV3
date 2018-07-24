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
mysqladmin -uroot -p'root' shutdown
adduser autotask -g wheel
echo "autotask" |passwd --stdin  autotask
echo "autotask2015" |passwd --stdin  root
chmod a+x /usr/local/tomcat-*/bin/*.sh
getLocalIp=$(ifconfig |grep inet |awk '{print $2}' |grep -v "127.0.0.1" |grep -v "^$")
echo "${getLocalIp}" >> /data/RexDeployV3/config/ip_lists.ini
mysql -uroot -p'root' --default-character-set=utf8 -e "use autotask;update pre_server_detail set network_ip='${getLocalIp}' where app_key in ('server2','flow2') ;"
chmod 600 /etc/rsyncd.secrets 
httpd 
rsync --daemon
/usr/sbin/sshd -D &
web/script/fastnotes.pl prefork -m production -w 10 -c 100 &
cd /usr ; /usr/bin/mysqld_safe 