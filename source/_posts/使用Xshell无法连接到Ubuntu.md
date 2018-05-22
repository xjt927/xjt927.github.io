---
title: 使用Xshell无法连接到Ubuntu
tags:
  - Xshell
  - Ubuntu
categories: Ubuntu
keywords: 'Ubuntu,Xshell'
abbrlink: fe58c937
date: 2018-05-12 09:27:16
---

安装完成之后，使用Xshell直接连接Ubuntu主机会发现连接不上，
这是因为Ubuntu主机没有开启SSH服务，需要开启openssh-server：
```
sudo apt-get install openssh-server
```