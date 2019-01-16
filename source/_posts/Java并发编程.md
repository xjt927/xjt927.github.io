---
title: Java并发编程
abbrlink: '3e225941'
date: 2018-12-19 15:53:00
tags: 多线程
categories: 多线程
keywords: 并发,多线程,Runnable,Thread,Callable,Future
---
# 实现Runnable接口创建线程

- 类实现Runnable接口
- 实现类中重写 void Run() 方法
- 调用 start() 方法运行

```
//类实现Runnable接口
class RunnableDemo implements Runnable{
	@Override
	public void Run(){
	//doSomething
	}
}

//执行线程
public static void main(String[] args) {
	RunnableDemo runDemo = new RunnableDemo();
	Thread thread = new Thread(runDemo);
	thread.start();
}
```

# 继承Thread类创建线程

- 类继承Thread类
- 类重写void Run()方法
- 调用 start() 方法运行

```
//类实现Thread接口
class ThreadDemo extends Thread{ 
	@Override
	public void Run(){
	//doSomething
	}
}

//执行线程
public static void main(String[] args) {
	Thread thread = new ThreadDemo();
	thread.start();
}
```

## Thread的重要方法

### 被Thread对象调用的方法

- public void start()
使该线程开始执行；Java 虚拟机调用该线程的 run 方法。
- public void run()
如果该线程是使用独立的 Runnable 运行对象构造的，则调用该 Runnable 对象的 run 方法；否则，该方法不执行任何操作并返回。
- public final void setName(String name)
改变线程名称，使之与参数 name 相同。
- public final void setPriority(int priority)
更改线程的优先级。
- public final void setDaemon(boolean on)
将该线程标记为守护线程或用户线程。
- public final void join(long millisec)
等待该线程终止的时间最长为 millis 毫秒。
- public void interrupt()
中断线程。
- public final boolean isAlive()
测试线程是否处于活动状态。

### Thread类的静态方法
- public static void yield()
暂停当前正在执行的线程对象，并执行其他线程。
- public static void sleep(long millisec)
在指定的毫秒数内让当前正在执行的线程休眠（暂停执行），此操作受到系统计时器和调度程序精度和准确性的影响。
- public static boolean holdsLock(Object x)
当且仅当当前线程在指定的对象上保持监视器锁时，才返回 true。
- public static Thread currentThread()
返回对当前正在执行的线程对象的引用。
- public static void dumpStack()
将当前线程的堆栈跟踪打印至标准错误流。

# 通过 Callable 和 Future 、FutureTask 创建线程

上面通过继承Thread和实现Runnable接口创建线程，这两种方式有一个缺陷：**无法获取执行结果！**

## Callable
Callable位于java.util.concurrent包下，它也是一个接口，在它里面也只声明了一个方法，只不过这个方法叫做call()：
```
public interface Callable<V> {
    /**
     * Computes a result, or throws an exception if unable to do so.
     *
     * @return computed result
     * @throws Exception if unable to compute a result
     */
    V call() throws Exception;
}
```
- 类实现Callable接口
- 实现类中重写 V call() 方法
- call()函数返回的类型就是传递进来的V类型
- 配合ExecutorService来使用

```
//实现Callable接口
class CallableDemo implements Callable<Integer>{
    @Override
    public Integer call() throws Exception { 
	//doSomething
        return 0;
    }
}
```

## Future
Future就是对于具体的Runnable或者Callable任务的执行结果进行取消、查询是否完成、获取结果。必要时可以通过get方法获取执行结果，该方法会阻塞直到任务返回结果。
Future类位于java.util.concurrent包下，它是一个接口：
```
public interface Future<V> {
    boolean cancel(boolean mayInterruptIfRunning);
    boolean isCancelled();
    boolean isDone();
    V get() throws InterruptedException, ExecutionException;
    V get(long timeout, TimeUnit unit)
        throws InterruptedException, ExecutionException, TimeoutException;
}
```
在Future接口中声明了5个方法，下面依次解释每个方法的作用：
- cancel方法用来取消任务，如果取消任务成功则返回true，如果取消任务失败则返回false。参数mayInterruptIfRunning表示是否允许取消正在执行却没有执行完毕的任务，如果设置true，则表示可以取消正在执行过程中的任务。如果任务已经完成，则无论mayInterruptIfRunning为true还是false，此方法肯定返回false，即如果取消已经完成的任务会返回false；如果任务正在执行，若mayInterruptIfRunning设置为true，则返回true，若mayInterruptIfRunning设置为false，则返回false；如果任务还没有执行，则无论mayInterruptIfRunning为true还是false，肯定返回true。
- isCancelled方法表示任务是否被取消成功，如果在任务正常完成前被取消成功，则返回 true。
- isDone方法表示任务是否已经完成，若任务完成，则返回true；
- get()方法用来获取执行结果，这个方法会产生阻塞，会一直等到任务执行完毕才返回；
- get(long timeout, TimeUnit unit)用来获取执行结果，如果在指定时间内，还没获取到结果，就直接返回null。

**因为Future只是一个接口，所以是无法直接用来创建对象使用的，因此就有了下面的FutureTask。**

## FutureTask
先来看一下FutureTask的实现：
```
public class FutureTask<V> implements RunnableFuture<V>
```
FutureTask类实现了RunnableFuture接口，我们看一下RunnableFuture接口的实现：
```
public interface RunnableFuture<V> extends Runnable, Future<V> {
    void run();
}
```
可以看出RunnableFuture继承了Runnable接口和Future接口，而FutureTask实现了RunnableFuture接口。所以它既可以作为Runnable被线程执行，又可以作为Future得到Callable的返回值。

FutureTask提供了2个构造器：
```
public FutureTask(Callable<V> callable) {
}
public FutureTask(Runnable runnable, V result) {
}
```
**事实上，FutureTask是Future接口的一个唯一实现类。**

## 使用示例
### Callable+Future获取执行结果

```
//实现Callable接口
class CallableDemo implements Callable<Integer>{
    @Override
    public Integer call() throws Exception { 
        int sum = 0;
        for(int i=0;i<100;i++)
            sum += i;
        return sum;
    }
}

//执行线程	
public static void main(String[] args) {
    ExecutorService executor = Executors.newCachedThreadPool();
    CallableDemo callableDemo = new CallableDemo();
    Future<Integer> future = executor.submit(callableDemo);
    executor.shutdown();
    System.out.println("callableDemo运行结果"+future.get());
}
```

### Callable+FutureTask获取执行结果
``` 
//实现Callable接口
class CallableDemo implements Callable<Integer>{
    @Override
    public Integer call() throws Exception { 
        int sum = 0;
        for(int i=0;i<100;i++)
            sum += i;
        return sum;
    }
}

//执行线程
public static void main(String[] args) {
    //第一种方式
    ExecutorService executor = Executors.newCachedThreadPool();
    CallableDemo callableDemo = new CallableDemo();
    FutureTask<Integer> futureTask = new FutureTask<Integer>(callableDemo);
    executor.submit(futureTask);
    executor.shutdown();
	
    //第二种方式，注意这种方式和第一种方式效果是类似的，只不过一个使用的是ExecutorService，一个使用的是Thread
    /*CallableDemo callableDemo = new CallableDemo();
    FutureTask<Integer> futureTask = new FutureTask<Integer>(callableDemo);
    Thread thread = new Thread(futureTask);
    thread.start();*/
	
	System.out.println("task运行结果"+futureTask.get());
}
```

