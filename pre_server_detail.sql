/*
 Navicat Premium Data Transfer

 Source Server         : 金融云准生产
 Source Server Type    : MySQL
 Source Server Version : 50505
 Source Host           : tdsql-qc4b1vpn.shjr.cdb.myqcloud.com
 Source Database       : autotask

 Target Server Type    : MySQL
 Target Server Version : 50505
 File Encoding         : utf-8

 Date: 03/07/2017 16:29:33 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `pre_server_detail`
-- ----------------------------
DROP TABLE IF EXISTS `pre_server_detail`;
CREATE TABLE `pre_server_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'åºå·',
  `yewu_name` varchar(255) DEFAULT NULL COMMENT 'ä¸šåŠ¡ç®¡ç†',
  `depart_name` varchar(64) DEFAULT NULL COMMENT 'åˆ†åŒºåç§°',
  `server_name` varchar(128) DEFAULT NULL COMMENT 'æœåŠ¡å™¨åç§°',
  `external_ip` varchar(15) DEFAULT NULL COMMENT 'å…¬ç½‘IP',
  `network_ip` varchar(15) NOT NULL COMMENT 'å†…ç½‘IP',
  `cpu` varchar(64) DEFAULT NULL COMMENT 'CPU',
  `mem` varchar(64) DEFAULT NULL COMMENT 'å†…å­˜',
  `disk` varchar(64) DEFAULT NULL COMMENT 'æ•°æ®ç›˜',
  `server_id` int(11) DEFAULT NULL COMMENT 'æœåŠ¡å™¨ID',
  `mirr_id` int(11) DEFAULT NULL COMMENT 'é•œåƒID',
  `pro_type` varchar(164) DEFAULT '' COMMENT 'åº”ç”¨ç±»åž‹',
  `config_dir` varchar(255) DEFAULT '' COMMENT 'é…ç½®ç›®å½•',
  `pro_dir` varchar(255) DEFAULT NULL COMMENT 'å·¥ç¨‹ç›®å½•',
  `log_dir` varchar(164) DEFAULT NULL COMMENT 'æ—¥å¿—è·¯å¾„',
  `pro_key` varchar(164) DEFAULT NULL COMMENT 'è¿›ç¨‹å…³é”®è¯',
  `pro_init` varchar(164) DEFAULT NULL COMMENT 'å¯åŠ¨è„šæœ¬',
  `pro_port` varchar(255) DEFAULT NULL COMMENT 'å¯åŠ¨ç«¯å£',
  `system_type` varchar(64) DEFAULT NULL COMMENT 'æ“ä½œç³»ç»Ÿ',
  `entrance_server` varchar(64) DEFAULT NULL COMMENT 'æ‰€å±žä¸»æœº',
  `note` varchar(128) DEFAULT NULL COMMENT 'å¤‡æ³¨',
  `status` varchar(64) DEFAULT 'å¯ç”¨' COMMENT 'çŠ¶æ€',
  `created_time` datetime DEFAULT NULL COMMENT 'åˆ›å»ºæ—¶é—´',
  `updated_time` datetime DEFAULT NULL COMMENT 'æœ€åŽæ›´æ–°è®°å½•æ—¶é—´',
  `groupby` varchar(128) DEFAULT NULL COMMENT 'åˆ†ç»„åç§°',
  `local_name` varchar(200) DEFAULT NULL COMMENT 'è¯†åˆ«åç§°',
  `app_key` varchar(200) DEFAULT NULL COMMENT 'åº”ç”¨å”¯ä¸€å…³é”®è¯',
  `is_deloy_dir` varchar(64) DEFAULT NULL COMMENT 'å‘å¸ƒç›®å½•åˆ¤æ–­',
  `container_dir` varchar(100) DEFAULT NULL COMMENT 'å®¹å™¨ç›®å½•',
  `java_versoin` varchar(64) DEFAULT NULL COMMENT 'javaç‰ˆæœ¬',
  `java_home` varchar(100) DEFAULT NULL COMMENT 'javaçš„Homeç›®å½•',
  `java_confirm` varchar(64) DEFAULT NULL COMMENT 'javaç‰ˆæœ¬ç¡®è®¤',
  `auto_deloy` varchar(64) DEFAULT '0' COMMENT 'æ˜¯å¦åŠ å…¥è‡ªåŠ¨å‘å¸ƒ',
  `backupdir_same_level` int(11) DEFAULT NULL COMMENT 'å¤‡ä»½ç›®å½•æ˜¯å¦å’Œpro_diråŒçº§',
  `deploydir_same_level` int(11) DEFAULT NULL COMMENT 'å‘å¸ƒç›®å½•æ˜¯å¦å’Œpro_diråŒçº§',
  `huanjin_name` varchar(255) DEFAULT NULL COMMENT 'çŽ¯å¢ƒç®¡ç†',
  `jifang_name` varchar(255) DEFAULT NULL COMMENT 'æœºæˆ¿ç®¡ç†',
  `env` varchar(255) DEFAULT NULL COMMENT 'çŽ¯å¢ƒå˜é‡è®¾ç½®',
  `configure_file_list` text COMMENT 'åŒæ­¥è¿œç¨‹é…ç½®æ–‡ä»¶åˆ°å¾…å‘è¡¨ç›®å½•çš„é…ç½®ç»„',
  `configure_file_status` int(255) DEFAULT NULL COMMENT 'é…ç½®æ–‡ä»¶çŠ¶æ€0ä¸ºæ‹·è´æ•´ä¸ªç›®å½•ï¼Œ1ä¸ºè¯»å–configure_file_listçš„åˆ—è¡¨æ–‡ä»¶',
  `logfile` varchar(200) DEFAULT NULL COMMENT '日志文件',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `pre_server_detail`
-- ----------------------------
BEGIN;
INSERT INTO `pre_server_detail` VALUES ('1', '掌中保', '', '模板机', '115.159.237.69', '172.16.0.4', '4核', '8GB', '100G(本地盘)', '22222', '11111', '', '', '', '', '', '', '', '', '', '备注测试你的测试', '', '2017-02-21 00:00:00', '2017-02-23 00:00:00', '', '', '', '2', '', '', '', '', '', null, null, '准生产环境', '', 'uat', '', '0', 'catalina.out.#%Y-%m-%d'), ('3', '掌中保', '', 'app-test', '115.159.237.152', '172.16.0.7', '8核', '24GB', '200G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/WEB-INF/classes', '/data/www/app', '/data/log/app', 'tomcat-app', '/usr/local/tomcat-app/bin/up.sh', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-test', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('6', '掌中保', '', 'uat-cm58', '115.159.235.58', '172.16.0.76', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm1', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('7', '掌中保', '', 'uat-cm206', '115.159.235.206', '172.16.0.248', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'cm2', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('8', '掌中保', '', 'uat-ccm112', '115.159.235.112', '172.16.0.32', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'ccm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', '', '0', 'catalina.out.#%Y-%m-%d'), ('9', '掌中保', '', 'uat-mini-cm119', '115.159.235.119', '172.16.0.190', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/cm', '/data/log/cm', 'tomcat-cm', '/etc/init.d/tomcat', '6080', 'centos7.3', '', '', '1', null, null, 'cm', 'cm', 'mini-cm', '2', '/usr/local/tomcat-cm', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('15', '掌中保', '', 'uat-edi192', '115.159.237.192', '172.16.0.143', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_edi', '/data/log/tomcat', 'edi-tomcat-8.0.22', '/etc/init.d/tomcat', '9080', 'centos7.3', '', '', '1', null, null, 'edi', 'edi', 'edi', '2', '/usr/local/edi-tomcat-8.0.22', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('16', '掌中保', '', 'uat-robot184', '115.159.237.184', '172.16.0.183', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html_robot', '/data/log/tomcat', 'tomcat-robot', '/etc/init.d/tomcat', '8080', 'centos7.3', '', '', '1', null, null, 'robot', 'robot', 'robot', '2', '/usr/local/tomcat', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('17', '掌中保', '', 'uat-app232', '115.159.237.232', '172.16.0.244', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb', '/data/www/app/', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app1', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'common/config.js,WEB-INF/classes/system.properties', '1', 'catalina.out.#%Y-%m-%d'), ('18', '掌中保', '', 'uat-wf1232', '115.159.237.232', '172.16.0.244', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', '/data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf1', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1', 'catalina.out.#%Y-%m-%d'), ('19', '掌中保', '', 'uat-app178', '115.159.235.178', '172.16.0.139', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/app/zhangzb/', '/data/www/app', '/data/log/app', 'tomcat-app', '/etc/init.d/tomcat-app ', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app2', '1', '/usr/local/tomcat-app', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'common/config.js,WEB-INF/classes/system.properties', '1', 'catalina.out.#%Y-%m-%d'), ('20', '掌中保', '', 'uat-wf2178', '115.159.235.178', '172.16.0.139', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', '/data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat-wf', '9080', 'centos7.3', '', '', '1', null, null, 'wf', 'wf', 'wf2', '1', '/usr/local/tomcat-wf', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1', 'catalina.out.#%Y-%m-%d'), ('22', '掌中保', '', 'uat-vxplat168', '115.159.237.168', '172.16.0.138', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_vxplat/vxplat/WEB-INF/classes/', '/data/www/html_vxplat', '', 'tomcat', '/etc/init.d/tomcat-vxplat ', '8080', 'centos7.3', '', '', '1', null, null, 'vxplat', 'vxplat', 'vxplat', '1', '/usr/local/tomcat-vxplat', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'applicationContext.xml', '1', 'catalina.out.#%Y-%m-%d'), ('23', '掌中保', '', 'uat-payment168', '115.159.237.168', '172.16.0.138', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_pay/payment/WEB-INF/classes', '/data/www/html_pay', '/data/log/payment', 'tomcat-pay', '/etc/init.d/tomcat-pay ', '8090', 'centos7.3', '', '', '1', null, null, 'payment', 'payment', 'payment', '1', '/usr/local/tomcat-pay', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'application.conf,applicationContextPay.xml,systemsetting.properties,cert.properties,99bill-rsa.cer,99bill-rsa.pfx,99bill-quickpos.cer,99bill-quickpos.jks,99bill-quickpos-test.cer,99bill-quickpos-test.jks', '1', 'catalina.out.#%Y-%m-%d'), ('24', '掌中保', '', 'uat-dispatch149', '115.159.235.149', '172.16.0.207', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '', 'tomcat', '/etc/init.d/tomcat ', '8080', 'centos7.3', '', '', '1', null, null, 'dispatch', 'dispatch', 'dispatch1', '1', '/usr/local/tomcat', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'spring-config.xml,test/config.properties,spring-config-cache.xml', '1', 'catalina.out.#%Y-%m-%d'), ('25', '掌中保', '', 'uat-openfire9', '115.159.237.9', '172.16.0.110', '4核', '8GB', '100G(本地盘)', null, null, 'openfire', '/usr/local/openfire', '/usr/local/openfire', '', 'openfire', '/etc/init.d/openfire ', '9090', 'centos7.3', '', '', '1', null, null, 'openfire', 'openfire', 'openfire', '1', '/usr/local/openfire', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('26', '掌中保', '', 'uat-chn105', '115.159.235.105', '172.16.0.34', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html_qudao/chn/WEB-INF/classes', '/data/www/html_qudao', '', 'tomcat-qudao', '/etc/init.d/tomcat ', '8090', 'centos7.3', '', '', '1', null, null, 'chn', 'chn', 'chn', '1', '/usr/local/tomcat-qudao', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'akka.conf,application.conf,conf/test/config.properties,conf/test/application.conf,conf/spring-config-db.xml,conf/spring-config-cache.xml', '1', 'catalina.out.#%Y-%m-%d'), ('28', '掌中保', '', 'uat-rule237', '115.159.235.237', '172.16.0.189', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/ins_share', '/data/www/html', '', 'resin', '/etc/init.d/resin ', '8080', 'centos7.3', '', '', '1', null, null, 'rule', 'rule', 'rule', '2', '/usr/local/resin', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', null, '0', 'catalina.out.#%Y-%m-%d'), ('29', '掌中保', null, 'uat-cwf98', '115.159.237.98', '172.16.0.109', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/workflow/WEB-INF/classes/config', '/data/www/workflow', '/data/log/workflow', 'tomcat-wf', '/etc/init.d/tomcat', '9080', 'centos7.3', null, null, '1', null, null, 'wf', 'wf', 'cwf', '1', '/usr/local/tomcat-wf', null, null, null, '1', '0', '0', '准生产环境', null, 'uat', 'ipconfig.properties,jdbc.properties,log4j.properties,spring-config-jbpm.xml,spring-config.xml,spring-mvc-config.xml,taskCode.properties,tomcat-jbpm-persistence.xml', '1', 'catalina.out.#%Y-%m-%d'), ('30', '掌中保', null, 'uat-dispatch138', '115.159.237.138', '172.16.0.198', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/dispatch/WEB-INF/classes/conf', '/data/www/dispatch', '/data/log/dispatch', 'tomcat', '/usr/local/tomcat/bin/startup.sh', '8080', 'centos7.3', null, null, '1', null, null, 'dispatch', 'dispatch', 'dispatch2', '1', '/usr/local/tomcat', null, null, null, '1', '0', '0', '准生产环境', null, 'uat', 'spring-config.xml,test/config.properties,spring-config-cache.xml', '1', 'catalina.out.#%Y-%m-%d'), ('31', '掌中保', null, 'uat-newprocess251', '115.159.235.251', '172.16.0.152', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/newprocess/common', '/data/www/newprocess', '/data/log/wxtomcat-org', 'wxtomcat-org', '/usr/local/tomcat/bin/startup.sh', '8080', 'centos7.3', null, null, '1', null, null, 'newprocess', 'newprocess', 'newprocess', '1', '/usr/local/wxtomcat-org', null, null, null, '1', '0', '0', '准生产环境', null, 'uat', 'config.js', '1', 'catalina.out.#%Y-%m-%d'), ('32', '掌中保', null, 'mini-app12', '115.159.235.12', '172.16.0.52', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/html', '/data/www/html', '/data/log/tomcat/', 'tomcat', '/etc/init.d/tomcat', '8080', 'centos7.3', null, null, '1', null, null, 'mini-app', 'mini-app', 'mini-app', '1', '/usr/local/tomcat', null, null, null, '1', '0', '0', '准生产环境', null, 'uat', 'common/config.js,WEB-INF/classes/system.properties,share/sharePage.html', '1', 'catalina.out.#%Y-%m-%d'), ('33', '掌中保', '', 'uat-app-nginx232', '115.159.237.232', '172.16.0.244', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/web/zhangzb', '/data/www/web/', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-nginx1', '1', '/usr/local/nginx', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'common/config.js,WEB-INF/classes/system.properties', '1', 'catalina.out.#%Y-%m-%d'), ('34', '掌中保', '', 'uat-app-nginx178', '115.159.237.178', '172.16.0.139', '4核', '8GB', '100G(本地盘)', null, null, 'tomcat', '/data/www/web/zhangzb', '/data/www/web/', '/data/log/nginx', 'nginx', '/etc/init.d/nginx', '8080', 'centos7.3', '', '', '1', null, null, 'app', 'app', 'app-nginx2', '1', '/usr/local/nginx', '', '', '', '1', '0', '0', '准生产环境', null, 'uat', 'common/config.js,WEB-INF/classes/system.properties', '1', 'catalina.out.#%Y-%m-%d'), ('107', '掌中保', '', '11111', '11111', '888888888888888', '', '', '', '0', '0', '', '', '', '', '', '', '', '', '', '', null, '2017-02-21 00:00:00', '2017-02-21 00:00:00', '', '', '', '1', '', '', '', '', '0', null, null, null, '', '', '', null, 'catalina.out.#%Y-%m-%d');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
