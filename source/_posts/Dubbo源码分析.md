---
title: Dubbo源码分析
abbrlink: 6y507e73
date: 2020-9-25
tags: dubbo
categories: dubbo
keywords: dubbo,源码
---
# 架构整体设计

## Dubbo调用关系说明

![mark](http://blog.xuejiangtao.com/blog/20200911/sRm7DeRHzO2K.png?imageslim)

在这里主要由四部分组成:

- Provider: 暴露服务的服务提供方

  Protocol 负责提供者和消费者之间协议交互数据

  Service 真实的业务服务信息 可以理解成接口 和 实现

  Container Dubbo的运行环境 

- Consumer: 调用远程服务的服务消费方

  Protocol 负责提供者和消费者之间协议交互数据

  Cluster 感知提供者端的列表信息

  Proxy 可以理解成 提供者的服务调用代理类 由它接管 Consumer中的接口调用逻辑

- Registry: 注册中心，用于作为服务发现和路由配置等工作，提供者和消费者都会在这里进行注册

- Monitor: 用于提供者和消费者中的数据统计，比如调用频次，成功失败次数等信息。

## 整体调用链路

![mark](http://blog.xuejiangtao.com/blog/20200911/xwJI4RPCWDlB.png?imageslim)

**说明：**

淡绿色代表了服务生产者的范围 

淡蓝色代表了服务消费者的范围 

紫色三角箭头（Inherit）为继承，可以把子类看作父类的同一个节点

蓝色虚线（Init）为初始化过程，即启动时组装链

红色实线（Call）为方法调用过程，即运行时调时链



从下向上分两部分，下部分为消费端，上部分为服务端。由消费端发起请求，一步步向上到服务端接口实现的业务层，再根据请求的路径一步步返回。

上图的调用链路分三层

1. 接口及业务逻辑层
2. RPC层（远程过程调用）
3. Remoting层（远程数据传输）

## Dubbo源码整体设计

![mark](http://blog.xuejiangtao.com/blog/20200911/7ah3jfejpJyI.png?imageslim)

**说明：**

- 左边淡蓝色代表了服务**消费者**的范围，右边淡绿色代表了服务**生产者**的范围，位于中轴线上的为双方都用到的接口。
- 图中从下至上分为三大层，共十层。各层均为单向依赖，右边的黑色箭头代表层之间的依赖关系，每一层都可以剥离上层被复用，其中，Service 和 Confifig 层为 API，其它各层均为 SPI。
- 图中绿色小块的为扩展接口，蓝色小块为实现类，图中只显示用于关联各层的实现类。
- 图中蓝色虚线为初始化过程，即启动时组装链；红色实线为方法调用过程，即运行时调时链；紫色三角箭头为继承，可以把子类看作父类的同一个节点，线上的文字为调用的方法。

### 分层介绍:

####  Business 业务逻辑层

- service 业务层 包括我们的业务代码 比如 接口 实现类 直接面向开发者

#### RPC层 远程过程调用层

- config 配置层 对外提供配置，以ServiceConfifig、ReferenceConfifig 为核心，可以直接初始化配置类 也可以解析配置文件生成 

- proxy 服务代理层 无论是生产者 还是消费者 框架都会产生一个代理类 整个过程对上层透明 就是业务层对远程调用无感 

- registry 注册中心层 封装服务地址的注册与发现 以服务的URL为中心 

- cluster 路由层 (集群容错层) 提供了多个提供者的路由和负载均衡 并且它桥接注册中心 以Invoker为核心

- monitor 监控层 RPC调用相关的信息 如 调用次数 成功失败的情况 调用时间等 在这一层完成

- protocol 远程调用层 封装RPC调用 无论是服务的暴露 还是 服务的引用 都是在Protocol中作为主功能入口 负责Invoker的整个生命周期 Dubbo中所有的模型都向Invoker靠拢

#### Remoting层 远程数据传输层

- exchange 信息交换层 封装请求和响应的模式 如把请求由同步 转换成异步
- transport 网络传输层 统一网络传输的接口 比如 netty 和 mina 统一为一个网络传输接口
- serialize 数据序列化层 负责管理整个框架中的数据传输的序列化 和反序列化



## Dubbot通过注解方式启动流程：

DubboBootstrap.start()->ServiceConfig.exportServices()->doExportUrls()->ZookeeperRegistryFactory.createRegistry()->AbstractRegistry.AbstractRegistry(URL url)本地生成提供方的访问url。->ZookeeperRegistry.doRegister()将url注册到zookeeper。





## 服务的注册过程分析

![mark](http://blog.xuejiangtao.com/blog/20200912/kSJ9ijUkjeu5.png?imageslim)

首先 ServiceConfig 类拿到对外提供服务的实际类 ref(如：HelloServiceImpl),然后通过ProxyFactory 接口实现类中的 getInvoker 方法使用 ref 生成一个 AbstractProxyInvoker 实例，到这一步就完成具体服务到 Invoker 的转化。接下来就是 Invoker 转换到 Exporter 的过程。



### 具体服务到Invoker的转换

#### ServiceConfig源码查看

文件路径org.apache.dubbo.config.ServiceConfig，针对上图中的三个对象ref、ProxyFactory、Protocol去ServiceConfig源码中查找。



ref对象在继承的父类ServiceConfigBase文件中，ref是一个泛型对象。

![mark](http://blog.xuejiangtao.com/blog/20200912/GIuGku9Xlshu.png?imageslim)



Protocol和ProxyFactory对象在代码中的位置

![mark](http://blog.xuejiangtao.com/blog/20200912/t36nuRj2PaaC.png?imageslim)

#### ProxyFactory获取invoker对象

![mark](http://blog.xuejiangtao.com/blog/20200912/GrNDyrvkr5nY.png?imageslim)



![mark](http://blog.xuejiangtao.com/blog/20200912/PGQRrG8u7mBA.png?imageslim)

PROXY_FACTORY.getInvoker方法，ref是接口实现类既实际提供服务的对象，interfaceClass是接口对象，第三个参数为获取的注册地址URL。当获取到invoker对象之后，又对其进行了一次封装，将其变成DelegateProviderMetaDataInvoker对象。

### Invoker转换成Exporter

Invoker转换成Exporter的具体过程如下：

ServiceConfig->RegistryProtocol(调用register方法注册)->ListenerRegistryWrapper->FailbackRegistry（调用super.register(url)，调用doRegister(url)方法）->跳进ZookeeperRegister类中的doRegister(Url url)方法，将服务端Url或消费端Url注册到Zookeeper中，`zkClient.create(toUrlPath(url), url.getParameter(DYNAMIC_KEY, true));`



```
+- RegistryService 
| +- Registry 
| | +- AbstractRegistry 
| | | +- FailbackRegistry 
| | | | +- ZookeeperRegistry 
| | | | +- NacosRegistry 
| | | | +- ...
```

目录结构描述如下：

- 在这里每个层级代表继承自父级

- 这里面 RegistryService 就是我们之前所讲对外提供注册机制的接口。

- 其下面 Registry 也同样是一个接口，是对 RegistryService 的集成，并且继承了 Node 接口，说明注册中心也是基于URL去做的。

- AbstractRegistry 是对注册中心的封装，其主要会对本地注册地址的封装，主要功能在于远程注册中心不可用的时候，可以采用本地的注册中心来使用。

- FailbackRegistry 从名字中可以看出来，失败自动恢复，后台记录失败请求，定时重发功能。

- 最深的一层则更多是真实的第三方渠道实现。

## URL规则详解

URL地址如下：

```
protocol://host:port/path?key=value&key=value 

provider://192.168.20.1:20883/com.lagou.service.HelloService? anyhost=true&application=service-provider2&bind.ip=192.168.20.1&bind.port=20883&category=configurators&check=false&deprecated=false&dubbo=2.0.2&dynamic=true&generic=false&interface=com.lagou.se rvice
```

URL主要有以下几部分组成：

- protocol: 协议，一般像我们的 provider 或者 consumer 在这里都是人为具体的协议

- host: 当前 provider 或者其他协议所具体针对的地址，比较特殊的像 override 协议所指定的host就是 0.0.0.0 代表所有的机器都生效

- port: 和上面相同，代表所处理的端口号

- path: 服务路径，在 provider 或者 consumer 等其他中代表着我们真实的业务接口

- key=value: 这些则代表具体的参数，这里我们可以理解为对这个地址的配置。比如我们 provider中需要具体机器的服务应用名，就可以是一个配置的方式设置上去。

  

**注意：Dubbo中的URL与java中的URL是有一些区别的，如下：**

- 这里提供了针对于参数的 parameter 的增加和减少(支持动态更改)
- 提供缓存功能，对一些基础的数据做缓存.

## 服务本地缓存

Dubbo在订阅注册中心的回调处理逻辑当中，会保存服务提供者信息到本地缓存文件当中（同步/异步两种方式），以URL纬度进行全量保存。

Dubbo在服务引用过程中会创建registry对象并加载本地缓存文件，会优先订阅注册中心，订阅注册中心失败后会访问本地缓存文件内容获取服务提供信息。



**当客户端调用`HelloService  helloService  = applicationContext.getBean("helloService1",HelloService.class);`后会将服务缓存到本地。**

最后贴出doSaveProperties方法将缓存保存到本地的源码。

```
public void doSaveProperties(long version) {
    if (version < lastCacheChanged.get()) {
        return;
    }
    if (file == null) {
        return;
    }
    // Save
    try {
    	// 使用文件级别所，来保证同一段时间只会有一个线程进行读取操作
        File lockfile = new File(file.getAbsolutePath() + ".lock");
        if (!lockfile.exists()) {
            lockfile.createNewFile();
        }
        try (RandomAccessFile raf = new RandomAccessFile(lockfile, "rw");
             FileChannel channel = raf.getChannel()) {
             // 利用文件锁来保证并发的执行的情况下，只会有一个线程执行成功(原因在于可能是跨 VM的)
            FileLock lock = channel.tryLock();
            if (lock == null) {
                throw new IOException("Can not lock the registry cache file " + file.getAbsolutePath() + ", ignore and retry later, maybe multi java process use the file, please config: dubbo.registry.file=xxx.properties");
            }
            // Save
            try {
                if (!file.exists()) {
                    file.createNewFile();
                }
                // 将配置的文件信息保存到文件中
                try (FileOutputStream outputFile = new FileOutputStream(file)) {
                    properties.store(outputFile, "Dubbo Registry Cache");
                }
            } finally {
            	// 解开文件锁
                lock.release();
            }
        }
    } catch (Throwable e) {
	    // 执行出现错误时，则交给专门的线程去进行重试
        savePropertiesRetryTimes.incrementAndGet();
        if (savePropertiesRetryTimes.get() >= MAX_RETRY_TIMES_SAVE_PROPERTIES) {
            logger.warn("Failed to save registry cache file after retrying " + MAX_RETRY_TIMES_SAVE_PROPERTIES + " times, cause: " + e.getMessage(), e);
            savePropertiesRetryTimes.set(0);
            return;
        }
        if (version < lastCacheChanged.get()) {
            savePropertiesRetryTimes.set(0);
            return;
        } else {
            registryCacheExecutor.execute(new SaveProperties(lastCacheChanged.incrementAndGet()));
        }
        logger.warn("Failed to save registry cache file, will retry, cause: " + e.getMessage(), e);
    }
}
```

## Dubbo消费过程分析

<img src="http://blog.xuejiangtao.com/blog/20200914/uafm12uHkwus.png?imageslim" alt="mark" style="zoom: 67%;" />

首先 ReferenceConfig 类的 init 方法调用 createProxy()方法，该方法中调用shouldJvmRefer()方法判断调用本地jvm缓存还是远程注册中心，验证`scope`和`generic`参数。

期间 使用 Protocol 调用 refer 方法生成 Invoker 实例(如上图中的红色部分)，`invoker = REF_PROTOCOL.refer(interfaceClass, urls.get(0));`再调用doRefer()方法获取invoker对象，这是服务消费的关键。

接下来使用ProxyFactory把 Invoker转换为客户端需要的接口，`(T) PROXY_FACTORY.getProxy(invoker);` (如：HelloService)。 

# Dubbo扩展SPI源码剖析

 `ExtensionLoader`类是所有Dubbo中SPI的入口。

通过分析源码来学习 `ExtensionLoader` 是怎么加载的。这里会具体介绍

`org.apache.dubbo.common.extension.ExtensionLoader.getExtensionLoader` 和 

`org.apache.dubbo.common.extension.ExtensionLoader.getExtension` 方法。

**getExtensionLoader** 获取扩展点加载器，并加载所对应的所有的扩展点实现。

**getExtension** 根据name获取扩展的指定实现。

## Adaptive功能实现原理

Adaptive的主要功能是对所有的扩展点进行封装为一个类，通过URL传入参数动态选择需要使用的**扩展点**。其底层的实现原理就是**动态代理**。

底层通过反射等一系列的方式将扩展点**拼接字符串**，生成一个改造后的class对象，通过类加载器将class对象加载成类对象。



## 信息缓存接口Directory

Directory是Dubbo中的一个接口，主要用于缓存当前可以被调用的提供者列表信息。

当程序启动时，dubbo会完成接口Bean对象注入到spring；

创建代理；

配置文件初始化；

Qos启动；

设置过滤器；

设置监听；

注册中心相关，注册中心注册消费者和服务者地址，并监听所有的服务者和消费者。

## 路由规则实现原理

打开Router类文件查看它的接口实现AbstractRouter->ConditionRouter.

![mark](http://blog.xuejiangtao.com/blog/20200924/2uXQrVTedmYR.png?imageslim)



ConditionRouter实现类中有两个属性：

![mark](http://blog.xuejiangtao.com/blog/20200924/Ks9ofar4tNOH.png?imageslim)

MatchPair类中有两个set属性：

![mark](http://blog.xuejiangtao.com/blog/20200924/AWAjoR8TikNY.png?imageslim)

 路由规则的判断：

![mark](http://blog.xuejiangtao.com/blog/20200924/3NbfKt9hbK8L.png?imageslim)

路由判断的核心逻辑：

![mark](http://blog.xuejiangtao.com/blog/20200924/qoonFv3xu9HF.png?imageslim)



## 负载均衡实现

![mark](http://blog.xuejiangtao.com/blog/20200924/vIOLEcDQMFxc.png?imageslim)

LoadBalance接口，默认标记使用**随机算法负载**@SPI(RandomLoadBalance.NAME)



```
//线程安全的随机
ThreadLocalRandom.current().nextInt(length)
```



随机负载采用轮盘组算法

![mark](http://blog.xuejiangtao.com/blog/20200924/Ke1OjpH6RefI.png?imageslim)

# 网络通信原理剖析

dubbo协议采用固定长度的消息头（16字节）和不定长度的消息体来进行数据传输，消息头定义了底层框架（netty）在IO线程处理时需要的信息。

![mark](http://blog.xuejiangtao.com/blog/20200925/COPJ1zt2VI4z.png?imageslim)

