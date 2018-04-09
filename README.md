# Rexdeploy

Rexdeploy: 一个基于名字服务自动化平台（`终端版`）

[中文文档](https://book.osichina.net)

## 简单描述

RexDeploy是一个免客户端安装的管控平台，支持基于`名字服务的自动发布`，基于`名字服务的自动重启(启动与停止)`，以及基于`名字服务的日志集中式管理`，用户管理等，同时也支持`批量执行命令`，`文件分发`（`上传与下载`）等。

## 功能特点

* 批量命令执行
* 批量文件上传
* 批量文件下载
* 应用自动发布
* 应用自动回滚
* 应用自动重启
* 应用自动下载
* 配置自动下载
* 应用自动同步
* 应用命令执行
* 应用发布检查
* 支持并发执行
* 查看实时日志
* 集中日志下载
* 日志分析过滤
* 系统用户管理

## 为什么是Perl?

> 相信很多的人会问到，为什么是perl？
>
> devops兴起的年代，在编程语言当中，居然还有人在折腾perl语言。我想很多人会有这样的疑问。所以我就为什么是perl语言，简要的交代一下。首先rexdeploy 并不是近期产生，我于12年进入现在的公司一直到现在，在进入公司后2年，也就是2014年，那时候公司的快速发展，传统的手工运维并满足不了业务的需求。所以，那时候我就开始研究自动化，恰逢其会的看到一款基于[perl语言开源自动化管理框架](http://rex.osichina.net)，于是开始对它进行调研，经过一段时间的试用，发现它特别适合我们的业务方向，只需要简单的安装配置即可配合业务做很多的事情。所以后来去学习perl语言，去进行二次开发来满足我们业务的发展方向。目前该产品已经在我们生产线上使用了3年以上的时间。在运维行业提到最多的可能还是python语言，然后才是php，最后才是perl。这3P占据了运维行业90%的天下。到如今，我们不但有perl，也会有基于python或者基于php语言的运维平台。每个语言都有它的独到之处，`对于产品来说，只有最合适的业务的语言，才是最好的语言`。

## 说明

此自动化的系统是基于原生rex进行二次开发而成,这是第三个大版本了，目前放出的这个版本是`终端版`，web版本已开发完成，预计5月份将会放出。

此前放出过第一个版本，详情请撮：

[http://git.oschina.net/lookingdreamer/RexDeploy\_v1](http://git.oschina.net/lookingdreamer/RexDeploy_v1)

新版本git地址: 

RexDeployV3 码云地址: [https://gitee.com/lookingdreamer/RexDeployV3](https://gitee.com/lookingdreamer/RexDeployV3)  
RexDeployV3 Github地址: [https://github.com/LookingDreamer/RexDeployV3](https://github.com/LookingDreamer/RexDeployV3)  

有任何问题欢迎提issue

rex官方：[http://rexify.org/](http://rexify.org/)  
rex中文: [http://rex.osichina.net](http://rex.osichina.net/)  
rex github: [https://github.com/RexOps/Rex ](https://github.com/RexOps/Rex)

由于国内有时候访问不了rex官方，本人根据[官方git](https://github.com/RexOps/rexify-website)重新拉取了一份中文官方网站部署在搬瓦工上，有需要请自行浏览。
