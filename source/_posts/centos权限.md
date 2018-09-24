---
title: Centos权限
tags:
  - Centos
  - 权限
categories: Centos
keywords: 'Centos,权限'
abbrlink: 4b590c7d
date: 2018-05-18 19:40:26
---

chmod -R 777 /文件夹名称

如何改变文件属性与权限
1.
chgrp，改变文件所属用户组；

chown，改变文件所有者；

chmod，改变文件的权限。  chmod -R 777 /data/project/ 设置project下所有文件的权限

2.

chgrp就是change group的简称，使用该指令时，要被改变的组名必须在/etc/group文件内存在才行。

chgrp [-R] group filename(or dirname)，其中R表示进行递归（recursive）的持续更改，也即连同子目录下的所有文件、目录。所以当修改一个目录中所有文件的用户组（所有者与权限也一样）时，要加上-R。

例如将文件install.log改到users用户组

$chgrp users install.log
 <!-- more -->
3.

chown就是change owner的简称。

chown [-R] user filename(or dirname)，改变file的文件所有者为user。

chown [-R] .group filename(or dirname)，改变file的用户组为group（注意加点）。

chown [-R] user.group filename(or dirname)，改变file的文件所有者为user，用户组为group。为避免“.”引起的系统误判，通常用一下命令表示该句：
chown [-R] user:group filename(or dirname)。

4.

复制文件给其他人，复制命令：

$cp [-option] [source file or dir] [target file or dir]

复制行为（cp）会复制执行者的属性与权限，所以即使复制到他人用户组仍然无法使用，所以这时必须修改该权限。

5.

chmod就是change mode bits的简称。

数字类型改变文件权限：

chmod [-R] xyz fileordir，其中x代表owner权限，y代表group权限，z代表others权限。

r=4，w=2，x=1，上面三种身份的权限是r+w+x的和，如果没有相应的权限，则值为0。

例如：install.log文件，owner=rwx=4+2+1=7，group=rwx=4+2+1=7，others=---=0+0+0=0，所以这个文件的将改变权限值为770：

chmod 770 install.log。

6.

符号类型改变文件权限

我们可以用u，g，o三个参数来代表user，group，others 3种身份的权限。

a代表all，也即全部的身份。

读写的权限就可以写成r，w，x。

+，-，=分别代表加入，出去，设置一个权限。

加入要设置一个文件的权限成“-rwxr-xr-x，指令为：

chmod u=rwx,go=rx filename，注意加上那个逗号。

要给一个文件的全部身份加上x权限，则指令为：

chmod a+x filename。

