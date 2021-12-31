---
title: git提交超过100M的大文件处理方式
abbrlink: b00439bc
date: 2021-03-04 19:03:45
tags:
categories:
keywords:
---



提交git时不小心提交了超过100m的文件，导致git提交失败：

```
remote: error: File: c7ff516d5323e220ffa1913e74bd7f8c13ca3481 467.21 MB, exceeds 100.00 MB.
```

 解决步骤：

1. 第一步，查看大文件对应的路径

   ```
   git rev-list --objects --all | grep c7ff516d5323e220ffa1913e74bd7f8c13ca3481 
   ```

   输出

	```
	c7ff516d5323e220ffa1913e74bd7f8c13ca3481 db/pms_crm/20210217235513.nb3
	```
2. 第二步
``` 
git filter-branch --force --index-filter  "git rm -rf --cached --ignore-unmatch db/pms_crm/20210217235513.nb3" --prune-empty --tag-name-filter cat -- --all
```

出现这个错误

``` 
Cannot rewrite branches: You have unstaged changes
```

##### 解决方案：执行`git stash`即可解决。
3. 第三步，推送
```
git push origin master --force
```