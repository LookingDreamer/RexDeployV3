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

- Centos一键安装和配置
```
# ./install/initStall.sh instalib   （一键安装依赖包）
# ./install/initStall.sh setConfig  (一键初始化配置) 
```
![输入图片说明](http://git.oschina.net/uploads/images/2016/1115/174416_b9dfecd6_119746.png "在这里输入图片标题")

- Centos系列手动安装 
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

RexDeploy-自动化系统
一、简介
RexDeploy是基于perl语言开发的一个自动化平台。
此自动化的系统是基于原生rex进行二次开发而成,这是第三个大版本了，目前放出的这个版本是终端版，web版本已在开发当中，预计12月份将会放出。
此前放出过第一个版本，详情请撮：http://git.oschina.net/lookingdreamer/RexDeploy_v1

基于名字服务的发布系统，它的功能不仅仅在于此!

目前主要功能：
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
    
二、安装
[X] Rex模块
[X] DBD::mysql
[X] Mojo::JSON 
Centos一键安装和配置

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



六、执行发布
直接上发布截图:

七.自动发布系统几大模块和功能点介绍

1、查看模块功能和帮助 rex -T
(左边是任务模块的名称,右边是解释和示例)
```
[root@VM_0_189_centos RexDeployV3]# rex -T
Tasks
 check                           检查服务器信息: rex check   --k='cm1 cm2 ../all'
 list                            获取关键词列表: rex list
 run                             批量执行命令行: rex run  --k='cm1 cm2 ../all' --cmd='ls'

 Enter:route:deploy              应用发布模块: rex  Enter:route:deploy --k='cm1 cm2 ..'
 Enter:route:download            应用下载模块: rex  Enter:route:download         --k='cm1 cm2 ../groupname/all'
 Enter:route:rollback            应用回滚模块: rex  Enter:route:rollback        --rollstatus=0 --k='cm1 cm2 ..'
                                 --rollstatus=0:回滚到上一次最近版本(默认值).
                                 --rollstatus=1:根据数据库字段rollStatus=1回滚.
 Enter:route:service             应用服务模块: rex  Enter:route:service --k='cm1 cm2 ..' --a='start/stop/restart' [--f='' --key='' --j='']

 Deploy:Db:initdb                初始化发布状态
 Deploy:Core:syncpro             同步本地(远程download)的程序和配置=>待发布目录: rex  Deploy:Core:syncpro --k='cm1 cm2 ../all'

 Common:Use:download             文件下载模块 远程->本地:rex [-H 'x.x.x.x']/[-G  jry-com] Common:Use:download --dir1='/tmp/1.txt' --dir2='/tmp/'
 Common:Use:run                  批量命令模块: rex [-H 'x.x.x.x x.x.x.x']/[-G  jry-com] run --cmd='uptime'
 Common:Use:upload               文件上传模块 本地->远程:rex [-H 'x.x.x.x']/[-G  jry-com] Common:Use:upload --dir1='/tmp/1.txt' --dir2='/tmp/'
Server Groups
 jry-zzb  172.16.0.4, 172.16.0.7, 172.16.0.32, 172.16.0.34, 172.16.0.52, 172.16.0.76, 172.16.0.109, 172.16.0.110, 172.16.0.138, 172.16.0.139, 172.16.0.143, 172.16.0.152, 172.16.0.183, 172.16.0.189, 172.16.0.190, 172.16.0.198,
          172.16.0.207, 172.16.0.244, 172.16.0.248
```
2、查看支持哪些系统的发布与操作 rex list
(app_key是唯一的,一个key代表一个系统)
```
[root@VM_0_189_centos RexDeployV3]# rex list
[2016-11-15 16:37:42] INFO - Running task list on <local>
[2016-11-15 16:37:42] INFO - Running task Deploy:Db:getlistkey on current connection
[2016-11-15 16:37:42] INFO -
[2016-11-15 16:37:42] INFO - 获取关键词如下:
 app-test cm1 cm2 ccm mini-cm edi robot app1 wf1 app2 wf2 vxplat payment dispatch1 openfire chn rule cwf dispatch2 newprocess mini-app app-nginx1 app-nginx2 23
[2016-11-15 16:37:42] INFO - All tasks successful on all hosts
```
3、发布一个或者多个系统： rex Enter:route:deploy --k='mini-cm'   或 rex Enter:route:deploy --k='app-test cm1 cm2 ccm mini-cm edi robot app1 wf1 app2 wf2 vxplat payment'
(以空格为间隔)
```
[root@VM_0_189_centos RexDeployV3]# rex  Enter:route:deploy  --k='mini-cm'
[2016-11-15 16:22:26] INFO - Running task Enter:route:deploy on <local>
[2016-11-15 16:22:26] INFO - Running task Deploy:Db:getallkey on current connection
[2016-11-15 16:22:26] INFO - Starting ...... 操作人: baowang
[2016-11-15 16:22:26] INFO -
[2016-11-15 16:22:26] INFO - 开始应用发布模块.
[2016-11-15 16:22:26] INFO - 并发控制:(0 - 1)
[2016-11-15 16:22:27] INFO - 父进程PID:9933 子进程PID:9944
[2016-11-15 16:22:27] INFO - 执行子进程,进程序号:0
[2016-11-15 16:22:27] INFO -
[2016-11-15 16:22:27] INFO - ##############(mini-cm)###############
[2016-11-15 16:22:27] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 16:22:27] INFO - 开始从数据库初始化数据...
[2016-11-15 16:22:27] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 16:22:27] INFO - (mini-cm)--获取到该服务器: id:9,app_key:mini-cm,其他信息请见数据库.
[2016-11-15 16:22:27] INFO - (mini-cm)--数据库初始化数据完成...
[2016-11-15 16:22:27] INFO - (mini-cm)--Get配置-1:id:9,app_key:mini-cm,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.190
[2016-11-15 16:22:27] INFO - (mini-cm)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-mini-cm119
[2016-11-15 16:22:27] INFO - ##############[uat-mini-cm119]###############
[2016-11-15 16:22:27] INFO - Running task Deploy:Db:getDeployStatus on current connection
[2016-11-15 16:22:27] INFO - (mini-cm)--开始获取&更新发布状态.
[2016-11-15 16:22:27] INFO - (mini-cm)--获取&更新发布状态完成.
[2016-11-15 16:22:27] INFO - Running task Deploy:Core:prepare on current connection
[2016-11-15 16:22:27] INFO - (mini-cm)--第一次连接,获取远程服务器基本信息.
[2016-11-15 16:22:28] INFO - (mini-cm)--启动文件: /etc/init.d/tomcat:存在OK
[2016-11-15 16:22:28] INFO - (mini-cm)--工程目录: /data/www/cm:存在OK
[2016-11-15 16:22:28] INFO - (mini-cm)--配置目录: /data/www/ins_share:存在OK
[2016-11-15 16:22:28] INFO - (mini-cm)--系统进程存在:2.
[2016-11-15 16:22:28] INFO - (mini-cm)--第一次连接,初始化服务器信息完成.
[2016-11-15 16:22:28] INFO - Running task Deploy:Core:uploading on current connection
[2016-11-15 16:22:31] INFO - (mini-cm)--创建临时目录/data/tmp/xmeqiaby_rex_20161115_162226.
[2016-11-15 16:22:33] INFO - (mini-cm)--创建临时程序目录/data/tmp/xmeqiaby_rex_20161115_162226/program 和配置目录/data/tmp/xmeqiaby_rex_20161115_162226/configdir.
[2016-11-15 16:22:33] INFO - (mini-cm)--开始传输程序和配置目录.
[2016-11-15 16:22:33] INFO - syncing softdir/cm/ => /data/www/cm_20161115_162226 &  syncing configuredir/cm/mini-cm/ => /data/www/ins_share_20161115_162226
[2016-11-15 16:22:34] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --exclude=*.sw* --exclude=*.tmp --backup --delete --progress softdir/cm/  baowang@172.16.0.190:/data/www/cm_20161115_162226 --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 16:22:36] INFO - [文件传输] rsync返回码为真,文件传输成功
[2016-11-15 16:22:36] INFO - [文件传输] 传输完成,耗时: 2秒,大小:112M    /data/www/cm_20161115_162226
[2016-11-15 16:22:37] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --exclude=*.sw* --exclude=*.tmp --backup --delete --progress configuredir/cm/mini-cm/  baowang@172.16.0.190:/data/tmp/xmeqiaby_rex_20161115_162226/configdir --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 16:22:37] INFO - [文件传输] rsync返回码为真,文件传输成功
[2016-11-15 16:22:38] INFO - [文件传输] 传输完成,耗时: 0秒,大小:240K    /data/tmp/xmeqiaby_rex_20161115_162226/configdir
[2016-11-15 16:22:40] INFO - (mini-cm)--传输程序和配置目录完成. mv /data/tmp/xmeqiaby_rex_20161115_162226/program /data/www/cm_20161115_162226; mv /data/tmp/xmeqiaby_rex_20161115_162226/configdir /data/www/ins_share_20161115_162226
[2016-11-15 16:22:40] INFO - (mini-cm)--删除临时目录/data/tmp/xmeqiaby_rex_20161115_162226.
[2016-11-15 16:22:40] INFO - Running task Deploy:Db:updateTimes on current connection
[2016-11-15 16:22:40] INFO - [SQL:更新传包时间]update pre_deploy_manage set rsync_war_time='2016-11-15 16:22:40' where  randomStr = '1479198147316405653' .
[2016-11-15 16:22:43] INFO - Running task Deploy:Db:updateTimes on current connection
[2016-11-15 16:22:43] INFO - [SQL:更新前的程序软连接]update pre_deploy_manage set deloy_prodir_before='/data/www/cm_20161115_000654',deloy_configdir_before = '/data/www/ins_share_20161115_000654' where  randomStr = '1479198147316405653' .
[2016-11-15 16:22:43] INFO - (mini-cm)--发布前软链接详情: /data/www/cm -> /data/www/cm_20161115_000654 || /data/www/ins_share -> /data/www/ins_share_20161115_000654
[2016-11-15 16:22:43] INFO - (mini-cm)--进程数为2,开始关闭应用->更改程序配置软链接->启动.
[2016-11-15 16:22:45] INFO - (mini-cm)--进程数为0,关闭成功.
[2016-11-15 16:22:47] INFO - Running task Deploy:Db:updateTimes on current connection
[2016-11-15 16:22:47] INFO - [SQL:更新后的程序软连接]update pre_deploy_manage set deloy_prodir_after='/data/www/cm_20161115_162226',deloy_configdir_after ='/data/www/ins_share_20161115_162226',deloy_size='112M /data/www/cm_20161115_162226 240K /data/www/ins_share_20161115_162226' where  randomStr = '1479198147316405653' .
[2016-11-15 16:22:47] INFO - (mini-cm)--进程数为0,发布后软链接详情: /data/www/cm -> /data/www/cm_20161115_162226 || /data/www/ins_share -> /data/www/ins_share_20161115_162226
[2016-11-15 16:22:47] INFO - (mini-cm)--进程数为0,更改程序&配置软链接&更改权限完成.
[2016-11-15 16:22:47] INFO - (mini-cm)--进程数为0,开始启动应用.
[2016-11-15 16:22:47] INFO - Running task Deploy:Db:updateTimes on current connection
[2016-11-15 16:22:47] INFO - [SQL:更新APP启动时间]update pre_deploy_manage set app_start_time = '2016-11-15 16:22:47' where  randomStr = '1479198147316405653' .
[2016-11-15 16:22:49] INFO - cmd(1): source /etc/profile ;  nohup /bin/bash /etc/init.d/tomcat start  & > /dev/null
[2016-11-15 16:22:49] INFO - 应用启动成功.
[2016-11-15 16:22:49] INFO - Running task Deploy:Db:updateTimes on current connection
[2016-11-15 16:22:49] INFO - [SQL:更新完成时间和进程数量和状态]update pre_deploy_manage set end_time='2016-11-15 16:22:49',processNumber='2',status=0 where  randomStr = '1479198147316405653' .
[2016-11-15 16:22:49] INFO - (mini-cm)--进程数为2,启动成功.
[2016-11-15 16:22:49] INFO - Running task Deploy:Db:updateTimes on current connection
[2016-11-15 16:22:49] INFO - [SQL:更新完成状态]uupdate pre_deploy_status set status=0 where  deploy_key = 'mini-cm' .
[2016-11-15 16:22:49] INFO - [SQL:查询各个流程中的时间] select start_time,rsync_war_time,start_app_time,end_time from pre_deploy_manage  where  randomStr = '1479198147316405653'.
[2016-11-15 16:22:50] INFO - [SQL:更新总花费时间]update pre_deploy_manage set deploy_take = 'Total Take:22 || Rsync Time:13 || Start App Time:2' where  randomStr = '1479198147316405653' .
[2016-11-15 16:22:50] INFO - Exiting Rex...
[2016-11-15 16:22:50] INFO - Cleaning up...
[2016-11-15 16:22:51] INFO - 应用发布模块完成.
[2016-11-15 16:22:51] INFO - 总共花费时间:25秒.
[2016-11-15 16:22:51] INFO - Exiting Rex...
[2016-11-15 16:22:51] INFO - Cleaning up...
```

4、下载远程服务器数据(程序和配置)到本地: rex Enter:route:download --k='app-test cm1 cm2 ccm mini-cm edi robot app1 wf1 app2 wf2 vxplat payment dispatch1'
（如果你要下载所有关键词的系统到本地请使用: rex download --k='all'）
```
[root@VM_0_189_centos RexDeployV3]# rex Enter:route:download --k='cm1 cm2'         
[2016-11-15 16:51:04] INFO - Running task Enter:route:download on <local>
[2016-11-15 16:51:04] INFO - Running task Deploy:Db:getallkey on current connection
[2016-11-15 16:51:04] INFO - Running task Deploy:Db:ilocalname on current connection
[2016-11-15 16:51:04] INFO - Starting ...... 操作人: baowang
[2016-11-15 16:51:04] INFO -
[2016-11-15 16:51:04] INFO - 开始下载远程服务器数据到本地.
[2016-11-15 16:51:04] INFO - 并发控制:(0 - 2)
[2016-11-15 16:51:04] INFO - 父进程PID:15058 子进程PID:15069
[2016-11-15 16:51:04] INFO - 执行子进程,进程序号:0
[2016-11-15 16:51:04] INFO -
[2016-11-15 16:51:04] INFO - ##############(cm1)###############
[2016-11-15 16:51:04] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 16:51:04] INFO - 开始从数据库初始化数据...
[2016-11-15 16:51:04] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 16:51:04] INFO - (cm1)--获取到该服务器: id:6,app_key:cm1,其他信息请见数据库.
[2016-11-15 16:51:04] INFO - (cm1)--数据库初始化数据完成...
[2016-11-15 16:51:04] INFO - (cm1)--Get配置-1:id:6,app_key:cm1,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.76
[2016-11-15 16:51:04] INFO - (cm1)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-cm58
[2016-11-15 16:51:04] INFO - ##############[uat-cm58]###############
[2016-11-15 16:51:04] INFO - Running task Deploy:Core:prepare on current connection
[2016-11-15 16:51:04] INFO - (cm1)--第一次连接,获取远程服务器基本信息.
[2016-11-15 16:51:04] INFO - 父进程PID:15058 子进程PID:15080
[2016-11-15 16:51:04] INFO - 执行子进程,进程序号:1
[2016-11-15 16:51:04] INFO -
[2016-11-15 16:51:04] INFO - ##############(cm2)###############
[2016-11-15 16:51:04] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 16:51:04] INFO - 开始从数据库初始化数据...
[2016-11-15 16:51:04] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 16:51:04] INFO - (cm2)--获取到该服务器: id:7,app_key:cm2,其他信息请见数据库.
[2016-11-15 16:51:04] INFO - (cm2)--数据库初始化数据完成...
[2016-11-15 16:51:04] INFO - (cm2)--Get配置-1:id:7,app_key:cm2,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.248
[2016-11-15 16:51:04] INFO - (cm2)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-cm206
[2016-11-15 16:51:04] INFO - ##############[uat-cm206]###############
[2016-11-15 16:51:04] INFO - Running task Deploy:Core:prepare on current connection
[2016-11-15 16:51:04] INFO - (cm2)--第一次连接,获取远程服务器基本信息.
[2016-11-15 16:51:06] INFO - (cm1)--启动文件: /etc/init.d/tomcat:存在OK
[2016-11-15 16:51:06] INFO - (cm1)--工程目录: /data/www/cm:存在OK
[2016-11-15 16:51:06] INFO - (cm1)--配置目录: /data/www/ins_share:存在OK
[2016-11-15 16:51:06] INFO - (cm1)--系统进程存在:2.
[2016-11-15 16:51:06] INFO - (cm1)--第一次连接,初始化服务器信息完成.
[2016-11-15 16:51:06] INFO - Running task Deploy:Core:downloading on current connection
[2016-11-15 16:51:06] INFO - (cm1)--开始传输程序和配置目录到本地.
[2016-11-15 16:51:06] INFO - (cm2)--启动文件: /etc/init.d/tomcat:存在OK
[2016-11-15 16:51:06] INFO - (cm2)--工程目录: /data/www/cm:存在OK
[2016-11-15 16:51:06] INFO - (cm2)--配置目录: /data/www/ins_share:存在OK
[2016-11-15 16:51:06] INFO - (cm2)--系统进程存在:2.
[2016-11-15 16:51:06] INFO - (cm2)--第一次连接,初始化服务器信息完成.
[2016-11-15 16:51:06] INFO - Running task Deploy:Core:downloading on current connection
[2016-11-15 16:51:06] INFO - (cm2)--开始传输程序和配置目录到本地.
[2016-11-15 16:51:07] INFO - [文件传输] sudo tty终端已经关闭.
[2016-11-15 16:51:07] INFO - [文件传输] [172.16.0.76]  /data/www/cm/-->remotecomdir/softdir/cm1/大小: 112M .
[2016-11-15 16:51:07] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --backup --progress  baowang@172.16.0.76:/data/www/cm/ remotecomdir/softdir/cm1/ --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 16:51:07] INFO - [文件传输] sudo tty终端已经关闭.
[2016-11-15 16:51:07] INFO - [文件传输] rsync返回码为真,文件传输成功

[2016-11-15 16:51:07] INFO - [文件传输] 传输完成,耗时: 0秒
[2016-11-15 16:51:07] INFO - [文件传输] [172.16.0.248]  /data/www/cm/-->remotecomdir/softdir/cm2/大小: 112M .
[2016-11-15 16:51:07] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --backup --progress  baowang@172.16.0.248:/data/www/cm/ remotecomdir/softdir/cm2/ --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 16:51:08] INFO - [文件传输] rsync返回码为真,文件传输成功

[2016-11-15 16:51:08] INFO - [文件传输] 传输完成,耗时: 1秒
[2016-11-15 16:51:09] INFO - [文件传输] sudo tty终端已经关闭.
[2016-11-15 16:51:09] INFO - [文件传输] sudo tty终端已经关闭.
[2016-11-15 16:51:09] INFO - [文件传输] [172.16.0.76]  /data/www/ins_share/-->remotecomdir/configuredir/cm1/大小: 240K .
[2016-11-15 16:51:09] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --backup --progress  baowang@172.16.0.76:/data/www/ins_share/ remotecomdir/configuredir/cm1/ --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 16:51:09] INFO - [文件传输] rsync返回码为真,文件传输成功

[2016-11-15 16:51:09] INFO - [文件传输] 传输完成,耗时: 0秒
[2016-11-15 16:51:09] INFO - [文件传输] [172.16.0.248]  /data/www/ins_share/-->remotecomdir/configuredir/cm2/大小: 228K .
[2016-11-15 16:51:09] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --backup --progress  baowang@172.16.0.248:/data/www/ins_share/ remotecomdir/configuredir/cm2/ --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 16:51:09] INFO - (cm1)--传输程序和配置目录到本地完成:remotecomdir/softdir/cm1/:112M || remotecomdir/configuredir/cm1/:240K
[2016-11-15 16:51:09] INFO - (cm1)--更新下载记录到日志:logs/download_record.log完成.
[2016-11-15 16:51:09] INFO - Exiting Rex...
[2016-11-15 16:51:09] INFO - Cleaning up...
[2016-11-15 16:51:09] INFO - [文件传输] rsync返回码为真,文件传输成功

[2016-11-15 16:51:09] INFO - [文件传输] 传输完成,耗时: 0秒
[2016-11-15 16:51:09] INFO - (cm2)--传输程序和配置目录到本地完成:remotecomdir/softdir/cm2/:112M || remotecomdir/configuredir/cm2/:228K
[2016-11-15 16:51:09] INFO - (cm2)--更新下载记录到日志:logs/download_record.log完成.
[2016-11-15 16:51:09] INFO - Exiting Rex...
[2016-11-15 16:51:09] INFO - Cleaning up...
[2016-11-15 16:51:09] INFO - 执行下载模板完成.
[2016-11-15 16:51:09] INFO - 总共花费时间:5秒.
[2016-11-15 16:51:09] INFO - Exiting Rex...
[2016-11-15 16:51:09] INFO - Cleaning up...
```
5、 同步本地(远程download)的程序和配置=>待发布目录  rex Deploy:Core:syncpro --k='cm1 cm2'
执行上面的时候,自动将所有待发布的目录清空,然后将下载目录的程序同步待发布的目录中,同时也会根据数据中的涉及的配置修改作配置归一。
```
[root@VM_0_189_centos RexDeployV3]# rex Deploy:Core:syncpro --k='cm1 cm2'
[2016-11-15 16:52:59] INFO - Running task Deploy:Core:syncpro on <local>
[2016-11-15 16:52:59] INFO - 开启同步(cm1)目录到待发布目录.
[2016-11-15 16:52:59] INFO - 删除发布程序目录完成: rmdir softdir//cm.
[2016-11-15 16:52:59] INFO - mv程序目录完成: mv(remotecomdir/softdir//cm1,softdir//cm).
[2016-11-15 16:52:59] INFO - mv配置目录完成: mv(remotecomdir/configuredir//cm1,configuredir//cm/cm1).
[2016-11-15 16:52:59] INFO - 同步(cm1)目录到待发布目录完成.
[2016-11-15 16:52:59] INFO - 开启同步(cm2)目录到待发布目录.
[2016-11-15 16:52:59] INFO - 删除发布程序目录完成: rmdir softdir//cm.
[2016-11-15 16:52:59] INFO - mv程序目录完成: mv(remotecomdir/softdir//cm2,softdir//cm).
[2016-11-15 16:52:59] INFO - mv配置目录完成: mv(remotecomdir/configuredir//cm2,configuredir//cm/cm2).
[2016-11-15 16:52:59] INFO - 同步(cm2)目录到待发布目录完成.
[2016-11-15 16:53:00] INFO - All tasks successful on all hosts
```
6、检查数据库以及远程服务器的配置 rex check --k='cm1 cm2'
(就是核对数据库中关于各个配置是否正确,比如远程服务器的工程目录/配置目录/启动脚本/进程等是否存在)
(检查所有远程服务器的信息: rex check --k='all' )
```
[root@VM_0_189_centos RexDeployV3]# rex check --k='cm1 cm2'
[2016-11-15 16:54:54] INFO - Running task check on <local>
[2016-11-15 16:54:54] INFO - Running task Deploy:Db:getallkey on current connection
[2016-11-15 16:54:54] INFO - Starting ...... 操作人: baowang
[2016-11-15 16:54:54] INFO -
[2016-11-15 16:54:54] INFO - 开始检查 发布系统 服务器以及数据库配置.
[2016-11-15 16:54:54] INFO -
[2016-11-15 16:54:54] INFO - ##############(cm1)###############
[2016-11-15 16:54:54] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 16:54:54] INFO - 开始从数据库初始化数据...
[2016-11-15 16:54:54] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 16:54:54] INFO - (cm1)--获取到该服务器: id:6,app_key:cm1,其他信息请见数据库.
[2016-11-15 16:54:54] INFO - (cm1)--数据库初始化数据完成...
[2016-11-15 16:54:54] INFO - (cm1)--Get配置-1:id:6,app_key:cm1,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.76
[2016-11-15 16:54:54] INFO - (cm1)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-cm58
[2016-11-15 16:54:54] INFO - ##############[uat-cm58]###############
[2016-11-15 16:54:54] INFO - Running task Deploy:Core:prepare on current connection
[2016-11-15 16:54:54] INFO - (cm1)--第一次连接,获取远程服务器基本信息.
[2016-11-15 16:54:56] INFO - (cm1)--启动文件: /etc/init.d/tomcat:存在OK
[2016-11-15 16:54:56] INFO - (cm1)--工程目录: /data/www/cm:存在OK
[2016-11-15 16:54:56] INFO - (cm1)--配置目录: /data/www/ins_share:存在OK
[2016-11-15 16:54:56] INFO - (cm1)--系统进程存在:2.
[2016-11-15 16:54:56] INFO - (cm1)--第一次连接,初始化服务器信息完成.
[2016-11-15 16:54:56] INFO -
[2016-11-15 16:54:56] INFO - ##############(cm2)###############
[2016-11-15 16:54:56] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 16:54:56] INFO - 开始从数据库初始化数据...
[2016-11-15 16:54:56] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 16:54:56] INFO - (cm2)--获取到该服务器: id:7,app_key:cm2,其他信息请见数据库.
[2016-11-15 16:54:56] INFO - (cm2)--数据库初始化数据完成...
[2016-11-15 16:54:56] INFO - (cm2)--Get配置-1:id:7,app_key:cm2,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.248
[2016-11-15 16:54:56] INFO - (cm2)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-cm206
[2016-11-15 16:54:56] INFO - ##############[uat-cm206]###############
[2016-11-15 16:54:56] INFO - Running task Deploy:Core:prepare on current connection
[2016-11-15 16:54:56] INFO - (cm2)--第一次连接,获取远程服务器基本信息.
[2016-11-15 16:54:58] INFO - (cm2)--启动文件: /etc/init.d/tomcat:存在OK
[2016-11-15 16:54:58] INFO - (cm2)--工程目录: /data/www/cm:存在OK
[2016-11-15 16:54:58] INFO - (cm2)--配置目录: /data/www/ins_share:存在OK
[2016-11-15 16:54:58] INFO - (cm2)--系统进程存在:2.
[2016-11-15 16:54:58] INFO - (cm2)--第一次连接,初始化服务器信息完成.
[2016-11-15 16:54:58] INFO - 检查 发布系统 服务器以及数据库配置完成.
[2016-11-15 16:54:58] INFO - All tasks successful on all hosts
```

7、批量执行命令 rex run --k='cm1 cm2 ' --cmd='uptime'
(如查看系统的时间: rex run --k='all' --cmd='date')
```
[root@VM_0_189_centos RexDeployV3]# rex run --k='cm1 cm2 ' --cmd='uptime'
[2016-11-15 17:13:10] INFO - Running task run on <local>
[2016-11-15 17:13:10] INFO - Starting ...... 操作人: baowang
[2016-11-15 17:13:10] INFO - Running task Deploy:Db:getallkey on current connection
[2016-11-15 17:13:10] INFO -
[2016-11-15 17:13:10] INFO - 开始执行命令模板.
[2016-11-15 17:13:10] INFO - 并发控制:(0 - 2)
[2016-11-15 17:13:10] INFO - 父进程PID:17620 子进程PID:17631
[2016-11-15 17:13:10] INFO - 执行子进程,进程序号:0
[2016-11-15 17:13:10] INFO -
[2016-11-15 17:13:10] INFO - ##############(cm1)###############
[2016-11-15 17:13:10] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 17:13:10] INFO - 开始从数据库初始化数据...
[2016-11-15 17:13:10] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 17:13:10] INFO - (cm1)--获取到该服务器: id:6,app_key:cm1,其他信息请见数据库.
[2016-11-15 17:13:10] INFO - (cm1)--数据库初始化数据完成...
[2016-11-15 17:13:10] INFO - (cm1)--Get配置-1:id:6,app_key:cm1,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.76
[2016-11-15 17:13:10] INFO - (cm1)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-cm58
[2016-11-15 17:13:10] INFO - ##############[uat-cm58]###############
[2016-11-15 17:13:10] INFO - 父进程PID:17620 子进程PID:17642
[2016-11-15 17:13:10] INFO - 执行子进程,进程序号:1
[2016-11-15 17:13:10] INFO -
[2016-11-15 17:13:10] INFO - ##############(cm2)###############
[2016-11-15 17:13:10] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 17:13:10] INFO - 开始从数据库初始化数据...
[2016-11-15 17:13:10] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 17:13:10] INFO - (cm2)--获取到该服务器: id:7,app_key:cm2,其他信息请见数据库.
[2016-11-15 17:13:10] INFO - (cm2)--数据库初始化数据完成...
[2016-11-15 17:13:10] INFO - (cm2)--Get配置-1:id:7,app_key:cm2,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.248
[2016-11-15 17:13:10] INFO - (cm2)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-cm206
[2016-11-15 17:13:10] INFO - ##############[uat-cm206]###############
[2016-11-15 17:13:11] INFO - Running task Deploy:Db:showname on current connection
[172.16.0.76]-[uat-cm58]  17:13:11 up 88 days,  3:23,  1 user,  load average: 0.12, 0.20, 0.17

[2016-11-15 17:13:11] INFO - Exiting Rex...
[2016-11-15 17:13:11] INFO - Cleaning up...
[2016-11-15 17:13:11] INFO - Running task Deploy:Db:showname on current connection
[172.16.0.248]-[uat-cm206]  17:13:11 up 88 days,  3:21,  1 user,  load average: 0.18, 0.19, 0.15

[2016-11-15 17:13:11] INFO - Exiting Rex...
[2016-11-15 17:13:11] INFO - Cleaning up...
[2016-11-15 17:13:11] INFO - 执行命令模板完成.
[2016-11-15 17:13:11] INFO - 总共花费时间:1秒.
[2016-11-15 17:13:11] INFO - Exiting Rex...
[2016-11-15 17:13:11] INFO - Cleaning up...
```
8、重启应用 rex  Enter:route:service --k='mini-cm' --a='start/stop/restart'
重启多个--k='cm1 cm2' （空格为间隔）
```
[root@VM_0_189_centos RexDeployV3]# rex  Enter:route:service --k='mini-cm' --a='restart'
[2016-11-15 17:22:42] INFO - Running task Enter:route:service on <local>
[2016-11-15 17:22:42] INFO - Running task Deploy:Db:getallkey on current connection
[2016-11-15 17:22:42] INFO -
[2016-11-15 17:22:42] INFO - 开始应用服务控制模块.
[2016-11-15 17:22:42] INFO -
[2016-11-15 17:22:42] INFO - ##############(mini-cm)###############
[2016-11-15 17:22:42] INFO - Running task Deploy:Core:init on current connection
[2016-11-15 17:22:42] INFO - 开始从数据库初始化数据...
[2016-11-15 17:22:42] INFO - 读取数据库表数据:pre_server_detail
[2016-11-15 17:22:42] INFO - (mini-cm)--获取到该服务器: id:9,app_key:mini-cm,其他信息请见数据库.
[2016-11-15 17:22:42] INFO - (mini-cm)--数据库初始化数据完成...
[2016-11-15 17:22:42] INFO - (mini-cm)--Get配置-1:id:9,app_key:mini-cm,pro_init:/etc/init.d/tomcat,pro_type:tomcat,network_ip:172.16.0.190
[2016-11-15 17:22:42] INFO - (mini-cm)--Get配置-2:pro_key:tomcat-cm,pro_dir:/data/www/cm,config_dir:/data/www/ins_share,server_name:uat-mini-cm119
[2016-11-15 17:22:42] INFO - ##############[uat-mini-cm119]###############
[2016-11-15 17:22:44] INFO - 应用关闭成功.
[2016-11-15 17:22:45] INFO - cmd(1): source /etc/profile ;  nohup /bin/bash /etc/init.d/tomcat start  & > /dev/null
[2016-11-15 17:22:46] INFO - cmd(2): source /etc/profile ;  nohup /bin/bash /etc/init.d/tomcat start  & > /dev/null
[2016-11-15 17:22:46] INFO - 应用启动成功.
[2016-11-15 17:22:46] INFO - 应用服务控制模块完成.
[2016-11-15 17:22:46] INFO - All tasks successful on all hosts
```
9、 rex   Deploy:Db:initdb 初始化发布状态
   当你正在发布,不小心按了取消，那个这个应用一直在处于发布状态(状态存储在数据库中)，这时候需要在重新重置一下发布状态。
```
[root@VM_0_189_centos RexDeployV3]# rex Deploy:Db:initdb
[2016-11-15 17:26:14] INFO - Running task Deploy:Db:initdb on <local>
[2016-11-15 17:26:14] INFO - 初始化发布状态完成.
[2016-11-15 17:26:14] INFO - All tasks successful on all hosts
```
10、针对个别IP或者IP组或者分组名--下载文件 rex [-H 'x.x.x.x x.x.x.x.x'] Common:Use:download --dir1='/tmp/1.txt' --dir2='/tmp/'
```
[root@VM_0_189_centos RexDeployV3]# rex -H '172.16.0.101'   Common:Use:download  --dir1='/data/www/ins_share/cm/config'  --dir2='/tmp'
[2016-11-15 17:34:09] INFO - Running task Common:Use:download on 172.16.0.101
[2016-11-15 17:34:10] INFO - [文件传输] sudo tty终端已经关闭.
[2016-11-15 17:34:10] INFO - [文件传输] [172.16.0.101]  /data/www/ins_share/cm/config-->/tmp大小: 220K .
[2016-11-15 17:34:10] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --backup --progress  baowang@172.16.0.101:/data/www/ins_share/cm/config /tmp --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 17:34:11] INFO - [文件传输] rsync返回码为真,文件传输成功

[2016-11-15 17:34:11] INFO - [文件传输] 传输完成,耗时: 1秒
[2016-11-15 17:34:11] INFO - All tasks successful on all hosts
```
11、针对个别IP或者IP组或者分组名--上传文件 rex [-H 'x.x.x.x x.x.x.x.x']/[-G  jry-com] Common:Use:download --dir1='/tmp/1.txt' --dir2='/tmp/'
```
[root@VM_0_189_centos RexDeployV3]# rex -H '172.16.0.101'   Common:Use:upload  --dir1='/tmp/config'  --dir2='/tmp'                                                                                                                          [2016-11-15 17:38:32] INFO - Running task Common:Use:upload on 172.16.0.101
[2016-11-15 17:38:33] INFO - [文件传输] cmd: rsync -a -e 'ssh  -i keys/baowang -o StrictHostKeyChecking=no ' --verbose --stats  --exclude=*.sw* --exclude=*.tmp --backup --delete --progress /tmp/config  baowang@172.16.0.101:/tmp --rsync-path='sudo rsync'; echo return_result$?
[2016-11-15 17:38:33] INFO - [文件传输] rsync返回码为真,文件传输成功
[2016-11-15 17:38:33] INFO - [文件传输] 传输完成,耗时: 0秒,大小:296K    /tmp
[2016-11-15 17:38:34] INFO - All tasks successful on all hosts
```

12、针对个别IP或者IP组或者分组名--执行命令 rex [-H 'x.x.x.x x.x.x.x.x']/[-G  jry-com] Common:Use:download --dir1='/tmp/1.txt' --dir2='/tmp/'
```
[root@VM_0_189_centos RexDeployV3]# rex -H '172.16.0.42'   Common:Use:run --cmd='free -h'
[2016-11-15 17:39:48] INFO - Running task Common:Use:run on 172.16.0.42
[2016-11-15 17:39:49] INFO - Running task Deploy:Db:showname on current connection
[172.16.0.42]               total        used        free      shared  buff/cache   available
Mem:           7.6G        506M        2.0G         12M        5.2G        6.9G
Swap:          2.0G          0B        2.0G

[2016-11-15 17:39:49] INFO - All tasks successful on all hosts
```

问题
1.version libmysqlclient_18 not defined报错
# rex -T
/usr/bin/perl: relocation error: /usr/local/lib64/perl5/auto/DBD/mysql/mysql.so: symbol mysql_options4, version libmysqlclient_18 not defined in file libmysqlclient.so.18 with link time reference
解决方法:
rpm -e --nodeps `rpm -qa | egrep -i "percona|mysql|maria"`











