---
title: rabbitmq安装
abbrlink: e28448e6
date: 2019-12-08 20:35:34
tags:
categories:
keywords:
---

#rabbitmq linux卸载

rabbitmq是运行在erlang环境下的，所以卸载时应将erlang卸载。

1、卸载rabbitmq相关

卸载前先停掉rabbitmq服务，执行命令

$ service rabbitmq-server stop
查看rabbitmq安装的相关列表

$ yum list | grep rabbitmq
卸载rabbitmq已安装的相关内容

$ yum -y remove rabbitmq-server.noarch
2、卸载erlang

查看erlang安装的相关列表

$ yum list | grep erlang
卸载erlang已安装的相关内容

$ yum -y remove erlang-*
$ yum remove erlang.x86_64
卸载完之后就可以重新安装了

3.删除相关文件

rm -rf /usr/lib64/erlang
rm -rf /var/lib/rabbitmq
rm -rf /usr/lib/rabbitmq/lib/rabbitmq_server-3.8.1/
rm -rf /etc/rabbitmq/
rm -rf /var/log/rabbitmq



https://www.jianshu.com/p/f9b4305585b0

https://www.cnblogs.com/cjyboy/p/11732070.html

https://ken.io/note/centos7-rabbitmq-install-setup

#安装erlang
https://github.com/rabbitmq/erlang-rpm/releases
rpm -ivh erlang-21.3.8.6-1.el7.x86_64.rpm
 
#安装rabbitmq
https://www.rabbitmq.com/install-rpm.html#downloads
rpm -ivh rabbitmq-server-3.8.1-1.el7.noarch.rpm
 
#后台运行
/usr/sbin/rabbitmq-server -detached

#开机启动
chkconfig rabbitmq-server on

#启动rabbitmq服务
service rabbitmq-server start

#开启管理控制台
/usr/sbin/rabbitmq-plugins list
/usr/sbin/rabbitmq-plugins enable rabbitmq_management

创建账户：
rabbitmqctl add_user  admin  admin
设置用户角色
rabbitmqctl set_user_tags admin administrator
设置用户权限
rabbitmqctl add_vhost admin
设置用户权限
rabbitmqctl set_permissions -p admin  admin ".*" ".*" ".*"
设置完成后可以查看当前用户和角色(需要开启服务)
rabbitmqctl list_users
		
#开启远程访问
#cd /etc/rabbitmq  
#cp /usr/share/doc/rabbitmq-server-3.5.6/rabbitmq.config.example /etc/rabbitmq/   
#mv rabbitmq.config.example rabbitmq.config 
vim /etc/rabbitmq/rabbitmq.config
添加： {loopback_users, []}
重启mq
service rabbitmq-server restart

#访问
http://ip:15672   guest  guest

#异常
1.Error: unable to perform an operation on node 'rabbit@localhost'. Please see diagnostics information and suggestions below.
解决：
直接用 echo 192.168.174.131 rabbitmq>>/etc/hosts 其中的IP是服务器的IP
重启rabbitmq 
```service rabbitmq-server restart```