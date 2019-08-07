---
title: .start.sh启动命令
date: 2019-07-26 16:58:14
tags:
categories:
keywords:
---

#!/bin/sh


JAVA_HOME=/usr/java

process=`ps -ef | grep java |grep /home/xuejiangtao/m88/soccer | awk '{print $2}'`


if [ "$process" != "" ]; then
        echo '应用下线.......'
        echo '杀死进程'$process
        kill -9 $process
fi

echo '重新启动中,请耐心等待5s......'
cd /home/xuejiangtao/m88
cp /home/xuejiangtao/m88/backup/soccer.jar /home/xuejiangtao/m88/

datef=`date  +%Y%m%d%H%M%S`
cp /home/xuejiangtao/m88/backup/soccer.jar /home/xuejiangtao/m88/backup/soccer.jar.${datef}

nohup ${JAVA_HOME}/bin/java   -Xmx500m \
                        -Xms500m \
                        -XX:MetaspaceSize=64m \
                        -XX:+UseConcMarkSweepGC \
                        -XX:ParallelCMSThreads=2 \
                        -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=80 -XX:+CMSParallelRemarkEnabled \
                        -Xloggc:./logs/gc.log \
                        -XX:+PrintGCDetails \
                        -XX:+PrintGCTimeStamps \
                        -XX:+PrintGCDateStamps  \
                        -XX:+PrintGCApplicationConcurrentTime \
                        -XX:+PrintGCApplicationStoppedTime \
						
                        -Djava.rmi.server.hostname=39.106.4.13 \
                        -Dcom.sun.management.jmxremote \
                        -Dcom.sun.management.jmxremote.port=9094 \
                        -Dcom.sun.management.jmxremote.authenticate=false \
                        -Dcom.sun.management.jmxremote.ssl=false \
                        -jar /home/xuejiangtao/m88/soccer.jar \
                         >/dev/null 2>&1 &

"start.sh" 52L, 1809C