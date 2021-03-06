---
title: IO和NIO的区别
abbrlink: 9gwc661
date: 2020-07-10 10:14:56
tags: java
categories: java
keywords: io,nio
---
# 一、概念

   NIO即Non-blocking IO，非阻塞IO，这个库是在JDK1.4中才引入的。NIO和IO有相同的作用和目的，但实现方式不同，NIO主要用到的是块，所以NIO的效率要比IO高很多。在Java API中提供了两套NIO，一套是针对标准输入输出NIO，另一套就是网络编程NIO。 

# 二、NIO和IO的主要区别

下表总结了Java IO和NIO之间的主要区别：

| **IO**   | **NIO**          |
| -------- | ---------------- |
| 面向流   | 面向缓冲         |
| 阻塞IO   | 非阻塞IO         |
| 无       | 选择器           |
| 监听机制 | 异步事件驱动机制 |

## **1、面向流与面向缓冲**

   Java IO和NIO之间第一个**最大的区别是，IO是面向流的，NIO是面向缓冲区的**。 Java IO面向流意味着每次从流中读一个或多个字节，直至读取所有字节，它们没有被缓存在任何地方。此外，它不能前后移动流中的数据。如果需要前后移动从流中读取的数据，需要先将它缓存到一个缓冲区。 Java NIO的缓冲导向方法略有不同。数据读取到一个它稍后处理的缓冲区，需要时可在缓冲区中前后移动。这就增加了处理过程中的灵活性。但是，还需要检查是否该缓冲区中包含所有您需要处理的数据。而且，需确保当更多的数据读入缓冲区时，不要覆盖缓冲区里尚未处理的数据。

## **2、阻塞与非阻塞IO**

  	 Java IO的各种流是阻塞的。这意味着，当一个线程调用read() 或 write()时，该线程被阻塞，直到有一些数据被读取，或数据完全写入。该线程在此期间不能再干任何事情了。

​		Java NIO的非阻塞模式，使一个线程从某通道发送请求读取数据，但是它仅能得到目前可用的数据，如果目前没有数据可用时，就什么都不会获取，而不是保持线程阻塞，所以直至数据变的可以读取之前，该线程可以继续做其他的事情。 非阻塞也是如此。一个线程请求写入一些数据到某通道，但不需要等待它完全写入，这个线程同时可以去做别的事情。 线程通常将非阻塞IO的空闲时间用于在其它通道上执行IO操作，所以**一个单独的线程现在可以管理多个输入和输出通道**（channel）。

​		io的各种流是阻塞的，就是当一个线程调用读写方法时，该线程会被阻塞，直到读写完，在这期间该线程不能干其他事，CPU转而去处理其他线程，假如一个线程**监听**一个端口，一天只会有几次请求进来，但是**CPU**却不得不为该线程不断的做**上下文切换**，并且大部分切换以阻塞告终。

 		NIO通讯是将整个任务切换成许多小任务，由一个线程负责处理所有io事件，并负责分发。它是利用**事件驱动机制**，而不是监听机制，事件到的时候再触发。NIO线程之间通过wait，notify等方式通讯。保证了每次上下文切换都有意义，减少无谓的进程切换。 

## **3、选择器（Selectors）**

   Java NIO的选择器允许一个单独的线程来监视多个输入通道，你可以注册多个通道使用一个选择器，然后使用一个单独的线程来“选择”通道：这些通道里已经有可以处理的输入，或者选择已准备写入的通道。这种选择机制，使得一个单独的线程很容易来管理多个通道。