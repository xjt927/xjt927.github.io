---
title: tomcat管理页面403 Access Denied的解决方法
date: 2018-12-05 09:39:50
tags: tomcat
categories: tomcat
keywords: tomcat
---

在tomcat下conf/tomcat-users.xml文件添加以下用户。

```
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="admin" password="123456" roles="admin-gui,manager-gui,manager-script" />
<user username="deploy" password="123456" roles="admin-gui,manager-gui,manager-script" />
```

进入Tomcat的manager时拒绝访问： 403 Access Denied

打开tomcat目录下/webapps/manager/META-INF/context.xml文件

将里面内容修改为：
```
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
		 allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|\d+\.\d+\.\d+\.\d+" />
```
这是因为原配置只允许ip为127.*.*.*访问，增加\d+\.\d+\.\d+\.\d+则不做ip限制。
做完上面这些之后重启tomcat。