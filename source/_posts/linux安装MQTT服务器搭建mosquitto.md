---
title: linux安装MQTT服务器搭建mosquitto
abbrlink: 4c465812
date: 2020-11-02 13:18:50
tags:
categories:
keywords:
---

## Mosquitto

mosquitto是一款实现了 MQTT v3.1 协议的开源的消息代理服务软件.
其提供了非常轻量级的消息数据传输协议，采用发布/订阅模式进行工作，可用于物联设备、中间件、APP客户端之间的消息通讯。

mosquitto官网
http://mosquitto.org/
关于mqtt协议可参考
http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html



## 基础准备


Linux内核版本：Centos 6.5_final_64bit


#### 安装基础软件

```
yum install gcc-c++
yum install cmake
yum install openssl-devel //mosquitto默认支持openssl
```

 

#### 下载程序

官网下载
```
wget http://mosquitto.org/files/source/mosquitto-1.4.4.tar.gz
tar -xzvf mosquitto-1.4.4.tar.gz
cd mosquitto-1.4.4 
```

## 编译安装

#### 编译选项

当前的程序目录可直接编译，在编译之前需根据需要做一定的配置，否则会出现 xxx.h找不到的情况。
```
vim config.mk
```

config.mk包括了多个选项, 可按需关闭或开启，但一旦开启则需要先安装对应的模块
模块说明 

| 选项              | 说明                                                         | make出错信息            |
| ----------------- | ------------------------------------------------------------ | ----------------------- |
| `WITH_SRV`        | `启用c-areas库的支持，一个支持异步DNS查找的库``见http://c-ares.haxx.se` | `missing ares.h`        |
| `WITH_UUID`       | `启用lib-uuid支持，支持为每个连接的客户端生成唯一的uuid`     | `missing uuid.h`        |
| `WITH_WEBSOCKETS` | `启用websocket支持，需安装libwebsockets`对于需要使用websocket协议的应用开启 | missing libwebsockets.h |



##### 安装c-areas

```
wget http://c-ares.haxx.se/download/c-ares-1.10.0.tar.gz
tar xvf c-ares-1.10.0.tar.gz
cd c-ares-1.10.0
./configure
make
sudo make install
```


##### 安装lib-uuid

```
yum install libuuid-devel
```

#####  安装libwebsockets

```
wget https://github.com/warmcat/libwebsockets/archive/v1.3-chrome37-firefox30.tar.gz
tar zxvf v1.3-chrome37-firefox30.tar.gz
cd libwebsockets-1.3-chrome37-firefox30
mkdir build; cd build;
cmake .. -DLIB_SUFFIX=64
make install
```

//若遇到以上模块无法安装的情况，可将对应模块选项关闭即可，但相应功能也将无法提供；




#### 开始安装mosquitto

```
make
make install
```

 至此程序已经安装完毕！
程序文件将默认安装到以下位置

| 路径            | 程序文件          |
| --------------- | ----------------- |
| /usr/local/sbin | mosquiotto server |
| /etc/mosquitto  | configuration     |
| /usr/local/bin  | utility command   |



#### 修正链接库路径

由于操作系统版本及架构原因，很容易出现安装之后的链接库无法被找到，如启动mosquitto客户端可能出现找不到
libmosquitto.so.1文件，因此需要添加链接库路径

//添加路径
```
vim /etc/ld.so.conf.d/liblocal.conf
/usr/local/lib64
/usr/local/lib
```

//刷新
```
ldconfig
```



## 启动与测试

#### 创建用户

```
mosquitto默认以mosquitto用户启动，可以通过配置文件修改
groupadd mosquitto
useradd -g mosuqitto mosquiotto
```

 

#### 程序配置

```
mv /etc/mosquitto/mosquitto.conf.example /etc/mosquitto/mosquitto.conf
配置项说明
```

```
# 服务进程的PID
#pid_file /var/run/mosquitto.pid
 
# 服务进程的系统用户
#user mosquitto
 
# 服务绑定的IP地址
#bind_address
 
# 服务绑定的端口号
#port 1883

port 1883
protocol mqtt

listener 1884
protocol websockets
 
# 允许的最大连接数，-1表示没有限制
#max_connections -1
 
# 允许匿名用户
#allow_anonymous true
```

//关于详细配置可参考
http://mosquitto.org/man/mosquitto-conf-5.html


#### 启动

```
mosquitto -c /etc/mosquitto/mosquitto.conf -d
```
成功将启动1883端口监听

#### 客户端测试

新建两个shell端口A/B
A 订阅主题：
```
mosquitto_sub -t location
```
B 推送消息：
```
mosquitto_pub -t location -h localhost -m "new location"
```
可以在A窗口看到由B推送的消息，此外服务端窗口也可以看到客户端连接和端口的日志
```
1443083396: New client connected from 127.0.0.1 as mosqpub/31924-iZ94eb8yq (c1, k60).
1443083396: Client mosqpub/31924-iZ94eb8yq disconnected.、
```

## FAQ

#### 启动mosquitto报错

error while loading shared libraries: libwebsockets.so.4.0.0: cannot open shared object file: No such file or directory
或者
error while loading shared libraries: libmosquitto.so.1: cannot open shared object file: No such file or directory
解决方法
找不到链接库，通过locate或find命令找到libwebsockets.so.4.0.0，将其目录添加至ldconfg配置中：
```
vim /etc/ld.so.conf.d/liblocal.conf
/usr/local/lib64
/usr/local/lib
ldconfig
//执行ln -s 添加软连接的方式也可行
```

 

#### 编译找不到openssl/ssl.h

解决方法
```
yum install openssl-devel
```

 

#### 编译报错

mosquitto.c:871: error: ‘struct mosquitto’ has no member named ‘achan’
找不到areas.h
解决方法
安装 c-areas模块(见上文)或将config.mk中WITH_SRV选项关闭


#### make test 提示不支持协议

Address family not supported by protocol

一般是指所访问的地址类型不被支持，比如IPV6，忽略该错误即可

 

## 参考文档

mosquitto1.4 搭建日记
https://goochgooch.wordpress.com/2014/08/01/building-mosquitto-1-4/

Ubuntu下搭建教程(日文)
http://qiita.com/aquaviter/items/cb3051cf42a3a3c4a4d9

使mosquitto支持websockets
https://www.justinribeiro.com/chronicle/2014/10/22/mosquitto-libwebsockets-google-compute-engine-setup/

使用JS实现mqtt-websocket
http://jpmens.net/2014/07/03/the-mosquitto-mqtt-broker-gets-websockets-support/




文章转载至：https://www.cnblogs.com/littleatp/p/4835879.html





## Mqtt服务Mosquitto的卸载

1. 查找mqtt服务文件

   ```
   whereis mosquitto
   whereis mosquitto_sub
   ```


2. 删除已安装的mqtt文件

   ```
   rm  -rf /etc/mosquitto
   rm  /usr/local/sbin/mosquitto
   rm /usr/local/bin/mosquitto_sub /usr/local/bin/mosquitto_pub /usr/local/bin/mosquitto_passwd
   ```

   mqtt服务配置文件，文件夹`/etc/mosquitto`
   mqtt命令文件` /usr/local/sbin/mosquitto` 
   相关mosquitto `mosquitto_sub` `mosquitto_pub` `mosquitto_passwd`
   删除以上所有相关的文件