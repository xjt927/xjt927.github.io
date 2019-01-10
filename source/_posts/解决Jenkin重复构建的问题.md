---
title: 解决Jenkin重复构建的问题
tags: Jenkins
categories: Jenkins
keywords: Jenkins
abbrlink: 2858c1bf
date: 2019-01-10 09:43:10
---

项目中使用Jenkins线上发布版本，不得不说Jenkins确实是个好东西，避免打包、拷贝版本等一系列繁琐事，解放劳动力提高发版效率，使你时间更自由，重要的是可以早点下班陪媳妇儿。
怎样搭建Jenkins就不说了，大家可以自行google、百度。
言归正传，Jenkins刚搭建成功后发布没有问题，前端时间开始，点击构建后会一直自动重复构建项目。  
**猜想一**：刚开始以为有人动了Jenkins发版流程配置，检查几遍发现没有没有任何问题。

**猜想二**：创建构建任务项目时，是复制现有其他任务项目，以为是Jenkins的bug，复制任务项目的问题，遂删除该项目重新创建任务项目，发现还存在重复构建问题。

<!-- more -->

**重点来了**

看日志发现有一段这个提示：
```
Multiple candidate revisions
Scheduling another build to catch up with 进出厂物流（后端）
``` 

![mark](http://blog.xuejiangtao.com/blog/20190110/vJgy3DOrCfwE.png?imageslim)

google了一篇文章 https://issues.jenkins-ci.org/browse/JENKINS-21464

打开自己的gitlab项目，发现不知道啥时候多了一个名称为`origin/develop`分支，将之删除，再次构建项目，没有重复发版。

多出来的分支
![mark](http://blog.xuejiangtao.com/blog/20190110/kHeidG3wtOEC.png?imageslim)

删除后的分支
![mark](http://blog.xuejiangtao.com/blog/20190110/ukdjOY0t3gI1.png?imageslim)
 