-- MySQL dump 10.13  Distrib 5.6.40, for Linux (x86_64)
--
-- Host: localhost    Database: autotask
-- ------------------------------------------------------
-- Server version	5.6.40

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
-- Table structure for table `load_key_sorts`
--

DROP TABLE IF EXISTS `load_key_sorts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `load_key_sorts` (
  `id` int(11) DEFAULT NULL,
  `local_name` varchar(255) DEFAULT NULL COMMENT '识别名称',
  `app_key_sort` text COMMENT '排序关键词'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `load_key_sorts`
--

LOCK TABLES `load_key_sorts` WRITE;
/*!40000 ALTER TABLE `load_key_sorts` DISABLE KEYS */;
INSERT INTO `load_key_sorts` VALUES (NULL,'server','server1;server2');
/*!40000 ALTER TABLE `load_key_sorts` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_deploy_manage`
--

LOCK TABLES `pre_deploy_manage` WRITE;
/*!40000 ALTER TABLE `pre_deploy_manage` DISABLE KEYS */;
INSERT INTO `pre_deploy_manage` VALUES (1,NULL,'server1','2018_0617','root','192.168.0.207',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-06-17 07:21:06',NULL,NULL,NULL,'1529220066366609500',0,0,0,NULL,NULL,1,NULL),(2,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_2018_0321_1628','','/data/www/html1_20180617_072834','/data/www/config1_20180617_072834','32M /data/www/html1_20180617_072834 24K /data/www/config1_20180617_072834','Total Take:35 || Rsync Time:20 || Start App Time:6','2018-06-17 07:29:55','2018-06-17 07:30:15','2018-06-17 07:30:24','2018-06-17 07:30:30','1529220595993270100',0,0,0,2,NULL,0,NULL),(3,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_2018_0321_1628','','/data/www/html2_20180617_072834','/data/www/config2_20180617_072834','32M /data/www/html2_20180617_072834 28K /data/www/config2_20180617_072834','Total Take:36 || Rsync Time:21 || Start App Time:6','2018-06-17 07:32:06','2018-06-17 07:32:27','2018-06-17 07:32:36','2018-06-17 07:32:42','1529220726901256000',0,0,0,2,NULL,0,NULL),(4,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_072834','/data/www/config1_20180617_072834','/data/www/html1_20180617_075100','/data/www/config1_20180617_075100','32M /data/www/html1_20180617_075100 24K /data/www/config1_20180617_075100','Total Take:33 || Rsync Time:19 || Start App Time:5','2018-06-17 07:52:20','2018-06-17 07:52:39','2018-06-17 07:52:48','2018-06-17 07:52:53','1529221940454810000',0,0,0,2,NULL,0,NULL),(5,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_072834','/data/www/config2_20180617_072834','/data/www/html2_20180617_075100','/data/www/config2_20180617_075100','32M /data/www/html2_20180617_075100 28K /data/www/config2_20180617_075100','Total Take:34 || Rsync Time:20 || Start App Time:5','2018-06-17 07:54:25','2018-06-17 07:54:45','2018-06-17 07:54:54','2018-06-17 07:54:59','1529222065244820100',0,0,0,2,NULL,0,NULL),(6,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_075100','/data/www/config1_20180617_075100','/data/www/html1_20180617_083410','/data/www/config1_20180617_083410','32M /data/www/html1_20180617_083410 24K /data/www/config1_20180617_083410','Total Take:31 || Rsync Time:17 || Start App Time:5','2018-06-17 08:35:18','2018-06-17 08:35:35','2018-06-17 08:35:44','2018-06-17 08:35:49','1529224518760049100',0,0,0,2,NULL,0,NULL),(7,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_075100','/data/www/config2_20180617_075100','/data/www/html2_20180617_083410','/data/www/config2_20180617_083410','32M /data/www/html2_20180617_083410 28K /data/www/config2_20180617_083410','Total Take:29 || Rsync Time:15 || Start App Time:5','2018-06-17 08:37:14','2018-06-17 08:37:29','2018-06-17 08:37:38','2018-06-17 08:37:43','1529224634940511300',0,0,0,2,NULL,0,NULL),(8,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_083410','/data/www/config1_20180617_083410','/data/www/html1_20180617_132238','/data/www/config1_20180617_132238','32M /data/www/html1_20180617_132238 24K /data/www/config1_20180617_132238','Total Take:30 || Rsync Time:16 || Start App Time:5','2018-06-17 13:23:21','2018-06-17 13:23:37','2018-06-17 13:23:46','2018-06-17 13:23:51','1529241801796843100',0,0,0,2,NULL,0,NULL),(9,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_083410','/data/www/config2_20180617_083410','/data/www/html2_20180617_132238','/data/www/config2_20180617_132238','32M /data/www/html2_20180617_132238 28K /data/www/config2_20180617_132238','Total Take:30 || Rsync Time:15 || Start App Time:6','2018-06-17 13:23:22','2018-06-17 13:23:37','2018-06-17 13:23:46','2018-06-17 13:23:52','1529241802189764300',0,0,0,2,NULL,0,NULL),(10,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_132238','/data/www/config1_20180617_132238','/data/www/html1_20180617_133826','/data/www/config1_20180617_133826','32M /data/www/html1_20180617_133826 24K /data/www/config1_20180617_133826','Total Take:29 || Rsync Time:15 || Start App Time:5','2018-06-17 13:39:01','2018-06-17 13:39:16','2018-06-17 13:39:25','2018-06-17 13:39:30','1529242741462875100',0,0,0,2,NULL,0,NULL),(11,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_132238','/data/www/config2_20180617_132238','/data/www/html2_20180617_133826','/data/www/config2_20180617_133826','32M /data/www/html2_20180617_133826 28K /data/www/config2_20180617_133826','Total Take:31 || Rsync Time:16 || Start App Time:6','2018-06-17 13:40:27','2018-06-17 13:40:43','2018-06-17 13:40:52','2018-06-17 13:40:58','1529242827806849600',0,0,0,2,NULL,0,NULL),(12,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_133826','/data/www/config1_20180617_133826','/data/www/html1_20180617_134609','/data/www/config1_20180617_134609','32M /data/www/html1_20180617_134609 24K /data/www/config1_20180617_134609','Total Take:29 || Rsync Time:14 || Start App Time:6','2018-06-17 13:47:19','2018-06-17 13:47:33','2018-06-17 13:47:42','2018-06-17 13:47:48','1529243239559014000',0,0,0,2,NULL,0,NULL),(13,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_133826','/data/www/config2_20180617_133826','/data/www/html2_20180617_134609','/data/www/config2_20180617_134609','32M /data/www/html2_20180617_134609 28K /data/www/config2_20180617_134609','Total Take:29 || Rsync Time:14 || Start App Time:6','2018-06-17 13:49:11','2018-06-17 13:49:25','2018-06-17 13:49:34','2018-06-17 13:49:40','1529243352025521200',0,0,0,2,NULL,0,NULL),(14,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_134609','/data/www/config1_20180617_134609','/data/www/html1_20180617_135555','/data/www/config1_20180617_135555','32M /data/www/html1_20180617_135555 24K /data/www/config1_20180617_135555','Total Take:29 || Rsync Time:14 || Start App Time:6','2018-06-17 13:56:30','2018-06-17 13:56:44','2018-06-17 13:56:53','2018-06-17 13:56:59','1529243790815502100',0,0,0,2,NULL,0,NULL),(15,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_134609','/data/www/config2_20180617_134609','/data/www/html2_20180617_135555','/data/www/config2_20180617_135555','32M /data/www/html2_20180617_135555 28K /data/www/config2_20180617_135555','Total Take:29 || Rsync Time:15 || Start App Time:5','2018-06-17 13:57:56','2018-06-17 13:58:11','2018-06-17 13:58:20','2018-06-17 13:58:25','1529243876582502400',0,0,0,2,NULL,0,NULL),(16,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_135555','/data/www/config1_20180617_135555','/data/www/html1_20180617_155907','/data/www/config1_20180617_155907','32M /data/www/html1_20180617_155907 24K /data/www/config1_20180617_155907','Total Take:34 || Rsync Time:18 || Start App Time:6','2018-06-17 16:00:42','2018-06-17 16:01:00','2018-06-17 16:01:10','2018-06-17 16:01:16','1529251243085588300',0,0,0,2,NULL,0,NULL),(17,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_135555','/data/www/config2_20180617_135555','/data/www/html2_20180617_155907','/data/www/config2_20180617_155907','32M /data/www/html2_20180617_155907 32K /data/www/config2_20180617_155907','Total Take:34 || Rsync Time:18 || Start App Time:6','2018-06-17 16:00:43','2018-06-17 16:01:01','2018-06-17 16:01:11','2018-06-17 16:01:17','1529251243441313400',0,0,0,2,NULL,0,NULL),(18,NULL,'server1','2018_0617','root','192.168.0.207',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-06-17 16:02:13',NULL,NULL,NULL,'1529251333428265900',0,0,0,NULL,NULL,1,NULL),(19,NULL,'server2','2018_0617','root','192.168.0.76',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2018-06-17 16:02:13',NULL,NULL,NULL,'1529251333802441000',0,0,0,NULL,NULL,1,NULL),(20,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_155907','/data/www/config1_20180617_155907','/data/www/html1_20180617_160305','/data/www/config1_20180617_160305','32M /data/www/html1_20180617_160305 24K /data/www/config1_20180617_160305','Total Take:34 || Rsync Time:18 || Start App Time:6','2018-06-17 16:03:06','2018-06-17 16:03:24','2018-06-17 16:03:34','2018-06-17 16:03:40','1529251386265171300',0,0,0,2,NULL,0,NULL),(21,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_155907','/data/www/config2_20180617_155907','/data/www/html2_20180617_160305','/data/www/config2_20180617_160305','32M /data/www/html2_20180617_160305 32K /data/www/config2_20180617_160305','Total Take:35 || Rsync Time:19 || Start App Time:7','2018-06-17 16:03:06','2018-06-17 16:03:25','2018-06-17 16:03:34','2018-06-17 16:03:41','1529251386683365600',0,0,0,2,NULL,0,NULL),(22,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_160305','/data/www/config1_20180617_160305','/data/www/html1_20180617_161312','/data/www/config1_20180617_161312','32M /data/www/html1_20180617_161312 24K /data/www/config1_20180617_161312','Total Take:27 || Rsync Time:12 || Start App Time:6','2018-06-17 16:14:11','2018-06-17 16:14:23','2018-06-17 16:14:32','2018-06-17 16:14:38','1529252051628782000',0,0,0,2,NULL,0,NULL),(23,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_160305','/data/www/config2_20180617_160305','/data/www/html2_20180617_161520','/data/www/config2_20180617_161520','32M /data/www/html2_20180617_161520 32K /data/www/config2_20180617_161520','Total Take:26 || Rsync Time:12 || Start App Time:5','2018-06-17 16:16:18','2018-06-17 16:16:30','2018-06-17 16:16:39','2018-06-17 16:16:44','1529252178354363800',0,0,0,2,NULL,0,NULL),(24,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_161312','/data/www/config1_20180617_161312','/data/www/html1_20180617_162206','/data/www/config1_20180617_162206','32M /data/www/html1_20180617_162206 24K /data/www/config1_20180617_162206','Total Take:26 || Rsync Time:12 || Start App Time:5','2018-06-17 16:22:36','2018-06-17 16:22:48','2018-06-17 16:22:57','2018-06-17 16:23:02','1529252556760871000',0,0,0,2,NULL,0,NULL),(25,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_161520','/data/www/config2_20180617_161520','/data/www/html2_20180617_162344','/data/www/config2_20180617_162344','32M /data/www/html2_20180617_162344 32K /data/www/config2_20180617_162344','Total Take:26 || Rsync Time:13 || Start App Time:5','2018-06-17 16:24:16','2018-06-17 16:24:29','2018-06-17 16:24:37','2018-06-17 16:24:42','1529252656314127100',0,0,0,2,NULL,0,NULL),(26,NULL,'server1','2018_0617','root','192.168.0.207',NULL,'/data/www/html1_20180617_162206','/data/www/config1_20180617_162206','/data/www/html1_20180617_163118','/data/www/config1_20180617_163118','32M /data/www/html1_20180617_163118 24K /data/www/config1_20180617_163118','Total Take:27 || Rsync Time:13 || Start App Time:5','2018-06-17 16:32:18','2018-06-17 16:32:31','2018-06-17 16:32:40','2018-06-17 16:32:45','1529253138982678800',0,0,0,2,NULL,0,NULL),(27,NULL,'server2','2018_0617','root','192.168.0.76',NULL,'/data/www/html2_20180617_162344','/data/www/config2_20180617_162344','/data/www/html2_20180617_163316','/data/www/config2_20180617_163316','32M /data/www/html2_20180617_163316 32K /data/www/config2_20180617_163316','Total Take:25 || Rsync Time:12 || Start App Time:5','2018-06-17 16:34:16','2018-06-17 16:34:28','2018-06-17 16:34:36','2018-06-17 16:34:41','1529253256509037300',0,0,0,2,NULL,0,NULL),(28,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180617_163118','/data/www/config1_20180617_163118','/data/www/html1_20180618_024512','/data/www/config1_20180618_024512','32M /data/www/html1_20180618_024512 24K /data/www/config1_20180618_024512','Total Take:31 || Rsync Time:16 || Start App Time:5','2018-06-18 02:46:28','2018-06-18 02:46:44','2018-06-18 02:46:54','2018-06-18 02:46:59','1529289989095777400',0,0,0,2,NULL,0,NULL),(29,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180618_024512','/data/www/config1_20180618_024512','/data/www/html1_20180618_025953','/data/www/config1_20180618_025953','32M /data/www/html1_20180618_025953 24K /data/www/config1_20180618_025953','Total Take:26 || Rsync Time:12 || Start App Time:5','2018-06-18 03:00:57','2018-06-18 03:01:09','2018-06-18 03:01:18','2018-06-18 03:01:23','1529290857112687700',0,0,0,2,NULL,0,NULL),(30,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180618_025953','/data/www/config1_20180618_025953','/data/www/html1_20180618_030439','/data/www/config1_20180618_030439','32M /data/www/html1_20180618_030439 24K /data/www/config1_20180618_030439','Total Take:26 || Rsync Time:12 || Start App Time:5','2018-06-18 03:05:44','2018-06-18 03:05:56','2018-06-18 03:06:05','2018-06-18 03:06:10','1529291144138571300',0,0,0,2,NULL,0,NULL),(31,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'/data/www/html2_20180617_163316','/data/www/config2_20180617_163316','/data/www/html2_20180618_030644','/data/www/config2_20180618_030644','32M /data/www/html2_20180618_030644 32K /data/www/config2_20180618_030644','Total Take:27 || Rsync Time:13 || Start App Time:5','2018-06-18 03:07:48','2018-06-18 03:08:01','2018-06-18 03:08:10','2018-06-18 03:08:15','1529291268978126000',0,0,0,2,NULL,0,NULL),(32,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'/data/www/html2_20180618_030644','/data/www/config2_20180618_030644','/data/www/html2_20180618_032005','/data/www/config2_20180618_032005','32M /data/www/html2_20180618_032005 32K /data/www/config2_20180618_032005','Total Take:34 || Rsync Time:18 || Start App Time:6','2018-06-18 03:21:36','2018-06-18 03:21:54','2018-06-18 03:22:04','2018-06-18 03:22:10','1529292096433097300',0,0,0,2,NULL,0,NULL),(33,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180618_030439','/data/www/config1_20180618_030439','/data/www/html1_20180618_094157','/data/www/config1_20180618_094157','32M /data/www/html1_20180618_094157 24K /data/www/config1_20180618_094157','Total Take:28 || Rsync Time:14 || Start App Time:5','2018-06-18 09:42:34','2018-06-18 09:42:48','2018-06-18 09:42:57','2018-06-18 09:43:02','1529314954700488100',0,0,0,2,NULL,0,NULL),(34,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'/data/www/html2_20180618_032005','/data/www/config2_20180618_032005','/data/www/html2_20180618_094338','/data/www/config2_20180618_094338','32M /data/www/html2_20180618_094338 32K /data/www/config2_20180618_094338','Total Take:29 || Rsync Time:14 || Start App Time:5','2018-06-18 09:44:12','2018-06-18 09:44:26','2018-06-18 09:44:36','2018-06-18 09:44:41','1529315053031154000',0,0,0,2,NULL,0,NULL),(35,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180618_094157','/data/www/config1_20180618_094157','/data/www/html1_20180618_104320','/data/www/config1_20180618_104320','32M /data/www/html1_20180618_104320 24K /data/www/config1_20180618_104320','Total Take:35 || Rsync Time:20 || Start App Time:5','2018-06-18 10:44:49','2018-06-18 10:45:09','2018-06-18 10:45:19','2018-06-18 10:45:24','1529318689586675600',0,0,0,2,NULL,0,NULL),(36,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'/data/www/html2_20180618_094338','/data/www/config2_20180618_094338','/data/www/html2_20180618_104320','/data/www/config2_20180618_104320','32M /data/www/html2_20180618_104320 24K /data/www/config2_20180618_104320','Total Take:36 || Rsync Time:20 || Start App Time:6','2018-06-18 10:44:49','2018-06-18 10:45:09','2018-06-18 10:45:19','2018-06-18 10:45:25','1529318689907501400',0,0,0,2,NULL,0,NULL),(37,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180618_104320','/data/www/config1_20180618_104320','/data/www/html1_20180618_105022','/data/www/config1_20180618_105022','48K /data/www/html1_20180618_105022 24K /data/www/config1_20180618_105022','Total Take:22 || Rsync Time:7 || Start App Time:6','2018-06-18 10:51:05','2018-06-18 10:51:12','2018-06-18 10:51:21','2018-06-18 10:51:27','1529319065065922600',0,0,0,2,NULL,0,NULL),(38,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'/data/www/html2_20180618_104320','/data/www/config2_20180618_104320','/data/www/html2_20180618_105022','/data/www/config2_20180618_105022','48K /data/www/html2_20180618_105022 24K /data/www/config2_20180618_105022','Total Take:23 || Rsync Time:7 || Start App Time:7','2018-06-18 10:51:05','2018-06-18 10:51:12','2018-06-18 10:51:21','2018-06-18 10:51:28','1529319065420395000',0,0,0,2,NULL,0,NULL),(39,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'html1_20180617_161312','/data/www/config1_20180618_105022','/data/www/html1_20180618_105402','/data/www/config1_20180618_105402','48K /data/www/html1_20180618_105402 24K /data/www/config1_20180618_105402','Total Take:22 || Rsync Time:7 || Start App Time:5','2018-06-18 10:54:57','2018-06-18 10:55:04','2018-06-18 10:55:14','2018-06-18 10:55:19','1529319297258293900',0,0,1,2,NULL,0,NULL),(40,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'html2_20180617_160305','/data/www/config2_20180618_105022','/data/www/html2_20180618_105402','/data/www/config2_20180618_105402','48K /data/www/html2_20180618_105402 24K /data/www/config2_20180618_105402','Total Take:23 || Rsync Time:8 || Start App Time:6','2018-06-18 10:54:57','2018-06-18 10:55:05','2018-06-18 10:55:14','2018-06-18 10:55:20','1529319297677681500',0,0,1,2,NULL,0,NULL),(41,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180618_105402','/data/www/config1_20180618_105402','html1_20180617_161312','/data/www/config1_20180618_105022','du: æ— æ³•è®¿é—®\"html1_20180617_161312\": æ²¡æœ‰é‚£ä¸ªæ–‡ä»¶æˆ–ç›®å½•\n24K /data/www/config1_20180618_105022','Total Take:13  || Start App Time:6','2018-06-18 10:56:13',NULL,'2018-06-18 10:56:20','2018-06-18 10:56:26','1529319373482825500',1,0,0,2,NULL,0,NULL),(42,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'/data/www/html2_20180618_105402','/data/www/config2_20180618_105402','html2_20180617_160305','/data/www/config2_20180618_105022','du: æ— æ³•è®¿é—®\"html2_20180617_160305\": æ²¡æœ‰é‚£ä¸ªæ–‡ä»¶æˆ–ç›®å½•\n24K /data/www/config2_20180618_105022','Total Take:13  || Start App Time:6','2018-06-18 10:56:13',NULL,'2018-06-18 10:56:20','2018-06-18 10:56:26','1529319373850422900',1,0,0,2,NULL,0,NULL),(43,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'html1_20180617_161312','/data/www/config1_20180618_105022','/data/www/html1_20180618_105728','/data/www/config1_20180618_105728','48K /data/www/html1_20180618_105728 24K /data/www/config1_20180618_105728','Total Take:23 || Rsync Time:7 || Start App Time:6','2018-06-18 10:58:14','2018-06-18 10:58:21','2018-06-18 10:58:31','2018-06-18 10:58:37','1529319494325700800',0,0,1,2,NULL,0,NULL),(44,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'html2_20180617_160305','/data/www/config2_20180618_105022','/data/www/html2_20180618_105728','/data/www/config2_20180618_105728','48K /data/www/html2_20180618_105728 24K /data/www/config2_20180618_105728','Total Take:23 || Rsync Time:7 || Start App Time:6','2018-06-18 10:58:14','2018-06-18 10:58:21','2018-06-18 10:58:31','2018-06-18 10:58:37','1529319494658520900',0,0,1,2,NULL,0,NULL),(45,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'/data/www/html1_20180618_105728','/data/www/config1_20180618_105728','html1_20180617_161312','/data/www/config1_20180618_105022','du: æ— æ³•è®¿é—®\"html1_20180617_161312\": æ²¡æœ‰é‚£ä¸ªæ–‡ä»¶æˆ–ç›®å½•\n24K /data/www/config1_20180618_105022','Total Take:13  || Start App Time:6','2018-06-18 10:59:21',NULL,'2018-06-18 10:59:28','2018-06-18 10:59:34','1529319562030115300',1,0,0,2,NULL,0,NULL),(46,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'/data/www/html2_20180618_105728','/data/www/config2_20180618_105728','html2_20180617_160305','/data/www/config2_20180618_105022','du: æ— æ³•è®¿é—®\"html2_20180617_160305\": æ²¡æœ‰é‚£ä¸ªæ–‡ä»¶æˆ–ç›®å½•\n24K /data/www/config2_20180618_105022','Total Take:13  || Start App Time:6','2018-06-18 10:59:22',NULL,'2018-06-18 10:59:29','2018-06-18 10:59:35','1529319562622154700',1,0,0,2,NULL,0,NULL),(47,NULL,'server1','2018_0618','root','192.168.0.207',NULL,'html1_20180617_161312','/data/www/config1_20180618_105022','/data/www/html1_20180618_145946','/data/www/config1_20180618_145946','32M /data/www/html1_20180618_145946 24K /data/www/config1_20180618_145946','Total Take:29 || Rsync Time:14 || Start App Time:6','2018-06-18 15:00:59','2018-06-18 15:01:13','2018-06-18 15:01:22','2018-06-18 15:01:28','1529334059210285600',0,0,0,2,NULL,0,NULL),(48,NULL,'server2','2018_0618','root','192.168.0.76',NULL,'html2_20180617_160305','/data/www/config2_20180618_105022','/data/www/html2_20180618_145946','/data/www/config2_20180618_145946','32M /data/www/html2_20180618_145946 24K /data/www/config2_20180618_145946','Total Take:29 || Rsync Time:14 || Start App Time:6','2018-06-18 15:02:58','2018-06-18 15:03:12','2018-06-18 15:03:21','2018-06-18 15:03:27','1529334178964932700',0,0,0,2,NULL,0,NULL),(49,NULL,'server1','2018_0621','root','192.168.0.207',NULL,'/data/www/html1_20180618_145946','/data/www/config1_20180618_145946','/data/www/html1_20180621_161054','/data/www/config1_20180621_161054','32M /data/www/html1_20180621_161054 24K /data/www/config1_20180621_161054','Total Take:28 || Rsync Time:14 || Start App Time:5','2018-06-21 16:11:57','2018-06-21 16:12:11','2018-06-21 16:12:20','2018-06-21 16:12:25','1529597517754529000',0,0,0,2,NULL,0,NULL),(50,NULL,'server2','2018_0621','root','192.168.0.76',NULL,'/data/www/html2_20180618_145946','/data/www/config2_20180618_145946','/data/www/html2_20180621_161054','/data/www/config2_20180621_161054','32M /data/www/html2_20180621_161054 24K /data/www/config2_20180621_161054','Total Take:29 || Rsync Time:13 || Start App Time:6','2018-06-21 16:13:49','2018-06-21 16:14:02','2018-06-21 16:14:12','2018-06-21 16:14:18','1529597629114265100',0,0,0,2,NULL,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_deploy_status`
--

LOCK TABLES `pre_deploy_status` WRITE;
/*!40000 ALTER TABLE `pre_deploy_status` DISABLE KEYS */;
INSERT INTO `pre_deploy_status` VALUES (1,NULL,'server1','2018_0621','root','192.168.0.207',NULL,NULL,NULL,NULL,NULL,NULL,'2018-06-21 16:11:57',NULL,0,NULL),(2,NULL,'server2','2018_0621','root','192.168.0.76',NULL,NULL,NULL,NULL,NULL,NULL,'2018-06-21 16:13:49',NULL,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
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
  `checkurl_status` int(11) DEFAULT '1' COMMENT '校验url',
  `differcount` varchar(255) DEFAULT NULL COMMENT '变化校验',
  `weight` varchar(255) DEFAULT NULL COMMENT '权重',
  `loadBalancerId` text COMMENT '负载均衡ID',
  `logfile` varchar(255) DEFAULT NULL COMMENT 'æ—¥å¿—æ–‡ä»¶',
  `url` varchar(255) DEFAULT NULL COMMENT 'url',
  `header` text COMMENT 'header',
  `params` text COMMENT 'post参数',
  `require` varchar(255) DEFAULT NULL COMMENT '返回校验',
  `requirecode` varchar(255) DEFAULT NULL COMMENT '期望状态码',
  `checkdir` text COMMENT '校验更新文件',
  `predir` text COMMENT 'http包合并下层路径',
  `local_pro_cmd` text COMMENT '待发布包之前的工程初始化操作',
  `local_conf_cmd` text COMMENT '待发布包之前的配置初始化操作',
  `is_restart_status` int(11) DEFAULT '0' COMMENT '不需要启动和关闭应用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_server_detail`
--

LOCK TABLES `pre_server_detail` WRITE;
/*!40000 ALTER TABLE `pre_server_detail` DISABLE KEYS */;
INSERT INTO `pre_server_detail` VALUES (1,'','','后台服务集群1','127.0.0.1','192.168.0.207','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/config1','/data/www/html1','/data/log/server1','tomcat-server1','/etc/init.d/tomcat-server1','6080','centos7.1','','','1','2018-03-21 10:29:50','2018-03-21 10:29:50','server','server','server1','2','/usr/local/tomcat-server1','','','','1',0,0,'',NULL,'test',NULL,0,1,'{\"app_key\":\"server1\",\"prodiffercount\":\"0,0,0,0\",\"confdiffercount\":\"0,0,0,0\"}','10,10','lb-0101010101,lb-0202020202','catalina.#%Y-%m-%d.log','http://127.0.0.1:6080/packController/runCmd.do?cmd=uptime','Content-Type:application/json','{\"cmd\":\"uptime\"}','inputStr','200','test,b.txt',NULL,NULL,'time=$(date \'+%s\') &&  njsver=\"1.1.${time}\" && jsver=$(cat config.properties |grep -n  \'jsver\' |head -n 1 | grep -P \'\\d{1,}.\\d{1,}.\\d{1,}\' -o) && sed -i \"s/${jsver}/${njsver}/\" config.properties ',0),(2,'','','后台服务集群2','127.0.0.1','192.168.0.76','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/config2','/data/www/html2','/data/log/server2','tomcat-server2','/etc/init.d/tomcat-server2','7080','centos7.1','','','1','2018-03-21 10:30:15','2018-03-21 10:30:15','server','server','server2','2','/usr/local/tomcat-server2','','','','1',0,0,'',NULL,'test',NULL,0,1,'{\"app_key\":\"server2\",\"prodiffercount\":\"0,0,0,0\",\"confdiffercount\":\"0,0,0,0\"}','10,10','lb-0101010101,lb-0202020202','catalina.#%Y-%m-%d.log','http://127.0.0.1:7080/packController/runCmd.do?cmd=uptime','Content-Type:application/json','{\"cmd\":\"uptime\"}','inputStr','200','test,b.txt',NULL,NULL,'time=$(date \'+%s\') &&  njsver=\"1.1.${time}\" && jsver=$(cat config.properties |grep -n  \'jsver\' |head -n 1 | grep -P \'\\d{1,}.\\d{1,}.\\d{1,}\' -o) && sed -i \"s/${jsver}/${njsver}/\" config.properties ',0),(3,'','','调度服务集群1','127.0.0.1','127.0.0.1','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/flow1/WEB-INF/classes/','/data/www/flow1','/data/log/flow1','tomcat-flow1','/etc/init.d/tomcat-flow1','8080','centos7.1','','','1','2018-03-21 10:30:19','2018-03-21 10:30:19','flow','flow','flow1','1','/usr/local/tomcat-flow1','','','','1',0,0,'',NULL,'test','config.properties,applicationContext.xml,log4j.properties,generatorConfig.xml',1,1,NULL,NULL,NULL,'catalina.#%Y-%m-%d.log',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0),(4,'','','调度服务集群2','127.0.0.1','172.17.0.3','4核','8GB','100G(本地盘)',NULL,NULL,'tomcat','/data/www/flow2/WEB-INF/classes/','/data/www/flow2','/data/log/flow2','tomcat-flow2','/etc/init.d/tomcat-flow2','9080','centos7.1','','','1','2018-03-21 10:30:22','2018-03-21 10:30:22','flow','flow','flow2','1','/usr/local/tomcat-flow2','','','','1',0,0,'',NULL,'test','config.properties,applicationContext.xml,log4j.properties,generatorConfig.xml',1,1,NULL,NULL,NULL,'catalina.#%Y-%m-%d.log',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0);
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

-- Dump completed on 2018-06-23  5:31:29
