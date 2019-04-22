---
title: 通信端口Com口被占用的原因分析
date: 2019-03-06 14:13:11
tags:
categories:
keywords:
---
目前在调试地磅读取程序，近一段时间无法读取，排查原因发现是com1端口被占用。

从网上找了无数个文章，最终得到一条有价值的消息，

原因如下：

com1端口不能读取电子地磅的数据了，重启之后发现 有一个驱动在更新Serial BallPoint

原来Com口连接的设备，因为满足了微软对Serial ballpoint设备的检测要求，被微软误认为Com口连接的是Serial ballpoint设备，操作系统占用了Com口导致问题。


解决办法：

在设置管理器-鼠标及其他指针设备：禁用:Microsoft Serial BallPoint，这样就防止Com口连接的设备误检测为Microsoft Serial BallPoint设备

 

现在便可以正常读取数据了！