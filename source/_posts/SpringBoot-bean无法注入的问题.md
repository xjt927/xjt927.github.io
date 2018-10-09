---
title: SpringBoot bean无法注入的问题
tags:
  - SpringBoot
  - Spring
categories: Spring
keywords: 'SpringBoot,Spring'
abbrlink: 8a7fd1a9
date: 2018-10-09 22:41:50
---
今天在运行项目时报错：
```
org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'com.example.SpringBootJdbcDemoApplication.SpringBootJdbcDemoApplication': Unsatisfied dependency expressed through field 'userRepository': No qualifying bean of type [com.example.repositories.UserRepository] found for dependency [com.example.repositories.UserRepository]: expected at least 1 bean which qualifies as autowire candidate for this dependency. Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true)}; nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type [com.example.repositories.UserRepository] found for dependency [com.example.repositories.UserRepository]: expected at least 1 bean which qualifies as autowire candidate for this dependency. Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true)}
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.inject(AutowiredAnnotationBeanPostProcessor.java:569)
	at org.springframework.beans.factory.annotation.InjectionMetadata.inject(InjectionMetadata.java:88)
```
记起来之前调过项目的目录结构，经过google一番搜索，发现如下：
<!--more-->
![mark](http://blog.xuejiangtao.com/blog/181009/6BKmgd7Gg7.png?imageslim)

iol-api项目要引用iol-common项目下的service接口，会报错。
在Application类上加入一行代码即可。
```
@ComponentScan(basePackages={"com.pcitc.iol.common.pm.configservice.bll"})
public class Application extends SpringBootServletInitializer {
	....
}
```

SpringBoot项目的Bean装配默认规则，是根据Application类所在的包位置从上往下扫描！ 
“Application类”是指SpringBoot项目入口类。这个类的位置很关键：
如果Application类所在的包为：com.pcitc.iol.api，则只会扫描com.pcitc.iol.api包及其所有子包，
如果引用的service或dao所在包不在com.pcitc.iol.api及其子包下，则不会被扫描！

解决：`@ComponentScan`注解进行指定要扫描的包以及要扫描的类。

参考：http://blog.csdn.net/u014695188/article/details/52263903