---
title: SynchronousQueue
abbrlink: f715f7b8
date: 2019-11-20 22:22:26
tags:
categories:
keywords:
---
`SynchronousQueue`类实现了`BlockingQueue`接口。阅读`BlockingQueue`文本以获取有关的更多信息。

`SynchronousQueue`是一个内部只能包含一个元素的队列。插入元素到队列的线程被阻塞，直到另一个线程从队列中获取了队列中存储的元素。同样，如果线程尝试获取元素并且当前不存在任何元素，则该线程将被阻塞，直到线程将元素插入队列。 