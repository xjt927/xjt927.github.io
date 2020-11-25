---
title: RPC学习笔记
abbrlink: 9adac232
date: 2020-07-10 09:14:56
tags: RPC
categories: 分布式
keywords: rpc
---
# RPC概念

RPC全称为remote procedure call，即**远程过程调用**，其实就是调用远程服务器上的方法。

借助RPC可以做到像本地调用一样调用远程服务，是一种**进程间的通信方式**。比如两台服务器A和B，A服务器上部署一个应用，B服务器上部署一个应用，A服务器上的应用想调用B服务器上的应用提供的方法，由于两个应用不在一个内存空间，不能直接调用，所以需要通过网络来表达调用的语义和传达调用的数据。

需要注意的是RPC并不是一个具体的技术，而是**指整个网络远程调用过程**。

# RPC架构

一个完整的RPC架构里面包含了**四个核心的组件，分别是Client，Client Stub，Server以及Server Stub，这个Stub可以理解为存根。**

- 客户端(Client)，服务的调用方。
- 客户端存根(Client Stub)，**存放服务端的地址消息**，再将客户端的请求参数打包成网络消息，然后通过网络远程发送给服务端。
- 服务端(Server)，真正的服务提供者。
- 服务端存根(Server Stub)，**接收客户端发送过来的消息**，将消息解包，并调用本地的方法。

![mark](http://blog.xuejiangtao.com/blog/20200713/z66ebaPPQugH.png?imageslim)

![mark](http://blog.xuejiangtao.com/blog/20200713/6TBDxeNnpeNO.png?imageslim)

(1) 客户端（client）以本地调用方式（即以接口的方式）调用服务；

(2) 客户端存根（client stub）接收到调用后，负责将方法、参数等组装成能够进行网络传输的消息体（将消息体对象序列化为二进制）；

(3) 客户端通过sockets将消息发送到服务端；

(4) 服务端存根( server stub）收到消息后进行解码（将消息对象反序列化）；

(5) 服务端存根( server stub）根据解码结果调用本地的服务；

(6) 本地服务执行并将结果返回给服务端存根( server stub）；

(7) 服务端存根( server stub）将返回结果打包成消息（将结果消息对象序列化）；

(8) 服务端（server）通过sockets将消息发送到客户端；

(9) 客户端存根（client stub）接收到结果消息，并进行解码（将结果消息发序列化）；

(10) 客户端（client）得到最终结果。

RPC的目标是要把2、3、4、7、8、9这些步骤都封装起来。

注意：无论是何种类型的数据，最终都需要转换成二进制流在网络上进行传输，数据的发送方需要将对象转换为二进制流，而数据的接收方则需要把二进制流再恢复为对象。

在java中RPC框架比较多，常见的有Hessian、gRPC、Thrift、HSF (High Speed Service Framework)、Dubbo等，其实对 于RPC框架而言，核心模块就是**通讯和序列化**。