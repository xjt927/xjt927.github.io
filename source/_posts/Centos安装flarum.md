---
title: Centos安装flarum
tags:
  - Centos
  - flarum
categories: Centos
keywords: 'Centos,flarum'
abbrlink: d92b3d0a
date: 2018-06-09 19:58:34
---

# CentOS7 yum安装PHP7.2

1. 如果之前已经安装我们先卸载一下
```
yum -y remove php*
```

2. 由于linux的yum源不存在php7.x，所以我们要更改yum源
```
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm   
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm    
```

3. yum 安装php72w和各种拓展，选自己需要的即可
```
yum -y install php72w php72w-cli php72w-common php72w-devel php72w-embedded php72w-fpm php72w-gd php72w-mbstring php72w-mysqlnd php72w-opcache php72w-pdo php72w-xml
```
 <!-- more -->
# 安装Composer

1. 下载composer.phar 
```
curl -sS https://getcomposer.org/installer | php
```

2. 把composer.phar移动到环境下让其变成可执行 
```
mv composer.phar /usr/local/bin/composer
```

3. 测试
```
composer -V 
```
 输出：`Composer version 1.6.5 2018-05-04 11:44:59`