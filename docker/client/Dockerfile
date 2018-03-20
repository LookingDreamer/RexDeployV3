FROM centos:7.1.1503 AS build
RUN yum clean all && yum makecache \
&& yum install wget tar unzip  -y \
&&  wget -q https://download.osichina.net/tools/jdk-8u161-linux-x64.tar.gz \
&&  wget -q https://download.osichina.net/tools/apache-tomcat-9.0.0.M4.zip \
&&  tar -zxvf jdk-8u161-linux-x64.tar.gz -C /usr/local/ \
&& ln -s /usr/local/jdk1.8.0_161 /usr/local/jdk \
&& unzip apache-tomcat-9.0.0.M4.zip -d  /usr/local/ \
&& ln -s /usr/local/apache-tomcat-9.0.0.M4 /usr/local/tomcat \
&& echo "export PATH = /usr/local/jdk/bin:\$PATH" >> /etc/profile \ 
&& rm -f jdk-8u161-linux-x64.tar.gz \
&& rm -f apache-tomcat-9.0.0.M4.zip 

WORKDIR /tmp/install
ENTRYPOINT [ "top", "-b" ]