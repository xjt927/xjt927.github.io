---
title: Zookeeper学习笔记
abbrlink: 6x507e71
date: 2020-8-19 22:31:44
tags: zookeeper
categories: zookeeper
keywords: zookeeper
---
# Zookeeper基本概念

Zookeeper是一个开源的**分布式协调服务**，其设计目标是将那些复杂的且容易出错的分布式一致性服务封装起来，构成一个高效可靠的原语集，并以一些简单的接口提供给用户使用。zookeeper是一个典型的**分布式数据一致性的解决方案**，分布式应用程序可以基于它实现诸如**数据订阅/发布、负载均衡、命名服务、集群管理、分布式锁和分布式队列等功能**。



## Zookeeper角色

Leader、Follower、Observer三种角色

Zookeeper集群中的所有机器通过Leader选举来选定一台被称为 Leader的机器，Leader服务器为客户端提供读和写服务。除Leader外，其他机器包括Follower和 Observer，**Follower和Observer都能提供读服务**，唯一的区别在于**Observer不参与Leader选举过程， 不参与写操作的过半写成功策略**，因此Observe r可以在不影响写性能的情况下提升集群的性能。



![mark](http://blog.xuejiangtao.com/blog/20200714/pUBRyPTw9S9n.png?imageslim)

## 客户端发送写请求

一、客户端写请求会随机请求到follower、observer或leader

1. 如果写请求分给follower/observer节点，则将请求转发给leader去处理

2. leader接收到写请求后，把该写请求转换成带各种状态的事务，将该事务进行广播（发送proposal，类似Paxos算法中的提案Proposal）

3. 所有接收到proposal的follower进行投票，需要向leader返回ACK消息

4. leader根据follower返回的ACK消息，判断如果大部分节点可以执行事务，则向所有follower和observer发送事务提交操作。follower和observer接收到leader发送来的提交事务的请求后，将事务写到日志中并去完成事务的执行。

二、写请求完成后，谁接收的客户端请求则由谁再将结果返回给客户端。

## 客户端发送读请求

客户端读请求会随机请求到follower、observer或leader



## Observer角色

Observer**不参与Leader投票过程**，只**提供读服务**。当Observer接收到leader发送提交事务请求后，会去**提交事务**，保持数据的一致性。

但是能接收到leader的投票广播。

Observer除了不进行投票外和Follower功能相同。因此observer在不影响写性能的前提下，提高集群性能。

## 会话（session）

Session指客户端会话，一个客户端连接是指**客户端和服务端之间的一个TCP长连接**，Zookeeper对外的服务端口默认为**2181**。**客户端启动的时候，首先会与服务器建立一个TCP连接，从第一次连接建立开始，客户端会话的生命周期也开始了**，通过这个连接，客户端能够**心跳检测**与服务器保持有效的会话，也能够向Zookeeper服务器**发送请求**并**接受响应**，同时还能够通过该连接接受来自服务器的**Watch事件通知**。

## 数据节点（Znode）

Zookeeper中，"节点"分为两类，第一类同样是指构成集群的机器，我们称之为**机器节点**；第二类则是指数据模型中的**数据单元**，我们称之为**数据节点一一ZNode**。

Zookeeper将所有数据存储在内存中，数据模型是一棵树（ZNode Tree），由斜杠（/）进行分割的路径，就是一个Znode,例如/app/path1。每个ZNode上都 会保存自己的数据内容，同时还会保存一系列属性信息。

# **Zookeeper基本使用**

在ZooKeeper中，数据信息被保存在一个个数据节点上，这些节点被称为znode。ZNode是 Zookeeper中最小数据单位，在ZNode下面又可以再挂ZNode,这样一层层下去就形成了一个层次化 命名空间ZNode树，我们称为ZNode Tree,它采用了类似文件系统的层级树状结构进行管理。



## ZNode的类型

持久性节点(Persistent)

临时性节点(Ephemeral)

顺序性节点(Sequential)



**持久节点：**是Zookeeper中最常见的一种节点类型，所谓持久节点，就是指节点被创建后会一直存在服 务器，直到删除操作主动清除

**持久顺序节点：**就是有顺序的持久节点，节点特性和持久节点是一样的，只是额外特性表现在顺序上。 顺序特性实质是在创建节点的时候，会在节点名后面加上一个数字后缀，来表示其顺序。

**临时节点：**就是会被自动清理掉的节点，它的生命周期和客户端会话绑在一起，客户端会话结束，节点 会被删除掉。与持久性节点不同的是，临时节点不能创建子节点。

**临时顺序节点：**就是有顺序的临时节点，和持久顺序节点相同，在其创建的时候会在名字后面加上数字 后缀。

## **事务ID**

ZooKeeper中，事务是指能够改变ZooKeeper服务器状态的操作，我们也称之为事务操作或更新操作，一般包括数据节点创建与删除、数据节点内容更新等操作。对于每一个事务请求，ZooKeeper都会为其分配一个全局唯一的事务ID，用**ZXID**来表示，通常是一个64位的数字。每一个ZXID对应一次更新操作，从这些ZXID中可以间接地识别出ZooKeeper处理这些更新操作请求的全局顺序

## ZNode的状态信息



![mark](http://blog.xuejiangtao.com/blog/20200730/Ubg8UWamASyP.png?imageslim)

整个ZNode节点内容包括两部分：节点数据内容和节点状态信息。



 cZxid 就是 Create ZXID，表示节点被创建时的事务ID。

 ctime 就是 Create Time，表示节点创建时间。

 mZxid 就是 Modified ZXID，表示节点最后⼀次被修改时的事务ID。

 mtime 就是 Modified Time，表示节点最后⼀次被修改的时间。

 pZxid 表示该节点的⼦节点列表最后⼀次被修改时的事务 ID。只有⼦节点列表变更才会更新 pZxid，⼦节点内容变更不会更新。

 cversion 表示⼦节点的版本号。

 dataVersion 表示内容版本号。

 aclVersion 标识acl版本

 ephemeralOwner 表示创建该临时节点时的会话 sessionID，如果是持久性节点那么值为 0

 dataLength 表示数据⻓度。

 numChildren 表示直系⼦节点数。

## Watcher--数据变更通知

Zookeeper使用Watcher机制实现分布式数据的发布/订阅功能

Zookeeper的Watcher机制主要包括**客户端线程**、**客户端WatcherManager**、**Zookeeper服务器**三部分。

具体工作流程为：客户端在向Zookeeper服务器注册的同时，会将Watcher对象存储在客户端的WatcherManager当中。当Zookeeper服务器触发Watcher事件后，会向客户端发送通知，客户端线程从WatcherManager中取出对应的Watcher对象来执行回调逻辑。



## ACL--保障数据的安全

如何保障系统中数据的安全，从而避免因误操作所带来的数据随意变更，而导致的数据库异常十分重要，在Zookeeper中，提供了一套完善的 ACL (Access Control List)权限控制机制来保障数据的安全。

我们可以从三个方面来理解ACL机制：权限模式(Scheme)、授权对象(ID)、权限(Permission)，通常使用"scheme: id:permission"来标识一个有效的ACL信息。

四种模式：

1. IP
2. Digest
3. Wordld
4. Super

# Zookeeper应用场景

数据发布/订阅
命名服务
集群管理
分布式日志收集系统
Master选举
分布式锁
排他锁
共享锁
羊群效应
分布式队列

# Zookeeper深入进阶

ZAB协议
ZAB核心
ZAB协议介绍

