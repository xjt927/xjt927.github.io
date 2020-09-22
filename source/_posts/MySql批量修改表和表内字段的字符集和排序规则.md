---
title: MySql批量修改表和表内字段的字符集和排序规则
date: 2020-09-22 09:14:56
tags:
categories:
keywords:
---

数据库的默认排序规则是`utf8mb4_0900_ai_ci`，当A数据库的排序规则是`utf8mb4_unicode_ci`时，从A数据库导入数据的表都用的是`utf8mb4_unicode_ci`的排序规则。

**数据库进行多表关联查询时，如果两张表的字符集或者排序规则不一致，就会报错。**

因此需要修改表内所有字段类型是varchar的编码。



#### 批量修改字段

```
SELECT TABLE_SCHEMA '数据库',TABLE_NAME '表',COLUMN_NAME '字段',CHARACTER_SET_NAME '原字符集',COLLATION_NAME '原排序规则',
    CONCAT(
        'ALTER TABLE `',
        TABLE_NAME,
        '` MODIFY `',
        COLUMN_NAME,
        '` ',
        DATA_TYPE,
        '(',
        CHARACTER_MAXIMUM_LENGTH,
        ') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci',
        ( CASE WHEN IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE '' END ),
        ';' 
)  '修正SQL'
FROM
    information_schema.COLUMNS 
WHERE
    TABLE_SCHEMA = '数据库名' 
    AND (
    DATA_TYPE = 'varchar' 
    OR DATA_TYPE = 'char')
```

将数据库名替换成要修改的数据库名称，执行sql语句，生成修改SQL。

然后执行“**修正SQL**”字段里的sql语句，就完成批量修改了。

![mark](http://blog.xuejiangtao.com/blog/20200922/gmP6RLIwJkBB.png?imageslim)



#### 批量修改表

```
SELECT TABLE_SCHEMA '数据库',TABLE_NAME '表',TABLE_COLLATION '原排序规则',
    CONCAT( 'ALTER TABLE ', TABLE_NAME, ' CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;' )  '修正SQL'
FROM
    information_schema.TABLES 
WHERE
    TABLE_SCHEMA = '数据库名';
```



#### 批量修复数据库

```
SELECT SCHEMA_NAME '数据库',DEFAULT_CHARACTER_SET_NAME '原字符集',DEFAULT_COLLATION_NAME '原排序规则',
	CONCAT('ALTER DATABASE ',SCHEMA_NAME,' CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;') '修正SQL'
FROM information_schema.`SCHEMATA`
WHERE DEFAULT_CHARACTER_SET_NAME RLIKE 'utf8';
```



将以上SQL语句中的`utf8mb4`、`utf8mb4_unicode_ci`、`数据库名`分别改成自己需要的值，成功执行后，将执行结果即SQL语句复制出来，再执行这些SQL语句即可。