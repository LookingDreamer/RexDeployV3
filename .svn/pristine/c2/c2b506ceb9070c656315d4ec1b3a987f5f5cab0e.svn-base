-- MySQL dump 10.13  Distrib 5.6.39, for Linux (x86_64)
--
-- Host: localhost    Database: autotask
-- ------------------------------------------------------
-- Server version	5.6.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pre_auto_configure`
--

DROP TABLE IF EXISTS `pre_auto_configure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pre_auto_configure` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `local_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '唯一关键词',
  `link_template_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '关联模版id',
  `configure_group` text COMMENT '服务器配置文件组',
  `configure_file` text COMMENT '发布机器配置文件组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_auto_configure`
--

LOCK TABLES `pre_auto_configure` WRITE;
/*!40000 ALTER TABLE `pre_auto_configure` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_auto_configure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_auto_template_vars`
--

DROP TABLE IF EXISTS `pre_auto_template_vars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pre_auto_template_vars` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `template_vars_name` varchar(200) DEFAULT NULL COMMENT '变量名',
  `template_vars_value` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量值',
  `template_vars_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '变量描述',
  `env` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '应用环境',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_auto_template_vars`
--

LOCK TABLES `pre_auto_template_vars` WRITE;
/*!40000 ALTER TABLE `pre_auto_template_vars` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_auto_template_vars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_bwzzbmonitor`
--

DROP TABLE IF EXISTS `pre_bwzzbmonitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_bwzzbmonitor`
--

LOCK TABLES `pre_bwzzbmonitor` WRITE;
/*!40000 ALTER TABLE `pre_bwzzbmonitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_bwzzbmonitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_deploy_manage`
--

DROP TABLE IF EXISTS `pre_deploy_manage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_deploy_manage`
--

LOCK TABLES `pre_deploy_manage` WRITE;
/*!40000 ALTER TABLE `pre_deploy_manage` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_deploy_manage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_deploy_status`
--

DROP TABLE IF EXISTS `pre_deploy_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_deploy_status`
--

LOCK TABLES `pre_deploy_status` WRITE;
/*!40000 ALTER TABLE `pre_deploy_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_deploy_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_external_server_detail`
--

DROP TABLE IF EXISTS `pre_external_server_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `env` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `configure_file_list` text COMMENT '同步远程配置文件到待发表目录的配置组',
  `configure_file_status` int(11) DEFAULT NULL COMMENT '配置文件状态0为拷贝整个目录，1为读取configure_file_list的列表文件',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_external_server_detail`
--

LOCK TABLES `pre_external_server_detail` WRITE;
/*!40000 ALTER TABLE `pre_external_server_detail` DISABLE KEYS */;
INSERT INTO `pre_external_server_detail` VALUES (1,'','','后台服务集群1','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/config1','/data/www/html1','/data/log/server1','tomcat-server1','/etc/init.d/tomcat-server1','6080','centos7.1','','','1','2018-03-21 10:29:50','2018-03-21 10:29:50','server','server','server1','2','/usr/local/tomcat-server1','','','','1',0,0,'',NULL,'test',NULL,0),(2,'','','后台服务集群2','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/config2','/data/www/html2','/data/log/server2','tomcat-server2','/etc/init.d/tomcat-server2','7080','centos7.1','','','1','2018-03-21 10:30:15','2018-03-21 10:30:15','server','server','server2','2','/usr/local/tomcat-server2','','','','1',0,0,'',NULL,'test',NULL,0),(3,'','','调度服务集群1','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/flow1/WEB-INF/classes/','/data/www/flow1','/data/log/flow1','tomcat-flow1','/etc/init.d/tomcat-flow1','8080','centos7.1','','','1','2018-03-21 10:30:19','2018-03-21 10:30:19','flow','flow','flow1','1','/usr/local/tomcat-flow1','','','','1',0,0,'',NULL,'test','config.properties,applicationContext.xml,log4j.properties,generatorConfig.xml',1),(4,'','','调度服务集群2','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/flow2/WEB-INF/classes/','/data/www/flow2','/data/log/flow2','tomcat-flow2','/etc/init.d/tomcat-flow2','9080','centos7.1','','','1','2018-03-21 10:30:22','2018-03-21 10:30:22','flow','flow','flow2','1','/usr/local/tomcat-flow2','','','','1',0,0,'',NULL,'test','config.properties,applicationContext.xml,log4j.properties,generatorConfig.xml',1);
/*!40000 ALTER TABLE `pre_external_server_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_server_detail`
--

DROP TABLE IF EXISTS `pre_server_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_server_detail`
--

LOCK TABLES `pre_server_detail` WRITE;
/*!40000 ALTER TABLE `pre_server_detail` DISABLE KEYS */;
INSERT INTO `pre_server_detail` VALUES (1,'','','后台服务集群1','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/config1','/data/www/html1','/data/log/server1','tomcat-server1','/etc/init.d/tomcat-server1','6080','centos7.1','','','1','2018-03-21 10:29:50','2018-03-21 10:29:50','server','server','server1','2','/usr/local/tomcat-server1','','','','1',0,0,'',NULL,'test',NULL,0),(2,'','','后台服务集群2','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/config2','/data/www/html2','/data/log/server2','tomcat-server2','/etc/init.d/tomcat-server2','7080','centos7.1','','','1','2018-03-21 10:30:15','2018-03-21 10:30:15','server','server','server2','2','/usr/local/tomcat-server2','','','','1',0,0,'',NULL,'test',NULL,0),(3,'','','调度服务集群1','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/flow1/WEB-INF/classes/','/data/www/flow1','/data/log/flow1','tomcat-flow1','/etc/init.d/tomcat-flow1','8080','centos7.1','','','1','2018-03-21 10:30:19','2018-03-21 10:30:19','flow','flow','flow1','1','/usr/local/tomcat-flow1','','','','1',0,0,'',NULL,'test','config.properties,applicationContext.xml,log4j.properties,generatorConfig.xml',1),(4,'','','调度服务集群2','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/flow2/WEB-INF/classes/','/data/www/flow2','/data/log/flow2','tomcat-flow2','/etc/init.d/tomcat-flow2','9080','centos7.1','','','1','2018-03-21 10:30:22','2018-03-21 10:30:22','flow','flow','flow2','1','/usr/local/tomcat-flow2','','','','1',0,0,'',NULL,'test','config.properties,applicationContext.xml,log4j.properties,generatorConfig.xml',1);
/*!40000 ALTER TABLE `pre_server_detail` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-21  4:26:31
