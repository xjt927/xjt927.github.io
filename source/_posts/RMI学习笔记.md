---
title: rmi实例
abbrlink: 6j507e71
date: 2020-9-2 23:30:44
tags: 分布式
categories: 分布式
keywords: 分布式
---
# 概念

Java RMI 指的是远程方法调用 (Remote Method Invocation)，是**java原生支持的远程调用**，采用JRMP（Java Remote Messageing protocol）作为通信协议，可以认为是**纯java版本的分布式远程调用解决方案**， RMI主要用于不同虚拟机之间的通信，这些虚拟机可以在不同的主机上、也可以在同一个主机上，这里的通信可以理解为**一个虚拟机上的对象调用另一个虚拟机上对象的方法**。

1.客户端：      

 1）存根/桩(Stub)：远程对象在客户端上的代理；     

 2）远程引用层(Remote Reference Layer)：解析并执行远程引用协议；     

 3）传输层(Transport)：发送调用、传递远程方法参数、接收远程方法执行结果。    

2.服务端：      

 1）骨架(Skeleton)：读取客户端传递的方法参数，调用服务器方的实际对象方法，并接收方法执行后的返回值；

 2）远程引用层(Remote Reference Layer)：处理远程引用后向骨架发送远程方法调用；

 3）传输层(Transport)：监听客户端的入站连接，接收并转发调用到远程引用层。    

3.注册表(Registry)：

以URL形式注册远程对象，并向客户端回复对远程对象的引用。

![mark](http://blog.xuejiangtao.com/blog/20200713/tpdOi5rQI4Ub.png?imageslim)

**远程调用过程：**

1）客户端从远程服务器的注册表中查询并获取远程对象引用。 

2）桩对象与远程对象具有相同的接口和方法列表，当客户端调用远程对象时，实际上是由相应的桩对象代理完成的。 

3 )远程引用层在将桩的本地引用转换为服务器上对象的远程引用后，再将调用传递给传输层(Transport)，由传输层通过TCP协议发送调用； 

4）在服务器端，传输层监听入站连接，它一旦接收到客户端远程调用后，就将这个引用转发给其上层的远程引用层； 

5）服务器端的远程引用层将客户端发送的远程应用转换为本地虚拟机的引用后，再将请求传递给骨架(Skeleton)； 

6）骨架读取参数，又将请求传递给服务器，最后由服务器进行实际的方法调用。 



**结果返回过程：**

1）如果远程方法调用后有返回值，则服务器将这些结果又沿着“骨架->远程引用层->传输层”向下传递； 

2）客户端的传输层接收到返回值后，又沿着“传输层->远程引用层->桩”向上传递，然后由桩来反序列化这些返回值，并将最终的结果传递给客户端程序。



# 创建服务端

在编写一个接口需要作为远程调用时，都需要继承了Remote，Remote 接口用于标识其方法可以从非本地虚拟机上调用的接口，只有在“远程接口”（扩展 java.rmi.Remote 的接口）中指定的这些方法才可远程使用，下面通过一个简单的示例，来讲解RMI原理以及开发流程：



RMIServer.jar 服务端启动类，用于创建远程对象注册表以及注册远程对象，代码如下：

```
public class RMIServer {
    public static void main(String[] args) throws RemoteException, AlreadyBoundException, MalformedURLException {
        //1.创建HelloService实例
        IHelloService service = new HelloServiceImpl();

        //2.获取注册表
        LocateRegistry.createRegistry(8888);

        //3.对象的绑定
        //bind方法的参数1:   rmi://ip地址:端口/服务名   参数2:绑定的对象
        Naming.bind("//127.0.0.1:8888/rmiserver",service);
    }
}
```
IHelloService.java 远程接口，该接口需要继承Remote接口，并且接口中的方法全都要抛出RemoteException异常，代码如下：

```
public interface IHelloService extends Remote {

    //1.定义一个sayHello方法
    public  String sayHello(User user) throws RemoteException;
}

```

HelloServiceImpl.java 远程接口实现类，必须继承UnicastRemoteObject（继承RemoteServer->继承RemoteObject->实现Remote，Serializable），只有继承UnicastRemoteObject类，**才表明其可以作为远程对象**，**被注册到注册表中供客户端远程调用**。

补充：客户端lookup找到的对象，只是该远程对象的Stub（存根对象），而服务端的对象有一个对应的骨架Skeleton（用于接收客户端stub的请求，以及调用真实的对象）对应。

**Stub是远程对象的客户端代理，Skeleton是远程对象的服务端代理**，他们之间协作完成客户端与服务器之间的方法调用时的通信。 代码如下：

```
public class HelloServiceImpl extends UnicastRemoteObject implements IHelloService {

    //手动实现父类的构造方法
    public HelloServiceImpl() throws RemoteException {
        super();
    }

    //我们自定义的sayHello
    public String sayHello(User user) throws RemoteException {
        System.out.println("this is server , say hello to "+user.getUsername());
        return "success";
    }
}

```

```
public class User implements Serializable {
    private String username;
    private int age;

    public User() {
    }

    public User(String username, int age) {
        this.username = username;
        this.age = age;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
```

# 创建客户端

```
public class RMIClient {
    public static void main(String[] args) throws RemoteException, NotBoundException, MalformedURLException {
        //1.从注册表中获取远程对象 , 强转
        IHelloService service = (IHelloService) Naming.lookup("//127.0.0.1:8888/rmiserver");

        //2.准备参数
        User user = new User("laowang",18);

        //3.调用远程方法sayHello
        String message = service.sayHello(user);
        System.out.println(message);
    }
}

```

```
public interface IHelloService extends Remote {

    //1.定义一个sayHello方法
    public  String sayHello(User user) throws RemoteException;
}

```

```
public class User implements Serializable {
    private String username;
    private int age;

    public User() {
    }

    public User(String username, int age) {
        this.username = username;
        this.age = age;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}

```

