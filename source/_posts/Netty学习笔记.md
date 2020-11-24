---
abbrlink: '0'
---
# Netty概念

## 什么是Netty？

​		Netty 是由 JBOSS 提供一个异步的、 基于事件驱动的网络编程框架。

​		Netty 可以帮助你快速、 简单的开发出一 个网络应用， 相当于简化和流程化了 NIO 的开发过程。 作为当前最流行的 NIO 框架， Netty 在互联网领域、 大数据分布式计算领域、 游戏行业、 通信行业等获得了广泛的应用， 知名的 Elasticsearch 、 Dubbo 框架内部都采用了 Netty。



> ​		Netty是由[JBOSS](https://baike.baidu.com/item/JBOSS)提供的一个[java开源](https://baike.baidu.com/item/java开源/10795649)框架，现为 [Github](https://baike.baidu.com/item/Github/10145341)上的独立项目。Netty提供异步的、[事件驱动](https://baike.baidu.com/item/事件驱动/9597519)的网络应用程序框架和工具，用以快速开发高性能、高可靠性的[网络服务器](https://baike.baidu.com/item/网络服务器/99096)和客户端程序。
>
> ​		也就是说，Netty 是一个基于NIO的客户、服务器端的编程框架，使用Netty 可以确保你快速和简单的开发出一个网络应用，例如实现了某种协议的客户、[服务端](https://baike.baidu.com/item/服务端/6492316)应用。Netty相当于简化和流线化了网络应用的编程开发过程，例如：基于TCP和UDP的socket服务开发。
>
> ​		“快速”和“简单”并不用产生维护性或性能上的问题。Netty 是一个吸收了多种协议（包括FTP、SMTP、HTTP等各种二进制文本协议）的实现经验，并经过相当精心设计的项目。最终，Netty 成功的找到了一种方式，在保证易于开发的同时还保证了其应用的性能，稳定性和伸缩性。

 

## Netty和Tomcat有什么区别？

Netty和Tomcat最大的区别就在于通信协议，Tomcat是基于Http协议的，他的实质是一个基于http协议的web容器，但是Netty不一样，他能通过编程自定义各种协议，因为netty能够通过codec自己来编码/解码字节流，完成类似redis访问的功能，这就是netty和tomcat最大的不同。

*有人说netty的性能就一定比tomcat性能高，其实不然，tomcat从6.x开始就支持了nio模式，并且后续还有APR模式——一种通过jni调用apache网络库的模式，相比于旧的bio模式，并发性能得到了很大提高，特别是APR模式，而netty是否比tomcat性能更高，则要取决于netty程序作者的技术实力了。*

为什么Netty受欢迎？

如第一部分所述，netty能够受到大公司青睐的原因有三：

1. **并发高**
2. **传输快**
3. **封装好**

参考 https://www.jianshu.com/p/b9f3f6a16911



## 为什么使用Netty

### NIO缺点

- NIO 的类库和 API 繁杂，使用麻烦。你需要熟练掌握 Selector、ServerSocketChannel、SocketChannel、ByteBuffffer 等.
- 可靠性不强，开发工作量和难度都非常大
- NIO 的 Bug。例如 Epoll Bug，它会导致 Selector 空轮询，最终导致 CPU 100%。



### Netty优点

- 对各种传输协议提供统一的 API
- 高度可定制的线程模型——单线程、一个或多个线程池
- 更好的吞吐量，更低的等待延迟
- 更少的资源消耗
- 最小化不必要的内存拷贝

## Netty为什么并发高

参考 https://www.jianshu.com/p/b9f3f6a16911

Netty是一款基于NIO（Nonblocking I/O，非阻塞IO）开发的网络通信框架，对比于BIO（Blocking I/O，阻塞IO），他的并发性能得到了很大提高，两张图让你了解BIO和NIO的区别：



![mark](http://blog.xuejiangtao.com/blog/20200709/QCzh72dHszRu.png?imageslim)

<center>阻塞IO的通信方式</center>





![非阻塞IO的通信方式](http://blog.xuejiangtao.com/blog/20200709/xUqYCDF3FwpF.png?imageslim)

<center>非阻塞IO的通信方式</center>



从这两图可以看出，NIO的单线程能处理连接的数量比BIO要高出很多，而为什么单线程能处理更多的连接呢？原因就是图二中出现的`Selector`。
 当一个连接建立之后，他有两个步骤要做，第一步是接收完客户端发过来的全部数据，第二步是服务端处理完请求业务之后返回response给客户端。NIO和BIO的区别主要是在第一步。
 在BIO中，等待客户端发数据这个过程是阻塞的，这样就造成了一个线程只能处理一个请求的情况，而机器能支持的最大线程数是有限的，这就是为什么BIO不能支持高并发的原因。
 而NIO中，当一个Socket建立好之后，Thread并不会阻塞去接受这个Socket，而是将这个请求交给Selector，Selector会不断的去遍历所有的Socket，一旦有一个Socket建立完成，他会通知Thread，然后Thread处理完数据再返回给客户端——**这个过程是不阻塞的**，这样就能让一个Thread处理更多的请求了。

## Netty为什么传输快

Netty的传输快其实也是依赖了NIO的一个特性——*零拷贝*。我们知道，Java的内存有堆内存、栈内存和字符串常量池等等，其中堆内存是占用内存空间最大的一块，也是Java对象存放的地方，一般我们的数据如果需要从IO读取到堆内存，中间需要经过Socket缓冲区，也就是说一个数据会被拷贝两次才能到达他的的终点，如果数据量大，就会造成不必要的资源浪费。
 Netty针对这种情况，使用了NIO中的另一大特性——零拷贝，当他需要接收数据的时候，他会在堆内存之外开辟一块内存，数据就直接从IO读到了那块内存中去，在netty里面通过ByteBuf可以直接对这些数据进行直接操作，从而加快了传输速度。
 下两图就介绍了两种拷贝方式的区别，摘自[Linux 中的零拷贝技术，第 1 部分](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.ibm.com%2Fdeveloperworks%2Fcn%2Flinux%2Fl-cn-zerocopy1%2Findex.html)



![mark](http://blog.xuejiangtao.com/blog/20200711/c5nGTkKhimVI.png?imageslim)

<center>传统数据拷贝</center>



![mark](http://blog.xuejiangtao.com/blog/20200711/YSiaqi8LCwxX.png?imageslim)

<center>零拷贝</center>

上文介绍的ByteBuf是Netty的一个重要概念，他是netty数据处理的容器，也是Netty封装好的一个重要体现，将在下一部分做详细介绍。



## NIO是同步非阻塞，为什么Netty基于NIO，却是异步？

Netty在启动时定义了线程池，netty在运行时是通过线程池多线程处理的，所以说是异步。

```
        EventLoopGroup bossGroup = new NioEventLoopGroup(); 
        EventLoopGroup workerGroup = new NioEventLoopGroup();
```



Java的NIO实现采用了同步非阻塞IO和IO多路复用，其核心组件是**Selector**。**Selector会不断的主动的询问Channel是否有事件发生，有事件发生，会进行事件处理。**

Netty采用的是NIO其对Java的NIO进行了改进，其内部也封装了Selector和Channel，采用串行并发来提高效率。

Java的NIO采用的是Reactor线程模型中的**Reactor单线程模型**（前台和服务员是一个人，全程为顾客服务，可以服务多个人。

Netty的NIO采用的是**主从Reactor模型**，是多Reactor多线程模型。

> 参考
>
> https://blog.csdn.net/hufi320/article/details/104411482

# Netty实战

创建一个Maven项目，在pom文件中引入一下Netty包

```        <dependency>
<dependency>
    <groupId>io.netty</groupId>
    <artifactId>netty-all</artifactId>
    <version>4.1.6.Final</version>
</dependency>
```



## 创建Netty服务

```
public class HttpServer {
    public static void main(String[] args) {
        /*
           bossGroup 和 workerGroup 是两个线程池, 它们默认线程数为 CPU 核心数乘以 2，
           bossGroup 用于接收客户端传过来的请求，接收到请求后将后续操作交由 workerGroup 处理。

           bootstrap 用来为 Netty 程序的启动组装配置一些必须要组件，例如上面的创建的两个线程组。

           channel 方法用于指定服务器端监听套接字通道 NioServerSocketChannel，
           其内部管理了一个 Java NIO 中的ServerSocketChannel实例。

           channelHandler 方法用于设置业务职责链，责任链是我们下面要编写的业务逻辑，
           责任链具体是什么，它其实就是由一个个的 ChannelHandler 串联而成，形成的链式结构。
           正是这一个个的 ChannelHandler 帮我们完成了要处理的事情。


          bind 方法， 接着我们调用了 bootstrap 的 bind 方法将服务绑定到 8080 端口上，bind 方法内部会执行端口绑定等一系列操，
          使得前面的配置都各就各位各司其职，sync 方法用于阻塞当前 Thread，一直到端口绑定操作完成。

          sync()方法，应用程序将会阻塞等待直到服务器的 Channel 关闭。
         */

        //1.构造两个线程组/线程池
        //bossGroup负责接收用户连接
        EventLoopGroup bossGroup = new NioEventLoopGroup();
        //workerGroup负责处理用户的io读写操作
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            //2.创建服务端启动引导类/启动辅助类
            ServerBootstrap bootstrap = new ServerBootstrap();

            //3.设置启动引导类
            //添加到组中,两个线程池,第一个位置的线程池就负责接收,第二个参数就负责读写
            bootstrap.group(bossGroup, workerGroup)
                    //设置通道类型
                    .channel(NioServerSocketChannel.class)
                    //绑定一个初始化监听，设置业务职责链，帮我们完成了要处理的事情
                    .childHandler(new HttpServerInitializer());

            //4.启动引导类绑定端口
            //sync 方法用于阻塞当前 Thread，一直到端口绑定操作完成。
            ChannelFuture future = bootstrap.bind(8080).sync();
            System.out.println("服务启动完成。");

            //5.等待服务端口关闭
            //应用程序将会阻塞等待直到服务器的 Channel 关闭
            future.channel().closeFuture().sync();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            // 优雅退出，释放线程池资源
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }
}
```



### 创建ChannelInitializer类

继承ChannelInitializer类，当有监听客户端连接时自动创建分配一个ChannelPipeline通道/管道


```
public class HttpServerInitializer extends ChannelInitializer<NioSocketChannel> {

    /*
        自定义一个类 HttpServerInitializer 继承 ChannelInitializer 并实现其中的 initChannel方法。
        ChannelInitializer 继承 ChannelInboundHandlerAdapter，用于初始化 Channel 的 ChannelPipeline。通过 initChannel 方法参数 nioSocketChannel 得到 ChannelPipeline 的一个实例。


        当一个新的连接被接受时， 一个新的 Channel 将被创建，同时它会被自动地分配到它专属的 ChannelPipeline。


        pipeline.addFirst(new StringEncoder());
        pipeline.addLast(new StringDecoder());

        pipeline.addLast("httpResponseEndcoder", new HttpResponseEncoder());
        pipeline.addLast("HttpRequestDecoder", new HttpRequestDecoder());

        StringEncoder和 HttpResponseEncoder 都继承了 MessageToMessageEncoder ChannelOutboundHandlerAdapter
        StringDecoder 和 HttpRequestDecoder 都继承了  ChannelInboundHandlerAdapter

        pipeline.addLast("httpServerCodec", new HttpServerCodec());
        HttpServerCodec 是 HttpRequestDecoder 和 HttpResponseEncoder 的组合

        HttpObjectAggregator 类，这个 ChannelHandler 作用就是将请求转换为单一的 FullHttpReques。
     */

    @Override
    //事件监听Channel通道
    protected void initChannel(NioSocketChannel nioSocketChannel) throws Exception {
        //获取pipeLine
        ChannelPipeline pipeline = nioSocketChannel.pipeline();
        //处理http消息的编解码
        pipeline.addLast("httpServerCodec", new HttpServerCodec());


        //Netty 支持 Http（超文本传输协议），必须要给它提供相应的编解码器。
        //不设置名称也可以，Netty 会给它个默认名称
//        pipeline.addFirst(new StringEncoder());
//        pipeline.addLast(new StringDecoder());

		//如果使用HttpServerChannelHandler的实现类，则需要下面代码
        //pipeline.addLast("aggregator", new HttpObjectAggregator(65536));

//        //绑定我们的业务逻辑
//        pipeline.addLast(new SimpleChannelInboundHandler<String>() {
//            protected void channelRead0(ChannelHandlerContext channelHandlerContext, String msg) throws Exception {
//                //获取入栈信息,打印客户端传递的数据
//                System.out.println(msg);
//            }
//        });

        //添加自定义的ChannelHandler
        pipeline.addLast("httpServerHandler", new HttpServerChannelHandler0());
    }
}
```

### 创建自定义ChannelHandler

HttpServerChannelHandler0为在创建的Channel中实现后续读写、业务逻辑等操作。

```
public class HttpServerChannelHandler0 extends SimpleChannelInboundHandler<HttpObject> {

    /*
        channelRead0方法，会在接收到服务器数据后被系统调用，可以在该方法中编写我们的业务逻辑代码

        Netty 的设计中把 Http 请求分为了 HttpRequest 和 HttpContent 两个部分，HttpRequest 主要包含请求头、请求方法等信息，HttpContent 主要包含请求体的信息。

        通过 Unpooled 提供的静态辅助方法来创建未池化的 ByteBuf 实例， Java NIO 提供了 ByteBuffer 作为它的字节容器，Netty 的 ByteBuffer 替代品是 ByteBuf。

        FullHttpResponse 设置一些响应参数，最后通过 writeAndFlush 方法将它写回给客户端。
     */


    private HttpRequest request;

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, HttpObject msg) throws Exception {
        if (msg instanceof HttpRequest) {
            request = (HttpRequest) msg;
            request.method();
            String uri = request.uri();
            System.out.println("Uri:" + uri);
        }
        if (msg instanceof HttpContent) {

            HttpContent content = (HttpContent) msg;
            ByteBuf buf = content.content();
            System.out.println(buf.toString(io.netty.util.CharsetUtil.UTF_8));

            ByteBuf byteBuf = Unpooled.copiedBuffer("hello world", CharsetUtil.UTF_8);
            FullHttpResponse response = new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.OK, byteBuf);
            response.headers().add(HttpHeaderNames.CONTENT_TYPE, "text/plain");
            response.headers().add(HttpHeaderNames.CONTENT_LENGTH, byteBuf.readableBytes());

            ctx.writeAndFlush(response);

        }
    }
}
```



HttpServerChannelHandler类是上面HttpServerChannelHandler0的改进版本。

由于上面这样获取请求（HttpRequest）和消息体（HttpContent）相当不方便，Netty 又提供了另一个类 FullHttpRequest，FullHttpRequest 包含请求的所有信息，它是一个接口，直接或者间接继承了 HttpRequest 和 HttpContent，它的实现类是 DefalutFullHttpRequest。

```
public class HttpServerChannelHandler extends SimpleChannelInboundHandler<FullHttpRequest> {

    /*
        FullHttpRequest 包含请求的所有信息，它是一个接口，直接或者间接继承了 HttpRequest 和 HttpContent，它的实现类是 DefalutFullHttpRequest。

     */

 

    protected void channelRead0(ChannelHandlerContext ctx, FullHttpRequest msg) throws Exception {

        ctx.channel().remoteAddress();

        FullHttpRequest request = msg;

        System.out.println("请求方法名称:" + request.method().name());

        System.out.println("uri:" + request.uri());
        ByteBuf buf = request.content();
        System.out.print(buf.toString(CharsetUtil.UTF_8));


        ByteBuf byteBuf = Unpooled.copiedBuffer("hello world", CharsetUtil.UTF_8);
        FullHttpResponse response = new DefaultFullHttpResponse(HttpVersion.HTTP_1_1, HttpResponseStatus.OK, byteBuf);
        response.headers().add(HttpHeaderNames.CONTENT_TYPE, "text/plain");
        response.headers().add(HttpHeaderNames.CONTENT_LENGTH, byteBuf.readableBytes());

        ctx.writeAndFlush(response);
    }
}
```

### 启动Netty服务

启动netty服务，然后在postman中请求服务

![mark](http://blog.xuejiangtao.com/blog/20200711/yTbnFx77jaPu.png?imageslim)

服务器接收信息并打印

![mark](http://blog.xuejiangtao.com/blog/20200711/qAzcGFyiPkVk.png?imageslim)

## 编写 Netty 客户端

```
public class HttpClient {

    public static void main(String[] args) throws Exception {
        String host = "127.0.0.1";
        int port = 8080;

        EventLoopGroup group = new NioEventLoopGroup();

        try {
            Bootstrap b = new Bootstrap();
            b.group(group)
                    .channel(NioSocketChannel.class)
                    .handler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        public void initChannel(SocketChannel ch) throws Exception {
                            ChannelPipeline pipeline = ch.pipeline();
                            pipeline.addLast(new HttpClientCodec());
                            pipeline.addLast(new HttpObjectAggregator(65536));
                            pipeline.addLast(new HttpClientHandler());
                        }
                    });

            // 启动客户端.
            ChannelFuture f = b.connect(host, port).sync();
            f.channel().closeFuture().sync();

        } finally {
            group.shutdownGracefully();
        }
    }
}
```

```
public class HttpClientHandler extends SimpleChannelInboundHandler<FullHttpResponse> {

    /*
        在 HttpClientHandler 类中，我们覆写了 channelActive 方法，当连接建立时，此方法会被调用，
        我们在方法中构建了一个 FullHttpRequest 对象，并且通过 writeAndFlush 方法将请求发送出去。

        channelRead0 方法用于处理服务端返回给我们的响应，打印服务端返回给客户端的信息。
     */


    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        URI uri = new URI("http://127.0.0.1:8080");
        String msg = "Are you ok?";
        FullHttpRequest request = new DefaultFullHttpRequest(HttpVersion.HTTP_1_1, HttpMethod.GET,
                uri.toASCIIString(), Unpooled.wrappedBuffer(msg.getBytes("UTF-8")));

        // 构建http请求
//        request.headers().set(HttpHeaderNames.HOST, "127.0.0.1");
//        request.headers().set(HttpHeaderNames.CONNECTION, HttpHeaderValues.KEEP_ALIVE);
        request.headers().set(HttpHeaderNames.CONTENT_LENGTH, request.content().readableBytes());
        // 发送http请求
        ctx.channel().writeAndFlush(request);
    }

    @Override
    public void channelRead0(ChannelHandlerContext ctx, FullHttpResponse msg) {

        FullHttpResponse response = msg;
        response.headers().get(HttpHeaderNames.CONTENT_TYPE);
        ByteBuf buf = response.content();
        System.out.println(buf.toString(io.netty.util.CharsetUtil.UTF_8));

    }
}
```

# Netty核心组件

## ChannelHandler及其实现类

ChannelHandler 接口定义了许多事件处理的方法， 我们可以通过重写这些方法去实现具 体的业务逻辑

我们经常需要自定义一个 Handler 类去继承 ChannelInboundHandlerAdapter， 然后通过 重写相应方法实现业务逻辑， 我们接下来看看一般都需要重写哪些方法：

```
  public void channelActive(ChannelHandlerContext ctx)， 通道就绪事件 
  
  public void channelRead(ChannelHandlerContext ctx, Object msg)， 通道读取数据事件 
  
  public void channelReadComplete(ChannelHandlerContext ctx) ， 数据读取完毕事件 
  
  public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause)， 通道发生异常事件
```

  

## ChannelPipeline

ChannelPipeline 是一个 Handler 的集合， 它负责处理和拦截 inbound 或者 outbound 的事 件和操作，相当于一个贯穿 Netty 的链。

```
  ChannelPipeline addFirst(ChannelHandler... handlers)， 把一个业务处理类（handler） 添加到链中的第一个位置 
  
  ChannelPipeline addLast(ChannelHandler... handlers)， 把一个业务处理类（handler） 添加到链中的最后一个位置
```

  

![mark](http://blog.xuejiangtao.com/blog/20200714/w0Ck8ROW63mq.png?imageslim)



## ChannelHandlerContext

这 是 事 件 处 理 器 上 下 文 对 象 ， Pipeline 链 中 的 实 际 处 理 节 点 。 每 个 处 理 节 点ChannelHandlerContext 中 包 含 一 个 具 体 的 事 件 处 理 器 ChannelHandler ， 同 时ChannelHandlerContext 中也绑定了对应的 pipeline 和 Channel 的信息，方便对 ChannelHandler 进行调用。

常用方法如下所示

```
ChannelFuture close()， 关闭通道 

ChannelOutboundInvoker flush()， 刷新 

ChannelFuture writeAndFlush(Object msg) ， 将数据写到当前ChannelPipeline中

ChannelHandler 的下一个 ChannelHandler 开始处理（出站）
```



##  ChannelFuture 

表示 Channel 中异步 I/O 操作的结果， 在 Netty 中所有的 I/O 操作都是异步的， I/O 的调用会直接返回， 调用者并不能立刻获得结果， 但是可以通过 ChannelFuture 来获取 I/O 操作 的处理状态。 常用方法如下所示：

```
Channel channel()， 返回当前正在进行 IO 操作的通道 

ChannelFuture sync()， 等待异步操作执行完毕
```

## EventLoopGroup 和其实现类 NioEventLoopGroup 

EventLoopGroup 是一组 EventLoop 的抽象， Netty 为了更好的利用多核 CPU 资源， 一般 会有多个 EventLoop同时工作， 每个 EventLoop 维护着一个 Selector 实例。 EventLoopGroup 提供 next 接口， 可以从组里面按照一定规则获取其中一个 EventLoop 来处理任务。 在 Netty 服务器端编程中， 我们一般都需要提供两个EventLoopGroup， 例如： BossEventLoopGroup 和 WorkerEventLoopGroup。 

```
public NioEventLoopGroup()， 构造方法 

public Future<?> shutdownGracefully()， 断开连接， 关闭线程
```



## ServerBootstrap和Bootstrap

ServerBootstrap 是 Netty 中的服务器端启动助手，通过它可以完成服务器端的各种配置； Bootstrap 是 Netty 中的客户端启动助手， 通过它可以完成客户端的各种配置。 常用方法如下 所示：

```
public ServerBootstrap group(EventLoopGroup parentGroup, EventLoopGroup childGroup)，该方法用于服务器端， 用来设置两个 EventLoop 

public B group(EventLoopGroup group) ， 该方法用于客户端， 用来设置一个 EventLoop 

public B channel(Class<? extends C> channelClass)， 该方法用来设置一个服务器端的通道实现 

public <T> B option(ChannelOption<T> option, T value)， 用来给 ServerChannel 添加配置 

public <T> ServerBootstrap childOption(ChannelOption<T> childOption, T value)， 用来给接收到的通道添加配置 

public ServerBootstrap childHandler(ChannelHandler childHandler)， 该方法用来设置业务处理类（自定义的 handler） 

public ChannelFuture bind(int inetPort) ， 该方法用于服务器端， 用来设置占用的端口号 

public ChannelFuture connect(String inetHost, int inetPort) 该方法用于客户端， 用来连接服务器端
```



## Channel、ChannelPipeline、ChannelHandler、ChannelHandlerContext 之间的关系

```
        serverBootstrap.group(bossGroup, workGroup)
                //设置通道为NIO
                .channel(NioServerSocketChannel.class)
                //创建监听channel
                .childHandler(new ChannelInitializer<NioSocketChannel>() {
                    protected void initChannel(NioSocketChannel nioSocketChannel) throws Exception {
                        //获取管道对象
                        ChannelPipeline pipeline = nioSocketChannel.pipeline();
                        //给管道对象pipeLine 设置编码
                        pipeline.addLast(new StringEncoder());
                        pipeline.addLast(new RpcDecoder(RpcRequest.class, new JSONSerializer()));
                        //把我们自定义一个ChannelHander添加到通道中
                        //责任链上添加处理客户端消息的自定义类
                        pipeline.addLast(new UserServiceHandler());
                    }
                });
```

```
public class UserServiceHandler extends ChannelInboundHandlerAdapter  {

    //当读取到客户端发来的数据时,该方法会被自动调用
    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {

        System.out.println("接收到客户端信息："+ JSON.toJSON(msg).toString());
        //将读到的msg对象，强转成RpcRequest对象
        RpcRequest rpcRequest = (RpcRequest) msg;

        //加载class文件
        Class<?> aClass = Class.forName(rpcRequest.getClassName());
        //通过class获取服务器spring容器中service类的实例化bean对象
        Object serviceBean = SpringContextUtil.getBean(aClass);
        Class<?> serviceBeanClass = serviceBean.getClass();

        //使用cglib的FastClass类创建动态子类实例
        FastClass fastClass = FastClass.create(serviceBeanClass);
        //根据方法名称和参数类型获取方法
        FastMethod fastMethod = fastClass.getMethod(rpcRequest.getMethodName(), rpcRequest.getParameterTypes());
        //调用方法执行
        Object result = fastMethod.invoke(serviceBean, rpcRequest.getParameters());

        //服务器写入数据，将结果返回给客户端
        ctx.writeAndFlush("success");
    }
}
```



### Channel 

 Channel 是框架自己定义的一个通道接口，Netty 实现的**客户端** NIO 套接字通道是 NioSocketChannel，提供的**服务器端** NIO 套接字通道是 NioServerSocketChannel。

**当服务端和客户端建立一个新的连接时， 一个新的 Channel 将被创建，同时它会被自动地分配到它专属的 ChannelPipeline。**



### ChannelPipeline 

ChannelPipeline 是一个**拦截流经 Channel 的入站和出站事件的 ChannelHandler 实例链**，并定义了用于在该链上传播入站和出站事件流的 API。那么就很容易看出这些 **ChannelHandler 之间的交互是组成一个应用程序数据和事件处理逻辑的核心**。



### ChannelHandler

ChannelHandler分为 ChannelInBoundHandler 和 ChannelOutboundHandler 两种

#### 入站

如果一个入站 IO 事件被触发，这个事件会从第一个开始依次通过 ChannelPipeline中的 ChannelInBoundHandler，先添加的先执行。

#### 出站

若是一个出站 I/O 事件，则会从最后一个开始依次通过 ChannelPipeline 中的 ChannelOutboundHandler，后添加的先执行，然后通过调用在 ChannelHandlerContext 中定义的事件传播方法传递给最近的 ChannelHandler。



### ChannelHandlerContext 

ChannelHandlerContext 代表了 ChannelHandler 和 ChannelPipeline 之间的关联，每当有 ChannelHandler 添加到 ChannelPipeline 中时，**都会创建 ChannelHandlerContext**。

ChannelHandlerContext 的主要功能是管理它所关联的 ChannelHandler 和在同一个 ChannelPipeline 中的其他 ChannelHandler 之间的交互。事件从一个 ChannelHandler 到下一个 ChannelHandler 的移动是由 ChannelHandlerContext 上的调用完成的。



在 ChannelPipeline 传播事件时，它会测试 ChannelPipeline 中的下一个 ChannelHandler 的类型是否和事件的运动方向相匹配。

如果某个ChannelHandler不能处理则会跳过，并将事件传递到下一个ChannelHandler，直到它找到和该事件所期望的方向相匹配的为止。



# Netty 线程模型

在前面的示例中我们程序一开始都会生成两个 NioEventLoopGroup 的实例，为什么需要这两个实例呢？这两个实例可以说是 Netty 程序的源头，其背后是由 Netty 线程模型决定的。

Netty 线程模型是典型的 **Reactor 模型结构**，其中常用的 Reactor 线程模型有三种，分别为：**Reactor 单线程模型、Reactor 多线程模型和主从 Reactor 多线程模型。**

而在 Netty 的线程模型并非固定不变，通过在启动辅助类中创建不同的 EventLoopGroup 实例并通过适当的参数配置，就可以支持上述三种 Reactor 线程模型。

## Reactor 单线程模型

Reactor 单线程模型指的是所有的 IO 操作都在同一个 NIO 线程上面完成。作为 NIO 服务端接收客户端的 TCP 连接，作为 NIO 客户端向服务端发起 TCP 连接，读取通信对端的请求或向通信对端发送消息请求或者应答消息。

由于 Reactor 模式使用的是异步非阻塞 IO，所有的 IO 操作都不会导致阻塞，理论上一个线程可以独立处理所有 IO 相关的操作。





参考 

[Netty实战入门详解——让你彻底记住什么是Netty（看不懂你来找我）](https://www.cnblogs.com/nanaheidebk/p/11025362.html)

[Netty入门教程——认识Netty](https://www.jianshu.com/p/b9f3f6a16911)

[Netty核心知识](https://baijiahao.baidu.com/s?id=1663161766587120223&wfr=spider&for=pc)

[Netty线程模型](https://www.jianshu.com/p/738095702b75)

