---
title: Nginx配置详情
abbrlink: 9aaac662
date: 2020-07-10 10:14:56
tags: ngxin
categories: nginx
keywords: nginx 配置
---

Nginx中文文档

https://www.nginx.cn/doc/index.html

http://www.ha97.com/5194.html

https://www.cnblogs.com/bluestorm/p/4574688.html



```
#定义Nginx运行的用户和用户组
user nobody;
#启动进程,通常设置成和cpu的数量相等
#worker_processes auto;　表示设置服务器cpu核数匹配开启nginx开启的worker进程数
worker_processes  1;
 
#全局错误日志定义类型，[ debug | info | notice | warn | error | crit ]
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
 
#PID进程文件
#pid        logs/nginx.pid;
 
#表示worker进程最多能打开的文件句柄数
#基于liunx系统ulimit设置，查看系统文件句柄数最大值：ulimit -n
#注意：Linux一切皆文件，所有请求过来最终目的访问文件，所以该参数值设置等同于liunx系统ulimit设置为优
#默认是没有设置，可以设置为操作系统最大的限制65535。
#worker_rlimit_nofile 65535;
 
#工作模式及连接数上限
events {
    #参考事件模型，use [ kqueue | rtsig | epoll | /dev/poll | select | poll ]; epoll模型是Linux 2.6以上版本内核中的高性能网络I/O模型，如果跑在FreeBSD上面，就用kqueue模型。
    #epoll是多路复用IO(I/O Multiplexing)中的一种方式,
    #仅用于linux2.6以上内核,可以大大提高nginx的性能
    use epoll; 
 
    #单个进程最大连接数
    #nginx作为反向代理服务器（计算公式 最大连接数 = worker_processes * worker_connections/4）
    #当nginx作为http服务器时，计算公式里面是除以2（计算公式 最大连接数 = worker_processes * worker_connections/2）
    worker_connections 1024;
 
    # 并发总数是 worker_processes 和 worker_connections 的乘积
    # 即 max_clients = worker_processes * worker_connections
    # 在设置了反向代理的情况下，max_clients = worker_processes * worker_connections / 4  为什么
    # 为什么上面反向代理要除以4，应该说是一个经验值
    # 根据以上条件，正常情况下的Nginx Server可以应付的最大连接数为：4 * 8000 = 32000
    # worker_connections 值的设置跟物理内存大小有关
    # 因为并发受IO约束，max_clients的值须小于系统可以打开的最大文件数
    # 而系统可以打开的最大文件数和内存大小成正比，一般1GB内存的机器上可以打开的文件数大约是10万左右
    # 我们来看看360M内存的VPS可以打开的文件句柄数是多少：
    # $ cat /proc/sys/fs/file-max
    # 输出 34336
    # 32000 < 34336，即并发连接总数小于系统可以打开的文件句柄总数，这样就在操作系统可以承受的范围之内
    # 所以，worker_connections 的值需根据 worker_processes 进程数目和系统可以打开的最大文件总数进行适当地进行设置
    # 使得并发总数小于操作系统可以打开的最大文件数目
    # 其实质也就是根据主机的物理CPU和内存进行配置
    # 当然，理论上的并发总数可能会和实际有所偏差，因为主机还有其他的工作进程需要消耗系统资源。
    # ulimit -SHn 65535
 
}
 
#设定http服务器
http {
    #设定mime类型,类型由mime.type文件定义
    #文件扩展名与文件类型映射表
    include    mime.types;
    default_type  application/octet-stream;
    #charset utf-8; #默认编码
    #设定日志格式
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
 
    #access_log  logs/access.log  main;
 
    #sendfile 指令指定 nginx 是否调用 sendfile 函数（zero copy 方式）来输出文件，
    #对于普通应用，必须设为 on,
    #如果用来进行下载等应用磁盘IO重负载应用，可设置为 off，
    #以平衡磁盘与网络I/O处理速度，降低系统的uptime.
    #开启高效文件传输模式，sendfile指令指定nginx是否调用sendfile函数来输出文件，对于普通应用设为 on，如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。注意：如果图片显示不正常把这个改成off。
    sendfile     on;  
    
 	#Nginx默认是不允许列出整个目录的。如需此功能，打开nginx.conf文件，在location，server 或 http段中加入autoindex on;，另外两个参数最好也加上去:
 	#autoindex on; #开启目录列表访问，合适下载服务器，默认关闭。
 	#autoindex_exact_size off; #默认为on，显示出文件的确切大小，单位是bytes。改为off后，显示出文件的大概大小，单位是kB或者MB或者GB
 	#autoindex_localtime on;#默认为off，显示的文件时间为GMT时间。改为on后，显示的文件时间为文件的服务器时间

 
    #连接超时时间
    #keepalive_timeout  0;
    keepalive_timeout  65;#长连接超时时间，单位是秒
    tcp_nodelay     on;#防止网络阻塞 
	#tcp_nopush	on; #防止网络阻塞 
 
 	#FastCGI相关参数是为了改善网站的性能：减少资源占用，提高访问速度。下面参数看字面意思都能理解。
	fastcgi_connect_timeout 300;
	fastcgi_send_timeout 300;
	fastcgi_read_timeout 300;
	fastcgi_buffer_size 64k;
	fastcgi_buffers 4 64k;
	fastcgi_busy_buffers_size 128k;
	fastcgi_temp_file_write_size 128k;
  
    #gzip模块设置
	gzip on; #开启gzip压缩输出
    gzip_disable "MSIE [1-6].";
	gzip_min_length 1k; #最小压缩文件大小
	gzip_buffers 4 16k; #压缩缓冲区
	gzip_http_version 1.0; #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
	gzip_comp_level 2; #压缩等级
	gzip_types text/plain application/x-javascript text/css application/xml;	#压缩类型，默认就已经包含text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。
	gzip_vary on;	#limit_zone crawler $binary_remote_addr 10m; #开启限制IP连接数的时候需要使用
    
    # http_proxy 设置
	client_max_body_size 10m;
	client_body_buffer_size 128k;
	proxy_connect_timeout 75;
	proxy_send_timeout 75;
	proxy_read_timeout 75;
	proxy_buffer_size 4k;
	proxy_buffers 4 32k;
	proxy_busy_buffers_size 64k;
	proxy_temp_file_write_size 64k;
	proxy_temp_path /usr/local/nginx/proxy_temp 1 2;
 
    #设定请求缓冲
    client_header_buffer_size    128k;
    large_client_header_buffers  4 128k;
 
 
	#upstream设置负载均衡
	#ip_hash;将ip通过hash计算出一个值，将ip固定到一个服务器地址，之后用户访问都是同一个服务器地址
	#weight是权重，可以根据机器配置定义权重。weigth参数表示权值，权值越高被分配到的几率越大。
	
	#Nginx在负载均衡功能中，用于判断后端节点状态
	#默认：fail_timeout为10s,max_fails为1次。
	#Nginx基于连接探测，如果发现后端异常，在fail_timeout设置的时间范围内达到max_fails次数，这个周期次数内，如果后端同一个节点不可用，那么就把该节点标记为不可用，并等待下一个周期（同样时常为fail_timeout）再一次去请求，判断是否连接成功。
	#即在10s以内后端失败了1次【即一次请求超时】，那么该后端就被标识为不可用，所以在接下来的10s内不访问该节点，nginx都会把请求分配给正常的后端【即多次的请求正常】。
	 upstream backend {
		 #ip_hash;
		 #要转发的地址
		 server 192.168.80.121:80 weight=3;
		 server 192.168.80.122:80 weight=2;
		 server 192.168.80.123:80 weight=3;
		 server 192.168.80.124:80 max_fails=2 fail_timeout=30s ;
	}
 
 
    #设定虚拟主机配置
    server {
        #侦听80端口
        listen    80;
        #定义使用localhost访问
        server_name  localhost;
        #server_name  www.example.com;
 
        #定义服务器的默认网站根目录位置
        root /apps/oaapp;
 
        #设定本虚拟主机的访问日志
        access_log  logs/nginx.access.log  main;
 
        #对 “/” 启用反向代理，URL对应的一系列配置项。
        location / {
            root /apps/oaapp;
            #定义首页索引文件的名称
            index index.php index.html index.htm;   
            proxy_redirect off; 
			# 后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
			client_max_body_size 10m; #允许客户端请求的最大单文件字节数
			client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数，
			proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间(代理连接超时)
			proxy_send_timeout 90; #后端服务器数据回传时间(代理发送超时)
			proxy_read_timeout 90; #连接成功后，后端服务器响应时间(代理接收超时)
			proxy_buffer_size 4k; #设置代理服务器（nginx）保存用户头信息的缓冲区大小
			proxy_buffers 4 32k; #proxy_buffers缓冲区，网页平均在32k以下的设置
			proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
			proxy_temp_file_write_size 64k;#设定缓存文件夹大小，大于这个值，将从upstream服务器传
			#请求转向backend定义的服务器列表，即反向代理，对应upstream负载均衡器。也可以proxy_pass http://ip:port。
 			proxy_pass http://backend;
        }
		 #设定查看Nginx状态的地址
		location /NginxStatus {
			stub_status on;
			access_log on;
			auth_basic “NginxStatus”;
			auth_basic_user_file conf/htpasswd;
			#htpasswd文件的内容可以用apache提供的htpasswd工具来产生。
		}

		#本地动静分离反向代理配置
		#所有jsp的页面均交由tomcat或resin处理
		location ~ .(jsp|jspx|do)?$ {
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_pass http://127.0.0.1:8080;
		}
		
		#所有静态文件由nginx直接读取不经过tomcat或resin
		location ~ .*.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt|pdf|xls|mp3|wma)$
		{             
			#过期30天，静态文件不怎么更新，过期可以设大一点，
            #如果频繁更新，则可以设置得小一点。
            expires 30d;
		}
		location ~ .*.(js|css)?$
		{ 
			expires 1h;
        } 

        # 定义错误提示页面
        error_page   500 502 503 504 /50x.html;
        location = /50x.html {
        }
  
        #PHP 脚本请求全部转发到 FastCGI处理. 使用FastCGI默认配置.
        location ~ .php$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
 
        #禁止访问 .htxxx 文件
            location ~ /.ht {
            deny all;
        }
 
    }
}
```

