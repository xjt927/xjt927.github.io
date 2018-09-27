---
title: '[JPA] javax.persistence.EntityNotFoundException处理'
tags: 'JPA,ORM'
categories: JPA
keywords: 'jpa,orm'
abbrlink: 105963c3
date: 2018-09-25 11:31:36
---

通过hibernate映射关系加载数据时遇到了如下错误： `javax.persistence.EntityNotFoundException: Unable to find 对象名 with id xxxxx`。

原因：
无论是`@OneToOne` 还是`@ManyToOne`，出现这个原因都是因为子表（被关联表）中没有主表（关联表）中ID所对应的记录。
	
<!-- more -->

解决办法：
 1. 检查为什么子表中没有主表中ID对应的记录
 2. 如果希望子表中没有主表ID对应的记录也可以正常加载数据，那么需要在主表字段上加一个`@NotFound  Annotation`。示例如下：

```
    @OneToOne(optional=true )
    @JoinColumn(name="companyId",insertable=false, updatable=false)
    @NotFound(action=NotFoundAction.IGNORE)
    private Company company;
```

这样，当子表中没找到数据时，主表中对应的field就是null，而不会报错了。
	
文章转自:https://my.oschina.net/ethan09/blog/203729