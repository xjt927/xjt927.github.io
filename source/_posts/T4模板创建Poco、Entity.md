---
title: T4模板创建Poco、Entity
tags: [T4,Poco、Entity,WPF,C#]
categories: WPF
abbrlink: 5e9ae70c
keywords: T4,Poco,Entity,模板,代码生成
date: 2018-04-30 13:25:02
---

# 什么是T4模板？

T4，即4个T开头的英文字母组合：Text Template Transformation Toolkit。

T4文本模板，即一种自定义规则的代码生成器。根据业务模型可生成任何形式的文本文件或供程序调用的字符串。（模型以适合于应用程序域的形式包含信息，并且可以在应用程序的生存期更改）

VS本身只提供一套基于T4引擎的代码生成的执行环境，由下面程序集构成：
Microsoft.VisualStudio.TextTemplating.10.0.dll
Microsoft.VisualStudio.TextTemplating.Interfaces.10.0.dll
Microsoft.VisualStudio.TextTemplating.Modeling.10.0.dll
Microsoft.VisualStudio.TextTemplating.VSHost.10.0.dll
<!-- more -->
# T4基本结构
T4模板可以分为：指令块、文本块、控制块。

1. 指令块 - 向文本模板化引擎提供关于如何生成转换代码和输出文件的一般指令。
2. 文本块 - 直接复制到输出的内容。
3. 控制块 - 向文本插入可变值并控制文本的条件或重复部件的程序代码，不能在控制块中嵌套控制块。 
 
# 设计时模板和运行时模板
T4文本模板分为：设计时模板和运行时模板
1. 设计时模板（文本模板）
2. 运行时模板（已预处理的文本模板）   

关于T4的介绍，可以参考这篇文章《[你必须懂的 T4 模板：深入浅出][1]》

# 项目地址

Github地址：[PocoByT4][2]

## T4模板
本文提供通过T4模板生成Poco、Entity，支持的数据库包括Oracle、MySql、SqlServer等数据库。

`OrmLitePocoByT4`是基于[ServiceStack.OrmLite][3]项目中的T4模板改写。
`PetaPocoByT4`是基于[PetaPoco][4]项目的T4模板改写。

## 使用WPF开发的桌面程序

`XJT.Com.EntitySql`为使用WPF开发的桌面程序，可以自动读取excel设计表，同时支持从数据库中读取表，生成实体。

<img src="https://github.com/xjt927/filerepository/blob/master/1525052216(1).jpg?raw=true" height="400">


  [1]: http://www.cnblogs.com/heyuquan/archive/2012/07/26/2610959.html
  [2]: https://github.com/xjt927/PocoByT4
  [3]: https://github.com/ServiceStack/ServiceStack.OrmLite
  [4]: https://github.com/CollaboratingPlatypus/PetaPoco