FROM centos:7.1.1503 AS build
USER root
RUN yum install wget -y && mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
&& wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo \
&& yum clean all && yum makecache \
&& yum install  tar unzip make  dos2unix perl-DBD-MySQL rsync -y \
&& wget  https://download.osichina.net/rpm/mysql-community-release-el7-5.noarch.rpm \
&& rpm -ivh mysql-community-release-el7-5.noarch.rpm \
&& yum install mysql-community-server  --nogpgcheck -y \
&& rm -f mysql-community-release-el7-5.noarch.rpm \
&& wget https://download.osichina.net/package/RexDeployV3.tar.gz \
&& mkdir /data \
&& tar -zxvf RexDeployV3.tar.gz  -C /data/ \
&& rm -f RexDeployV3.tar.gz \
&& cd /data/RexDeployV3 \
&& /bin/bash install/initStall.sh instalib \
&& rm /var/lib/mysql/* -rf \
&& mysql_install_db --user=mysql \
&& wget https://download.osichina.net/tools/apache-tomcat-9.0.0.M4.zip \
&& unzip apache-tomcat-9.0.0.M4.zip -d /usr/local \
&& rm -f apache-tomcat-9.0.0.M4.zip \
&& /bin/bash /data/RexDeployV3/docker/client.sh \
&& cd /data/RexDeployV3  && /bin/bash install/initStall.sh instalib


WORKDIR /data/RexDeployV3 
#ENTRYPOINT [ "top", "-b" ]
ENTRYPOINT [ "/data/RexDeployV3/docker/start.sh" ]
    

