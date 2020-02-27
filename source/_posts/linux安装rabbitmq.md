---
title: linux安装rabbitmq
abbrlink: fb99bc05
date: 2019-11-11 17:00:24
tags:
categories:
keywords:
---
一.安装erlang
yum install erlang

二.安装rabbitMQ
1.去官网查看最新版本，并下载
https://www.rabbitmq.com/releases/rabbitmq-server/

wget -c http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.15/rabbitmq-server-generic-unix-3.6.15.tar.xz

解压：
xz -d rabbitmq-server-generic-unix-3.6.15.tar.xz
tar -xvf rabbitmq-server-generic-unix-3.6.15.tar
vim /etc/profile

2.配置rabbitmq的环境变量
vim /etc/profile
export PATH=$PATH:/usr/local/rabbitmq_server-3.6.15/sbin
source /etc/profile

3.rabbitmq的基本操作：
启动：rabbitmq-server -detached
重启：service rabbitmq-server restart
关闭：rabbitmqctl stop
查看状态：rabbitmqctl status

4.配置rabbitmq网页管理插件
启用插件：rabbitmq-plugins enable rabbitmq_management
本地访问管理页面：http://127.0.0.1:15672
端口默认为15672
默认登陆账号密码：guest/guest
由于账号guest具有所有的操作权限，并且又是默认账号，出于安全因素的考虑，guest用户只能通过localhost登陆使用
