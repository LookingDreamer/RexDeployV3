FROM centos:7.1.1503 AS build
#USER root
RUN yum install wget -y && mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
&& wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
&& yum clean all && yum makecache \
&& yum install  tar unzip make perl dos2unix -y \
&& wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm \
&& rpm -ivh mysql-community-release-el7-5.noarch.rpm \
&& yum install mysql-community-server

COPY RexDeployV3.tar.gz /tmp/
COPY start.sh /tmp/
ENTRYPOINT [ "/bin/bash", "/tmp/start.sh" ]
    

