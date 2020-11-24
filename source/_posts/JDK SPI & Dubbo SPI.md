---
title: JDK SPI & Dubbo SPI
abbrlink: 6y507e71
date: 2020-9-10
tags: dubbo
categories: dubbo
keywords: dubbo,spi
---
# SPI简介

SPI 全称为 (Service Provider Interface) ，**是JDK内置的一种服务发现机制**。 

目前有不少框架用它来做**服务的扩展发现**，简单来说，它就是一种**动态替换发现的机制**。使用SPI机制的**优势是实现解耦**，使得第三方服务模块的装配控制逻辑与调用者的**业务代码分离**。

个人理解：

我只需要关心接口的定义，比不关心怎么实现的，使用的时候根据一定的规则调用接口就行。





#  JDK中的SPI

Java中如果想要使用SPI功能，先提供标准服务接口，然后再提供相关接口实现和调用者。这样就可以通过SPI机制中**约定好的信息(在resource/MATE-INF.services目录下创建接口全限定类名，内容为实现类：包名+实现类名)**进行查询相应的接口实现。

SPI遵循如下约定：

1. 当服务提供者提供了接口的一种具体实现后，在resources/META-INF/services目录下创建一个以“接口全限定名”为命名的文件，内容为实现类的全限定名；

2. 接口实现类所在的jar包放在主程序的classpath中；

3. 主程序通过java.util.ServiceLoader动态装载实现模块，它通过扫描resources/META-INF/services目录下的配置文件找到实现类的全限定名，把类加载到JVM； 

4. SPI的实现类必须携带一个无参构造方法；

# java SDK SPI实现过程：

1. 创建公共Api接口模块项目，**定义接口**。

2. 创建实现Api接口模块项目，**实现Api接口**。

   1. 在pom中引入公共Api接口模块项目，**实现Api接口实现类及方法**。
   2. 在resources下创建**META-INF.services**目录，**该目录下创建一个以“接口全限定名”为命名的文件**，**内容为实现类的全限定名（包名+实现类名）。**

3. 创建主**应用**模块项目，用于测试SPI的效果。

   1. 在pom中引入公共Api接口模块，和实现Api接口模块项目。

   2. 按以下代码方式调用测试JDK SPI效果。

      ```java
      public class JavaSpiMain {
          public static void main(String[] args) {
              final ServiceLoader<HelloService> helloServices  = ServiceLoader.load(HelloService.class);
              for (HelloService helloService : helloServices){
                  System.out.println(helloService.getClass().getName() + ":" + helloService.sayHello());
              }
          }
      }
      ```

   

# Dubbo SPI实现过程：

## dubbo已经实现好的扩展点

Maven: org.apache.dubbo:dubbo:2.7.5/dubbo-2.7.5.jar/META-INF.dubbo.internal为dubbo已经存在的

所有已经实现好的扩展点。

<img src="http://blog.xuejiangtao.com/blog/20200901/0YFUDOnIrOs1.png?imageslim" alt="mark" style="zoom:60%;" />

负载均衡扩展点

![mark](http://blog.xuejiangtao.com/blog/20200901/SXNbpEYyoMhV.png?imageslim)

## api项目创建

1. 导入坐标 dubbo

   ```
       <dependencies>
           <dependency>
               <groupId>org.apache.dubbo</groupId>
               <artifactId>dubbo</artifactId>
               <version>2.7.5</version>
           </dependency>
       </dependencies>
   ```

2. 创建接口

   在接口上使用@SPI，如`@SPI("human")`

## impl项目创建

1. pom中导入api项目的依赖

2. 建立实现类，为了表达支持多个实现的目的，这里分别创建两个实现。分别为
   `HumanHelloService 和 DogHelloService` 。 

3. SPI进行声明操作，在 **resources** 目录下创建目录 **META-INF.dubbo** 目录，在目录下创建名称为

   `com.lagou.dubbo.study.spi.demo.api.HelloService`的文件，文件内部配置两个实现类名称和对应的全
   限定名：

   ```
   human=com.lagou.service.impl.HumanHelloService 
   
   dog=com.lagou.service.impl.DogHelloService 
   ```

## main项目创建

1. pom中导入坐标 **Api接口项目 和 实现类项目**。

2. 创建DubboSpiMain

和原先调用的方式不太相同，dubbo有对其进行自我重新实现，需要借助ExtensionLoader，创建新的运行项目。这里demo中的示例和java中的功能相同，查询出所有的已知实现，并且调用。

```
public class DubboSpiMain {
    public static void main(String[] args) {
        // 获取扩展加载器
        ExtensionLoader<HelloService>  extensionLoader  = ExtensionLoader.getExtensionLoader(HelloService.class);
        // 遍历所有的支持的扩展点 META-INF.dubbo
        Set<String>  extensions = extensionLoader.getSupportedExtensions();
        for (String extension : extensions){
            String result = extensionLoader.getExtension(extension).sayHello();
            System.out.println(result);
        }
    }
}
```

## dubbo自己做SPI的目的

1. JDK 标准的 SPI 会一次性实例化扩展点所有实现，如果有扩展实现初始化很耗时，但如果没用上也加载，会很浪费资源 。

2. 如果有扩展点加载失败，则所有扩展点无法使用 。

3. 提供了对扩展点包装的功能(Adaptive)，并且还支持通过set的方式对其他的扩展点进行注入。



# Dubbo自己做SPI的目的

1. JDK 标准的 SPI 会**一次性实例化扩展点所有实现**，如果有扩展实现初始化很耗时，但如果没用上也加载，会很浪费资源 

2. 如果有扩展点加载失败，则所有扩展点无法使用 

3. 提供了对扩展点包装的功能(Adaptive)，并且还支持通过set的方式对其他的扩展点进行注入





# Dubbo SPI中的Adaptive功能

Dubbo中的Adaptive功能，**主要解决如何动态的选择具体的扩展点。**

通过**getAdaptiveExtension** 统一对**指定接口**对应的所有**扩展点进行封装**，通过**URL的方式**对扩展点来进行**动态选择**。 (dubbo中所有的注册信息都是通过URL的形式进行处理的。)这里同样采用相同的方式进行实现。

## Adaptive实现:

### 1. 创建接口

   在接口方法上增加**@Adaptive的注解**，并且在**参数中提供URL参数**.

   *注意这里的URL参数的类为 org.apache.dubbo.common.URL*

   其中@SPI可以指定一个字符串参数“**human**”，用于指明该SPI的默认实现，如果当调用的URL不指定扩展点参数，则默认使用“**human**”作为扩展点。

![mark](http://blog.xuejiangtao.com/blog/20200903/LODjTRkHblWT.png?imageslim)



### 2. 创建实现类

   HumanHelloService实现

   ![mark](http://blog.xuejiangtao.com/blog/20200903/1zbiCkhnCGOV.png?imageslim)

   ​	DogHelloService实现

   ![mark](http://blog.xuejiangtao.com/blog/20200903/bbWNE0aAns9G.png?imageslim)

   ### 3. 编写DubboAdaptiveMain

URL地址重要的是参数部分，一个URL地址指定一个扩展点。

hello.service为接口文件名称大写字母变为点，参数值为resources/META-INF.dubbo/com.lagou.service.HelloService配置项中的key。

如果url中不指定参数，则将dubbo接口中的SPI扩展点默认值作为扩展点。

```
public class DubboAdaptiveMain {
    public static void main(String[] args) {
        URL   url  = URL.valueOf("test://localhost/hello?hello.service=dog");
        //ExtensionLoader为扩展加载器
        //getAdaptiveExtension()获取指定接口下的所有Adaptive扩展点
        HelloService  adaptiveExtension = ExtensionLoader.getExtensionLoader(HelloService.class).getAdaptiveExtension();
        //根据url自动定位到要调用的扩展点	
        String  msg = adaptiveExtension.sayHello(url);
        System.out.println(msg);
    }
}
```

 

