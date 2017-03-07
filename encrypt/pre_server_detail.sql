/*
 Navicat Premium Data Transfer

 Source Server         : 115.159.237.148(自动化)
 Source Server Type    : MySQL
 Source Server Version : 50613
 Source Host           : 115.159.237.148
 Source Database       : autotask

 Target Server Type    : MySQL
 Target Server Version : 50613
 File Encoding         : utf-8

 Date: 10/31/2016 22:53:19 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `pre_server_detail`
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
  `configure_file_list` text,
  `configure_file_status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Records of `pre_server_detail`
-- ----------------------------
BEGIN;
INSERT INTO `pre_server_detail` VALUES ('52', '', '', 'cm238', '115.159.235.238', '172.16.0.254', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm3', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('53', '', '', 'cm104', '115.159.237.104', '172.16.0.70', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm4', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('54', '', '', 'cm16', '115.159.235.16', '172.16.0.68', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm5', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('55', '', '', 'cm107', '115.159.235.107', '172.16.0.101', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm6', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('56', '', '', 'cm154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm7', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('57', '', '', 'cm14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm8', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('58', '', '', 'app154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb', '/data/www/app', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app1', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, 'common/config.js,WEB-INF/classes/system.properties', '1'), ('59', '', '', 'app14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb', '/data/www/app', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app2', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, 'common/config.js,WEB-INF/classes/system.properties', '1'), ('60', '', '', '渠道cm161', '115.159.235.161', '172.16.0.253', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('61', '', '', '渠道cm57', '115.159.235.57', '172.16.0.78', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('62', '', '', '新渠道流程cm202', '115.159.235.202', '172.16.0.219', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_qudao/chn/WEB-INF/classes', '/data/www/html_qudao', '/data/log/cm', 'tomcat-qudao', '/usr/local/tomcat-qudao/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'nfl-cm', 'nfl-cm', '1', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, 'akka.conf,application.conf,conf/test/application.conf,conf/spring-config-db.xml,conf/spring-config-cache.xml', '1'), ('63', '', '', 'mini-cm146', '115.159.235.146', '172.16.0.114', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh ', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('64', '', '', 'mini前端100', '115.159.235.100', '172.16.0.54', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'mini-app', 'mini-app', 'mini-app', '1', '/etc/init.d/tomcat', '', '', '', '1', '0', '0', '', null, null, 'common/config.js,WEB-INF/classes/system.properties,share/sharePage.html', '1'), ('65', '', '', '渠道前端188', '115.159.235.188', '172.16.0.93', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app', '/data/www/app', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'chn-app', 'chn-app', 'chn-app', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, '', '1'), ('66', '', '', '新渠道流程前端159', '115.159.237.159', '172.16.0.23', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/newprocess/common', '/data/www/newprocess', '/data/log/tomcat', 'wxtomcat-org ', '/usr/local/wxtomcat-org/bin/startup.sh', '8081', 'centos7.3', '', '', '1', null, null, 'nfl-app', 'nfl-app', 'nfl-app', '1', '/usr/local/wxtomcat-org', '', '', '', '1', '0', '0', '', null, null, 'config.js', '1'), ('67', '', '', '工作流92', '115.159.235.92', '172.16.0.232', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf1', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1'), ('68', '', '', '工作流42', '115.159.237.42', '172.16.0.134', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf2', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1'), ('69', '', '', '工作流154-common', '115.159.237.154', '172.16.0.13', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf3', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1'), ('70', '', '', '工作流14-common', '115.159.235.14', '172.16.0.11', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf4', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1'), ('71', '', '', '渠道工作流19', '115.159.237.19', '172.16.0.103', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', ' /data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf ', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'chn-wf', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1'), ('72', '', '', '精灵89', '115.159.235.89', '172.16.0.146', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb1', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('73', '', '', '精灵181', '115.159.235.181', '172.16.0.43', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb2', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('74', '', '', '精灵70', '115.159.235.70', '172.16.0.81', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb3', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('75', '', '', '精灵122', '115.159.235.122', '172.16.0.206', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb4', '2', '/usr/local/tomcat-robot', '', '', '', '1', '1', '1', '', null, null, null, '0'), ('76', '', '', '精灵61', '115.159.237.61', '172.16.0.153', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb5', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('77', '', '', '精灵54', '115.159.235.54', '172.16.0.8', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat-robot', 'tomcat-robot', '/etc/init.d/tomcat-robot ', '8080', 'centos7.3', '', '', '1', null, null, 'rb', 'rb', 'rb6', '2', '/usr/local/tomcat-robot', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('78', '', '', 'edi26', '115.159.237.26', '172.16.0.129', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi1', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('79', '', '', 'edi163', '115.159.237.163', '172.16.0.9', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/usr/local/edi-tomcat-8.0.22/bin/startup.sh', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi2', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('80', '', '', 'edi26', '115.159.235.26', '172.16.0.2', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share/', '/data/www/html', '/data/log/tomcat/', 'edi-tomcat', '/etc/init.d/tomcat-edi ', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi3', '2', '/usr/local/edi-tomcat-8.0.22/', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('81', '', '', '调度179', '115.159.237.179', '172.16.0.194', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, 'spring-config.xml,test/config.properties,spring-config-cache.xml', '1'), ('82', '', '', '调度111', '115.159.237.111', '172.16.0.205', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, 'spring-config.xml,test/config.properties,spring-config-cache.xml', '1'), ('83', '', '', '规则服务器65', '115.159.237.65', '172.16.0.252', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine1', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('84', '', '', '规则服务器176', '115.159.237.176', '172.16.0.14', '8核', '32GB', '200G(本地盘)', null, null, 'resin', '/data/www/ins_share', '/data/www/html', '/data/log/resin', 'resin', '/etc/init.d/resin', '8080', 'centos7.3', '', '', '1', null, null, 'engine', 'engine', 'engine2', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('85', '', '', '微信后台135', '115.159.237.135', '172.16.0.92', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, 'applicationContext.xml', '1'), ('86', '', '', '微信后台202', '115.159.237.202', '172.16.0.115', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'nzzb-vx', 'nzzb-vx', 'nzzb-vx2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, 'applicationContext.xml', '1'), ('87', '', '', '去哪保微信后台148', '115.159.237.148', '172.16.0.10', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/vxplat/WEB-INF/classes', '/data/www/html/vxplat', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'qnb-vx', 'qnb-vx', 'qnb-vx', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, 'applicationContext.xml', '1'), ('88', '', '', '支付平台30', '115.159.237.30', '172.16.0.120', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay1', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, 'applicationContext.xml,application.conf,systemsetting.properties,cert.properties', '1'), ('89', '', '', '支付平台227', '115.159.237.227', '172.16.0.6', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html/payment/WEB-INF/classes', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'pay', 'pay', 'pay2', '1', '/usr/local/tomcat ', '', '', '', '1', '0', '0', '', null, null, 'applicationContext.xml,application.conf,systemsetting.properties,cert.properties', '1'), ('90', '', '', 'openfire211', '115.159.237.211', '172.16.0.187', '4核', '8GB', '0G', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of1', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, '1'), ('91', '', '', 'openfire215-common', '115.159.237.215', '172.16.0.3', '4核', '8GB', '100G(本地盘)', null, null, 'java', '/usr/local/openfire/conf', '/usr/local/openfire', '/data/log/openfire', 'java', '/etc/init.d/openfire', '9090', 'centos7.3', '', '', '1', null, null, 'of', 'of', 'of2', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, '1'), ('92', '', '', 'nginx_app215-common', '115.159.237.215', '172.16.0.3', '4核', '8GB', '100G(本地盘)', null, null, 'nginx', '/usr/local/nginx/conf', '/usr/local/nginx', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '80', 'centos7.3', '', '', '1', null, null, 'app-nginx', 'app-nginx', 'app-nginx', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '', null, null, null, '1'), ('93', '', '', 'ocr75-common', '115.159.235.75', '172.16.0.5', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, '1'), ('94', '', '', 'File_S', '115.159.235.218', '172.16.0.16', '4核', '8GB', '500G(本地SSD盘)', null, null, 'nfs', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, '1'), ('95', '', '', 'redis', '115.159.235.237', '172.16.0.12', '8核', '24GB', '200G(本地盘)', null, null, 'db', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, '1'), ('96', '', '', '日志系统', '115.159.237.152', '172.16.0.7', '4核', '8GB', '100G(本地盘)', null, null, 'php', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, '1'), ('97', '', '', '自动化平台', '115.159.237.25', '172.16.0.178', '4核', '8GB', '100G(本地盘)', null, null, 'perl', '', '', '', '', '', '', '', '', '', '', null, null, '', '', '', '', '', '', '', '', '', null, null, '', null, null, null, '1'), ('99', '', '', 'test-wf', '115.159.237.69', '172.16.0.4', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', '/data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'test-wf', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '', null, null, null, '1'), ('100', '', '', 'cm95', '115.159.237.95', '172.16.0.25', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('101', '', '', 'cm227', '115.159.235.227', '172.16.0.127', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0'), ('103', '', '', 'cm-test', '115.159.237.152', '172.16.0.7', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm-test', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, 'test', null, '0'), ('104', '', '', 'app-test', '115.159.237.152', '172.16.0.7', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb', '/data/www/app', '/data/log/app', 'tomcat-app', '/usr/local/tomcat-app/bin/startup.sh', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-test', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '', null, null, null, '1'), ('105', '', '', 'mini-cm41', '115.159.235.41', '172.16.0.222', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm ', '/data/log/cm', 'tomcat-cm', '/usr/local/tomcat-cm/bin/startup.sh', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '', null, null, null, '0');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
