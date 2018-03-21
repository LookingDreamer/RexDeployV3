### RexDeploy-自动化系统

一、简介
RexDeploy是基于perl语言开发的一个自动化平台。
此自动化的系统是基于原生rex进行二次开发而成,这是第三个大版本了，目前放出的这个版本是终端版，web版本已在开发当中，预计12月份将会放出。
此前放出过第一个版本，详情请撮：http://git.oschina.net/lookingdreamer/RexDeploy_v1

 **基于名字服务的发布系统，它的功能不仅仅在于此!** 

目前主要功能：
```
     批量命令执行
     批量文件上传
     批量文件下载
     应用自动发布
     应用自动回滚
     应用自动重启
     应用自动下载
     配置自动下载
     应用自动同步
     应用命令执行
     应用发布检查
     支持并发执行
```

二、安装
[X] Rex模块
[X] DBD::mysql
[X] Mojo::JSON 
 **
 _- Centos一键安装和配置_ ** 
```
# ./install/initStall.sh instalib   （一键安装依赖包）
# ./install/initStall.sh setConfig  (一键初始化配置) 
```
![输入图片说明](http://git.oschina.net/uploads/images/2016/1115/174416_b9dfecd6_119746.png "在这里输入图片标题")
 _**
- Centos系列手动安装 **_ 
1.0 Rex模块安装
CentOS 7
```
$ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS6
$ cat >/etc/yum.repos.d/rex.repo <<EOF
[rex]
name=Fedora \$releasever - \$basearch - Rex Repository
baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
enabled=1
EOF
$ yum install rex
```

CentOS 6

```
$ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS6

$ cat >/etc/yum.repos.d/rex.repo <<EOF
[rex]
name=Fedora \$releasever - \$basearch - Rex Repository
baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
enabled=1
EOF

$ yum install rex
```


CentOS 5


```
$ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS5

$ cat >/etc/yum.repos.d/rex.repo <<EOF
[rex]
name=Fedora \$releasever - \$basearch - Rex Repository
baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
enabled=1
EOF

$ yum install rex
```
rex完成之后，执行rex -v，显示版本号，则rex模块安装成功。
其他的系统（如mac /windowws 等）安装请参见: http://rexify.org/get.html 
```
[root@localhost ~]# rex -v
(R)?ex 1.4.1
```
2.0 其他依赖安装

```wget  http://git.oschina.net/lookingdreamer/resources/raw/master/perl/cpanm -O /usr/bin/cpanm; chmod +x /usr/bin/cpanm```
```
# cpanm DBD::mysql
# cpanm Mojo::JSON 
```
在安装Mojo::JSON的时候，如果安装失败时，请使用源码包的安装方式。
```
wget http://git.oschina.net/lookingdreamer/resources/raw/master/perl/Mojolicious-7.10.tar.gz 
cd Mojolicious-7.10
perl Makefile.PL 
make
make install
```

3.0 初始化配置
```
# cd RexDeployV3
# chmod +x install/initStall.sh
# ./install/initStall.sh setConfig
```
![输入图片说明](http://git.oschina.net/uploads/images/2016/1115/174633_277db093_119746.png "在这里输入图片标题")


三、目录层级解释

```# tree -L 2```
├── config   (配置文件目录)
│   ├── config.yml   (主配置文件)
│   └── ip_lists.ini    (IP分组列表配置)
├── configuredir  (发布前的配置目录)
├── download     (下载目录)
├── install   (安装目录)
│   ├── autotask_jry.sql  (安装sql)
│   ├── initStall.sh   (安装和初始化脚本)
│   ├── packages  (本地安装源包)
│   └── rex.repo
├── keys (秘钥目录)
│   ├── baowang
│   ├── baowang.pub
│   ├── huanggaoming
│   └── huanggaoming.pub
├── lib   (模块目录)
│   ├── Common (公共模块)
│   ├── Deploy  (发布模块)
│   ├── Enter (路由模块)
│   └── Rex  (自有模块)
├── LICENSE
├── logs   (日志目录)
│   └── rex.log
├── nosudoRexfile
├── pre_auto_template_vars.sql
├── pre_server_detail.sql
├── README.md
├── remotecomdir  (从远程服务器下载后的目录)
├── Rexfile  (rex主程序入口)
├── scripts  (脚本目录)
├── softdir   (发布前的工程目录)
├── src    (Rex源码目录)
│   └── Rex
├── temp   (发布临时目录)
├── tmp   (临时目录)
│   └── thread.pl
└── upload  (上传目录)

20 directories, 17 files
对于使用者只要关注 configuredir  softdir .

四、主配置文件详解 config.yml

```
#主配置文件
#环境变量设置,dev/uat/com等不同的环境变量设置
 db:
   dbname: "autotask"
   dbhost: "10.68.3.102"
   dbuser: "public"
   dbpassword: "public"
   dbport: "3306"
   apitable: "pre_host_zzb"
 env:
   key: "dev"
 uat:
   #认证相关配置
   # key_auth=true时,为秘钥认证,pass_auth=true,为密码认证。秘钥认证和密码认证不能同时为真;
   # 当key_auth=true时,仅支持秘钥认证为空的情况
   # user:用户名 password:密码 private_key:私钥文件 public_key:公钥文件 global_sudo:是否开启sudo,on为开启,off为关闭 sudo_password:sudo时密码
   # logfile:日志文件
   # groups_file:IP分组文件 
   # timeout:SSH超时时间 
   # max_connect_retries:SSH失败时最大连接尝试次数
   # parallelism:使用分组时,最大的并发数量 
   # table:主机信息表(废弃) 
   # monitor_table:监控数据表(暂时不使用) 
   # rerite_info_table:是否写入json文件(暂时不使用) 
   # default_jsonfile:默认json串存储文件(暂时不使用)   
   # table_string:数据库初始化主机信息要查询的字段(不要轻易修改) 
   # softdir:待发布应用目录
   # configuredir:待发布配置目录 
   # local_prodir:远程同步应用目录 
   # local_confdir:远程同步配置目录 
   # temp:应用发布时临时目录   
   # backup_dir:发布应用时,当数据库字段中backupdir_same_level为0时,且当配置目录在应用目录时,备份该应用程序的所在目录
   # baseapp_dir:发布应用时,当数据库字段中deploydir_same_level为0时,即是待发布目录的目录(发布目录不能和发布目录同层级),比如你的应用在webapp下,你的新的发布应用时不能再webapp下面,因为当你放在webapp下面时就相当于会启动2个app,所以需要另外的发布目录
   # download_all:是否下载所有的目录(暂时不使用,不能为空) 
   # is_link: 是否是软链接(暂时不使用,不能为空) 
   # is_stop:是否停止应用 (暂时不使用,不能为空) 
   # is_start:是否启动应用(暂时不使用,不能为空) 
   # download_record_log:下载应用的日志记录 
   # deploy_config_table:主机详细配置文件数据表(重要) 
   # deploy_record_table:发布时记录数据表
   # deploy_status_table:发布时状态数据表 
   # external_status:是否开启外网表,当开启外网表时,需要你将新建 复制主机详细配置文件数据表,同时将内网地址和外网地址交换,当external_status为true时,deploy_config_table将不起作用,读取外网表
   # external_deploy_config_table:  主机详细配置文件数据表(外网表)
   # list_all_task_status:是否要打印所有的模块信息,如果不为false,则答应所有的模块信息。为false时,则打印list_task所列出的模块
   # list_task:执行rex -T 要显示的模块 
   # service_start_retry:启动服务失败时的尝试次数 
   # rsync_log_stdout:是否显示传输包的进度和传输速度
   key_auth: "true"
   pass_auth: "false" 
   user: "baowang"
   password: ""
   private_key: "keys/baowang"
   public_key: "keys/baowang.pub"
   global_sudo: "on"
   sudo_password: "baowang2015"         
   logfile: "logs/rex.log"
   groups_file: "true,config/ip_lists.ini"
   timeout: "10"
   max_connect_retries: "8"
   parallelism: "5"
   table: "pre_host_zzb_dev"
   monitor_table: "pre_bwzzbmonitor_dev"
   rerite_info_table: "false"
   default_jsonfile: "cache/json/json.txt"
   table_string: "id,app_key,server_name,network_ip,pro_type,config_dir,pro_dir,pro_key,pro_init,local_name,is_deloy_dir"
   softdir: "softdir/"
   configuredir: "configuredir/"
   local_prodir: "remotecomdir/softdir/"
   local_confdir: "remotecomdir/configuredir/"
   temp: "temp/"
   backup_dir: "/data/backup"
   baseapp_dir: "/data/www/apps"
   download_all : "false"
   is_link :  "true"
   is_stop :  "false"
   is_start :  "true"
   download_record_log: "logs/download_record.log"
   deploy_config_table: "pre_server_detail"
   deploy_record_table: "pre_deploy_manage"
   deploy_status_table: "pre_deploy_status"
   external_status: "true"
   external_deploy_config_table: "pre_external_server_detail"
   list_all_task_status: "false"
   list_task: "check,list,run,Enter:route:deploy,Enter:route:download,Enter:route:rollback,Enter:route:service,Deploy:Db:initdb,Deploy:Core:syncpro,Common:Use:download,Common:Use:run,Common:Use:upload"
   service_start_retry: "5"
   rsync_log_stdout: "false"
#开发环境配置文件
 dev:
   key_auth: "true"
   pass_auth: "false" 
   user: "baowang"
   password: ""
   private_key: "keys/baowang"
   public_key: "keys/baowang.pub"
   global_sudo: "on"
   sudo_password: "baowang2015"           
   logfile: "logs/rex.log"
   groups_file: "true,config/ip_lists.ini"
   timeout: "10"
   max_connect_retries: "8"
   parallelism: "5"
   table: "pre_host_zzb_dev"
   monitor_table: "pre_bwzzbmonitor_dev"
   rerite_info_table: "false"
   default_jsonfile: "cache/json/json.txt"
   table_string: "id,app_key,server_name,network_ip,pro_type,config_dir,pro_dir,pro_key,pro_init,local_name,is_deloy_dir"
   softdir: "softdir/"
   configuredir: "configuredir/"
   local_prodir: "remotecomdir/softdir/"
   local_confdir: "remotecomdir/configuredir/"
   temp: "temp/"
   backup_dir: "/data/backup"
   baseapp_dir: "/data/www/apps"
   download_all : "false"
   is_link :  "true"
   is_stop :  "false"
   is_start :  "true"
   download_record_log: "logs/download_record.log"
   deploy_config_table: "pre_server_detail"
   deploy_record_table: "pre_deploy_manage"
   deploy_status_table: "pre_deploy_status"
   external_status: "true"
   external_deploy_config_table: "pre_external_server_detail"
   list_all_task_status: "false"
   list_task: "check,list,run,Enter:route:deploy,Enter:route:download,Enter:route:rollback,Enter:route:service,Deploy:Db:initdb,Deploy:Core:syncpro,Common:Use:download,Common:Use:run,Common:Use:upload"
   service_start_retry: "5"
   rsync_log_stdout: "false"
#生产环境配置文件
 com:
   key_auth: "true"
   pass_auth: "false" 
   user: "baowang"
   password: ""
   private_key: "keys/baowang"
   public_key: "keys/baowang.pub"
   global_sudo: "on"
   sudo_password: "baowang2015"           
   logfile: "logs/rex.log"
   groups_file: "true,config/ip_lists.ini"
   timeout: "10"
   max_connect_retries: "8"
   parallelism: "5"
   table: "pre_host_zzb_dev"
   monitor_table: "pre_bwzzbmonitor_dev"
   rerite_info_table: "false"
   default_jsonfile: "/Users/huanggaoming/Project/RexCenter/cache/json/json.txt"
   table_string: "id,app_key,server_name,network_ip,pro_type,config_dir,pro_dir,pro_key,pro_init,local_name,is_deloy_dir"
   softdir: "/data/RexDeploy/softdir/"
   configuredir: "/data/RexDeploy/configuredir/"
   local_prodir: "/data/RexDeploy/remotecomdir/softdir/"
   local_confdir: "/data/RexDeploy/remotecomdir/configuredir/"
   temp: "/data/RexDeploy/temp/"
   backup_dir: "/data/backup"
   baseapp_dir: "/data/www/apps"
   download_all : "false"
   is_link :  "true"
   is_stop :  "false"
   is_start :  "true"
   download_record_log: "/data/RexDeploy/logs/download_record.log"
   deploy_config_table: "pre_server_detail"
   deploy_record_table: "pre_deploy_manage"
   deploy_status_table: "pre_deploy_status"
   external_status: "false"
   external_deploy_config_table: "pre_external_server_detail"
   list_all_task_status: "false"
   list_task: "check,list,run,Enter:route:deploy,Enter:route:download,Enter:route:rollback,Enter:route:service,Deploy:Db:initdb,Common:Use:download,Common:Use:run,Common:Use:upload,Deploy:Core:syncpro"
   service_start_retry: "5"
   rsync_log_stdout: "true"
```



五、自动发布原理图


六、数据库表字段约束和解释

 主机信息配置表（pre_server_detail ）核心数据表，包含应用配置文件，应用程序位置，应用关键词等等
 ```
CREATE TABLE `pre_server_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `yewu_name` varchar(255) DEFAULT NULL COMMENT '业务管理',
  `depart_name` varchar(64) DEFAULT NULL COMMENT '分区名称',
  `server_name` varchar(128) DEFAULT NULL COMMENT '服务器名称',
  `external_ip` varchar(15) DEFAULT NULL COMMENT '公网IP',
  `network_ip` varchar(15) NOT NULL COMMENT '内网IP',
  `cpu` varchar(64) DEFAULT NULL COMMENT 'CPU',
  `mem` varchar(64) DEFAULT NULL COMMENT '内存',
  `disk` varchar(64) DEFAULT NULL COMMENT '数据盘',
  `server_id` int(11) DEFAULT NULL COMMENT '服务器ID',
  `mirr_id` int(11) DEFAULT NULL COMMENT '镜像ID',
  `pro_type` varchar(164) DEFAULT '' COMMENT '应用类型',
  `config_dir` varchar(255) DEFAULT '' COMMENT '配置目录',
  `pro_dir` varchar(255) DEFAULT NULL COMMENT '工程目录',
  `log_dir` varchar(164) DEFAULT NULL COMMENT '日志路径',
  `pro_key` varchar(164) DEFAULT NULL COMMENT '进程关键词',
  `pro_init` varchar(164) DEFAULT NULL COMMENT '启动脚本',
  `pro_port` varchar(255) DEFAULT NULL COMMENT '启动端口',
  `system_type` varchar(64) DEFAULT NULL COMMENT '操作系统',
  `entrance_server` varchar(64) DEFAULT NULL COMMENT '所属主机',
  `note` varchar(128) DEFAULT NULL COMMENT '备注',
  `status` varchar(64) DEFAULT '启用' COMMENT '状态',
  `created_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_time` datetime DEFAULT NULL COMMENT '最后更新记录时间',
  `groupby` varchar(128) DEFAULT NULL COMMENT '分组名称',
  `local_name` varchar(200) DEFAULT NULL COMMENT '识别名称',
  `app_key` varchar(200) DEFAULT NULL COMMENT '应用唯一关键词',
  `is_deloy_dir` varchar(64) DEFAULT NULL COMMENT '发布目录判断',
  `container_dir` varchar(100) DEFAULT NULL COMMENT '容器目录',
  `java_versoin` varchar(64) DEFAULT NULL COMMENT 'java版本',
  `java_home` varchar(100) DEFAULT NULL COMMENT 'java的Home目录',
  `java_confirm` varchar(64) DEFAULT NULL COMMENT 'java版本确认',
  `auto_deloy` varchar(64) DEFAULT '0' COMMENT '是否加入自动发布',
  `backupdir_same_level` int(11) DEFAULT NULL COMMENT '备份目录是否和pro_dir同级',
  `deploydir_same_level` int(11) DEFAULT NULL COMMENT '发布目录是否和pro_dir同级',
  `huanjin_name` varchar(255) DEFAULT NULL COMMENT '环境管理',
  `jifang_name` varchar(255) DEFAULT NULL COMMENT '机房管理',
  `env` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `configure_file_list` text COMMENT '同步远程配置文件到待发表目录的配置组',
  `configure_file_status` int(11) DEFAULT NULL COMMENT '配置文件状态0为拷贝整个目录，1为读取configure_file_list的列表文件',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8;
 ```
发布记录（pre_deploy_manage ）发布前中后的相关统计，比如发布前应用的目录，发布的时间，启动的时间，发布是否成功等
```
CREATE TABLE `pre_deploy_manage` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `deploy_sys` varchar(64) DEFAULT NULL COMMENT '发布系统',
  `deploy_key` varchar(64) DEFAULT NULL COMMENT '发布关键词',
  `deploy_version` varchar(64) DEFAULT NULL COMMENT '发布版本',
  `deploy_people` varchar(64) DEFAULT NULL COMMENT '发布人',
  `deploy_ip` varchar(64) CHARACTER SET utf32 DEFAULT NULL COMMENT '内网IP地址',
  `deploy_content` varchar(64) DEFAULT NULL COMMENT '发布内容',
  `deloy_prodir_before` varchar(64) DEFAULT NULL COMMENT '发布前工程目录',
  `deloy_configdir_before` varchar(64) DEFAULT NULL COMMENT '发布前配置目录',
  `deloy_prodir_after` varchar(64) DEFAULT NULL COMMENT '发布后工程目录',
  `deloy_configdir_after` varchar(64) DEFAULT NULL COMMENT '发布后配置目录',
  `deloy_size` text COMMENT '发布目录大小',
  `deploy_take` varchar(64) DEFAULT NULL COMMENT '发布花费时间',
  `start_time` datetime DEFAULT NULL COMMENT '发布开始时间',
  `rsync_war_time` datetime DEFAULT NULL COMMENT '传包完成时间',
  `start_app_time` datetime DEFAULT NULL COMMENT '应用开始启动时间',
  `end_time` datetime DEFAULT NULL COMMENT '发布结束时间',
  `randomStr` varchar(128) DEFAULT NULL COMMENT '随机字符串',
  `rollRecord` int(64) DEFAULT '0' COMMENT '是否是回滚的记录',
  `rollStatus` int(64) DEFAULT '0' COMMENT '回滚状态',
  `rollbackNumber` int(64) DEFAULT '0' COMMENT '回滚次数',
  `processNumber` int(64) DEFAULT NULL COMMENT '进程数量',
  `deloy_prodir_real_before` varchar(255) DEFAULT NULL COMMENT '发布程序前的真实目录',
  `status` int(64) DEFAULT '0' COMMENT '发布状态',
  `note` varchar(128) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;
```


发布状态（pre_deploy_status ）发布的状态控制，当一个服务正在发布时，会在这个表当中添加一条记录。
```
CREATE TABLE `pre_deploy_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `deploy_sys` varchar(64) DEFAULT NULL COMMENT '发布系统',
  `deploy_key` varchar(64) DEFAULT NULL COMMENT '发布关键词',
  `deploy_version` varchar(64) DEFAULT NULL COMMENT '发布版本',
  `deploy_people` varchar(64) DEFAULT NULL COMMENT '发布人',
  `deploy_ip` varchar(64) DEFAULT NULL COMMENT '要发布的机器IP',
  `deploy_content` varchar(64) DEFAULT NULL COMMENT '发布内容',
  `deloy_prodir_before` varchar(64) DEFAULT NULL COMMENT '发布前工程目录',
  `deloy_configdir_before` varchar(64) DEFAULT NULL COMMENT '发布前配置目录',
  `deloy_prodir_after` varchar(64) DEFAULT NULL COMMENT '发布后工程目录',
  `deloy_configdir_after` varchar(64) DEFAULT NULL COMMENT '发布后配置目录',
  `deploy_take` varchar(64) DEFAULT NULL COMMENT '发布花费时间',
  `start_time` datetime DEFAULT NULL COMMENT '发布开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '发布结束时间',
  `status` int(64) DEFAULT '0' COMMENT '发布状态',
  `note` varchar(128) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
```
应用自动配置组
```
CREATE TABLE `pre_auto_configure` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `local_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '唯一关键词',
  `link_template_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '关联模版id',
  `configure_group` text COMMENT '服务器配置文件组',
  `configure_file` text COMMENT '发布机器配置文件组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
```
应用自动配置的变量表
```
CREATE TABLE `pre_auto_template_vars` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `template_vars_name` varchar(200) DEFAULT NULL COMMENT '变量名',
  `template_vars_value` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量值',
  `template_vars_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量描述',
  `env` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '应用环境',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
```
其他的几个表都有注释，可以见数据库中的注释。


针对pre_server_detail，作重点解释。
重点字段如下:
"id","app_key","server_name","network_ip","pro_type","config_dir","pro_dir","pro_key","pro_init","local_name","is_deloy_dir"

app_key: 应用发布的唯一关键词,不能有重复,不能为空,如果为空,则不会加入到自动发布的系统里面。
pro_key: 进程关键字最好选择的唯一的关键词,在关闭应用失败的时候,会通过应用关键词去KILL应用
pro_init: 启动脚本
is_deloy_dir: 发布目录判断
=>2代表工程路径和配置路径是隔离开来的,
比如:cm的工程路径为: /data/www/html 配置路径为: /data/www/ins_share
=> 1代表 工程路径和配置路径是合在一起的
比如task-dispatcher,它的工程路径为/data/www/apps/task-dispatcher,配置路径为: /data/www/apps/task-dispatcher/conf
local_name: 应用发布初始目录的名字,比如 cm3系统设置的local_name为cm,且is_deloy_dir为2,那么发布的初始目录为: 工程路径:$softdir/cm 配置路径为: $configure/cm3

