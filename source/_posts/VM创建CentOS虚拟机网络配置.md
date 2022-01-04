---
title: VM创建CentOS虚拟机网络配置
date: 2021-04-24 18:41:28
tags:
categories:
keywords:
---

1. 打开Windows服务，将下面两个服务启动起来。

   VMware DHCP Service

   VMware NAT Service

2. 设置Windows网络

   控制面板中打开“网络连接”，设置当前wlan或者以太网的属性-共享，允许其他用户访问连接，并选择“VMware Network Adapter VMnet8”允许访问。

3. 虚拟机设置

   VMware界面最上面，选择虚拟机->设置：将网络连接改为桥接模式。

![img](https://img.jbzj.com/file_images/article/202002/2020021315054914.png)

2. 查看本机电脑DNS

   win+R 输入cmd，启动命令行界面，输入ipconfig/all，查看主机DNS服务器地址，如下图所示：

   ![img](https://img.jbzj.com/file_images/article/202002/2020021315054915.png)

   注意，由于本机是无线上网，此处为无线局域网的DNS服务器地址，记下此地址，后面有用。

3. **修改CentOS7网络配置文件**

   1.在CentOS7中打开终端，输入 cd /etc/sysconfig/network-scripts/

   2.输入 vi ifcfg-ens33 打开网络配置文件ifcfg-ens33，如下图所示：

   ![img](https://img.jbzj.com/file_images/article/202002/2020021315054916.png)

   配置文件内容如下：

```
TYPE=Ethernet                 # 网卡类型：为以太网
PROXY_METHOD=none               # 代理方式：关闭状态
BROWSER_ONLY=no                # 只是浏览器：否
BOOTPROTO=dhcp                # 网卡的引导协议：DHCP
DEFROUTE=yes                 # 默认路由：是 
IPV4_FAILURE_FATAL=no             # 是不开启IPV4致命错误检测：否
IPV6INIT=yes                 # IPV6是否自动初始化: 是
IPV6_AUTOCONF=yes               # IPV6是否自动配置：是
IPV6_DEFROUTE=yes               # IPV6是否可以为默认路由：是
IPV6_FAILURE_FATAL=no             # 是不开启IPV6致命错误检测：否
IPV6_ADDR_GEN_MODE=stable-privacy       # IPV6地址生成模型：stable-privacy 
NAME=ens33                  # 网卡物理设备名称
UUID=42773503-99ed-443f-a957-66dbc1258347   # 通用唯一识别码
DEVICE=ens33                 # 网卡设备名称
ONBOOT=no                   # 是否开机启动， 可用systemctl restart network重启网络
```

4. 修改 ONBOOT=yes 并增添 DNS1=192.168.31.1，此DNS地址设为本机的DNS地址（之前记下的地址）

   输入Esc :wq!退出，如下图所示：

![img](https://img.jbzj.com/file_images/article/202002/2020021315054917.png)

​		注意，如果用户权限不够，则在保存时会提示错误，建议登陆root账户。

5. 输入 systemctl restart network 重启网络，没有提示任何信息，则表示网络重启成功，如下图所示：

![img](https://img.jbzj.com/file_images/article/202002/2020021315054918.png)

​		到此，全部设置完成，打开浏览器就可以上网了。