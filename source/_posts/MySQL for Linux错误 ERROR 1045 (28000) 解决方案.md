---
title: 'MySQL for Linux错误 ERROR 1045 (28000) 解决方案'
date: 2020-10-10 15:25:31
tags:
---

登录mysql时报错：`ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)`

解决方式：

## 一、修改数据库密码

1. 修改 /etc/my.cnf 文件

   ```
   vim /etc/my.cnf
   ```

2. 在配置文件中[mysqld]后面任意一行添加“`skip-grant-tables`”用来跳过密码验证的过程

   保存并退出 :wq

3. 重启mysql服务器

  ```
  service mysql restart
  ```

4. 输入 `mysql`  进入 mysql 

   ```
   mysql> use mysql; //选择数据库
   mysql> update user set authentication_string=passworD("新密码") where user='root';//数据库是5.7以上的用该命令
   -- mysql> update user set password=password("你的新密码") where user="root";//数据库是5.以下的用该命令
   mysql> flush privileges;
   mysql> quit;
   ```

5. 编辑my.cnf，去掉刚才添加的内容，然后重启MySQL。大功告成！
6. 使用`mysql -u root -p`回车，输入密码登录mysql数据库。



如果找不到my.cnf或者my.ini文件，如果你是Linux,使用如下方式可以搜索到：

```
whereis my
```

如果是windows平台，去安装目录下找一下my.ini。



## 二、数据库远程访问授权

做完以上操作，登录Linux服务器使用命令行可以登录mysql，**使用navicat任然报1045的错误提示**。

1. 使用`select user,host,authentication_string from mysql.user;`命令查看root账号有没有远程访问权限。

   ![mark](http://blog.xuejiangtao.com/blog/20201010/zu0hfxk1hjyI.png?imageslim)

   可以看到root用户只有ip为localhost的访问权限。

2. 为root用户的远程访问授权，可以授权到指定的客户端IP，也可以授权为所有IP都可访问（host值为%）

```
执行以下命令：
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' ;
```

![mark](http://blog.xuejiangtao.com/blog/20201010/XcUBzSM0Ln5Q.png?imageslim)

3. 执行`mysql> flush privileges;`命令重载授权表。
4. 使用navicat连接数据库，搞定。



## 三、重要提醒

在对数据库进行远程数据库授权时，如果授权为%表示所有IP都可以访问，如果密码设置比较简单，被人撞库成功，可能会出现：

```
您需要支付0.03比特币（BTC）才能恢复数据库：blog_system, blog_system2, job。 如果您需要证明，请通过以下电子邮件与我们联系：mysqldumps@protonmail.com。


To recover your lost Database and avoid leaking it: Send us 0.03 Bitcoin (BTC) to our Bitcoin address 1J8jK64528P9CKJm8Sk5oY6eea2Qm5UHYK and contact us by Email with your Server IP or Domain name and a Proof of Payment. If you are unsure if we have your data, contact us and we will send you a proof. Your Database is downloaded and backed up on our servers. Backups that we have right now: job. If we dont receive your payment in the next 10 Days, we will make your database public or use them otherwise.
```

