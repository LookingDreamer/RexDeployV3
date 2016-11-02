/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50542
 Source Host           : localhost
 Source Database       : autotask_52zzb

 Target Server Type    : MySQL
 Target Server Version : 50542
 File Encoding         : utf-8

 Date: 11/02/2016 22:20:22 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `pre_auto_template_vars`
-- ----------------------------
DROP TABLE IF EXISTS `pre_auto_template_vars`;
CREATE TABLE `pre_auto_template_vars` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `template_vars_name` varchar(200) DEFAULT NULL COMMENT '变量名',
  `template_vars_value` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量值',
  `template_vars_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量描述',
  `env` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '应用环境',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
--  Records of `pre_auto_template_vars`
-- ----------------------------
BEGIN;
INSERT INTO `pre_auto_template_vars` VALUES ('1', 'redis_server', '172.16.0.172', 'redis的服务器地址', 'test'), ('2', 'akka_server', '127.0.0.1', '本机的内网地址', 'test'), ('3', 'cif_server', '172.16.3.154', 'cif的内网地址', 'test'), ('4', 'edi_server', '172.16.0.143', 'edi的内网地址', 'test'), ('5', 'pay_server', '172.16.0.138', 'pay的内网地址', 'test'), ('6', 'uploadimage_server', '115.159.237.219', '影像的地址', 'test'), ('7', 'workflow_server', '172.16.0.249', '工作流的地址', 'test'), ('8', 'robot_server', '172.16.0.183', '精灵的地址', 'test'), ('9', 'mysql_server', '172.16.0.72', 'mysql的的地址', 'test'), ('10', 'rule_server', '172.16.0.189', 'rule的地址', 'test'), ('11', 'vxplat_server', '172.16.0.138', '微信后台的地址', 'test'), ('12', 'ocr_server', '115.159.235.75', 'ocr的地址', 'test'), ('13', 'localhost_server', '127.0.0.1', '本地公网地址', 'test'), ('14', 'dispatch_server', '172.16.0.197', '调度内网的地址', 'test'), ('15', 'isEnablePressureTest', 'true', '压测模式', 'test'), ('16', 'edi_system.ip', '10.0.0.7', 'edi公网ip', 'test'), ('17', 'isInsuredOrg', 'true', 'robot压测模式', 'test'), ('18', 'chn_server', '172.16.0.34', 'chn内网地址', 'test'), ('19', 'cm_server', '172.16.0.124', 'cm内网地址', 'test'), ('20', 'cmwai_server', '115.159.234.74', 'cm外网地址', 'test');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
