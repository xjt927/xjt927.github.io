---
title: 解决从github下载资源慢
abbrlink: 3d1f8262
date: 2019-12-08 21:04:13
tags:
categories:
keywords:
---
第一步：去这个网站查询3个域名对应的IP地址，不能用ping来获取IP地址哦

https://www.ipaddress.com/

第二步：在/etc/hosts文件中添加类似下面的3行
```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

140.82.114.4 github.com
199.232.5.194 github.global.ssl.fastly.net
140.82.113.10 codeload.github.com
185.199.108.153 assets-cdn.github.com
52.216.9.27 github-cloud.s3.amazonaws.com
52.216.206.51 github-production-release-asset-2e65be.s3.amazonaws.com
192.168.226.102 localhost
```
第三步：重启网络

```
sudo /etc/init.d/networking restart 
或
service network restart
```

现在可以飞快的下载Github上的代码了