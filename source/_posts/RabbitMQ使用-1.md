---
title: RabbitMQ使用
date: 2020-10-16 09:55:39
tags:
categories:
keywords:
---

RabbitMQ使用方式：

1. 引入RabbitMQ客户端

   ```
   <dependency>
       <groupId>com.rabbitmq</groupId>
       <artifactId>amqp-client</artifactId>
       <version>3.6.5</version>
   </dependency>
   ```

2. RabbitMQ使用

  一、默认发送，直接将消息发送到某个队列，默认交换机type为direct

```
            // 声明默认的队列
            channel.queueDeclare(queneName, true, false, true, null);
```

  二、指定交换机，队列，路由key方式

```
            // 声明交换机类型
            channel.exchangeDeclare("amq.fanout", "fanout", true);
```



