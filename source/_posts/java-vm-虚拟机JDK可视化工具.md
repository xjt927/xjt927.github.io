---
title: java vm 虚拟机JDK可视化工具
abbrlink: e3115414
date: 2018-11-21 15:48:23
tags: JVM
categories: JVM
keywords: JVM
---

```
public class BTraceTest {
    public int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) throws IOException {
        BTraceTest test = new BTraceTest();
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        reader.readLine();
        for (int i = 0; i < 10; i++) {
            int a = (int) Math.round(Math.random() * 1000);
            int b = (int) Math.round(Math.random() * 1000);
            System.out.println(test.add(a, b));
        }
    }
}
```

```
@BTrace
public class TracingScript {
	/* put your code here */
	@OnMethod(clazz="xjt.com.javaVM.BTraceTest",method="add",location=@Location(Kind.RETURN)) 
	public static void func(@Self xjt.com.javaVM.BTraceTest instance,int a, int b,@Return int result){
		println("调试堆栈");
		jstack();
		println(strcat("方法参数A：",str(a)));
		println(strcat("方法参数B：",str(b)));
		println(strcat("方法结果：",str(result)));
	}
}

```

结果如下：

![mark](http://blog.xuejiangtao.com/blog/181121/bL8d47lmGL.png?imageslim)