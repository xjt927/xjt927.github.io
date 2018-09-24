---
title: Spring-SpEL表达式语言(3)
tags:
  - Spring
  - SpEL
categories: Spring
keywords: 'Spring,SpEL,表达式'
abbrlink: 1e307c48
date: 2018-09-20 19:49:52
---

#  xml风格的配置
SpEL支持在Bean定义时注入，默认使用“#{SpEL表达式}”表示，其中“#root”根对象默认可以认为是ApplicationContext，只有ApplicationContext实现默认支持SpEL，获取根对象属性其实是获取容器中的Bean。

首先看下配置方式（chapter5/el1.xml）吧：
```
<bean id="world" class="java.lang.String">  
    <constructor-arg value="#{' World!'}"/>  
</bean>  
<bean id="hello1" class="java.lang.String">  
    <constructor-arg value="#{'Hello'}#{world}"/>  
</bean>    
<bean id="hello2" class="java.lang.String">  
    <constructor-arg value="#{'Hello' + world}"/>  
    <!-- 不支持嵌套的 -->  
    <!--<constructor-arg value="#{'Hello'#{world}}"/>-->  
</bean>  
<bean id="hello3" class="java.lang.String">  
    <constructor-arg value="#{'Hello' + @world}"/>  
</bean>  
       模板默认以前缀“#{”开头，以后缀“}”结尾，且不允许嵌套，如“#{'Hello'#{world}}”错误，如“#{'Hello' + world}”中“world”默认解析为Bean。当然可以使用“@bean”引用了。
```

接下来测试一下吧：
```
@Test  
public void testXmlExpression() {  
    ApplicationContext ctx = new ClassPathXmlApplicationContext("chapter5/el1.xml");  
    String hello1 = ctx.getBean("hello1", String.class);  
    String hello2 = ctx.getBean("hello2", String.class);  
    String hello3 = ctx.getBean("hello3", String.class);  
    Assert.assertEquals("Hello World!", hello1);  
    Assert.assertEquals("Hello World!", hello2);  
    Assert.assertEquals("Hello World!", hello3);  
}     
```
是不是很简单，除了XML配置方式，Spring还提供一种注解方式@Value，接着往下看吧。

#  注解风格的配置
基于注解风格的SpEL配置也非常简单，使用@Value注解来指定SpEL表达式，该注解可以放到字段、方法及方法参数上。

测试Bean类如下，使用@Value来指定SpEL表达式：
```
package cn.javass.spring.chapter5;  
import org.springframework.beans.factory.annotation.Value;  
public class SpELBean {  
    @Value("#{'Hello' + world}")  
    private String value;  
    //setter和getter由于篇幅省略，自己写上  
}  
```
首先看下配置文件(chapter5/el2.xml)：
```
<?xml version="1.0" encoding="UTF-8"?>  
<beans  xmlns="http://www.springframework.org/schema/beans"  
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
        xmlns:context="http://www.springframework.org/schema/context"  
        xsi:schemaLocation="  
          http://www.springframework.org/schema/beans  
          http://www.springframework.org/schema/beans/spring-beans-3.0.xsd  
          http://www.springframework.org/schema/context  
http://www.springframework.org/schema/context/spring-context-3.0.xsd">  
   <context:annotation-config/>  
   <bean id="world" class="java.lang.String">  
       <constructor-arg value="#{' World!'}"/>  
   </bean>  
   <bean id="helloBean1" class="cn.javass.spring.chapter5.SpELBean"/>  
   <bean id="helloBean2" class="cn.javass.spring.chapter5.SpELBean">  
       <property name="value" value="haha"/>  
   </bean>  
</beans>  
```

配置时必须使用`"<context:annotation-config/>"`来开启对注解的支持。
有了配置文件那开始测试吧：
```
@Test  
public void testAnnotationExpression() {  
    ApplicationContext ctx = new ClassPathXmlApplicationContext("chapter5/el2.xml");  
    SpELBean helloBean1 = ctx.getBean("helloBean1", SpELBean.class);  
    Assert.assertEquals("Hello World!", helloBean1.getValue());  
    SpELBean helloBean2 = ctx.getBean("helloBean2", SpELBean.class);  
    Assert.assertEquals("haha", helloBean2.getValue());  
}  
```
其中“helloBean1 ”值是SpEL表达式的值，而“helloBean2”是通过setter注入的值，这说明setter注入将覆盖@Value的值。
#  在Bean定义中SpEL的问题

如果有同学问“#{我不是SpEL表达式}”不是SpEL表达式，而是公司内部的模板，想换个前缀和后缀该如何实现呢？

那我们来看下Spring如何在IoC容器内使用BeanExpressionResolver接口实现来求值SpEL表达式，那如果我们通过某种方式获取该接口实现，然后把前缀后缀修改了不就可以了。

此处我们使用BeanFactoryPostProcessor接口提供postProcessBeanFactory回调方法，它是在IoC容器创建好但还未进行任何Bean初始化时被ApplicationContext实现调用，因此在这个阶段把SpEL前缀及后缀修改掉是安全的，具体代码如下：
```
package cn.javass.spring.chapter5;  
import org.springframework.beans.BeansException;  
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;  
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;  
import org.springframework.context.expression.StandardBeanExpressionResolver;  
public class SpELBeanFactoryPostProcessor implements BeanFactoryPostProcessor {  
    @Override  
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory)  
        throws BeansException {  
        StandardBeanExpressionResolver resolver = (StandardBeanExpressionResolver) beanFactory.getBeanExpressionResolver();  
        resolver.setExpressionPrefix("%{");  
        resolver.setExpressionSuffix("}");  
    }  
}  
```
首先通过 ConfigurableListableBeanFactory的getBeanExpressionResolver方法获取BeanExpressionResolver实现，其次强制类型转换为StandardBeanExpressionResolver，其为Spring默认实现，然后改掉前缀及后缀。

开始测试吧，首先准备配置文件(chapter5/el3.xml)：
```
<?xml version="1.0" encoding="UTF-8"?>  
<beans  xmlns="http://www.springframework.org/schema/beans"  
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
        xmlns:context="http://www.springframework.org/schema/context"  
        xsi:schemaLocation="  
           http://www.springframework.org/schema/beans  
           http://www.springframework.org/schema/beans/spring-beans-3.0.xsd  
           http://www.springframework.org/schema/context  
           http://www.springframework.org/schema/context/spring-context-3.0.xsd">  
   <context:annotation-config/>  
   <bean class="cn.javass.spring.chapter5.SpELBeanFactoryPostProcessor"/>  
   <bean id="world" class="java.lang.String">  
       <constructor-arg value="%{' World!'}"/>  
   </bean>  
   <bean id="helloBean1" class="cn.javass.spring.chapter5.SpELBean"/>  
   <bean id="helloBean2" class="cn.javass.spring.chapter5.SpELBean">  
       <property name="value" value="%{'Hello' + world}"/>  
   </bean>  
</beans>  
```
配置文件和注解风格的几乎一样，只有SpEL表达式前缀变为“%{”了，并且注册了“cn.javass.spring.chapter5.SpELBeanFactoryPostProcessor”Bean，用于修改前缀和后缀的。

写测试代码测试一下吧：
```
@Test  
public void testPrefixExpression() {  
    ApplicationContext ctx = new ClassPathXmlApplicationContext("chapter5/el3.xml");  
    SpELBean helloBean1 = ctx.getBean("helloBean1", SpELBean.class);  
    Assert.assertEquals("#{'Hello' + world}", helloBean1.getValue());  
    SpELBean helloBean2 = ctx.getBean("helloBean2", SpELBean.class);  
    Assert.assertEquals("Hello World!", helloBean2.getValue());  
}      
```
此处helloBean1 中通过@Value注入的“#{'Hello' + world}”结果还是“#{'Hello' + world}”说明不对其进行SpEL表达式求值了，而helloBean2使用“%{'Hello' + world}”注入，得到正确的“"Hello World!”。




