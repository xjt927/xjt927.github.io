---
title: '@Controller和@RestController的区别？'
tags: Spring
categories: Spring
keywords: Spring
abbrlink: 2708e1c6
date: 2018-09-29 09:23:26
---

# @Controller

## @Controller和页面结合使用
`@Controller`用来响应页面, 单独使用`@Controller`时, 必须配合模版来使用, 才能返回请求页面.
```
@Controller
//@ResponseBody
public class HelloController {

    @RequestMapping(value="/hello",method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
} 
```
如果直接使用@Controller这个注解，当运行该SpringBoot项目后，在浏览器中输入：local:8080/hello,会得到如下错误提示： 
![mark](http://blog.xuejiangtao.com/blog/180929/8g69gHeBkl.png)
出现这种情况的原因在于：没有使用模版。即@Controller 用来响应页面，@Controller必须配合模版来使用。spring-boot 支持多种模版引擎包括：  
1，FreeMarker  
2，Groovy  
3，Thymeleaf （Spring 官网使用这个）  
4，Velocity  
5，JSP （貌似Spring Boot官方不推荐，STS创建的项目会在src/main/resources 下有个templates 目录，这里就是让我们放模版文件的，然后并没有生成诸如 SpringMVC 中的webapp目录） 
<!-- more -->
本文以Thymeleaf为例介绍使用模版，具体步骤如下：

第一步：在pom.xml文件中添加如下模块依赖：
```
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
```
第二步：修改控制器代码，具体为：
```
/**
 * Created by wuranghao on 2017/4/7.
 */
@Controller
public class HelloController {

    @RequestMapping(value="/hello",method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
} 
```
第三步：在resources目录的templates目录下添加一个hello.html文件，具体工程目录结构如下：
<center> ![mark](http://blog.xuejiangtao.com/blog/180929/3bcjHm0gLc.png) </center>
其中，hello.html文件中的内容为：
```
<h1>Hello World!</h1>
```
这样，再次运行此项目之后，在浏览器中输入：localhost:8080/hello

就可以看到hello.html中所呈现的内容了。
 

## @Controller返回数据
需要`@ResponseBody`和`@Controller`组合注解使用,使用方式:
```
@Controller
@ResponseBody
public class HelloController {

    @RequestMapping(value="/hello",method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
} 
```
浏览器输入:localhost:8080/hello
返回的是字符串: hello


```
@Controller
@RequestMapping("/test")
public class MyController1 {
    
    @ResponseBody
    @GetMapping(path="/get1", produces = "text/plain;charset=utf-8")
    public String getMethod1(String str) {
        return str;
    }

    @GetMapping(path="/get2", produces = "text/plain;charset=utf-8")
    public String getMethod2(String str) {
        return str;
    }
} 
```
访问 /test/get1，并携带参数 str="index" ，返回 index 字符串。
访问 /test/get2，并携带参数 str="index" ，返回名为 index 页面，如index.jsp。


# @RestController
`@RestController`是Spring4之后新加入的注解，原来返回json,XML或自定义mediaType数据需要`@ResponseBody`+`@Controller`组合注解。 

官方文档：
@RestController is a stereotype annotation that combines @ResponseBody and @Controller.
意思是：
**@RestController注解相当于@ResponseBody ＋ @Controller合在一起的作用。**
 
意味着这个Controller的所有方法上面都加了@ResponseBody，不论你在每个方法前加、或不加@ResponseBody，都一样。所以这种Controller不会返回页面。
```
@RestController
public class HelloController {

    @RequestMapping(value="/hello",method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
} 
```
与下面代码是一样的:
```
@Controller
@ResponseBody
public class HelloController {

    @RequestMapping(value="/hello",method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
} 
```

# @RequestMapping 配置url映射

`@RequestMapping`此注解即可以作用在控制器的某个方法上，也可以作用在此控制器类上。

当控制器在类级别上添加`@RequestMapping`注解时，这个注解会应用到控制器的所有处理器方法上。处理器方法上的`@RequestMapping`注解会对类级别上的`@RequestMapping`的声明进行补充。

## 例子一：@RequestMapping仅作用在处理器方法上
```
@RestController
public class HelloController {

    @RequestMapping(value="/hello",method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
}
```
以上代码sayHello所响应的url=localhost:8080/hello。

## 例子二：@RequestMapping仅作用在类级别上
```
/**
 * Created by wuranghao on 2017/4/7.
 */
@Controller
@RequestMapping("/hello")
public class HelloController {

    @RequestMapping(method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
} 
```
以上代码sayHello所响应的url=localhost:8080/hello,效果与例子一一样，没有改变任何功能。

## 例子三：@RequestMapping作用在类级别和处理器方法上
```
/**
 * Created by wuranghao on 2017/4/7.
 */
@RestController
@RequestMapping("/hello")
public class HelloController {

    @RequestMapping(value="/sayHello",method= RequestMethod.GET)
    public String sayHello(){
        return "hello";
    }
    @RequestMapping(value="/sayHi",method= RequestMethod.GET)
    public String sayHi(){
        return "hi";
    }
}
```
这样，以上代码中
sayHello所响应的url=localhost:8080/hello/sayHello。
sayHi所响应的url=localhost:8080/hello/sayHi。


参考文章:
https://blog.csdn.net/u010412719/article/details/69710480
https://www.jianshu.com/p/c89a3550588a