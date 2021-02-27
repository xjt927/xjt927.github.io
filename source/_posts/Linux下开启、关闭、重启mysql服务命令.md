---
title: Linux下开启、关闭、重启mysql服务命令
abbrlink: 1da03c34
date: 2021-2-21 18:18:10
tags:
categories:
keywords: 
---
进入到数据库安装目录下

```
cd /usr/local/mysql/bin
```

**一、 启动**
1、使用 service 脚本启动：service mysql start
2、使用 mysqld 脚本启动：/etc/inint.d/mysql start
3、使用 safe_mysqld 启动：safe_mysql&



**二、停止**
1、使用 service 脚本停止：service mysql stop
2、使用 mysqld 脚本停止：/etc/inint.d/mysql stop
3、mysqladmin shutdown



**三、重启**
1、使用 service 脚本启动：service mysql restart
2、使用 mysqld 脚本启动：/etc/inint.d/mysql restart



**四、查看mysql状态**

\>>mysql

