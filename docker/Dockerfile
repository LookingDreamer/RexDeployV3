FROM centos:7.1.1503 AS build
USER root
RUN yum install wget -y && mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
&& wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo \
&& yum clean all && yum makecache \
&& yum install  tar unzip make  dos2unix perl-DBD-MySQL rsync passwd openssl openssh-server net-tools vim openssh-clients sudo httpd -y \
&& sed -i "s/\/var\/www\/html/\/data\/rsync/g" /etc/httpd/conf/httpd.conf \
&& mkdir -p /data/rsync && chmod 777 /data/rsync -R \
&& ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''   \
&& ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N ''  \
&& sed -i "s/UsePAM yes/UsePAM no/g" /etc/ssh/sshd_config \
&& sed -i "s/UsePrivilegeSeparation sandbox/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
&& wget  https://download.osichina.net/rpm/mysql-community-release-el7-5.noarch.rpm \
&& rpm -ivh mysql-community-release-el7-5.noarch.rpm \
&& yum install mysql-community-server  --nogpgcheck -y \
&& rm -f mysql-community-release-el7-5.noarch.rpm \
&& wget https://download.osichina.net/package/RexDeployV3.tar.gz \
&& tar -zxvf RexDeployV3.tar.gz  -C /data/ \
&& rm -f RexDeployV3.tar.gz \
&& cd /data/RexDeployV3 \
&& /bin/bash install/initStall.sh instalib \
&& rm /var/lib/mysql/* -rf \
&& mysql_install_db --user=mysql \
&& wget https://download.osichina.net/tools/apache-tomcat-9.0.0.M4.zip \
&& unzip apache-tomcat-9.0.0.M4.zip -d /usr/local \
&& rm -f apache-tomcat-9.0.0.M4.zip \
&&  wget -q https://download.osichina.net/tools/jdk-8u161-linux-x64.tar.gz \
&&  tar -zxvf jdk-8u161-linux-x64.tar.gz -C /usr/local/ \
&& ln -s /usr/local/jdk1.8.0_161 /usr/local/jdk \
&& echo "export PATH=/usr/local/jdk/bin:\$PATH" >> /etc/profile \ 
&& echo "export JAVA_HOME=/usr/local/jdk/" >> /etc/profile \ 
&& rm -f jdk-8u161-linux-x64.tar.gz \
&& mkdir -p /data/www/html1_2018_0321_1628 \
&& wget https://download.osichina.net/package/pack.war  \
&& unzip pack.war -d /data/www/html1_2018_0321_1628  \
&& rm -f pack.war \
&& /bin/bash /data/RexDeployV3/docker/client.sh \
&& cd /data/RexDeployV3  && /bin/bash install/initStall.sh instalib

ADD rsyncd.conf /etc/rsyncd.conf
ADD rsyncd.secrets /etc/rsyncd.secrets
ADD start.sh /data/RexDeployV3/docker/start.sh
WORKDIR /data/RexDeployV3 
#ENTRYPOINT [ "top", "-b" ]
ENTRYPOINT [ "/data/RexDeployV3/docker/start.sh" ]
    

