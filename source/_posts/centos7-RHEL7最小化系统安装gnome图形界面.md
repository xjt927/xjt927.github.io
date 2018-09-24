---
title: centos7/RHEL7最小化系统安装gnome图形界面
date: 2018-05-21 19:42:49
tags: Centos
categories: Centos
keywords: Centos
---

[Linux CentOS 7安装GNOME图形界面并设置默认启动方式][1]

[centos7/RHEL7最小化系统安装gnome图形界面][2]


应用场景：对于比较熟悉linux系统的用户来说，全命令行系统可能来的比较简单明了高效，也存在某些情况下需要有像winodws下弹出对话框的情形需求，或者对于初识linux习惯windows界面的用户来说，桌面版更加方便点。

 

测试环境：一台安装了CentOS-7-x86_64-Minimal-1511.iso的虚拟机，也就是最小化安装的centos7.2（同版本RHEL7适用）。

 

具体操作：

　　1.查看需要安装的软件包

　　　　~]# yum grouplist 　　　　//前提要配置好自己的yum源或者能够连接到网上的源

　　　　　　

　　　　　　可以在Available Environment Groups:列表中看见各种包，这里我选择显示的GNMOE Desktop

　　　　　　注：有版本可能安装的是X Window System，不用在意，安装自己列表中存在的软件包即可。

 

　　2.安装软件包

　　　　~]# yum groupinstall -y "GNOME Desktop"　　　　//文件包多，时间比较长，如果本地yum源会快很多；

　　　　直至完成。

 

　　3.重启登录

　　　　~]# reboot

　　　　

　　　　注意：重启之后注意观察有license相关信息（好比windows下的“我同意”，“下一步”等等）

　　　　　　　选择“1”，然后继续“c”;选择“2”，然后继续“c”，根据自己看见的实际情况选择。

 

　　4.开启图形界面

　　　　~]#startx

　　　　或者

　　　　~]#init 5　　　　//linux系统运行等级，启动图形界面的等级5；

 　　　　

 

　　5.开启 默认启动图形界面

　　　　~]# unlink  /etc/systemd/system/default.target　　　　//断开默认启动方式

　　　　~]# ln -sf  /lib/systemd/system/graphical.target   /etc/systemd/system/default.target　　　　//创建图形启动方式为默认启动方式

 　　　　

　　　

　　　结束.


  [1]: https://blog.csdn.net/duchao123duchao/article/details/72617768
  [2]: https://www.cnblogs.com/ding2016/p/6649789.html?utm_source=itdadao&utm_medium=referral