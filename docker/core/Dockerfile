FROM centos:7.1.1503 AS build
USER root
RUN yum install wget -y && mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
&& wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo \
&& yum clean all && yum makecache \
&& yum install  tar unzip make  dos2unix perl-DBD-MySQL rsync passwd openssl openssh-server net-tools vim  -y \
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
&& mkdir /data \
&& tar -zxvf RexDeployV3.tar.gz  -C /data/ \
&& rm -f RexDeployV3.tar.gz \
&& cd /data/RexDeployV3 \
&& /bin/bash install/initStall.sh instalib \
&& rm /var/lib/mysql/* -rf \
&& mysql_install_db --user=mysql \
&& cd /data/RexDeployV3  && /bin/bash install/initStall.sh instalib
ADD start.sh /data/RexDeployV3/docker/start.sh
WORKDIR /data/RexDeployV3 
#ENTRYPOINT [ "top", "-b" ]
ENTRYPOINT [ "/data/RexDeployV3/docker/start.sh" ]
    

