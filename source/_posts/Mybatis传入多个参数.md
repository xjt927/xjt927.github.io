---
title: Mybatis传入多个参数
tags: mybatis
categories: mybatis
keywords: mybatis 参数
abbrlink: eae51fdb
date: 2020-01-02 10:08:58
---

##### 一、单个参数

mapper

```
public List<Test> getTestList(String id);
```
xml 
```
<select id = "getTestList" parameterType = "java.lang.String" resultType = "com.test.Test">
　　select t.* from test t where t.id = #{id}
</select>
```

##### 二、多个参数

###### 1、使用索引

mapper

```
public List<Test> getTestList(String id, String name);
```
xml
```
<select id = "getTestList" resultType = "com.test.Test">
　　select t.* from test t where t.id = #{0} and t.name = #{1} 
</select>
```
###### 2、使用Map封装多参数

mapper

```
public List<Test> getTestList(HashMap map);
```
xml
```
<select id = "getTestList" parameterType = "hashmap" resultType = "com.test.Test">
　　select t.* from test t where t.id = #{id} and t.name= #{name} 
</select> 
```
 **#{}中的变量名要和map中的key对应。**

###### 3、使用注解

mapper

```
public List<Test> getTestList(@Param("id")int id, @Param("name")int name);
```
xml
```
<select id = "getTestList" resultMap = "com.test.Test">
   select t.* from test t where t.id = #{id} and t.name = #{name}
</select>
```
