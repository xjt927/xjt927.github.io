---
title: spi
abbrlink: 6y507e7a
date: 2020-9-6 15:31:44
tags: dubbo
categories: dubbo
keywords: dubbo
---
配置方式：

xml

注解

api接口



配置属性

zk配置

超时

qos

dubbo应用名称



实现：

引用pom文件

创建api项目

创建consumer

创建provider



功能：

SPI

​		将创建的api全限定路径文件放入resource/MATE-INF，并设置实现接口类的全路径名称

​		设置Adaptive，动态选择扩展点。

Filter

​		过滤器单独一个项目，使用时直接引用该pom项目。

负载均衡

​		随机、轮询、最小访问数、一致性hash，默认为随机random

​			随机：根据权重随机

