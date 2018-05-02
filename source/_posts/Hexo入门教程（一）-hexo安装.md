---
title: Hexo入门教程（一）-hexo安装
tags: hexo
categories: hexo
abbrlink: 3523a191
date: 2018-04-18 15:51:18
---
hexo有[官方文档](https://hexo.io/zh-cn/docs/index.html)，本文只记录自己搭建hexo博客的过程。


#### 先检查电脑是否安装NodeJs和Git
- **查看nodejs**：  
node -v  
npm -v
- **检查git**  
在文件夹空白处右键，如果出现以下图片表明安装成功。  
<img src="https://github.com/xjt927/filerepository/blob/master/20180207163420.jpg?raw=true" width="300">
 
 <!-- more -->
 
##### 安装NodeJs
下载并安装nodejs  
官方下载地址：https://nodejs.org/en/download/  
<img src="https://github.com/xjt927/filerepository/blob/master/1517994916(1).jpg?raw=true" width="700"  />   
<br/>
中文下载地址：http://nodejs.cn/download/  
<img src="https://github.com/xjt927/filerepository/blob/master/1517994824(1).jpg?raw=true" width="700"  />  
具体nodejs安装可参考 [Node.js 安装配置](http://www.runoob.com/nodejs/nodejs-install-setup.html) 

##### 安装Git
下载并安装Git  
下载地址 https://git-scm.com/downloads  
具体Git安装可参考 [Git 安装配置](http://www.runoob.com/git/git-install-setup.html) 

### 安装Hexo框架  
使用npm命令安装Hexo框架，进入cmd命令然后输入：  
`npm install -g hexo-cli`

<img src="https://github.com/xjt927/filerepository/blob/master/1523175254(1).jpg?raw=true" width="600"  />

### 创建Hexo网站
使用npm命令安装Hexo网站所需的文件，依次输入：  
`hexo init <folder>`  
`cd <folder>`  
`npm install` 

`<folder>` 为你要安装hexo的路径  
如果没有设置 `folder` ，Hexo默认在目前的文件夹建立网站。
<img src="https://github.com/xjt927/filerepository/blob/master/1523177024(1).jpg?raw=true" width="600"  />
新建完成后，指定文件夹的目录如下：  
.  
├── _config.yml  
├── package.json  
├── scaffolds  
├── source  
|   ├── _drafts  
|   └── _posts  
└── themes  

到这里Hexo已经安装成功了，使用cmd命令cd进入刚才创建的hexo文件夹，分别执行以下命令：  
`hexo g`  
`hexo c`  
命令简写  
`hexo n "我的博客" == hexo new "我的博客" #新建文章`
`hexo g == hexo generate #生成`
`hexo s == hexo server #启动服务预览`
`hexo d == hexo deploy #部署`
完成后，打开浏览器输入地址：  
[localhost:4000](http://localhost:4000)  
可以看到默认网站样式
<img src="https://github.com/xjt927/filerepository/blob/master/1523177767(1).jpg?raw=true" width="600"  />

