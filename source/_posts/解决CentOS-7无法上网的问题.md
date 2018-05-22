---
title: 解决CentOS 7无法上网的问题
tags: Centos
categories: Centos
keywords: 'Centos,上网,权限'
abbrlink: '60910929'
date: 2018-05-10 08:42:53
---

# 新安装好的CentOS 7无法上外网

1. 打开终端窗口  用root登录

2. 输入：
`vi /etc/sysconfig/network-scripts/ifcfg-ens33`

3. 编辑配置文件：
修改`noboot=no` 为 `noboot=yes`

4. 修改完成后保存：
`:wq`  保存退出
如果保存时报“**E212：无法打开并写入文件**”，是因为没有写入权限，使用这个命令保存“**:w !sudo tee %**”

5. 重启网络服务
`service  network restart `

# centos 设置网络IP地址方法

可参考以下地址
https://www.cnblogs.com/donaldworld/p/6498398.html