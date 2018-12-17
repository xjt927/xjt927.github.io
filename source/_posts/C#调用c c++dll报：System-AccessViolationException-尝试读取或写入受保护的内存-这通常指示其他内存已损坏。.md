---
title: 'C#调用c/c++dll报：System.AccessViolationException 尝试读取或写入受保护的内存,这通常指示其他内存已损坏。'
date: 2018-12-15 10:24:38
tags:
categories:
keywords:
---

项目中用到使用C#调用c++接口dll，有一个接口参数是struct结构类型，在调用c++接口时报出异常：System.AccessViolationException 尝试读取或写入受保护的内存,这通常指示其他内存已损坏。
网上找了很多解决方法都不行，后来将结构中的一个参数类型换成IntPtr竟然可以了。
因为结构中的state为指针，所以必须使用IntPtr方式传值。

c++接口，其中`PtDioReadBit`类型为结构类型
```
[DllImport("ADSAPI32.dll",  EntryPoint = "DRV_DioReadBit")]
public static extern UInt16 DRV_DioReadBit(int DriverHandle,ref PtDioReadBit DioReadBit);
```

```
[StructLayout(LayoutKind.Sequential)]
public struct PtDioReadBit
{ 
    public UInt16 Port;
    public UInt16 Bit;
    public IntPtr State;
}
```