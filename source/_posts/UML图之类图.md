---
title: UML图之类图
tags:
  - UML
  - 类图
categories: UML
keywords: 'UML,类图'
abbrlink: d824f0b1
date: 2018-07-26 19:34:53
---

UML教程
https://www.w3cschool.cn/uml_tutorial/
https://blog.csdn.net/soft_zzti/article/details/79811923
https://www.cnblogs.com/shindo/p/5579191.html

# UML定义
Unified Modeling Language (UML)又称统一建模语言或标准建模语言，是始于1997年一个OMG标准，它是一个支持模型化和软件系统开发的图形化语言，为软件开发的所有阶段提供模型化和可视化支持，包括由需求分析到规格，到构造和配置。

统一建模语言（UML，UnifiedModelingLanguage）是面向对象软件的标准化建模语言。

UML规范用来描述建模的概念有，类（对象的）、对象、关联、职责、行为、接口、用例、包、顺序、协作，以及状态。

关系用来把事物结合在一起，包括依赖、关联、泛化和实现关系。
 <!-- more -->
# 类图中关系（relation）
在UML类图中，常见的有以下几种关系: 泛化（Generalization）, 实现（Realization），关联（Association)，聚合（Aggregation），组合(Composition)，依赖(Dependency)
## 泛化（Generalization） 继承

 【泛化关系】：是一种继承关系，表示一般与特殊的关系，它指定了子类如何特化父类的所有特征和行为。
 例如：老虎是动物的一种，即有老虎的特性也有动物的共性。
 【箭头指向】：带三角箭头的实线，箭头指向父类
<center>
![mark](http://blog.xuejiangtao.com/blog/180819/geE0HhkfhG.png)
泛化
</center>

## 实现（Realization）
【实现关系】：是一种类与接口的关系，表示类是接口所有特征和行为的实现.
【箭头指向】：带三角箭头的虚线，箭头指向接口
<center>
![mark](http://blog.xuejiangtao.com/blog/180819/EICBh24l6c.png)
实现
</center>

## 关联（Association)
【关联关系】：是一种拥有的关系，它使一个类知道另一个类的属性和方法；如：老师与学生，
丈夫与妻子关联可以是双向的，也可以是单向的。
双向的关联可以有两个箭头或者没有箭头，单向的关联有一个箭头。
【代码体现】：成员变量
【箭头及指向】：带普通箭头的实心线，指向被拥有者
<center>
![mark](http://blog.xuejiangtao.com/blog/180819/aGm9JiK4l2.png)
关联
</center>

上图中，老师与学生是双向关联，老师有多名学生，学生也可能有多名老师。
但学生与某课程间的关系为单向关联，一名学生可能要上多门课程，课程是个抽象的东西他不拥有学生。
下图为自身关联：
<center>
![mark](http://blog.xuejiangtao.com/blog/180819/47jEiI3Ki5.png)
自身关联
</center>

## 聚合（Aggregation）
【聚合关系】：是整体与部分的关系，且部分可以离开整体而单独存在。
如车和轮胎是整体和部分的关系，轮胎离开车仍然可以存在。
聚合关系是关联关系的一种，是强的关联关系；关联和聚合在语法上无法区分，必须考察具体的逻辑关系。
【代码体现】：成员变量
【箭头及指向】：带空心菱形的实心线，菱形指向整体
<center>
![mark](http://blog.xuejiangtao.com/blog/180819/g1c4mC8bJ4.png)
聚合
</center>
## 组合(Composition)

 【组合关系】：是整体与部分的关系，但部分不能离开整体而单独存在。
  如公司和部门是整体和部分的关系，没有公司就不存在部门。
 组合关系是关联关系的一种，是比聚合关系还要强的关系，
 它要求普通的聚合关系中代表整体的对象负责代表部分的对象的生命周期。
    【代码体现】：成员变量
    【箭头及指向】：带实心菱形的实线，菱形指向整体
<center>
    ![mark](http://blog.xuejiangtao.com/blog/180819/BJFa34lF5K.png)
组合
</center>
## 依赖(Dependency)
【依赖关系】：是一种使用的关系，即一个类的实现需要另一个类的协助，
 所以要尽量不使用双向的互相依赖.
【代码表现】：局部变量、方法的参数或者对静态方法的调用
【箭头及指向】：带箭头的虚线，指向被使用者
<center>
    ![mark](http://blog.xuejiangtao.com/blog/180819/elFAI1iBi2.png)
依赖
</center>

各种关系的强弱顺序：
泛化 = 实现 > 组合 > 聚合 > 关联 > 依赖
下面这张UML图，比较形象地展示了各种类图关系：
<center>
![mark](http://blog.xuejiangtao.com/blog/180819/l0ID1k3Ji0.png)
11.png
</center>

**类图绘制的要点**

1. 类的操作是针对类自身的操作，而不是它去操作人家。比如书这个类有上架下架的操作，是书自己被上架下架，不能因为上架下架是管理员的动作而把它放在管理员的操作里。
2. 两个相关联的类，需要在关联的类中加上被关联类的ID，并且箭头指向被关联类。可以理解为数据表中的外键。比如借书和书，借书需要用到书的信息，因此借书类需包含书的ID，箭头指向书。
3. 由于业务复杂性，一个显示中的实体可能会被分为多个类，这是很正常的，类不是越少越好。类的设计取决于怎样让后台程序的操作更加简单。比如单看逻辑，借书类可以不存在，它的信息可以放在书这个类里。然而借还书和书的上架下架完全不是一回事，借书类对借书的操作更加方便，不需要去重复改动书这个类中的内容。此外，如果书和借书是1对多的关系，那就必须分为两个类。
4. 类图中的规范问题，比如不同关系需要不同的箭头，可见性符号等。

# UML类图

类图由第一层类名，第二层由属性，第三层由方法，组成。
![mark](http://blog.xuejiangtao.com/blog/180819/iCCDIC8llF.png)

指定一个类成员（即任何属性或方法）的可见性有下列符号，必须摆在各成员的名字之前：
```
+	  public 公共 
- 	  private 私有 
# 	  protected 保护（即对子类可见）
~         包（即对包内其他成员可见）
/         推导（即由其他属性推导得出，不需要直接给定其值）
底線       静态
```
## UML类图中属性表达方式

属性的完整表示方式如下：
```
可见性  名称 ：类型 [ = 缺省值]
```
中括号中的内容表示是可选的。

比如下图表示一个Employee类，它包含name,age和email这3个属性，以及modifyInfo()方法。
![mark](http://blog.xuejiangtao.com/blog/180819/0gdIec9jD5.png)

## UML类图中方法的表达式
方法的完整表示方式如下：
```
可见性  名称(参数列表) [：返回类型]
```
同样，中括号中的内容是可选的。

比如在下图的Demo类中，定义了3个方法：
![mark](http://blog.xuejiangtao.com/blog/180819/8Gkb31akh2.png)

- public方法method1接收一个类型为Object的参数，返回值类型为void
- protected方法method2无参数，返回值类型为String
- private方法method3接收类型分别为int、int[]的参数，返回值类型为int

![mark](http://blog.xuejiangtao.com/blog/180819/Ggf6cbakgm.png)

![mark](http://blog.xuejiangtao.com/blog/180819/641G3DBDf4.png)