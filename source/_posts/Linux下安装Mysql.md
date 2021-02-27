---
title: Linux下安装Mysql
abbrlink: 1da03cb6
date: 2019-11-21 18:18:10
tags:
categories:
keywords:
---
# 一、 MySQL数据库卸载



## 二进制包方式安装卸载

1. **查看是否安装MySQL**

```
rpm -qa|grep -i mysql
```

2. **停止mysql服务、删除之前安装的mysql**

   删除命令：**`rpm -e –nodeps 包名`**

   ```
   　　rpm -ev MySQL-client-5.5.25a-1.rhel5
   　　rpm -ev MySQL-server-5.5.25a-1.rhel5
   ```

3. **查找之前老版本mysql的目录、并且删除老版本mysql的文件和库**

   ```
   find / -name mysql
   
   # 查询到的结果
   /var/lib/mysql
   /var/lib/mysql/mysql
   /usr/lib64/mysql  
   ```

   删除目录

   ```
   rm -rf /var/lib/mysql /var/lib/mysql/mysql /usr/lib64/mysql
   ```

   删除配置文件

   ```
   rm -rf /etc/my.cnf
   ```



## rpm包安装方式卸载

```
查包名：rpm -qa|grep -i mysql
删除命令：rpm -e –nodeps 包名
```



## yum安装方式下载

``` 
1.查看已安装的mysql
命令：rpm -qa | grep -i mysql

2.卸载mysql
命令：yum remove mysql-community-server-5.6.36-2.el7.x86_64
查看mysql的其它依赖：rpm -qa | grep -i mysql  

3.卸载依赖
yum remove mysql-libs
yum remove mysql-server
yum remove perl-DBD-MySQL
yum remove mysql

```



# 二、 安装MySQL



1. 下载mysql安装包

   在这里下载的是如下版本的mysql，下载完毕后上传到linux服务器

  ```
  https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz
  ```

​	或者直接wget下载

```
 cd /usr/local/
 wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz
```

2. 解压
  ```
	tar -xzvf  mysql-5.7.26-linux-glibc2.12-x86_64.tar.gz
	mv mysql-5.7.26-linux-glibc2.12-x86_64/ mysql
  ```

3. 添加mysql用户组和mysql用户，添加完使用groups mysql查看是否添加成功

```
 groupadd mysql
 useradd -r -g mysql mysql
 groups mysql
```

将安装目录所有者及所属组改为mysql

```
chown -R mysql.mysql /usr/local/mysql
```

创建data文件夹，用于存放数据库表之类的数据

```
mkdir data #进入mysql文件夹
```

4. 安装依赖包

```
 yum install libaio
```
初始化

```
 /usr/local/mysql/bin/mysqld --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data --initialize
```

注意这里是生成的数据库临时密码，记录日志最末尾位置**root@localhost:**后的字符串

![mark](http://blog.xuejiangtao.com/blog/20210219/Rg6qbMXQAY2m.png?imageslim)

5. 编辑配置文件

 ```
/etc/my.cnf
 ```

在配置文件中写入以下内容

```
[mysqld]
datadir=/usr/local/mysql/data
basedir=/usr/local/mysql
socket=/tmp/mysql.sock
user=mysql
port=3306
character-set-server=utf8
 
# skip-grant-tables
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

6. 将mysql加入到服务中

   ```
   cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
   ```

7.  开机启动

   ```
   chkconfig mysql on
   ```

8. 启动服务

   ```
   service mysql start
   ```

9. 登陆数据库

```
/usr/local/mysql/bin/mysql -uroot -p
```

10. 设置新的Mysql密码（不再使用临时密码）

    ```
    alter user 'root'@'localhost' identified by '数据库密码';
    ```

11. 授权root允许远程访问（可视化软件可以建立链接）

    必须登录mysql才能执行下面命令

```
grant all privileges on *.* to 'root'@'%' identified by '数据库密码';
flush privileges;
```

