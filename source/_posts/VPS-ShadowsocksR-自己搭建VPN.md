---
title: VPS + ShadowsocksR 自己搭建VPN
date: 2018-06-27 13:20:31
tags: VPN
categories: VPN
keywords: VPN,VPS,SSR,SS,ShadowsocksR,Shadowsocks,搭建,购买,部署,搬瓦工
---

# VPS和VPN介绍 #
1. VPS
VPS（Virtual Private Server 虚拟专用服务器）技术，将一台服务器分割成多个虚拟专享服务器的优质服务。实现VPS的技术分为容器技术，和虚拟化技术。在容器或虚拟机中，每个VPS都可分配独立公网IP地址、独立操作系统、实现不同VPS间磁盘空间、内存、CPU资源、进程和系统配置的隔离，为用户和应用程序模拟出“独占”使用计算资源的体验。VPS可以像独立服务器一样，重装操作系统，安装程序，单独重启服务器。

> **简单理解VPS就是一台拥有公网IP的服务器。**

2. VPN
虚拟私人网络（英语：Virtual Private Network，缩写为VPN）是一种常用于连接中、大型企业或团体与团体间的私人网络的通讯方法。它利用已加密的通道协议（Tunneling Protocol）来达到保密、发送端认证、消息准确性等私人消息安全效果。这种技术可以用不安全的网络（例如：互联网）来发送可靠、安全的消息。VPN有多种分类方式，主要是按协议进行分类。VPN可通过服务器、硬件、软件等多种方式实现。

# 购买VPS #
国外有很多VPS服务提供商，我选用的[搬瓦工][1]，具体购买流程参考[这篇文章][2]和[这篇文章][3]，已经讲得很详细了。
![mark](http://blog.xuejiangtao.com/blog/180627/FjbgBD7Ik9.png)
我买的是 `$19.99/年`的，一般来说一个人或者几个人一起用，这个配置够用了。`$19.99/年`的好像不常有，如果没有这款，就得等搬瓦工补货。

> **优惠码：**
1. IAMSMART5YA8FO – 4.41%
2. IAMSMART5C48JJ- 4.79%
3. IAMSMART50BAR1 – 4.2%
4. BWH1ZBPVK – 6.00%（这个目前优惠最大）
5. ireallyreadtheterms8 – 5.5%

这是我的付款页面：
![mark](http://blog.xuejiangtao.com/blog/180627/d0Em1lh6Ea.png)

# 部署ShadowSocksR（SSR) #

> 为什么选择SSR而不是原版的SS
主要原因如下 
1. 可以直接启用chacha20加密，在移动设备上比较好使
2. TFO(TCP Fast Open)直接自带，减少握手次数。
3. 二次混淆和抗重放等附加功能

进入搬瓦工服务器控制台，点击 Main controls菜单，点一下 Stop 停掉服务器，接着去 Install new OS 这里，选择 CentOS-6-x86_64-bbr，勾选 I agree， 点击 Reload。

服务器系统重装之后，点击KiwiVM Extras菜单，点击 ShadowsocksR Server菜单安装，由于我买的是这款比较便宜，所以没有Shadowsocks Server 和 ShadowsocksR Server一键安装服务。有点淡淡的忧伤...

那就自己登录服务器手动安装ssr服务，打开Xshell连接自己的centos服务器，（如果不会用Xshell可自行谷歌），安装ssr的教程可以[参考这一篇文章][4]。

> **注意**，如果在使用命令安装时提示：**-bash wget:未找到命令**
需要在服务器上安装`wget`，使用命令`yum install wget`安装，之后再次重试。


# 使用SSR #
ShadowsocksR 下载使用

1. Windows 下载地址
[SS][5]
[SSR-4.7.0][6]
ShadowsocksR 分为 dotnet 2.0 和 4.0，实际功能无区别，只是电脑安装 .NET Framework v2.0 或 4.0 的支持库版本不同。一般 Win7 以后都默认安装了 v2.0；Win8 以后都默认安装了 2.0 和 4.0，只有 XP 系统两个都默认没有安装，需要手动安装支持库。

2. Android 下载地址
[SS][7]
[SSR-3.4.0.5][8]

3. Mac 下载地址
[ShadowsocksX-NG-R][9]
[electron-ssr][10]

4. iOS 下载地址
[Wingy][11]
[Shadowrocket][12]
这里讲一下，ios想要翻墙需要下载Shadowrocket，国内该App已经下架，美国地区可以下载（要收费`$2.99`），前提是有美国地区商店账号，比较麻烦。这里推荐使用`PP助手`在应用里搜索，找到安装即可，不得不说PP助手还是很良心的软件！
![mark](http://blog.xuejiangtao.com/blog/180627/LHfjE1FlIB.png)


这些文章讲的都不错，参考
[VPS+ShadowsocksR 搭建自己的 VPN][13]
[Vultr VPS主机快速安装SSR完整图文教程][14]
[搬瓦工VPS搭建shadowsocks][15]


  [1]: https://bwh1.net/index.php
  [2]: http://banwagong.cn/gonglue.html
  [3]: https://my.oschina.net/matol/blog/1595199
  [4]: http://vultr.aicnm.com/Vultr-VPS%E4%B8%BB%E6%9C%BA%E5%BF%AB%E9%80%9F%E5%AE%89%E8%A3%85SSR%E5%AE%8C%E6%95%B4%E5%9B%BE%E6%96%87%E6%95%99%E7%A8%8B/
  [5]: https://github.com/shadowsocks/shadowsocks-windows/releases
  [6]: https://cache.cdn.bydisk.com/ShadowsocksR-4.7.0-win.7z
  [7]: https://github.com/shadowsocks/shadowsocks-android/releases
  [8]: https://qiniucloud.download.storage.bydisk.com/ssr-3.4.0.5.apk
  [9]: https://github.com/qinyuhang/ShadowsocksX-NG-R/releases
  [10]: https://github.com/erguotou520/electron-ssr/releases
  [11]: https://itunes.apple.com/us/app/wingy-http-s-socks5-proxy-utility/id1178584911
  [12]: https://itunes.apple.com/us/app/shadowrocket/id932747118
  [13]: https://medium.com/@liaoyuqin/vps-shadowsocksr-%E6%90%AD%E5%BB%BA%E8%87%AA%E5%B7%B1%E7%9A%84-vpn-6fc6d5772cc4
  [14]: http://vultr.aicnm.com/Vultr-VPS%E4%B8%BB%E6%9C%BA%E5%BF%AB%E9%80%9F%E5%AE%89%E8%A3%85SSR%E5%AE%8C%E6%95%B4%E5%9B%BE%E6%96%87%E6%95%99%E7%A8%8B/
  [15]: https://blog.csdn.net/fang_chuan/article/details/79393356