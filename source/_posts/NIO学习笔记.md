---
title: NIO理论
abbrlink: 6j507e71
date: 2020-9-2 23:30:44
tags: 分布式
categories: 分布式
keywords: 分布式
---
# 一、NIO概念

## 1.1NIO介绍

同步非阻塞IO （non-blocking IO / new io）是指JDK 1.4 及以上版本。

服务器实现模式为一个请求一个通道，即客户端发送的连接请求都会注册到**多路复用器**上，多路复用器轮询到连接有IO请求时才启动一个线程进行处理。



**通道（Channels）**

NIO 新引入的最重要抽象的是通道的概念。Channel 数据连接的通道。 数据可以从Channel读到Buffffer中，也可以从Buffffer 写到Channel中 .

**缓冲区（Buffffers）**

通道channel可以向缓冲区Buffffer中写数据，也可以像buffffer中存数据。

**选择器（Selector）**

使用选择器，借助单一线程，就可对数量庞大的活动 I/O 通道实时监控和维护。

![mark](http://blog.xuejiangtao.com/blog/20200714/0FHQTu3csF0E.png?imageslim)

## 1.2特点

当一个连接创建后，不会需要对应一个线程，这个**连接会被注册到多路复用器**，所以一个连接只需要一个线程即可。所有的连接需要一个线程就可以操作，该线程的多路复用器会轮训，发现连接有请求时，才开启一个线程处理。





**IO模型中**，一个连接来了，会创建一个线程，对应一个while死循环，死循环的目的就是不断监测这条连接上是否有数据可以读。大多数情况下，1w个连接里面同一时刻只有少量的连接有数据可读。因此，很多个while死循环都白白浪费掉了，因为读不出啥数据。

而在**NIO模型中**，他把这么多while死循环变成一个死循环，这个死循环由一个线程控制。那么他又是如何做到一个线程，一个while死循环就能监测1w个连接是否有数据可读的呢？ 这就是NIO模型中**selector的作用**，一条连接来了之后，现在不创建一个while死循环去监听是否有数据可读了，而是直接把这条连接注册到selector上，然后，通过检查这个selector，就可以批量监测出有数据可读的连接，进而读取数据。



# 二、NIO是如何实现同步非阻塞的呢？

Java的NIO实现采用了同步非阻塞IO和IO多路复用，其核心组件是Selector。Selector会不断的主动的询问Channel是否有事件发生，有事件发生，会进行事件处理。

```
//java nio
while(true) {
  ......
  selector.select(1); //不阻塞
  Set<SelectionKey> selectionKeySet= selector.selectedKeys();
  ......
  //处理selectionKeySet中事件,线程没有阻塞
}


//java socket处理连接，线程会阻塞
while(true) {
  ......
  Socket socket = serverSocket.accept(); //阻塞
  InputStream in = socket.getInputStream(); 
  ......
  //处理in中内容
}

```

# 三、代码实战

## 3.1创建NIO服务端

```
public class NIOServer extends Thread{

    //1.声明多路复用器
    private Selector selector;
    //2.定义读写缓冲区
    private ByteBuffer readBuffer = ByteBuffer.allocate(1024);
    private ByteBuffer writeBuffer = ByteBuffer.allocate(1024);

    //3.定义构造方法初始化端口
    public NIOServer(int port) {
        init(port);
    }

    //4.main方法启动线程
    public static void main(String[] args) {
        new Thread(new  NIOServer(8888)).start();
    }

    //5.初始化
    private void init(int port) {

        try {
            System.out.println("服务器正在启动......");
            //1)开启多路复用器
            this.selector = Selector.open();
            //2) 开启服务通道
            ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();
            //3)设置为非阻塞
            serverSocketChannel.configureBlocking(false);//为什么我们要明确配置非阻塞模式呢？这是因为阻塞模式下，注册操作是不允许的，会抛出 IllegalBlockingModeException 异常；
            //4)绑定端口
            serverSocketChannel.bind(new InetSocketAddress(port));
            /**
             * SelectionKey.OP_ACCEPT   —— 接收连接继续事件，表示服务器监听到了客户连接，服务器可以接收这个连接了
             * SelectionKey.OP_CONNECT  —— 连接就绪事件，表示客户与服务器的连接已经建立成功
             * SelectionKey.OP_READ     —— 读就绪事件，表示通道中已经有了可读的数据，可以执行读操作了（通道目前有数据，可以进行读操作了）
             * SelectionKey.OP_WRITE    —— 写就绪事件，表示已经可以向通道写数据了（通道目前可以用于写操作）
             */
            //5)注册,标记服务连接状态为ACCEPT状态
            serverSocketChannel.register(this.selector, SelectionKey.OP_ACCEPT);
            System.out.println("服务器启动完毕");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void run(){
        while (true){
            try {
                //1.当有至少一个通道被选中,执行此方法
                this.selector.select(); //阻塞等待就绪的Channel
                //2.获取选中的通道编号集合
                Iterator<SelectionKey> keys = this.selector.selectedKeys().iterator();
                //3.遍历keys
                while (keys.hasNext()) {
                    SelectionKey key = keys.next();
                    //4.当前key需要从动刀集合中移出,如果不移出,下次循环会执行对应的逻辑,造成业务错乱
                    keys.remove();
                    //5.判断通道是否有效
                    if (key.isValid()) {
                        try {
                            //6.判断是否可以连接
                            if (key.isAcceptable()) {
                                accept(key);
                            }
                        } catch (CancelledKeyException e) {
                            //出现异常断开连接
                            key.cancel();
                        }

                        try {
                            //7.判断是否可读
                            if (key.isReadable()) {
                                read(key);
                            }
                        } catch (CancelledKeyException e) {
                            //出现异常断开连接
                            key.cancel();
                        }

                        try {
                            //8.判断是否可写
                            if (key.isWritable()) {
                                write(key);
                            }
                        } catch (CancelledKeyException e) {
                            //出现异常断开连接
                            key.cancel();
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void accept(SelectionKey key) {
        try {
            //1.当前通道在init方法中注册到了selector中的ServerSocketChannel
            ServerSocketChannel serverSocketChannel = (ServerSocketChannel) key.channel();
            //2.阻塞方法, 客户端发起后请求返回.
            SocketChannel channel = serverSocketChannel.accept();
            ///3.serverSocketChannel设置为非阻塞
            channel.configureBlocking(false);
            //4.设置对应客户端的通道标记,设置次通道为可读时使用
            channel.register(this.selector, SelectionKey.OP_READ);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //使用通道读取数据
    private void read(SelectionKey key) {
        try{
            //清空缓存
            this.readBuffer.clear();
            //获取当前通道对象
            SocketChannel channel = (SocketChannel) key.channel();
            //将通道的数据(客户发送的data)读到缓存中.
            int readLen = channel.read(readBuffer);
            //如果通道中没有数据
            if(readLen == -1 ){
                //关闭通道
                key.channel().close();
                //关闭连接
                key.cancel();
                return;
            }
            //Buffer中有游标,游标不会重置,需要我们调用flip重置. 否则读取不一致
            this.readBuffer.flip();
            //创建有效字节长度数组
            byte[] bytes = new byte[readBuffer.remaining()];
            //读取buffer中数据保存在字节数组
            readBuffer.get(bytes);
            System.out.println("收到了从客户端 "+ channel.getRemoteAddress() + " :  "+ new String(bytes,"UTF-8"));
            //注册通道,标记为写操作
            channel.register(this.selector,SelectionKey.OP_WRITE);

        }catch (Exception e){

        }
    }

    //给通道中写操作
    private void write(SelectionKey key) {
        //清空缓存
        this.readBuffer.clear();
        //获取当前通道对象
        SocketChannel channel = (SocketChannel) key.channel();
        //录入数据
        Scanner scanner = new Scanner(System.in);

        try {
            System.out.println("即将发送数据到客户端..");
            String line = scanner.nextLine();
            //把录入的数据写到Buffer中
            writeBuffer.put(line.getBytes("UTF-8"));
            //重置缓存游标
            writeBuffer.flip();
            channel.write(writeBuffer);
            channel.register(this.selector,SelectionKey.OP_READ);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## 3.2创建NIO客户端

```
public class NIOClient {
    public static void main(String[] args) {
        //创建远程地址
        InetSocketAddress address  = new InetSocketAddress("127.0.0.1",8888);
        SocketChannel channel = null;
        //定义缓存
        ByteBuffer buffer = ByteBuffer.allocate(1024);
        try {
            //开启通道
              channel = SocketChannel.open();
            //连接远程远程服务器
            channel.connect(address);
            Scanner sc = new Scanner(System.in);
            while (true){
                System.out.println("客户端即将给 服务器发送数据..");
                String line = sc.nextLine();
                if(line.equals("exit")){
                    break;
                }
                //控制台输入数据写到缓存
                buffer.put(line.getBytes("UTF-8"));
                //重置buffer 游标
                buffer.flip();
                //数据发送到数据
                channel.write(buffer);
                //清空缓存数据
                buffer.clear();

                //读取服务器返回的数据
                int readLen = channel.read(buffer);
                if(readLen == -1){
                    break;
                }
                //重置buffer游标
                buffer.flip();
                byte[] bytes = new byte[buffer.remaining()];
                //读取数据到字节数组
                buffer.get(bytes);
                System.out.println("收到了服务器发送的数据 : "+ new String(bytes,"UTF-8"));
                buffer.clear();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (null != channel){
                try {
                    channel.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```

