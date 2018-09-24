---
title: Hexo错误”expected end of comment, got end of file”
abbrlink: 11a14c34
date: 2018-09-24 20:19:42
tags:
categories:
keywords:
---
使用hexo generate命令时报错：

```
FATAL Something's wrong. Maybe you can find the solution here: http://hexo.io/docs/troubleshooting.html
Template render error: Error: expected end of comment, got end of file
    at Object._prettifyError (E:\xjt927.github.io\node_modules\nunjucks\src\lib.js:35:11)
    at Template.render (E:\xjt927.github.io\node_modules\nunjucks\src\environment.js:526:21)
    at Environment.renderString (E:\xjt927.github.io\node_modules\nunjucks\src\environment.js:364:17)
    at Promise (E:\xjt927.github.io\node_modules\hexo\lib\extend\tag.js:66:9)
    at Promise._execute (E:\xjt927.github.io\node_modules\bluebird\js\release\debuggability.js:303:9)
    at Promise._resolveFromExecutor (E:\xjt927.github.io\node_modules\bluebird\js\release\promise.js:483:18)
    at new Promise (E:\xjt927.github.io\node_modules\bluebird\js\release\promise.js:79:10)
    at Tag.render (E:\xjt927.github.io\node_modules\hexo\lib\extend\tag.js:64:10)
    at Object.tagFilter [as onRenderEnd] (E:\xjt927.github.io\node_modules\hexo\lib\hexo\post.js:260:16)
    at Promise.then.then.result (E:\xjt927.github.io\node_modules\hexo\lib\hexo\render.js:65:19)
    at tryCatcher (E:\xjt927.github.io\node_modules\bluebird\js\release\util.js:16:23)
    at Promise._settlePromiseFromHandler (E:\xjt927.github.io\node_modules\bluebird\js\release\promise.js:512:31)
    at Promise._settlePromise (E:\xjt927.github.io\node_modules\bluebird\js\release\promise.js:569:18)
    at Promise._settlePromise0 (E:\xjt927.github.io\node_modules\bluebird\js\release\promise.js:614:10)
    at Promise._settlePromises (E:\xjt927.github.io\node_modules\bluebird\js\release\promise.js:693:18)
    at Async._drainQueue (E:\xjt927.github.io\node_modules\bluebird\js\release\async.js:133:16)
    at Async._drainQueues (E:\xjt927.github.io\node_modules\bluebird\js\release\async.js:143:10)
    at Immediate.Async.drainQueues [as _onImmediate] (E:\xjt927.github.io\node_modules\bluebird\js\release\async.js:17:14)
    at runCallback (timers.js:789:20)
    at tryOnImmediate (timers.js:751:5)
    at processImmediate [as _immediateCallback] (timers.js:722:5)
```
想到刚才文章内容中有 # 字符作为普通字符出现，但并没有做转义处理，包含 # 字符的内容如下：
```
${#v1}
```
经过实际测试确实是因为 # 导致的。

首先想到用 Markdown 转义字符 \ 进行转义，但问题依旧。

hexo generate 目标是将 .md 文件内容转为 html 文件，html 可以对字符编码。从网上查了下 # 的 html 编码为 &#35; 替换后问题解决。
```
${&#35;v1}
```
参考文档:
[hexo generate 处理 #](http://zhang-jc.github.io/2016/09/11/hexo-generate-%E5%A4%84%E7%90%86-hashes/)
