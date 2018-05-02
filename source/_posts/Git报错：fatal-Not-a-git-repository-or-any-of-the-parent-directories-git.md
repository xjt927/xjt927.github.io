---
title: 'Git报错：fatal: Not a git repository (or any of the parent directories): .git'
tags: Git
categories: Git
abbrlink: be93165a
date: 2018-05-02 08:57:26
---
# 前言
在使用Git进行`push`，`fetch`等操作时，提示：
`fatal: Not a git repository (or any of the parent directories): .git`

# 产生原因：
一般是没有初始化git本地版本管理仓库，所以无法执行git命令
<!-- more -->
# 解决方法：
1. 执行以下命令行: `git init`
2. 再执行查看状态信息：`git status`

<img src="https://github.com/xjt927/filerepository/blob/master/2G$%5BOZ~U@7%5B7VGHBJULHNCO.png?raw=true" height="300">