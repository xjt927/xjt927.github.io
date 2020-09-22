---
title: java获取系统信息
date: 2020-09-14 12:47:13
tags:
categories:
keywords:
---


获取系统属性：

```
// System.getProperty("属性名称")
System.getProperty("user.home")
```



可以获取的系统属性如下：

```
"java.runtime.name" -> "Java(TM) SE Runtime Environment"
"sun.boot.library.path" -> "D:\Program Files\Java\jdk1.8.0_231\jre\bin"
"java.vm.version" -> "25.231-b11"
"java.vm.vendor" -> "Oracle Corporation"
"java.vendor.url" -> "http://java.oracle.com/"
"path.separator" -> ";"
"java.vm.name" -> "Java HotSpot(TM) 64-Bit Server VM"
"file.encoding.pkg" -> "sun.io"
"user.country" -> "CN"
"user.script" -> ""
"sun.java.launcher" -> "SUN_STANDARD"
"sun.os.patch.level" -> ""
"java.vm.specification.name" -> "Java Virtual Machine Specification"
"user.dir" -> "E:\myfiles\Dubbo\code\demo-base"
"intellij.debug.agent" -> "true"
"java.runtime.version" -> "1.8.0_231-b11"
"java.awt.graphicsenv" -> "sun.awt.Win32GraphicsEnvironment"
"java.endorsed.dirs" -> "D:\Program Files\Java\jdk1.8.0_231\jre\lib\endorsed"
"os.arch" -> "amd64"
"java.io.tmpdir" -> "C:\Users\xjt92\AppData\Local\Temp\"
"line.separator" -> "\r\n"
"java.vm.specification.vendor" -> "Oracle Corporation"
"user.variant" -> ""
"os.name" -> "Windows 10"
"sun.jnu.encoding" -> "GBK"
"java.library.path" -> "D:\Program Files\Java\jdk1.8.0_231\bin;C:\WINDOWS\Sun\Java\bin;C:\WINDOWS\system32;C:\WINDOWS;D:\Python27\Scripts\;D:\Python27\;D:\Program Files (x86)\Borland\Delphi7\Bin;D:\Program Files (x86)\Borland\Delphi7\Projects\Bpl\;D:\Program Files (x86)\NetSarang\Xftp 6\;D:\Program Files (x86)\NetSarang\Xshell 6\;C:\Program Files (x86)\Common Files\Oracle\Java\javapath;C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\iCLS\;C:\Program Files\Intel\Intel(R) Management Engine Components\iCLS\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\IPT;C:\Program Files\Intel\Intel(R) Management Engine Components\IPT;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVI"
"sun.nio.ch.bugLevel" -> ""
"jboss.modules.system.pkgs" -> "com.intellij.rt"
"java.specification.name" -> "Java Platform API Specification"
"java.class.version" -> "52.0"
"sun.management.compiler" -> "HotSpot 64-Bit Tiered Compilers"
"os.version" -> "10.0"
"user.home" -> "C:\Users\xjt92"
"user.timezone" -> "Asia/Shanghai"
"java.awt.printerjob" -> "sun.awt.windows.WPrinterJob"
"file.encoding" -> "UTF-8"
"java.specification.version" -> "1.8"
"java.class.path" -> "D:\Program Files\Java\jdk1.8.0_231\jre\lib\charsets.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\deploy.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\access-bridge-64.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\cldrdata.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\dnsns.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\jaccess.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\jfxrt.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\localedata.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\nashorn.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\sunec.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\sunjce_provider.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\sunmscapi.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\sunpkcs11.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext\zipfs.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\javaws.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\jce.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\jfr.jar;D:\Progra"
"user.name" -> "xjt92"
"java.vm.specification.version" -> "1.8"
"sun.java.command" -> "com.lagou.ProviderApplication"
"java.home" -> "D:\Program Files\Java\jdk1.8.0_231\jre"
"sun.arch.data.model" -> "64"
"user.language" -> "zh"
"java.specification.vendor" -> "Oracle Corporation"
"awt.toolkit" -> "sun.awt.windows.WToolkit"
"java.vm.info" -> "mixed mode"
"java.version" -> "1.8.0_231"
"java.ext.dirs" -> "D:\Program Files\Java\jdk1.8.0_231\jre\lib\ext;C:\WINDOWS\Sun\Java\lib\ext"
"sun.boot.class.path" -> "D:\Program Files\Java\jdk1.8.0_231\jre\lib\resources.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\rt.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\sunrsasign.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\jsse.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\jce.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\charsets.jar;D:\Program Files\Java\jdk1.8.0_231\jre\lib\jfr.jar;D:\Program Files\Java\jdk1.8.0_231\jre\classes"
"java.vendor" -> "Oracle Corporation"
"file.separator" -> "\"
"java.vendor.url.bug" -> "http://bugreport.sun.com/bugreport/"
"sun.io.unicode.encoding" -> "UnicodeLittle"
"sun.cpu.endian" -> "little"
"sun.desktop" -> "windows"
"sun.cpu.isalist" -> "amd64"
```

