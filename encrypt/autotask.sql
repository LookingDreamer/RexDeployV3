/*
Navicat MySQL Data Transfer

Source Server         : 203.195.138.240大数据)
Source Server Version : 50511
Source Host           : 203.195.138.240:3306
Source Database       : autotask

Target Server Type    : MYSQL
Target Server Version : 50511
File Encoding         : 65001

Date: 2016-11-12 17:48:37
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for pre_auto_configure
-- ----------------------------
DROP TABLE IF EXISTS `pre_auto_configure`;
CREATE TABLE `pre_auto_configure` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `local_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '唯一关键词',
  `link_template_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '关联模版id',
  `configure_group` text COMMENT '服务器配置文件组',
  `configure_file` text COMMENT '发布机器配置文件组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_auto_configure
-- ----------------------------
INSERT INTO `pre_auto_configure` VALUES ('1', 'cm1', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,2930,31,32,33,34,35,36,37,38,39,40,41', '/data/www/ins_share/cm/config/akka.conf,/data/www/ins_share/cm/config/config.properties', '/data/RexDeploy/configuredir/cm/cm-test/cm/config/akka.conf,/data/RexDeploy/configuredir/cm/cm-test/cm/config/config.properties');
INSERT INTO `pre_auto_configure` VALUES ('2', 'edi', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,2930,31,32,33,34,35,36,37,38,39,40,41', '/data/www/ins_share/edi/config/db.properties,/data/www/ins_share/edi/config/deploy.properties', '/data/RexDeploy/configuredir/edi/edi/edi/config/db.properties,/data/RexDeploy/configuredir/edi/edi/edi/config/deploy.properties');
INSERT INTO `pre_auto_configure` VALUES ('3', 'robot', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,2930,31,32,33,34,35,36,37,38,39,40,41', '/data/www/ins_share/rb/config/akka.conf,/data/www/ins_share/rb/config/datasource.properties,/data/www/ins_share/rb/config/data.properties', '/data/RexDeploy/configuredir/rb/rb/config/akka.conf,/data/RexDeploy/configuredir/rb/rb/config/datasource.properties,/data/RexDeploy/configuredir/rb/rb/config/data.properties');
INSERT INTO `pre_auto_configure` VALUES ('4', 'app', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,2930,31,32,33,34,35,36,37,38,39,40,41', '/data/www/app/zhangzb/WEB-INF/class/system.properties', null);
INSERT INTO `pre_auto_configure` VALUES ('5', 'cm2', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,2930,31,32,33,34,35,36,37,38,39,40,41', '/data/www/ins_share/cm/config/akka.conf,/data/www/ins_share/cm/config/config.properties', '/data/RexDeploy/configuredir/cm/cm2/cm/config/akka.conf,/data/RexDeploy/configuredir/cm/cm2/cm/config/config.properties');

-- ----------------------------
-- Table structure for pre_auto_template_vars
-- ----------------------------
DROP TABLE IF EXISTS `pre_auto_template_vars`;
CREATE TABLE `pre_auto_template_vars` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `template_vars_name` varchar(200) DEFAULT NULL COMMENT '变量名',
  `template_vars_value` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量值',
  `template_vars_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量描述',
  `env` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '应用环境',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_auto_template_vars
-- ----------------------------
INSERT INTO `pre_auto_template_vars` VALUES ('1', 'redis_server', '172.16.0.172', 'redis的服务器地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('2', 'akka_server', '127.0.0.1', '本机的内网地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('3', 'cif_server', '172.16.3.154', 'cif的内网地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('4', 'edi_server', '172.16.0.143', 'edi的内网地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('5', 'pay_server', '172.16.0.138', 'pay的内网地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('6', 'uploadimage_server', '115.159.237.219', '影像的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('7', 'workflow_server', '172.16.0.249', '工作流的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('8', 'robot_server', '172.16.0.183', '精灵的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('9', 'mysql_server', '172.16.0.72', 'mysql的的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('10', 'rule_server', '172.16.0.189', 'rule的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('11', 'vxplat_server', '172.16.0.138', '微信后台的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('12', 'ocr_server', '115.159.235.75', 'ocr的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('13', 'localhost_server', '127.0.0.1', '本地公网地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('14', 'dispatch_server', '172.16.0.197', '调度内网的地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('15', 'isEnablePressureTest', 'true', '压测模式', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('16', 'edi_system.ip', '10.0.0.7', 'edi公网ip', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('17', 'isInsuredOrg', 'true', 'robot压测模式', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('18', 'chn_server', '172.16.0.34', 'chn内网地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('19', 'cm_server', '172.16.0.124', 'cm内网地址', 'test');
INSERT INTO `pre_auto_template_vars` VALUES ('20', 'cmwai_server', '115.159.234.74', 'cm外网地址', 'test');

-- ----------------------------
-- Table structure for pre_bwzzbmonitor
-- ----------------------------
DROP TABLE IF EXISTS `pre_bwzzbmonitor`;
CREATE TABLE `pre_bwzzbmonitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `app_key` varchar(100) DEFAULT NULL COMMENT '应用KEY',
  `app_cpu` varchar(100) DEFAULT NULL COMMENT 'CPU',
  `app_mem` varchar(100) DEFAULT NULL COMMENT '内存',
  `process_num` varchar(100) DEFAULT NULL COMMENT '进程数',
  `app_port` varchar(100) DEFAULT NULL COMMENT '应用端口',
  `app_status` varchar(100) DEFAULT NULL COMMENT '应用url健康',
  `app_disk` varchar(100) DEFAULT NULL COMMENT '磁盘状态',
  `app_logs` varchar(200) DEFAULT NULL COMMENT '应用日志',
  `created_time` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_time` datetime DEFAULT NULL COMMENT '更新时间',
  `status` varchar(64) DEFAULT '开启' COMMENT '使用状态',
  `note` varchar(128) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=752 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_bwzzbmonitor
-- ----------------------------

-- ----------------------------
-- Table structure for pre_deploy_manage
-- ----------------------------
DROP TABLE IF EXISTS `pre_deploy_manage`;
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

-- ----------------------------
-- Records of pre_deploy_manage
-- ----------------------------

-- ----------------------------
-- Table structure for pre_deploy_status
-- ----------------------------
DROP TABLE IF EXISTS `pre_deploy_status`;
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

-- ----------------------------
-- Records of pre_deploy_status
-- ----------------------------

-- ----------------------------
-- Table structure for pre_external_server_detail
-- ----------------------------
DROP TABLE IF EXISTS `pre_external_server_detail`;
CREATE TABLE `pre_external_server_detail` (
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
  `configure_file_list` text COMMENT '配置文件列表',
  `configure_file_status` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_external_server_detail
-- ----------------------------
INSERT INTO `pre_external_server_detail` VALUES ('52', '', '', 'cm238', '115.159.235.238', '115.159.235.238', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm3', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('53', '', '', 'cm104', '115.159.237.104', '115.159.237.104', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm4', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('54', '', '', 'cm16', '115.159.235.16', '115.159.235.16', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm5', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('55', '', '', 'cm107', '115.159.235.107', '115.159.235.107', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm6', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('56', '', '', 'cm154-common', '115.159.237.154', '115.159.237.154', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm7', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('57', '', '', 'cm14-common', '115.159.235.14', '115.159.235.14', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm8', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('58', '', '', 'app154-common', '115.159.237.154', '115.159.237.154', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app1', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, 'common/config.js,WEB-INF/classes/system.properties', '1');
INSERT INTO `pre_external_server_detail` VALUES ('59', '', '', 'app14-common', '115.159.235.14', '115.159.235.14', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app2', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('60', '', '', '渠道cm161', '115.159.235.161', '115.159.235.161', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('61', '', '', '渠道cm57', '115.159.235.57', '115.159.235.57', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('62', '', '', '新渠道流程cm202', '115.159.235.202', '115.159.235.202', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_qudao/chn/WEB-INF/classes', '/data/www/html_qudao', '/data/log/cm', 'tomcat-qudao', '/usr/local/tomcat-qudao/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'nfl-cm', 'nfl-cm', '1', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('63', '', '', 'mini-cm146', '115.159.235.146', '115.159.235.146', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('64', '', '', 'mini前端100', '115.159.235.100', '115.159.235.100', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'mini-app', 'mini-app', 'mini-app', '1', '/etc/init.d/tomcat', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('65', '', '', '渠道前端188', '115.159.235.188', '115.159.235.188', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app/zzbchannel/templates/common', '/data/www/app/zzbchannel', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'chn-app', 'chn-app', 'chn-app', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('66', '', '', '新渠道流程前端159', '115.159.237.159', '115.159.237.159', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/newprocess/WEB-INF/classes', '/data/www/newprocess', '/data/log/tomcat', 'wxtomcat-org ', '/usr/local/wxtomcat-org/bin/startup.sh', '8081', 'centos7.3', '', '', '1', null, null, 'nfl-app', 'nfl-app', 'nfl-app', '1', '/usr/local/wxtomcat-org', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('67', '', '', '工作流92', '115.159.235.92', '115.159.235.92', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf1', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('68', '', '', '工作流42', '115.159.237.42', '115.159.237.42', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf2', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('69', '', '', '工作流154-common', '115.159.237.154', '115.159.237.154', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf3', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('70', '', '', '工作流14-common', '115.159.235.14', '115.159.235.14', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf4', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('71', '', '', '渠道工作流19', '115.159.237.19', '115.159.237.19', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'chn-wf', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('72', '', '', '精灵89', '115.159.235.89', '115.159.235.89', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb1', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('73', '', '', '精灵181', '115.159.235.181', '115.159.235.181', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb2', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('74', '', '', '精灵70', '115.159.235.70', '115.159.235.70', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb3', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('75', '', '', '精灵122', '115.159.235.122', '115.159.235.122', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb4', '2', '/usr/local/tomcat-robot', '', '', '', '1', '1', '1', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('76', '', '', '精灵61', '115.159.237.61', '115.159.237.61', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb5', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('77', '', '', '精灵54', '115.159.235.54', '115.159.235.54', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb6', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('78', '', '', 'edi26', '115.159.237.26', '115.159.237.26', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi1', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('79', '', '', 'edi163', '115.159.237.163', '115.159.237.163', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/usr/local/edi-tomcat-8.0.22/bin/startup.sh', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi2', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('80', '', '', 'edi26', '115.159.235.26', '115.159.235.26', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi3', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('81', '', '', '调度179', '115.159.237.179', '115.159.237.179', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('82', '', '', '调度111', '115.159.237.111', '115.159.237.111', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('83', '', '', '规则服务器65', '115.159.237.65', '115.159.237.65', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine1', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('84', '', '', '规则服务器176', '115.159.237.176', '115.159.237.176', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine2', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('85', '', '', '微信后台135', '115.159.237.135', '115.159.237.135', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('86', '', '', '微信后台202', '115.159.237.202', '115.159.237.202', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('87', '', '', '去哪保微信后台148', '115.159.237.148', '115.159.237.148', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'qnb-vx', 'qnb-vx', 'qnb-vx', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('88', '', '', '支付平台30', '115.159.237.30', '115.159.237.30', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('89', '', '', '支付平台227', '115.159.237.227', '115.159.237.227', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('90', '', '', 'openfire211', '115.159.237.211', '115.159.237.211', '4核', '8GB', '0G', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of1', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('91', '', '', 'openfire215-common', '115.159.237.215', '115.159.237.215', '4核', '8GB', '100G(本地盘)', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of2', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('92', '', '', 'nginx_app215-common', '115.159.237.215', '115.159.237.215', '4核', '8GB', '100G(本地盘)', null, null, 'nginx', '/usr/local/nginx/conf', '/usr/local/nginx', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '80', 'centos7.3', '', '', '1', null, null, 'app-nginx', 'app-nginx', 'app-nginx', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('93', '', '', 'ocr75-common', '115.159.235.75', '115.159.235.75', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('94', '', '', 'File_S', '115.159.235.218', '115.159.235.218', '4核', '8GB', '500G(本地SSD盘)', null, null, 'nfs', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('95', '', '', 'redis', '115.159.235.237', '115.159.235.237', '8核', '24GB', '200G(本地盘)', null, null, 'db', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('96', '', '', '日志系统', '115.159.237.152', '115.159.237.152', '4核', '8GB', '100G(本地盘)', null, null, 'php', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('97', '', '', '自动化平台', '115.159.237.25', '115.159.237.25', '4核', '8GB', '100G(本地盘)', null, null, 'perl', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('99', '', '', '模板机', '115.159.237.69', '115.159.237.69', '4核', '8GB', '100G(本地盘)', null, null, '', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('100', '', '', 'cm95', '115.159.237.95', '115.159.237.95', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('101', '', '', 'cm227', '115.159.235.227', '115.159.235.227', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('103', '', '', 'cm-test', '115.159.237.152', '115.159.237.152', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm-test', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('104', '', '', 'app-test', '115.159.237.152', '115.159.237.152', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/usr/local/tomcat-app/bin/startup.sh', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-test', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, '0');
INSERT INTO `pre_external_server_detail` VALUES ('105', '', '', 'mini-cm41', '115.159.235.41', '115.159.235.41', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, '0');

-- ----------------------------
-- Table structure for pre_host_zzb
-- ----------------------------
DROP TABLE IF EXISTS `pre_host_zzb`;
CREATE TABLE `pre_host_zzb` (
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
  `env` varchar(255) DEFAULT NULL,
  `configure_file_list` text,
  `configure_file_status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_host_zzb
-- ----------------------------
INSERT INTO `pre_host_zzb` VALUES ('52', '', '', 'cm238', '115.159.235.238', '172.16.0.254', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm3', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('53', '', '', 'cm104', '115.159.237.104', '172.16.0.70', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm4', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('54', '', '', 'cm16', '115.159.235.16', '172.16.0.68', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm5', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('55', '', '', 'cm107', '115.159.235.107', '172.16.0.101', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm6', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('56', '', '', 'cm154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm7', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('57', '', '', 'cm14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm8', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('58', '', '', 'app154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app1', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('59', '', '', 'app14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app2', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('60', '', '', '渠道cm161', '115.159.235.161', '172.16.0.253', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('61', '', '', '渠道cm57', '115.159.235.57', '172.16.0.78', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('62', '', '', '新渠道流程cm202', '115.159.235.202', '172.16.0.219', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_qudao/chn/WEB-INF/classes', '/data/www/html_qudao', '/data/log/cm', 'tomcat-qudao', '/usr/local/tomcat-qudao/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'nfl-cm', 'nfl-cm', '1', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('63', '', '', 'mini-cm146', '115.159.235.146', '172.16.0.114', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('64', '', '', 'mini前端100', '115.159.235.100', '172.16.0.54', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'mini-app', 'mini-app', 'mini-app', '1', '/etc/init.d/tomcat', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('65', '', '', '渠道前端188', '115.159.235.188', '172.16.0.93', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app/zzbchannel/templates/common', '/data/www/app/zzbchannel', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'chn-app', 'chn-app', 'chn-app', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('66', '', '', '新渠道流程前端159', '115.159.237.159', '172.16.0.23', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/newprocess/WEB-INF/classes', '/data/www/newprocess', '/data/log/tomcat', 'wxtomcat-org ', '/usr/local/wxtomcat-org/bin/startup.sh', '8081', 'centos7.3', '', '', '1', null, null, 'nfl-app', 'nfl-app', 'nfl-app', '1', '/usr/local/wxtomcat-org', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('67', '', '', '工作流92', '115.159.235.92', '172.16.0.232', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf1', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('68', '', '', '工作流42', '115.159.237.42', '172.16.0.134', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf2', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('69', '', '', '工作流154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf3', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('70', '', '', '工作流14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf4', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('71', '', '', '渠道工作流19', '115.159.237.19', '172.16.0.103', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'chn-wf', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('72', '', '', '精灵89', '115.159.235.89', '172.16.0.146', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb1', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('73', '', '', '精灵181', '115.159.235.181', '172.16.0.43', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb2', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('74', '', '', '精灵70', '115.159.235.70', '172.16.0.81', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb3', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('75', '', '', '精灵122', '115.159.235.122', '172.16.0.206', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb4', '2', '/usr/local/tomcat-robot', '', '', '', '1', '1', '1', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('76', '', '', '精灵61', '115.159.237.61', '172.16.0.153', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb5', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('77', '', '', '精灵54', '115.159.235.54', '172.16.0.8', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb6', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('78', '', '', 'edi26', '115.159.237.26', '172.16.0.129', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi1', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('79', '', '', 'edi163', '115.159.237.163', '172.16.0.9', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/usr/local/edi-tomcat-8.0.22/bin/startup.sh', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi2', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('80', '', '', 'edi26', '115.159.235.26', '172.16.0.2', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi3', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('81', '', '', '调度179', '115.159.237.179', '172.16.0.194', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('82', '', '', '调度111', '115.159.237.111', '172.16.0.205', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('83', '', '', '规则服务器65', '115.159.237.65', '172.16.0.252', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine1', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('84', '', '', '规则服务器176', '115.159.237.176', '172.16.0.14', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine2', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('85', '', '', '微信后台135', '115.159.237.135', '172.16.0.92', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('86', '', '', '微信后台202', '115.159.237.202', '172.16.0.115', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('87', '', '', '去哪保微信后台148', '115.159.237.148', '172.16.0.10', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'qnb-vx', 'qnb-vx', 'qnb-vx', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('88', '', '', '支付平台30', '115.159.237.30', '172.16.0.120', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('89', '', '', '支付平台227', '115.159.237.227', '172.16.0.6', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('90', '', '', 'openfire211', '115.159.237.211', '172.16.0.187', '4核', '8GB', '0G', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of1', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('91', '', '', 'openfire215-common', '115.159.237.215', '172.16.0.3', '4核', '8GB', '100G(本地盘)', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of2', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('92', '', '', 'nginx_app215-common', '115.159.237.215', '172.16.0.3', '4核', '8GB', '100G(本地盘)', null, null, 'nginx', '/usr/local/nginx/conf', '/usr/local/nginx', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '80', 'centos7.3', '', '', '1', null, null, 'app-nginx', 'app-nginx', 'app-nginx', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('93', '', '', 'ocr75-common', '115.159.235.75', '172.16.0.5', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('94', '', '', 'File_S', '115.159.235.218', '172.16.0.16', '4核', '8GB', '500G(本地SSD盘)', null, null, 'nfs', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('95', '', '', 'redis', '115.159.235.237', '172.16.0.12', '8核', '24GB', '200G(本地盘)', null, null, 'db', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('96', '', '', '日志系统', '115.159.237.152', '172.16.0.7', '4核', '8GB', '100G(本地盘)', null, null, 'php', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('97', '', '', '自动化平台', '115.159.237.25', '172.16.0.178', '4核', '8GB', '100G(本地盘)', null, null, 'perl', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('99', '', '', '模板机', '115.159.237.69', '172.16.0.4', '4核', '8GB', '100G(本地盘)', null, null, '', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('100', '', '', 'cm95', '115.159.237.95', '172.16.0.25', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('101', '', '', 'cm227', '115.159.235.227', '172.16.0.127', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_host_zzb` VALUES ('103', '', '', 'cm-test', '115.159.237.152', '172.16.0.7', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm-test', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, 'test', null, null);
INSERT INTO `pre_host_zzb` VALUES ('104', '', '', 'app-test', '115.159.237.152', '172.16.0.7', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/usr/local/tomcat-app/bin/startup.sh', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-test', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, 'test', null, null);
INSERT INTO `pre_host_zzb` VALUES ('105', '', '', 'mini-cm41', '115.159.235.41', '172.16.0.222', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);

-- ----------------------------
-- Table structure for pre_server_detail
-- ----------------------------
DROP TABLE IF EXISTS `pre_server_detail`;
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

-- ----------------------------
-- Records of pre_server_detail
-- ----------------------------
INSERT INTO `pre_server_detail` VALUES ('1', '', '', '模板机', '115.159.237.69', '172.16.0.4', '4核', '8GB', '100G(本地盘)', null, null, '', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, '0');
INSERT INTO `pre_server_detail` VALUES ('3', '', '', 'app-test', '115.159.237.152', '172.16.0.7', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app', '/data/log/app', 'tomcat-app', '/usr/local/tomcat-app/bin/up.sh', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-test', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('6', '', '', 'uat-cm58', '115.159.235.58', '172.16.0.76', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('7', '', '', 'uat-cm206', '115.159.235.206', '172.16.0.248', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('8', '', '', 'uat-ccm112', '115.159.235.112', '172.16.0.32', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('9', '', '', 'uat-mini-cm119', '115.159.235.119', '172.16.0.190', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('15', '', '', 'uat-edi192', '115.159.237.192', '172.16.0.143', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_edi', '/data/log/tomcat', 'edi-tomcat-8.0.22', '/etc/init.d/tomcat', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi', '2', '/usr/local/edi-tomcat-8.0.22', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('16', '', '', 'uat-robot184', '115.159.237.184', '172.16.0.183', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat', 'tomcat-robot', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'robot', 'robot', 'robot', '2', '/usr/local/tomcat', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('17', '', '', 'uat-app232', '115.159.237.232', '172.16.0.244', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb', '/data/www/app/', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app1', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, 'test', 'common/config.js,WEB-INF/classes/system.properties', '1');
INSERT INTO `pre_server_detail` VALUES ('18', '', '', 'uat-wf1232', '115.159.237.232', '172.16.0.244', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', '/data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf1', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, 'test', 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1');
INSERT INTO `pre_server_detail` VALUES ('19', '', '', 'uat-app178', '115.159.235.178', '172.16.0.139', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/', '/data/www/app', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app ', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app2', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, 'test', 'common/config.js,WEB-INF/classes/system.properties', '1');
INSERT INTO `pre_server_detail` VALUES ('20', '', '', 'uat-wf2178', '115.159.235.178', '172.16.0.139', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', '/data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf2', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, 'test', 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1');
INSERT INTO `pre_server_detail` VALUES ('22', '', '', 'uat-vxplat168', '115.159.237.168', '172.16.0.138', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_vxplat/vxplat/WEB-INF/classes/', '/data/www/html_vxplat', '', 'tomcat', '/etc/init.d/tomcat-vxplat ', '8080', 'centos7.3', '', '', '1', null, null, 'vxplat', 'vxplat', 'vxplat', '1', '/usr/local/tomcat-vxplat', '', '', '', '1', '0', '0', '', null, 'test', 'applicationContext.xml', '1');
INSERT INTO `pre_server_detail` VALUES ('23', '', '', 'uat-payment168', '115.159.237.168', '172.16.0.138', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_pay/payment/WEB-INF/classes', '/data/www/html_pay', '/data/log/payment', 'tomcat-pay', '/etc/init.d/tomcat-pay ', '8090', 'centos7.3', '', '', '1', null, null, 'payment', 'payment', 'payment', '1', '/usr/local/tomcat-pay', '', '', '', '1', '0', '0', '', null, 'test', 'application.conf,systemsetting.properties,cert.properties,99bill-rsa.cer,99bill-rsa.pfx,99bill-quickpos.cer,99bill-quickpos.jks,99bill-quickpos-test.cer,99bill-quickpos-test.jks', '1');
INSERT INTO `pre_server_detail` VALUES ('24', '', '', 'uat-dispatch149', '115.159.235.149', '172.16.0.207', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '', 'tomcat', '/etc/init.d/tomcat ', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch1', '1', '/usr/local/tomcat', '', '', '', '1', '0', '0', '', null, 'test', 'spring-config.xml,test/config.properties,spring-config-cache.xml', '1');
INSERT INTO `pre_server_detail` VALUES ('25', '', '', 'uat-openfire9', '115.159.237.9', '172.16.0.110', '4核', '8GB', '100G(本地盘)', null, null, 'openfire', '/usr/local/openfire', '/usr/local/openfire', '', 'openfire', '/etc/init.d/openfire ', '9090', 'centos7.3', '', '', '1', null, null, 'openfire', 'openfire', 'openfire', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('26', '', '', 'uat-chn105', '115.159.235.105', '172.16.0.34', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_qudao/chn/WEB-INF/classes', '/data/www/html_qudao', '', 'tomcat-qudao', '/etc/init.d/tomcat ', '8090', 'centos7.3', '', '', '1', null, null, 'chn', 'chn', 'chn', '1', '/usr/local/tomcat-qudao', '', '', '', '1', '0', '0', '', null, 'test', 'akka.conf,application.conf,conf/test/config.properties,conf/test/application.conf,conf/spring-config-db.xml,conf/spring-config-cache.xml', '1');
INSERT INTO `pre_server_detail` VALUES ('28', '', '', 'uat-rule237', '115.159.235.237', '172.16.0.189', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html', '', 'resin', '/etc/init.d/resin ', '8080', 'centos7.3', '', '', '1', null, null, 'rule', 'rule', 'rule', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, 'test', null, '0');
INSERT INTO `pre_server_detail` VALUES ('29', null, null, 'uat-cwf98', '115.159.237.98', '172.16.0.109', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', '/data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat', '9080', 'centos7.3', null, null, '1', null, null, 'wf', 'wf', 'cwf', '1', '/usr/local/tomcat-wf', null, null, null, '1', '0', '0', null, null, 'test', 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1');
INSERT INTO `pre_server_detail` VALUES ('30', null, null, 'uat-dispatch138', '115.159.237.138', '172.16.0.198', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', null, null, '1', null, null, 'dispatch', 'dispatch', 'dispatch2', '1', '/usr/local/tomcat', null, null, null, '1', '0', '0', null, null, 'test', 'spring-config.xml,test/config.properties,spring-config-cache.xml', '1');
INSERT INTO `pre_server_detail` VALUES ('31', null, null, 'uat-newprocess251', '115.159.235.251', '172.16.0.152', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/newprocess/common', '/data/www/newprocess', '/data/log/wxtomcat-org', 'wxtomcat-org', '/etc/init.d/tomcat', '8080', 'centos7.3', null, null, '1', null, null, 'newprocess', 'newprocess', 'newprocess', '1', '/usr/local/wxtomcat-org', null, null, null, '1', '0', '0', null, null, 'test', 'config.js', '1');
INSERT INTO `pre_server_detail` VALUES ('32', null, null, 'mini-app12', '115.159.235.12', '172.16.0.52', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', null, null, '1', null, null, 'mini-app', 'mini-app', 'mini-app', '1', '/usr/local/tomcat', null, null, null, '1', '0', '0', null, null, 'test', 'common/config.js,WEB-INF/classes/system.properties,share/sharePage.html', '1');
INSERT INTO `pre_server_detail` VALUES ('33', '', '', 'uat-app-nginx232', '115.159.237.232', '172.16.0.244', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/web/zhangzb', '/data/www/web/', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-nginx1', '1', '/usr/local/nginx', '', '', '', '1', '0', '0', '', null, 'test', 'common/config.js,WEB-INF/classes/system.properties', '1');
INSERT INTO `pre_server_detail` VALUES ('34', '', '', 'uat-app-nginx178', '115.159.237.178', '172.16.0.139', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/web/zhangzb', '/data/www/web/', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-nginx2', '1', '/usr/local/nginx', '', '', '', '1', '0', '0', '', null, 'test', 'common/config.js,WEB-INF/classes/system.properties', '1');

-- ----------------------------
-- Table structure for pre_server_zw
-- ----------------------------
DROP TABLE IF EXISTS `pre_server_zw`;
CREATE TABLE `pre_server_zw` (
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
  `env` varchar(255) DEFAULT NULL,
  `configure_file_list` text,
  `configure_file_status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_server_zw
-- ----------------------------
INSERT INTO `pre_server_zw` VALUES ('52', '', '', 'cm238', '115.159.235.238', '172.16.0.254', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm3', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('53', '', '', 'cm104', '115.159.237.104', '172.16.0.70', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm4', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('54', '', '', 'cm16', '115.159.235.16', '172.16.0.68', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm5', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('55', '', '', 'cm107', '115.159.235.107', '172.16.0.101', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm6', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('56', '', '', 'cm154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm7', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('57', '', '', 'cm14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm8', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('58', '', '', 'app154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app1', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('59', '', '', 'app14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app2', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('60', '', '', '渠道cm161', '115.159.235.161', '172.16.0.253', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('61', '', '', '渠道cm57', '115.159.235.57', '172.16.0.78', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('62', '', '', '新渠道流程cm202', '115.159.235.202', '172.16.0.219', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_qudao/chn/WEB-INF/classes', '/data/www/html_qudao', '/data/log/cm', 'tomcat-qudao', '/usr/local/tomcat-qudao/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'nfl-cm', 'nfl-cm', '1', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('63', '', '', 'mini-cm146', '115.159.235.146', '172.16.0.114', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('64', '', '', 'mini前端100', '115.159.235.100', '172.16.0.54', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'mini-app', 'mini-app', 'mini-app', '1', '/etc/init.d/tomcat', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('65', '', '', '渠道前端188', '115.159.235.188', '172.16.0.93', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app/zzbchannel/templates/common', '/data/www/app/zzbchannel', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'chn-app', 'chn-app', 'chn-app', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('66', '', '', '新渠道流程前端159', '115.159.237.159', '172.16.0.23', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/newprocess/WEB-INF/classes', '/data/www/newprocess', '/data/log/tomcat', 'wxtomcat-org ', '/usr/local/wxtomcat-org/bin/startup.sh', '8081', 'centos7.3', '', '', '1', null, null, 'nfl-app', 'nfl-app', 'nfl-app', '1', '/usr/local/wxtomcat-org', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('67', '', '', '工作流92', '115.159.235.92', '172.16.0.232', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf1', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('68', '', '', '工作流42', '115.159.237.42', '172.16.0.134', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf2', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('69', '', '', '工作流154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf3', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('70', '', '', '工作流14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf4', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('71', '', '', '渠道工作流19', '115.159.237.19', '172.16.0.103', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'chn-wf', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('72', '', '', '精灵89', '115.159.235.89', '172.16.0.146', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb1', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('73', '', '', '精灵181', '115.159.235.181', '172.16.0.43', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb2', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('74', '', '', '精灵70', '115.159.235.70', '172.16.0.81', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb3', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('75', '', '', '精灵122', '115.159.235.122', '172.16.0.206', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb4', '2', '/usr/local/tomcat-robot', '', '', '', '1', '1', '1', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('76', '', '', '精灵61', '115.159.237.61', '172.16.0.153', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb5', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('77', '', '', '精灵54', '115.159.235.54', '172.16.0.8', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb6', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('78', '', '', 'edi26', '115.159.237.26', '172.16.0.129', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi1', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('79', '', '', 'edi163', '115.159.237.163', '172.16.0.9', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/usr/local/edi-tomcat-8.0.22/bin/startup.sh', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi2', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('80', '', '', 'edi26', '115.159.235.26', '172.16.0.2', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi3', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('81', '', '', '调度179', '115.159.237.179', '172.16.0.194', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('82', '', '', '调度111', '115.159.237.111', '172.16.0.205', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('83', '', '', '规则服务器65', '115.159.237.65', '172.16.0.252', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine1', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('84', '', '', '规则服务器176', '115.159.237.176', '172.16.0.14', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine2', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('85', '', '', '微信后台135', '115.159.237.135', '172.16.0.92', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('86', '', '', '微信后台202', '115.159.237.202', '172.16.0.115', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('87', '', '', '去哪保微信后台148', '115.159.237.148', '172.16.0.10', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'qnb-vx', 'qnb-vx', 'qnb-vx', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('88', '', '', '支付平台30', '115.159.237.30', '172.16.0.120', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('89', '', '', '支付平台227', '115.159.237.227', '172.16.0.6', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('90', '', '', 'openfire211', '115.159.237.211', '172.16.0.187', '4核', '8GB', '0G', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of1', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('91', '', '', 'openfire215-common', '115.159.237.215', '172.16.0.3', '4核', '8GB', '100G(本地盘)', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of2', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('92', '', '', 'nginx_app215-common', '115.159.237.215', '172.16.0.3', '4核', '8GB', '100G(本地盘)', null, null, 'nginx', '/usr/local/nginx/conf', '/usr/local/nginx', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '80', 'centos7.3', '', '', '1', null, null, 'app-nginx', 'app-nginx', 'app-nginx', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('93', '', '', 'ocr75-common', '115.159.235.75', '172.16.0.5', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('94', '', '', 'File_S', '115.159.235.218', '172.16.0.16', '4核', '8GB', '500G(本地SSD盘)', null, null, 'nfs', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('95', '', '', 'redis', '115.159.235.237', '172.16.0.12', '8核', '24GB', '200G(本地盘)', null, null, 'db', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('96', '', '', '日志系统', '115.159.237.152', '172.16.0.7', '4核', '8GB', '100G(本地盘)', null, null, 'php', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('97', '', '', '自动化平台', '115.159.237.25', '172.16.0.178', '4核', '8GB', '100G(本地盘)', null, null, 'perl', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('99', '', '', '模板机', '115.159.237.69', '172.16.0.4', '4核', '8GB', '100G(本地盘)', null, null, '', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('100', '', '', 'cm95', '115.159.237.95', '172.16.0.25', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('101', '', '', 'cm227', '115.159.235.227', '172.16.0.127', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
INSERT INTO `pre_server_zw` VALUES ('103', '', '', 'cm-test', '115.159.237.152', '172.16.0.7', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm-test', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, 'test', null, null);
INSERT INTO `pre_server_zw` VALUES ('104', '', '', 'app-test', '115.159.237.152', '172.16.0.7', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app/zhangzb', '/data/log/app', 'tomcat-app', '/usr/local/tomcat-app/bin/startup.sh', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-test', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, 'test', null, null);
INSERT INTO `pre_server_zw` VALUES ('105', '', '', 'mini-cm41', '115.159.235.41', '172.16.0.222', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, null);
