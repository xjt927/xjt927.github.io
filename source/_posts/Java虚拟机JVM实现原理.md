---
title: Java虚拟机JVM实现原理
tags:
  - Java
  - JVM
categories: Java
keywords: 'Java,JVM,虚拟机'
abbrlink: '3e210110'
date: 2018-10-08 09:33:26
---

# JVM基础概念
JVM既Java Virtual Machine（java虚拟机），它是虚构出来的计算机，是通过在实际计算机上仿真模拟各种计算机功能来实现的。说白了java虚拟机就是和计算机打交道，代码程序通过java虚拟机得以在计算机上执行。
原理：编译后的java程序指令并不直接在硬件系统的cpu上执行，而是由JVM执行。java程序编译后会生成字节码（.class文件），JVM会识别并运行字节码，可以在多种平台上运行。**JVM在执行字节码时，把字节码解释成具体平台上的机器指令执行**。因此java和平台无关，实现跨平台，既**一次编译，到处运行**。

# JVM生命周期
- JVM属于进程级别，一个java程序对应一个虚拟机。同一台机器上运行三个程序，就会有三个运行中的java虚拟机。
- 启动
java虚拟机总是开始于一个main()方法，这个方法必须是共有、返回void、只接受一个字符串数组参数。在程序执行时，必须给java虚拟机指明这个包含main()方法的类名。
- 运行
main()方法是程序的起点，它被执行的线程初始化为程序的初始线程。程序中其他线程都是由它来启动的。JVM内部的线程分为两种：**守护线程（daemon）**和**普通线程（non-daemon）**main()属于非守护线程，守护线程是java虚拟机自己使用的线程，比如负责垃圾收集的线程就是一个守护线程。当然，你也可以把自己的程序设置为守护线程。
- 消亡
只要java虚拟机中还有普通线程在执行，java虚拟机就不会停止。当程序中所有非守护线程都终止时，JVM才推出；如果有足够权限，可以调用Runtime类或者System.exit()来终止线程。

# JRE、JKD、JVM是什么关系？
JRE(JavaRuntimeEnvironment，Java运行环境)，也就是Java平台。所有的Java 程序都要在JRE下才能运行。普通用户只需要运行已开发好的java程序，安装JRE即可。

JDK(Java Development Kit)是程序开发者用来编译、调试java程序用的开发工具包。JDK的工具也是Java程序，也需要JRE才能运行。为了保持JDK的独立性和完整性，在JDK的安装过程中，JRE也是安装的一部分。所以，在JDK的安装目录下有一个名为jre的目录，用于存放JRE文件。

JVM(JavaVirtualMachine，Java虚拟机)是JRE的一部分。它是一个虚构出来的计算机，是通过在实际的计算机上仿真模拟各种计算机功能来实现的。JVM有自己完善的硬件架构，如处理器、堆栈、寄存器等，还具有相应的指令系统。Java语言最重要的特点就是跨平台运行。使用JVM就是为了支持与操作系统无关，实现跨平台。
 
# JVM的体系结构
![mark](http://blog.xuejiangtao.com/blog/181008/2Hm6BcgGk4.png?imageslim)
![mark](http://blog.xuejiangtao.com/blog/181008/K5d0GFEk0L.png?imageslim)

类装载器（ClassLoader）（用来装载.class文件）

执行引擎（执行字节码，或者执行本地方法）

运行时数据区（方法区、堆、java栈、PC寄存器、本地方法栈）

