---
title: Dubbo高级实战
abbrlink: 6y507e72
date: 2020-9-11
tags: dubbo
categories: dubbo
keywords: dubbo
---
# Dubbo过滤器

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



# Dubbo负载均衡

负载均衡策略主要用于客户端存在多个提供者时进行选择某个提供者。

在集群负载均衡时，缺省为random随机调用。

## Dubbo 提供的负载均衡策略：

random随机

roundrobin轮询

leastactive最少活跃调用数

consistenthash一致性hash



## 配置

配置负载均衡策略，**既可以在服务提供者一方配置，也可以在服务消费者一方配置**，如下：

### Api注解方式

```
	//在服务消费者一方配置负载均衡策略 
	@Reference(check = false,loadbalance = "random")
    private HelloService helloService;
    public String sayHello(String name, int timeToWait) {
        return helloService.sayHello(name, timeToWait);
    }
```

```
    //在服务提供者一方配置负载均衡 
    @Service(loadbalance = "random") 
    public class HelloServiceImpl implements HelloService 
    { 
    	public String sayHello(String name) { 
    		return "hello " + name; 
    	}
    }
```

### xml方式

#### 服务端服务级别

```xml
<dubbo:service interface="..." loadbalance="roundrobin" />
```

#### 客户端服务级别

```xml
<dubbo:reference interface="..." loadbalance="roundrobin" />
```



#### 服务端方法级别

```xml
<dubbo:service interface="...">
    <dubbo:method name="..." loadbalance="roundrobin"/>
</dubbo:service>
```

#### 客户端方法级别

```xml
<dubbo:reference interface="...">
    <dubbo:method name="..." loadbalance="roundrobin"/>
</dubbo:reference>
```



#  Dubbo异步调用

## 1.使用RpcContext

1. 修改consumer.xml配置文件。在xml配置文件中增加如下配置：

   ```
       <dubbo:reference id="helloService" interface="com.lagou.service.HelloService">
            <dubbo:method name="sayHello" async="true"></dubbo:method>
       </dubbo:reference>
   ```

   `<dubbo:method name="sayHello" async="true">`指定方法为异步方法。

   

2. 消费端调用方法，利用Future模式异步获取返回值。

   ```
   String hello = service.sayHello("world", 100);
   // 利用Future 模式来获取
   Future<Object> future = RpcContext.getContext().getFuture();
   System.out.println("future result:" + future.get());
   ```
   

或

   ```
   CompletableFuture<String> future = RpcContext.getContext().asyncCall(
           () -> {
              return service.sayHello("world", 100);
           }
   );
   System.out.println("future result:" + future.get());
   ```

   或

   ```
   service.sayHello("world", 100);
   // 拿到调用的Future引用，当结果返回后，会被通知和设置到此Future
   CompletableFuture<String> helloFuture = RpcContext.getContext().getCompletableFuture();
   // 为Future添加回调
   helloFuture.whenComplete((retValue, exception) -> {
       if (exception == null) {
           System.out.println(retValue);
       } else {
           exception.printStackTrace();
       }
   });
   ```

## 2.使用CompletableFuture签名的接口

需要服务提供者事先定义CompletableFuture签名的服务，具体参见[服务端异步执行](http://dubbo.apache.org/zh-cn/docs/user/demos/async-execute-on-provider.html)接口定义：

```java
public interface AsyncService {
    CompletableFuture<String> sayHello(String name);
}
```

注意接口的返回类型是`CompletableFuture`。

XML引用服务：

```xml
<dubbo:reference id="asyncService" timeout="10000" interface="com.alibaba.dubbo.samples.async.api.AsyncService"/>
```

调用远程服务：

```java
// 调用直接返回CompletableFuture
CompletableFuture<String> future = asyncService.sayHello("async call request");
// 增加回调
future.whenComplete((v, t) -> {
    if (t != null) {
        t.printStackTrace();
    } else {
        System.out.println("Response: " + v);
    }
});
// 早于结果输出
System.out.println("Executed before response return.");
```

# Dubbo线程池

FixedThreadPool: 表示创建固定大小的线程池。也是Dubbo默认的使用方式，默认创建的执行线程数为200，并且是没有任何等待队列的。


CachedThreadPool: 创建非固定大小的线程池，当线程不足时，会自动创建新的线程。但是使用这种的时候需要注意，如果突然有高TPS的请求过来，方法没有及时完成，则会造成大量的线程创建，对系统的CPU和负载都是压力，执行越多反而会拖慢整个系统。

1. 使用FixedThreadPool实现线程池的创建。
2. SPI声明，创建文件 META-INF/dubbo/org.apache.dubbo.common.threadpool.ThreadPool 

```
watching=包名.线程池名
```

3. 在服务提供方项目引入该依赖
4. 在服务提供方项目中设置使用该线程池生成器

```
dubbo.provider.threadpool=watching
```





## Dubbo线程池监控

```
public class WachingThreadPool  extends FixedThreadPool  implements  Runnable{
    private  static  final Logger  LOGGER = LoggerFactory.getLogger(WachingThreadPool.class);
    // 定义线程池使用的阀值
    private  static  final  double  ALARM_PERCENT = 0.90;
    private  final Map<URL, ThreadPoolExecutor>    THREAD_POOLS = new ConcurrentHashMap<>();
    public  WachingThreadPool(){
        // 每隔3秒打印线程使用情况
        Executors.newSingleThreadScheduledExecutor().scheduleWithFixedDelay(this,1,3, TimeUnit.SECONDS);
    }
    // 通过父类创建线程池
    @Override
    public Executor getExecutor(URL url) {
         final  Executor executor = super.getExecutor(url);
         if(executor instanceof  ThreadPoolExecutor){
             THREAD_POOLS.put(url,(ThreadPoolExecutor)executor);
         }
         return  executor;
    }

    @Override
    public void run() {
         // 遍历线程池
         for (Map.Entry<URL,ThreadPoolExecutor> entry: THREAD_POOLS.entrySet()){
              final   URL  url = entry.getKey();
              final   ThreadPoolExecutor  executor = entry.getValue();
              // 计算相关指标
              final  int  activeCount  = executor.getActiveCount();
              final  int  poolSize = executor.getCorePoolSize();
              double  usedPercent = activeCount / (poolSize*1.0);
              LOGGER.info("线程池执行状态:[{}/{}:{}%]",activeCount,poolSize,usedPercent*100);
              if (usedPercent > ALARM_PERCENT){
                  LOGGER.error("超出警戒线! host:{} 当前使用率是:{},URL:{}",url.getIp(),usedPercent*100,url);
              }

         }
    }
}
```

**写好之后在服务端的pom文件中添加该线程池项目的引用。**

# Dubbo路由

## Dubbo路由使用

编写注册路由的执行函数

```
    public static void main(String[] args) {
        //注册中心的工厂对象
        RegistryFactory registryFactory = ExtensionLoader.getExtensionLoader(RegistryFactory.class).getAdaptiveExtension();
        //获取注册中心
        Registry registry = registryFactory.getRegistry(URL.valueOf("zookeeper://127.0.0.1:2181"));
        registry.register(URL.valueOf("condition://0.0.0.0/com.lagou.service.HelloService?category=routers&force=true&dynamic=true&rule="
                + URL.encode("=> host != 192.168.31.123")));
    }
```

运行上面代码，则将路由规则添加到Dubbo注册中心。之后客户端再访问就按照新注册的规则路由。

## Dubbo路由规则详解

[官方文档](http://dubbo.apache.org/zh-cn/docs/user/demos/routing-rule-deprecated.html)

- `route://` 表示路由规则的类型，支持条件路由规则（condition）和脚本路由规则（script），可扩展，**必填**。
- `0.0.0.0` 表示对所有 IP 地址生效，如果只想对某个 IP 的生效，请填入具体 IP，**必填**。
- `com.foo.BarService` 表示只对指定服务生效，**必填**。
- `group=foo` 对指定服务的指定group生效，不填表示对未配置group的指定服务生效
- `version=1.0`对指定服务的指定version生效，不填表示对未配置version的指定服务生效
- `category=routers` 表示该数据为动态配置类型，**必填**。
- `dynamic=false` 表示该数据为持久数据，当注册方退出时，数据依然保存在注册中心，**必填**。
- `enabled=true` 覆盖规则是否生效，可不填，缺省生效。
- `force=false` 当路由结果为空时，是否强制执行，如果不强制执行，路由结果为空的路由规则将自动失效，可不填，缺省为 `false`。
- `runtime=false` 是否在每次调用时执行路由规则，否则只在提供者地址列表变更时预先执行并缓存结果，调用时直接从缓存中获取路由结果。如果用了参数路由，必须设为 `true`，需要注意设置会影响调用的性能，可不填，缺省为 `false`。
- `priority=1` 路由规则的优先级，用于排序，优先级越大越靠前执行，可不填，缺省为 `0`。
- `rule=URL.encode("host = 10.20.153.10 => host = 10.20.153.11")` 表示路由规则的内容，**必填**。

## 条件路由规则

基于条件表达式的路由规则，如：`host = 10.20.153.10 => host = 10.20.153.11`

### 规则：

- `=>` 之前的为消费者匹配条件，所有参数和消费者的 URL 进行对比，当消费者满足匹配条件时，对该消费者执行后面的过滤规则。
- `=>` 之后为提供者地址列表的过滤条件，所有参数和提供者的 URL 进行对比，消费者最终只拿到过滤后的地址列表。
- 如果匹配条件为空，表示对所有消费方应用，如：`=> host != 10.20.153.11`
- 如果过滤条件为空，表示禁止访问，如：`host = 10.20.153.10 =>`

### 表达式：

参数支持：

- 服务调用信息，如：method, argument 等，暂不支持参数路由
- URL 本身的字段，如：protocol, host, port 等
- 以及 URL 上的所有参数，如：application, organization 等

条件支持：

- 等号 `=` 表示"匹配"，如：`host = 10.20.153.10`
- 不等号 `!=` 表示"不匹配"，如：`host != 10.20.153.10`

值支持：

- 以逗号 `,` 分隔多个值，如：`host != 10.20.153.10,10.20.153.11`
- 以星号 `*` 结尾，表示通配，如：`host != 10.20.*`
- 以美元符 `$` 开头，表示引用消费者参数，如：`host = $host`

# 路由与上线系统结合

通过Dubbo路由规则，对预发布（灰度）机器进行保护，从机器列表中将这类机器移除。

让其把现有请求处理完毕后再关闭机器，或者重启完成后再对外提供服务。

**实现主体思路**

```
1.利用zookeeper的路径感知能力，在服务准备进行重启之前将当前机器的IP地址和应用名写入zookeeper。 
2.服务消费者监听该目录，读取其中需要进行关闭的应用名和机器IP列表并且保存到内存中。 
3.当前请求过来时，判断是否是请求该应用，如果是请求重启应用，则将该提供者从服务列表中移除。
```

（1）引入 Curator 框架，用于方便操作Zookeeper 

（2）编写Zookeeper的操作类，用于方便进行zookeeper处理

（3）编写需要进行预发布的路径管理器，用于缓存和监听所有的待灰度机器信息列表。

（4）编写路由类(实现 org.apache.dubbo.rpc.cluster.Router )，主要目的在于对ReadyRestartInstances 中的数据进行处理，并且移除路由调用列表中正在重启中的服务。

（5）由于 Router 机制比较特殊，所以需要利用一个专门的 RouterFactory 来生成，原因在于并不是所有的都需要添加路由，所以需要利用 @Activate 来锁定具体哪些服务才需要生成使用。

```
@Activate
public class RestartingInstanceRouterFactory implements RouterFactory {
    @Override
    public Router getRouter(URL url) {
        return new RestartingInstanceRouter(url);
    }
}
```

（6）对 RouterFactory 进行注册，同样放入到META-INF/dubbo/org.apache.dubbo.rpc.cluster.RouterFactory 文件中。

```
restartInstances=com.lagou.router.RestartingInstanceRouterFactory
```

（7）将dubbo-spi-router项目引入至 consumer 项目的依赖中。

（8）这时直接启动程序，还是利用上面中所写好的 consumer 程序进行执行，确认各个 provider 可以正常执行。

（9）单独写一个 main 函数来进行将某台实例设置为启动中的状态，比如这里我们认定为当前这台机器中的 service-provider 这个提供者需要进行重启操作。

```
ReadyRestartInstances.create().addRestartingInstance("service-provider", "正在 重新启动的机器IP");
```

（10）执行完成后，再次进行尝试通过 consumer 进行调用，即可看到当前这台机器没有再发送任何请求

（11）一般情况下，当机器重启到一定时间后，我们可以再通过 removeRestartingInstance 方法对这个机器设定为既可以继续执行。

（12）调用完成后，我们再次通过 consumer 去调用，即可看到已经再次恢当前机器的请求参数。



# 服务动态降级

##  什么是服务降级

服务降级，当服务器压力剧增的情况下，根据当前业务情况及流量对一些服务有策略的降低服务级别，以释放服务器资源，保证核心任务的正常运行。

## 为什么要服务降级

这是防止分布式服务发生雪崩效应。

**什么是雪崩？**

就是蝴蝶效应，当一个请求发生超时，一直等待着服务响应，那么在高并发情况下，很多请求都是因为这样一直等着响应，直到服务资源耗尽产生宕机，而宕机之后会导致分布式其他服务调用该宕机的服务也会出现资源耗尽宕机，这样下去将导致整个分布式服务都瘫痪，这就是雪崩。

## Dubbo 服务降级实现方式 

### 第一种 在 dubbo 管理控制台配置服务降级

**屏蔽和容错**

- mock=force:return null

  表示消费方对该服务的方法调用都直接返回 null 值，不发起远程调用。用来屏蔽不重要服务不可用时对调用方的影响。

- mock=fail:return null

  表示消费方对该服务的方法调用在失败后，再返回 null 值，不抛异常。用来容忍不重要服务不稳定时对调用方的影响。

![mark](http://blog.xuejiangtao.com/blog/20200910/AThRWueyklBt.png?imageslim)

### 第二种 指定返回简单值或者null

- 在客户端xml配置文件中配置

```
不请求服务端，直接返回null
<dubbo:reference id="xxService" check="false" interface="com.xx.XxService" timeout="3000" mock="return null" /> 

不请求服务端，直接返回指定内容“1234”
<dubbo:reference id="xxService2" check="false" interface="com.xx.XxService2" timeout="3000" mock="return 1234" />
```

- 使用注解方式

使用@Reference(mock="return null") 和@Reference(mock="return 简单值")

也支持 @Reference(mock="force:return null")  和@Reference(mock="force:return null") 

### 第三种 使用java代码 动态写入配置中心

```
RegistryFactory registryFactory =  ExtensionLoader.getExtensionLoader(RegistryFactory.class).getAdaptiveExtension();

Registry registry = registryFactory.getRegistry(URL.valueOf("zookeeper://IP:端口")); 

registry.register(URL.valueOf("override://0.0.0.0/com.foo.BarService? 
category=configurators&dynamic=false&application=foo&mock=force:return+null"));
```

### 第四种 整合整合 hystrix