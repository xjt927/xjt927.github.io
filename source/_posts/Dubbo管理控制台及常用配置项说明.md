---
title: Dubbo管理控制台及常用配置项说明
abbrlink: 6f507e7a
date: 2020-9-2 23:30:44
tags: dubbo
categories: dubbo
keywords: dubbo,控制台
---
#  Dubbo管理控制台dubbo-admin

## 控制台安装步骤

1. 从git 上下载项目 https://github.com/apache/dubbo-admin 

   **建议使用master分支**，因为该分支比较稳定。develop分支一直在更新提交，存在不稳定因素。

   <img src="http://blog.xuejiangtao.com/blog/20200830/aSmJ4nfcQe3d.png?imageslim" alt="mark" style="zoom:50%;" />

2. 修改项目下的配置文件 

   dubbo-admin-master\dubbo-admin\src\main\resources\application.properties

   注意dubbo.registry.address对应的值，需要对应当前使用的Zookeeper的ip地址和端口号 

   • dubbo.registry.address=zookeeper://zk所在机器ip:zk端口 

   • dubbo.admin.root.password=root 

   • dubbo.admin.guest.password=guest 

3. 切换到项目所在的路径dubbo-admin-master\dubbo-admin 使用mvn 打包 

   mvn clean package -Dmaven.test.skip=true 

4. 进入\target目录使用java 命令运行 

   java -jar 对应的jar包

## 使用控制台

1.访问http://localhost:7001（默认端口） 

2.输入用户名root,密码root 

3.点击菜单 服务治理，查看服务提供者和服务消费者信息

# Dubbo常用配置项说明

配置文件和普通Spring中属性名称用“."隔开

Spring boot中属性名写一起

[Dubbo官网schema 配置参考手册](http://dubbo.apache.org/zh-cn/docs/user/references/xml/introduction.html)



## dubbo:application

对应 org.apache.dubbo.confifig.ApplicationConfifig, 代表当前应用的信息

1. name: 当前应用程序的名称，在dubbo-admin中我们也可以看到，这个代表这个应用名称。我们在真正时是时也会根据这个参数来进行聚合应用请求。

2. owner: 当前应用程序的负责人，可以通过这个负责人找到其相关的应用列表，用于快速定位到责任人。

3. qosEnable : 是否启动QoS 默认true

4. qosPort : 启动QoS绑定的端口 默认22222

5. qosAcceptForeignIp: 是否允许远程访问 默认是false 

## Qos使用

[Dubbo官网Qos命令使用说明](http://dubbo.apache.org/zh-cn/docs/user/references/qos.html)

当dubbo持续启动时默认启动qos服务，并为该服务分配默认的 22222端口。

Qos主要是运维时使用。

### 登陆Qos

打开cmd命令窗口，输入`telnet localhost 22222`

输入`ls`

<img src="http://blog.xuejiangtao.com/blog/20200830/rGXdMoxJfUaw.png?imageslim" alt="mark" style="zoom:80%;" />

当登录服务后，输入命令报异常：`Foreign Ip Not Permitted.`

说明没有权限访问该服务。

```
需要在配置文件中将
<dubbo:parameter key="qos.accept.foreign.ip" value="false">
设置为
<dubbo:parameter key="qos.accept.foreign.ip" value="true">
```

## dubbo:registry

```
<!-- 使用zookeeper注册中心暴露服务地址 -->
<dubbo:registry address="zookeeper://127.0.0.1:2181" id="r1" timeout="10000"/>
```

org.apache.dubbo.confifig.RegistryConfifig, 代表该模块所使用的注册中心。一个模块中的服务可以将

其注册到多个注册中心上，也可以注册到一个上。后面再service和reference也会引入这个注册中心。

1. id : 当前服务中provider或者consumer中存在**多个注册中心时**，则使用需要增加该配置。在一些公司，会通过业务线的不同选择不同的注册中心，所以一般都会配置该值。
2. address : 当前注册中心的访问地址。

3. protocol : 当前注册中心所使用的协议是什么。也可以直接在 address 中写入，比如使用zookeeper，就可以写成zookeeper://xx.xx.xx.xx:2181 
4. timeout : 当与注册中心不再同一个机房时，大多会把该参数延长。

## dubbo:protocol

```
<!-- 用dubbo协议在20882端口暴露服务
<dubbo:protocol name="dubbo" port="20882" /> -->
<!-- 用dubbo协议在20883端口暴露服务 -->
<dubbo:protocol name="dubbo" port="20883"/>
```

org.apache.dubbo.confifig.ProtocolConfifig, 指定服务在进行数据传输所使用的协议。

1. id : 在大公司，可能因为各个部门技术栈不同，所以可能会选择使用不同的协议进行交互。这里在多个协议使用时，需要指定。

2. name : 指定协议名称。默认使用 dubbo 。

   **参考org.apache.dubbo.rpc.Protocol定义的协议。**

   Maven: org.apache.dubbo:dubbo:2.7.5/dubbo-2.7.5.jar/META-INF.dubbo.internal/org.apache.dubbo.rpc.Protocol

   ![mark](http://blog.xuejiangtao.com/blog/20200901/HH5cY0Rp06Cq.png?imageslim)

## dubbo:service

```
    <!-- 声明需要暴露的服务接口 -->
    <dubbo:service interface="com.lagou.service.HelloService" ref="helloService"  />

    <!-- 和本地bean一样实现服务 -->
    <bean id="helloService" class="com.lagou.service.impl.HelloServiceImpl" />
```

org.apache.dubbo.confifig.ServiceConfifig, 用于指定当前需要对外暴露的服务信息，后面也会具体讲解。和 dubbo:reference 大致相同。

1. interface : 指定当前需要进行对外暴露的接口是什么。

2. ref : 具体实现对象的引用，一般我们在生产级别都是使用Spring去进行Bean托管的，所以这里面一般也指的是Spring中的BeanId。 

3. version : 对外暴露的版本号。不同的版本号，消费者在消费的时候只会根据固定的版本号进行消费。

## dubbo:reference

```
<!-- 生成远程服务代理，可以和本地bean一样使用demoService -->
<dubbo:reference id="helloService" interface="com.xjt.service.AnnotationService" timeout="4000" retries="2"/>
```

org.apache.dubbo.confifig.ReferenceConfifig, 消费者的配置，这里只做简单说明，后面会具体讲解。

1. id : 指定该Bean在注册到Spring中的id。 

2. interface: 服务接口名

3. version : 服务版本，与服务提供者的版本一致。

4. registry : 远程服务调用重试次数，不包括第一次调用，不需要重试请设为0。

##  dubbo:method

xml配置文件中独有的属性

org.apache.dubbo.confifig.MethodConfifig, 用于在制定的 dubbo:service 或者 dubbo:reference 中的更具体一个层级，指定具体方法级别在进行RPC操作时候的配置，可以理解为对这上面层级中的配置针对于具体方法的特殊处理。

1. name : 指定方法名称，用于对这个方法名称的RPC调用进行特殊配置。

2. async: 是否异步 默认false

##  dubbo:service和dubbo:reference详解

这两个在dubbo中是我们最为常用的部分，其中有一些我们必然会接触到的属性。并且这里会讲到一些设置上的使用方案。

1. mock: 用于在方法调用出现错误时，当做服务降级来统一对外返回结果，**用于客户端配置**。
   1. mock属性写到dubbo:consumer标签或者dubbo:reference都可以
   2. 设置`mock="true"`，设置mock=true后自动找”包名+接口名+Mock“的文件
   3. 编写”接口名称+Mock“的mock文件，该文件要implement实现接口，并在方法中写业务逻辑

2. timeout: 用于**客户端指定服务端当前方法或者接口中所有方法的超时时间**。**用于客户端配置**。

   我们一般都会根据提供者的时长来具体规定。比如我们在进行第三方服务依赖时可能会对接口的时长做放宽，防止第三方服务不稳定导致服务受损。

   ```
   <dubbo:consumer timeout="2000" ... /> 或 <dubbo:reference ... timeout="1000"/>标签属性中设置。
   
   以reference为主，以consumer为辅。
   ```

   

3. check: 用于在启动时，检查生产者是否有该服务。**用于客户端配置**。

   我们一般都会将这个值设置为false，不让其进行检查。因为如果出现模块之间循环引用的话，那么则可能会出现相互依赖，都进行check的话，那么这两个服务永远也启动不起来。

   ```
   <dubbo:consumer ... check="true" />
   ```

   

4. retries: 用于指定当前服务在执行时出现错误或者超时时的重试机制。**用于客户端配置**。
   1. 注意提供者是否有幂等，否则可能出现数据一致性问题

   2. 注意提供者是否有类似缓存机制，如出现大面积错误时，可能因为不停重试导致雪崩

      ```
      <dubbo:consumer retries="2"  ... /> 或 <dubbo:reference ... retries="3" />标签属性中设置。
      
      以reference为主，以consumer为辅。
      ```

      

5. executes: **用于在提供者做配置**，来确保最大的并行度。
   1. 可能导致集群功能无法充分利用或者堵塞
   2. 但是也可以启动部分对应用的保护功能
   3. 可以不做配置，结合后面的熔断限流使用

