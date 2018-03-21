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

#客户端应用初始化
#mkdir -p /data/log/server1 /data/log/server2 /data/log/flow1 /data/log/flow2 /data/www/config1 /data/www/config2
#mv apache-tomcat-9.0.0.M4 /usr/local/tomcat-server1
#cp tomcat-server1 tomcat-server2 -ar
#cp tomcat-server1 tomcat-flow1 -ar
#cp tomcat-server1 tomcat-flow2 -ar
#find tomcat-server1/ -name server.xml -exec sed -i  "s/8080/6080/g" {} \;
#find tomcat-server2/ -name server.xml -exec sed -i  "s/8080/7080/g" {} \;
#find tomcat-server2/  -type f -exec  sed -i "s/\/data\/log\/server1/\/data\/log\/server2/g" {} \;
#find tomcat-server2/ -name server.xml -exec sed -i  "s/\/data\/www\/html1/\/data\/www\/html2/g" {} \;
#find tomcat-flow1/ -name server.xml -exec sed -i  "s/8080/8080/g" {} \;
#find tomcat-flow2/ -name server.xml -exec sed -i  "s/8080/9080/g" {} \;
#find tomcat-flow1/  -type f -exec  sed -i "s/\/data\/log\/server1/\/data\/log\/flow1/g" {} \;
#find tomcat-flow2/  -type f -exec  sed -i "s/\/data\/log\/server1/\/data\/log\/flow2/g" {} \;
#find tomcat-flow1/ -name server.xml -exec sed -i  "s/\/data\/www\/html1/\/data\/www\/flow1/g" {} \;
#find tomcat-flow2/ -name server.xml -exec sed -i  "s/\/data\/www\/html1/\/data\/www\/flow2/g" {} \;


#cp /data/www/html1_2018_0321_1628 /data/www/html2_2018_0321_1628 -ar
#cp /data/www/html1_2018_0321_1628 /data/www/flow1_2018_0321_1628 -ar
#cp /data/www/html1_2018_0321_1628 /data/www/flow2_2018_0321_1628 -ar

#mv html1/WEB-INF/classes/config.properties config1/
#mv html1/WEB-INF/classes/applicationContext.xml config1/
#mv html1/WEB-INF/classes/log4j.properties config1/
#mv html1/WEB-INF/classes/ config1/
#cp config1/ config2 -ar
#ln -s html2_2018_0321_1628/ html2
#ln -s  flow1_2018_0321_1628/ flow1
#ln -s flow2_2018_0321_1628 flow2
#rm html2/WEB-INF/classes/{config.properties,applicationContext.xml,generatorConfig.xml,log4j.properties} -f
find tomcat-server1/ -name server.xml -exec sed -i  "s/8005/8015/g" {} \;
find tomcat-server2/ -name server.xml -exec sed -i  "s/8005/8025/g" {} \;
find tomcat-flow1/ -name server.xml -exec sed -i  "s/8005/8035/g" {} \;
find tomcat-flow2/ -name server.xml -exec sed -i  "s/8005/8045/g" {} \;

find tomcat-server1/ -name server.xml -exec sed -i  "s/8009/8019/g" {} \;
find tomcat-server2/ -name server.xml -exec sed -i  "s/8009/8029/g" {} \;
find tomcat-flow1/ -name server.xml -exec sed -i  "s/8009/8039/g" {} \;
find tomcat-flow2/ -name server.xml -exec sed -i  "s/8009/8049/g" {} \;