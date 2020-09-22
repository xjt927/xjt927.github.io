---
title: git上传文件超过100M，push异常
date: 2020-09-12 11:02:00
tags:
categories:
keywords:
---

# Git remote: error: this exceeds file size limit of 100.0 MB

吴提交了一些文件导致push代码时报异常，是因为github、gitee不允许上传超过100M的大文件。

`remote: error: File ******* is 199.68 MB; this exceeds GitHub‘s file size limit of 100.00 MB`



# 解决办法：

在git的顶级目录执行以下代码

```
git filter-branch -f --prune-empty --index-filter 'git rm -rf --cached --ignore-unmatch 要删除的文件路径' --tag-name-filter cat -- --all
```

**要删除的文件路径** 为当前git顶级目录下的全路径（有`.git`目录），比如**第三阶段/dubboo/code/dubbo_source/dubbo.rar**

![mark](http://blog.xuejiangtao.com/blog/20200912/dgkhlLCtJRuY.png?imageslim)

等执行完成后再push，ok了。

