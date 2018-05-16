ALTER TABLE `pre_server_detail`
ADD COLUMN `loadBalancerId`  text NULL COMMENT '负载均衡ID' AFTER `configure_file_status`;
ALTER TABLE `pre_server_detail`
ADD COLUMN `url`  varchar(255) NULL COMMENT 'url';
ALTER TABLE `pre_server_detail`
ADD COLUMN `header`  text NULL COMMENT 'header' ;
ALTER TABLE `pre_server_detail`
ADD COLUMN `params`  text NULL COMMENT 'post参数' ;
ALTER TABLE `pre_server_detail`
ADD COLUMN `require`  varchar(255) NULL COMMENT '返回校验' ;
ALTER TABLE `pre_server_detail`
ADD COLUMN `requirecode`  varchar(255) NULL COMMENT '期望状态码' ;
ALTER TABLE `pre_server_detail`
ADD COLUMN `weight`   varchar(255) NULL COMMENT '权重' AFTER `configure_file_status`;
ALTER TABLE `pre_server_detail`
ADD COLUMN `differcount`   varchar(255) NULL COMMENT '变化校验' AFTER `configure_file_status`;
ALTER TABLE `pre_server_detail`
ADD COLUMN `checkurl_status`   int DEFAULT 1 COMMENT '校验url' AFTER `configure_file_status`;
CREATE TABLE `load_key_sorts` (
`id`  int(11) NULL ,
`local_name`  varchar(255) NULL COMMENT '识别名称' ,
`app_key_sort`  text NULL COMMENT '排序关键词' 
);
ALTER TABLE `pre_server_detail`
ADD COLUMN `checkdir`  text NULL  COMMENT '校验更新文件' ;