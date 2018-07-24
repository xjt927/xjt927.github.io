---
title: Git 忽略文件设置 .ignore 和 .git/info/exclude
tags: Git
categories: Git
keywords: 'Git,.gitignore,exclude'
abbrlink: 66fcee6f
date: 2018-07-24 15:04:44
---

# 使用.gitignore忽略文件
存放地址在项目根目录下的`.gitignore`文件。
在使用git管理代码时，有一些文件不需要提交，将这些文件添加到`.gitignore`文件中，格式如下：
## 示例
```
/target/
!.mvn/wrapper/maven-wrapper.jar

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr

### 项目文件 ###

/pom.xml

```
## 忽略文件使用规则
```
# 此为注释 – 将被 Git 忽略
*.a       # 忽略所有 .a 结尾的文件
!lib.a    # 但 lib.a 除外
/TODO     # 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
build/    # 忽略 build/ 目录下的所有文件
doc/*.txt # 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt
```
## 其他一些过滤条件
```
* ？：代表任意的一个字符
* ＊：代表任意数目的字符
* {!ab}：必须不是此类型
* {ab,bb,cx}：代表ab,bb,cx中任一类型即可
* [abc]：代表a,b,c中任一字符即可
* [ ^abc]：代表必须不是a,b,c中任一字符
```
由于git不会加入空目录，所以下面做法会导致tmp不会存在 tmp/*             //忽略tmp文件夹所有文件
```
改下方法，在tmp下也加一个.gitignore,内容为
 *
 !.gitignore
还有一种情况，就是已经commit了，再加入gitignore是无效的，所以需要删除下缓存
git rm -r --cached ignore_file
```
<!-- more -->

## .gitignore其他功能
`.gitignore` 还有个有意思的小功能，一个空的`.gitignore`文件可以当作是一个placeholder（占位符）。如当你需要为项目创建一个空的log目录时，这就变的很有用。

**使用方法：**创建一个log目录在里面放置一个空的`.gitignore`文件，当你clone这个repo的时候git会自动的创建好一个空的log目录了。

## 注意
`.gitignore`只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改`.gitignore`是无效的。
正确的做法是在每个clone下来的仓库中手动设置不要检查特定文件的更改情况。
`git update-index --assume-unchanged PATH`  在`PATH`处输入要忽略的文件。

# 使用exclude忽略文件
`.git/info/exclude`，本地仓库忽略，这里配置的忽略文件不会提交到代码库中，对团队里的其他人不会有影响，只影响自己本地仓库

# gitignore 和 exclude 的区别
- `.gitignore` 这个文件本身会提交到版本库中去，用来保存的是公共的需要排除的文件。
- `.git/info/exclude` 这里设置的则是你自己本地需要排除的文件，他不会影响到其他人，也不会提交到版本库中去。
 
