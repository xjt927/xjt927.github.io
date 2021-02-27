---
title: Linux下忘记数据库密码
abbrlink: 1da03c31
date: 2021-2-21 18:18:10
tags:
categories:
keywords: 
---

一、停止数据库服务

进入到数据库安装目录下

```
cd /usr/local/mysql/bin
```

使用 service 脚本停止服务：

```
service mysql stop
```

二、修改/etc/my.cnf配置文件

```
[mysqld]
#登录时跳过密码
skip-grant-tables
```

三、启动数据库服务

```
service mysql start
```

 四、登录数据库

```
/usr/local/mysql/bin/mysql -uroot -p 
```

出现Enter password: 时直接按回车进入。

五、修改密码

进入MySql控制台（直接按回车，这时不需要输入root密码。）

 切换到mysql数据库
 	 mysql>use mysql;

修改mysql数据库中root的密码

<u>**注意**：这里不同的数据库版本会有不同：mysql，5.7之前的版本是password字段，5.7之后该字段改为了authentication_string里可以用：desc 表明；查看表结构确认具体字段信息</u>

```
alter user 'root'@'localhost' identified by '数据库密码';
或
set password for root@localhost=password('你的密码');


5.7之后该字段改为了authentication_string
 update user set authentication_string=password('填入新密码') where user='root';
```

刷新mysql权限，再执行：

```
flush privileges;
```



六、将步骤二中的`skip-grant-tables`删除，重启服务就ok了。exit退出