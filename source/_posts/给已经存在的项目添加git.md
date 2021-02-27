---
title: 给已存在的项目添加git
tags: Git
categories: Git
keywords: Git
abbrlink: 9e4dab1
date: 2018-12-20 09:12:07
---
前提：先去gitlab或github网站上创建一个新项目

## 方式一

1、打开终端​，cd到已存在项目的目录

2、输入以下命令行，初始化一个本地仓库：

```
git init
```

3、输入以下命令，添加远程仓库地址：
```
输入：git remote add origin + 你的仓库地址

例如：git remote add origin https://***.git

如果出现fatal: remote origin already exists.
说明你已经添加过远程仓库了，输入以下命令删除远程仓库：git remote rm origin
然后再次执行第5步。
```
4、从远程仓拉取项目，`git pull --progress -v --no-rebase "origin" master`

5、输入以下命令，把工程所有文件都添加到该仓库中（千万别忘记后面的`.`号！！！）：

```
git add .
```
<!-- more -->
6、输入以下命令，把文件提交到本地仓库：

```
git commit -m "Initial commit"
```
如果出现`nothing to commit, working directory clean​`说明你已经提交好了。

7、​输入以下命令，把文件提交到远程仓库：

```
git push -u origin master
```

然后你就等着它提交完成就完事了。

8、假如第6部失败的话再执行`git pull –rebase origin master`命令，然后再执行`git push -u origin master`即可上传成功。

9、完事后假如还是不能拉代码的话再重启项目执行`git branch –set-upstream master origin/master`即可。 



## 方式二

1. 在项目所在目录右键，选择git的快捷键`Git Bash Here`，输入命令`git init`初始化git。
2. 给git添加远程仓库地址`git remote add origin http://192.168.3.2:8003/platform/***.git`

3. 从远程仓拉取项目，`git pull --progress -v --no-rebase "origin" master`
4. 将该文件夹下的所有文件加入到git仓库中，`git add .`
5. 提交到本地仓库`git commit -m "Initial commit"`
6. 推送到远程仓库`git push -u origin master`