---
title: linux常用命令整理
abbrlink: f6c82bc1
date: 2019-03-19 11:14:13
tags:
categories:
keywords:
---
# 查看运行程序
https://www.cnblogs.com/zwgblog/p/5971462.html
https://www.cnblogs.com/liuzhengliang/p/4609632.html
https://baijiahao.baidu.com/s?id=1617448120776344096&wfr=spider&for=pc
ps命令——查看静态的进程统计信息（Processes Statistic）
a：显示当前终端下的所有进程信息，包括其他用户的进程。
u：使用以用户为主的格式输出进程信息。
x：显示当前用户在所有终端下的进程。
-e：显示系统内的所有进程信息。
-l：使用长（long）格式显示进程信息。
-f：使用完整的（full）格式显示进程信息。

ps aux
ps -elf

ps -ef|grep chrome

ps -ef | grep java | awk '{print $2}'

ps aux | grep program_filter_word,ps -ef |grep tomcat 
ps -ef|grep java|grep -v grep 

# 执行脚本命令 
 - sh script.sh    回车
 - ./script.sh     回车
 - /home/xuejiangtao/LinuxStudy/shellStudy/script.sh  回车   指定脚本文件的绝对路径，即可执行
 
 
# 查看日志
https://www.cnblogs.com/kbkiss/p/7567725.html
cat 1.log | grep key  
可以写为： 
grep key 1.log

查看倒数200行
tail es999.log -n 200
head es999.log -n 200

more es999.log |grep session|grep "2273212"

cat  test.log | head -n 200　　# 查看test.log前200行
cat  test.log | tail -n 200　　# 查看test.log倒数200行


grep 过滤内容 文件名 | sort -r
sort 是排序
sort -r 是倒序


在taobao.log日志文件中查找为‘发送’的关键字，查找日志末尾200行，按正序排序
grep 发送  toabao.log | tail -n 200 | sort 
grep 发送  toabao.log | tail -n 200 | sort -r

tail -f taobao.log 

# 查看服务器容量
df：列出文件系统的整体磁盘使用量；
du：评估文件系统的磁盘使用量（常用于评估目录所占容量）

df参数：
-a：列出所有的文件系统，包括系统特有的/proc等文件系统
-k：以KB的容量显示各文件系统
-m：以MB的容量显示各文件系统
-h：以人们较易阅读的GB,MB,KB等格式自行显示
-H：以M=1000K替代M=1024K的进位方式
-T：连同该分区的文件系统名称（例如ext3）也列出
-i：不用硬盘容量，而以inode的数量来显示

du参数：
-a : 列出所有的文件与目录容量，因为默认仅统计目录下面的文件量而已；
-h : 以人们较易读的容量格式（G/M）显示；
-s : 列出总量，而不列出每个个别的目录占用了容量；
-S : 不包括子目录下的总计，与-s有点差别；
-k : 以KB列出容量显示；
-m : 以MB列出容量显示。


常用命令：
df -h 
df -h /etc
df -i
du -h *

du -sh : 查看当前目录总共占的容量。
du -lh --max-depth=1 : 查看当前目录下一级子文件和子目录占用的磁盘容量。
du -ah --max-depth=1 ：显示当前目录的占用磁盘容量


du --apparent-size -h

# 查看内存
https://www.cnblogs.com/shihaiming/p/5949272.html
https://blog.csdn.net/vtopqx/article/details/80774669
https://blog.csdn.net/taozhe666/article/details/80744941
https://blog.csdn.net/Gavinmiaoc/article/details/80527717

free -h

# 释放内存
sync
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches

drop_caches的值可以是0-3之间的数字，代表不同的含义：
0：不释放（系统默认值）
1：释放页缓存
2：释放dentries和inodes
3：释放所有缓存

# 查看程序端口
ps -ef | grep java
netstat -nap | grep 进程id
netstat -tunlp|grep 进程id
netstat -nap | grep java|grep LISTEN

# linux访问url
curl https://www.baidu.com/

# 结束进程
kill -9 进程id

kill -s 9 `pgrep 查找字符串`

查找包含字符串的进程，并杀死
ps -ef | grep 查找字符串 | grep -v grep | cut -c 9-15 | xargs kill -s 9
ps -ef | grep 查找字符串 | grep -v grep | awk '{print $2}' | xargs kill -9
pgrep 查找字符串 | xargs kill -s 9
ps -ef | grep 查找字符串 | awk '{print $2}' | xargs kill -9


# 修改文件
vi 文件名称
q  ：退出
wq ：修改后保存退出
q! : 强制退出，不保存修改的内容
 
 https://baijiahao.baidu.com/s?id=1588552298343207312&wfr=spider&for=pc
一、基本的替换
命令格式1：sed 's/原字符串/新字符串/' 文件 
命令格式2：sed 's/原字符串/新字符串/g' 文件
没有“g”表示只替换第一个匹配到的字符串，有“g”表示替换所有能匹配到的字符串，“g”可以认为是“global”（全局的）的缩写

二、替换某行内容
命令格式1：sed '行号c 新字符串' 文件
命令格式2：sed '起始行号，终止行号c 新字符串' 文件

三、多条件替换
命令格式：sed -e 命令1 -e 命令2 -e 命令3


保存替换结果到文件中
sed -i 命令


sed -i 's/soccer-22bet-spider/order_web/g' start.sh

# 查看占用cpu最高的进程
ps aux|head -1;ps aux|grep -v PID|sort -rn -k +3|head

# 查看占用内存最高的进程
ps aux|head -1;ps aux|grep -v PID|sort -rn -k +4|head

# 查看CPU信息（型号）
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c



ps -mp 3409 -o THREAD,tid,time | sort -rn
printf "%x\n" 3417
jstack 3409 |grep d59 -A 30

# 删除文件
find 路径名 -name 文件名

//查找所有以mp3为扩展的文件
find / -name "*.mp3"  
//查找并删除文件
find / -name "*.mp3" |xargs rm -rf

find /home/xuejiangtao/es999/backup/ -name 'soccer.jar.20190*'

# 拷贝文件
跨目录
cp 源路径/test.txt 目标路径/

同级目录
cp -r dir1 dir2

# 跨服务器拷贝文件

跨服务器拷贝需要用到的命令是scp.

----------------------拷贝文件夹----------------------------------------------

把当前文件夹tempA拷贝到 目标服务器10.127.40.25 服务器的 /tmp/wang/文件夹下

scp -r /tmp/tempA/ wasadmin@10.127.40.25:/tmp/wang/

其中wasadmin是目标服务器的用户名，执行命令提示输入密码，然后输入密码即可

 

----------------------拷贝文件----------------------------------------------

把当前文件夹tempA.txt拷贝到 目标服务器10.127.40.25 服务器的 /tmp/wang/文件夹下

scp  /tmp/tempA.txt wasadmin@10.127.40.25:/tmp/wang/

其中wasadmin是目标服务器的用户名，执行命令提示输入密码，然后输入密码即可

# 文本文件中查找字符串
在normal模式下按下`/`即可进入查找模式，输入要查找的字符串并按下回车。

Vim会跳转到第一个匹配。按下`n`查找下一个，按下`N`查找上一个。

Vim查找支持正则表达式，例如`/vim$`匹配行尾的`"vim"`。 需要查找特殊字符需要转义，例如`/vim\$`匹配`"vim$"`。
