---
title: Linux下开启/关闭防火墙命令
abbrlink: '92666433'
date: 2020-10-10 17:08:22
tags:
categories:
keywords:
---

## 使用以下命令开启、关闭防火墙

   ```
# 查看防火墙状态： 
systemctl status firewalld

# 开启防火墙： 
systemctl start firewalld

# 关闭防火墙：
systemctl stop firewalld

# 设置开机启动：
systemctl enable firewalld

# 禁用开机启动：
systemctl disable firewalld

# 重启防火墙（每次修改都要重启）：
firewall-cmd --reload

# 开放端口（修改后需要重启防火墙方可生效）：
firewall-cmd --permanent --zone=public --add-port=8080/tcp

# 关闭端口：
firewall-cmd --permanent --zone=public --remove-port=8080/tcp

# 查看开放的端口： 
firewall-cmd --list-ports
   ```

或者使用下面命令

   ```
# 查看防火墙状态：systemctl status firewalld
# 开启：service firewalld start
# 重启：service firewalld restart
# 关闭：service firewalld stop
   ```

## linux防火墙开启后无法访问tomcat

**通过开放centos7防火墙的端口：**

```
添加开放端口   			firewall-cmd --permanent --zone=public --add-port=8080/tcp
重启防火墙		  		 firewall-cmd --reload
检查是否生效   			firewall-cmd --zone=public --query-port=8080/tcp
```

同样的可以开放3306等端口。

