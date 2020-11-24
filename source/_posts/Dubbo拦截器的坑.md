---
title: Dubbo拦截器的坑
abbrlink: 6y507e76
date: 2020-10-9
tags: dubbo
categories: dubbo
keywords: dubbo,拦截器
---
## Dubbo使用介绍

dubbo过滤器类似于jsp servlet中的filter，spring中的filter拦截器思想一样。可以通过该机制在**执行目标程序前后**执行我们指定的代码。

Dubbo的Filter机制，是专门为**服务提供方和服务消费方**调用过程进行**拦截**设计的，**每次远程方法执行，该拦截都会被执行**。这样就为开发者提供了非常方便的扩展性，比如为dubbo接口实现**ip白名单功能、监控功能 、日志记录**等。

实现步骤：

1. 实现 org.apache.dubbo.rpc.Filter 接口
2. 使用 org.apache.dubbo.common.extension.Activate 接口对**类**进行注册通过group 可以**指定生产端 消费端** 如: 

```
@Activate(group = {CommonConstants.CONSUMER})
或者
@Activate(group = {CommonConstants.CONSUMER,CommonConstants.PROVIDER})
```

3. 业务代码实现
4. 在 resources/META-INF.dubbo 中新建 org.apache.dubbo.rpc.Filter 文件，并将当前类的全名写入

```
# timerFilter=包名.过滤器的名字
timeFilter=com.lagou.filter.DubboInvokeFilter
```

**注意：一般类似于这样的功能都是单独开发依赖的，所以再使用方的项目中只需要引入依赖，在调用接口时，该方法便会自动拦截。**



## 大坑来了

当进行第4步创建`resources/META-INF.dubbo`目录时，一定要写成`META-INF/dubbo`形式，记得加`/`， 否则代码编译后不会生成`dubbo`目录，进而找不到过滤器文件，导致过滤器功能不生效。



![mark](http://blog.xuejiangtao.com/blog/20201009/cNLgak7XCk38.png?imageslim)