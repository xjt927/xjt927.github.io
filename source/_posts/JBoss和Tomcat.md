---
abbrlink: '0'
---
# 什么是Tomcat？

​		Tomcat 服务器是一个免费的开放源代码的Web 应用服务器，属于轻量级应用[服务器](https://baike.baidu.com/item/服务器)，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP 程序的首选。对于一个初学者来说，可以这样认为，当在一台机器上配置好Apache 服务器，可利用它响应[HTML](https://baike.baidu.com/item/HTML)（[标准通用标记语言](https://baike.baidu.com/item/标准通用标记语言/6805073)下的一个应用）页面的访问请求。实际上Tomcat是Apache 服务器的扩展，但运行时它是独立运行的，所以当你运行tomcat 时，它实际上作为一个与Apache 独立的进程单独运行的。



# 什么是JBoss？

​		JBoss是一个基于J2EE的[开放源代码](https://baike.baidu.com/item/开放源代码/114160)的[应用服务器](https://baike.baidu.com/item/应用服务器/4971773)。 JBoss代码遵循LGPL许可，可以在任何商业应用中免费使用。JBoss是一个管理EJB的容器和服务器，支持EJB 1.1、EJB 2.0和EJB3的规范。但JBoss核心服务不包括支持servlet/JSP的WEB容器，一般与Tomcat或Jetty绑定使用。



# Tomcat和JBoss区别对比：

​		Tomcat 服务器是一个免费的开放源代码的Web 应用服务器，属于轻量级应用服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP 程序的首选。Tomcat技术先进、性能稳定，而且免费，因而深受Java 爱好者的喜爱并得到了部分软件开发商的认可。其运行时占用的系统资源小，扩展性好，且支持负载平衡与邮件服务等开发应用系统常用的功能。作为一个小型的轻量级应用服务器，Tomcat在中小型系统和并发访问用户不是很多的场合下被普遍使用，成为目前比较流行的Web 应用服务器。



​		JBoss 采用业界最优的开源Java Web引擎， 将Java社区中下载量最大，用户数最多，标准支持最完备的Tomcat内核作为其Servlet容器引擎，并加以审核和调优。单纯的Tomcat性能有限，在很多地方表现有欠缺，如活动连接支持、静态内容、大文件和HTTPS等。除了性能问题，Tomcat的另一大缺点是它是一个受限的集成平台，仅能运行Java应用程序。企业在使用时Tomcat，往往还需同时部署Apache Web Server以与之整合。此配置较为繁琐，且不能保证性能的优越性。



# JBoss有如下六大优点： 

1、JBoss是免费的，开放源代码J2EE的实现，它通过LGPL许可证进行发布。 
2、JBoss需要的内存和硬盘空间比较小。 
3、安装非常简单。先解压缩JBoss打包文件再配置一些环境变量就可以了。 
4、JBoss能够"热部署"，部署BEAN只是简单拷贝BEAN的JAR文件到部署路径下就可以了。如果没有加载就加载它；如果已经加载了就卸载掉，然后LOAD这个新的。 
5、JBoss与Web服务器在同一个Java虚拟机中运行，Servlet调用EJB不经过网络，从而大大提高运行效率，提升安全性能。 
6、用户可以直接实施J2EE-EAR，而不是以前分别实施EJB-JAR和Web-WAR，非常方便。 



参考

https://blog.csdn.net/cynhafa/article/details/6234900?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase



https://blog.csdn.net/iiiiher/article/details/70158290?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase