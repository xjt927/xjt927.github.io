---
title: linux下设置redis开机启动
abbrlink: 1a0fe82
date: 2019-12-08 15:13:08
tags:
categories:
keywords:
---
步骤1：设置redis.conf中daemonize为yes,确保守护进程开启。
步骤2：编写开机自启动脚本

基本原理为：
系统开机启动时会去加载/etc/init.d/下面的脚本，通常而言每个脚本文件会自定义实现程序的启动；若想将新的程序开机自启动，只需在该目录下添加一个自定义启动程序的脚本，然后设置相应规则即可。
如在这里我们在/etc/init.d/下新建一个 redis 的脚本，开机启动时会去加载执行该脚本。

```vim /etc/init.d/redis```

脚本内容如下：
```
#!/bin/sh  
#chkconfig: 2345 80 90  
# Simple Redis init.d script conceived to work on Linux systems  
# as it does use of the /proc filesystem.  
REDISPORT=6379                          #端口号，这是默认的，如果你安装的时候不是默认端口号，则需要修改
REDISPATH=/usr/local/bin/                #redis-server启动脚本的所在目录，你如果忘了可以用find / -name redis-server 或whereis redis-server找到 
EXEC=${REDISPATH}/redis-server            
CLIEXEC=${REDISPATH}/redis-cli  
PIDFILE=/var/run/redis.pid  #在redis.conf中可找到该路径   /var/run/redis_${REDISPORT}.pid
CONF="${REDISPATH}/redis.conf"           #redis.conf的位置, 如果不和redis-server在同一目录要修改成你的redis.conf所在目录
case "$1" in  
  start)  
    if [ -f $PIDFILE ]  
    then  
        echo "$PIDFILE exists, process is already running or crashed"  
    else  
        echo "Starting Redis server..."  
        $EXEC $CONF  
    fi  
    ;;  
  stop)  
    if [ ! -f $PIDFILE ]  
    then  
        echo "$PIDFILE does not exist, process is not running"  
    else  
        PID=$(cat $PIDFILE)  
        echo "Stopping ..."  
        $CLIEXEC -p $REDISPORT shutdown  
        while [ -x /proc/${PID} ]  
        do  
          echo "Waiting for Redis to shutdown ..."  
          sleep 1  
        done  
        echo "Redis stopped"  
    fi  
    ;;  
  *)  
    echo "Please use start or stop as first argument"  
    ;;  
esac  
```

写完后wq保存退出

设置可执行权限：

```chmod 777 /etc/init.d/redis```
启动redis:
```/etc/init.d/redis start```

执行结束之后用redis-cli 或者 ps aux|grep redis 查看redis是否成功启动.

设置开机启动:
```
chkconfig redis on
```

关机重启测试:
```reboot```