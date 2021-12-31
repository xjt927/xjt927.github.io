---
title: vm虚拟机CentOS网络设置
abbrlink: 7d1dfc54
date: 2021-04-27 09:21:29
tags:
categories:
keywords:
---

在vm虚拟机上安装了centos系统后ping www.baidu.com的时候 报出 name or service not known

解决办法：

1. **网络配置查看**

**![img](https://images2017.cnblogs.com/blog/875642/201710/875642-20171025110943863-1800103861.png)**

![img](https://images2017.cnblogs.com/blog/875642/201710/875642-20171025111141066-1331123476.png)

![img](https://images2017.cnblogs.com/blog/875642/201710/875642-20171025111216738-1335885432.png)

记住NAT设置中的子网IP、子网掩码、网关IP三项，接下来配置文件主要是这三项。

2. **编辑Linux中的网络配置文件**

```
vi /etc/sysconfig/network-scripts/ifcfg-ens33  #注 网络配置文件名可能会有不同，在输入到ifcfg时，可以连续按两下tab键，获取提示，比如我的机器 为 ifcfg-ens33
```

内容替换如下：

```
TYPE=”Ethernet” 
BOOTPROTO=”static” #静态连接 
NAME=”ens33” 
UUID=”1f093d71-07de-4ca5-a424-98e13b4e9532” 
DEVICE=”ens33” 
ONBOOT=”yes” #网络设备开机启动 
IPADDR=”192.168.0.101” #192.168.59.x, x为3~255. 
NETMASK=”255.255.255.0” #子网掩码 
GATEWAY=”192.168.66.2” #网关IP
```

3. **DNS文件配置**

   添加dns服务器 vi /etc/resolv.conf 

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

4. **重启网络服务**

```
service network restart
```

5. **测试效果**

```
ping www.baidu.com
```

