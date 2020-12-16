---
title: linux执行定时任务-crontab
date: 2020-12-09 10:16:12
tags: 定时任务,crontab
categories: linux
keywords: linux,定时任务,crontab
---

在/etc/目录下使用vi编辑crontab文件

```
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
*   0-8/1 *  *  * root /var/llzjxpms/pms_cn/src/auto_doendofday.sh
*/5 * * * * root  /var/llzjxpms/pms_cn/src/auto_sync_crmdata.sh

```

之后使用crontab -e 编辑内容，不清楚为什么两个编辑命令出来的内容是不一样的。

```
* 0-8/1 *  *  *  sh /var/llzjxpms/pms_cn/src/auto_doendofday.sh
*/5 * * * *  sh /var/llzjxpms/pms_cn/src/auto_sync_crmdata.sh >>/tmp/log/ganglia/check.log
```

