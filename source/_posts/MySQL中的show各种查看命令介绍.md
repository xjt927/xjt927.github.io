---
title: MySQL中的show各种查看命令介绍
abbrlink: 7ef7296d
date: 2021-02-28 10:52:13
tags:
categories:
keywords:
---

# 1.使用show查看

show databases; 
解释：显示mysql中所有数据库的名称

show tables或show tables from database_name; 
解释：显示当前数据库中所有表的名称

show processlist;
解释：显示系统中正在运行的所有进程，也就是当前正在执行的查询。大多数用户可以查看
他们自己的进程，但是如果他们拥有process权限，就可以查看所有人的进程，包括密码。

show table status;
解释：显示当前使用或者指定的database中的每个表的信息。信息包括表类型和表的最新更新时间

show columns from table_name from database_name; 或show columns from database_name.table_name;
解释：显示表中列名称

show grants for user_name@localhost;
解释：显示一个用户的权限，显示结果类似于grant 命令

show index from table_name;
解释：显示表的索引

show status;
解释：显示一些系统特定资源的信息，例如，正在运行的线程数量

show variables;
解释：显示系统变量的名称和值

show privileges;
解释：显示服务器所支持的不同权限

show create database database_name;
解释：显示create database 语句是否能够创建指定的数据库

show create table table_name;
解释：显示create database 语句是否能够创建指定的数据库

show engies;
解释：显示安装以后可用的存储引擎和默认引擎。

show innodb status;
解释：显示innoDB存储引擎的状态

show logs;
解释：显示BDB存储引擎的日志

show warnings;
解释：显示最后一个执行的语句所产生的错误、警告和通知

show errors;
解释：只显示最后一个执行语句所产生的错误

show version（）；
解释：查看数据库版本

# 2.select查看

select @@port	
解释：查看端口

select@@basedir;
解释：查看数据库安装路径

select @@datadir;
解释：查看数据文件路径

select @@socket;
解释：查看套接字文件位置

select version（）；
解释：查看MySQL版本

select now（）；
解释：查看当前时间

select @@server_id;
解释：查看MySQL的PID 