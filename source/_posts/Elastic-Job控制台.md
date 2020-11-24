---
title: Linux下安装Dubbo监控中心
abbrlink: 65507e7a
date: 2020-6-28 23:06:44
tags: dubbo
categories: dubbo
keywords: dubbo
---
elastic-job还提供了一个不错的UI控制台，[项目源代码](https://github.com/elasticjob/elastic-job-lite)git clone到本地，mvn install就能得到一个elastic-job-lite-console-${version}.tar.gz的包，解压，然后运行里面的bin/start.sh 就能跑起来。

1. 下载代码后，使用idea打开，我当前使用的是2019.3.1版本。

2. 将所有项目jdk版本配置为1.8，将language level设置为8；

3. maven版本为3.6.3；

4. 在elastic-job-lite-console项目对应的maven中执行install；编译时可能报错，按照报错提示，一步一步install其依赖项目。

5. 最后再install  elastic-job-lite-console项目，最后生成elastic-job-lite-console-3.0.0.M1-SNAPSHOT-console-bin.tar.gz压缩包。

6. 将生成的压缩包解压缩到指定目录，进入bin目录，发现有两个启动文件，start.bat，start.sh，根据需要启动其中一个。
7. 在浏览器中输入http://127.0.0.1:8899/，输入用户和密码，默认都是root

至此elastic-job-lite-console的界面已启动，下面介绍如何使用。

登陆页面后，在注册中心配置页面的列表模块下面，点击添加按钮，并填写注册中心基本信息。

<img src="http://blog.xuejiangtao.com/blog/20200628/XUMe9hb25gCd.png?imageslim" alt="mark" style="zoom:50%;" />



<img src="http://blog.xuejiangtao.com/blog/20200628/3ELIVAe93vIB.png?imageslim" alt="mark" style="zoom: 67%;" />



提交之后，点击连接。

<img src="http://blog.xuejiangtao.com/blog/20200628/dA5mAucUGpAc.png?imageslim" alt="mark" style="zoom:50%;" />

此时我的后台代码已经在运行了，可以很直观的看到作业名称、作业分片、cron表达式等信息，并很方便的操作该作业。

相关代码如下

![mark](http://blog.xuejiangtao.com/blog/20200628/HNtDlfhuReBt.png?imageslim)



<img src="http://blog.xuejiangtao.com/blog/20200628/u9QW5PrivEf1.png?imageslim" alt="mark" style="zoom:50%;" />

![mark](http://blog.xuejiangtao.com/blog/20200628/7AFLbkPpD5Bt.png?imageslim)

作业详情中可以单独控制分片上线、下线

![mark](http://blog.xuejiangtao.com/blog/20200628/AEdMA7alNqx7.png?imageslim)



![mark](http://blog.xuejiangtao.com/blog/20200628/yYzNw2ejmadU.png?imageslim)

![mark](http://blog.xuejiangtao.com/blog/20200628/AWdqF2phBXTx.png?imageslim)