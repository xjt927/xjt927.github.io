---
title: Linux关闭防火墙命令
abbrlink: 62cb6811
date: 2019-12-09 22:24:56
tags:
categories:
keywords:
---
下面是red hat/CentOs7关闭防火墙的命令!

1:查看防火状态

systemctl status firewalld

service  iptables status

2:暂时关闭防火墙

systemctl stop firewalld

service  iptables stop

3:永久关闭防火墙

systemctl disable firewalld

chkconfig iptables off

4:重启防火墙

systemctl enable firewalld

service iptables restart  

5:永久关闭后重启

//暂时还没有试过

chkconfig iptables on