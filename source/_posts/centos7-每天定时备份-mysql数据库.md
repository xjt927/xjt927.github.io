---
title: centos7-每天定时备份 mysql数据库
tags: mysql 备份
categories: mysql
keywords: mysql 备份
abbrlink: b0c8090a
date: 2021-12-31 10:14:52
---



## 第一步：编写数据库备份脚本database_mysql_shell.sh



```
#!/bin/bash
DATE=`date +%Y%m%d%H%M`                #every minute
DATABASE=springboot-admin              #database name
DB_USERNAME=root                       #database username
DB_PASSWORD="mysql"                    #database password
BACKUP_PATH=/backup/mysqldata          #backup path

#backup command

/usr/bin/mysqldump -u$DB_USERNAME -p$DB_PASSWORD -h 127.0.0.1 -R --opt $DATABASE | gzip > ${BACKUP_PATH}\/${DATABASE}_${DATE}.sql.gz

#just backup the latest 5 days

find ${BACKUP_PATH} -mtime +5 -name "${DATABASE}_*.sql.gz" -exec rm -f {} \;
```

## 第二步：给脚本授权

```
chmod +x database_backup_shell.sh
```

## 第三步：编写定时备份任务

输入如下命令：

```
crontab -e
```

在页面中编写如下内容：

```
00 3 * * * /root/database_backup_shell.sh
```



转自[mysql备份](https://www.cnblogs.com/zuidongfeng/p/9416226.html)

