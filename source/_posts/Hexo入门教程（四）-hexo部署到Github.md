---
title: Hexo入门教程（四）-hexo部署到Github
tags: hexo
categories: hexo
abbrlink: '30e46490'
keywords: hexo,搭建,部署,Github,博客,hexo教程
date: 2018-04-18 15:54:18
---

## Github Pages设置
### 什么是Github Pages

 - Github Pages 是 github 公司提供的免费的静态网站托管服务，用起来方便而且功能强大，不仅没有空间限制，还可以绑定自己的域名。在 https://pages.github.com/ 首页上可以看到很多用 Github Pages 托管的网站，很漂亮。另外很多非常著名的公司和项目也都用这种方式来搭建网站，如[微软][1]和 [twitter][2] 的网站，还有 谷歌的 [Material Design][3] 图标 网站。
 
 - 每个帐号只能有一个仓库来存放个人主页，而且仓库的名字必须是username/username.github.io，这是特殊的命名约定。你可以通过http://username.github.io 来访问你的个人主页。
 
 - 每一个github账户最多只能创建一个，这样可以直接使用域名访问仓库。
 
 - **这里特别提醒一下，需要注意的个人主页的网站内容是在master分支下的。**
<!-- more -->
## Github Pages优缺点
  
- Github Pages优点：
 - 轻量级的博客系统，没有麻烦的配置
 - 使用标记语言，比如Markdown
 - 无需自己搭建服务器
 - 根据Github的限制，对应的每个站有300MB空间
 - 可以绑定自己的域名
- Github Pages缺点：
 - 使用Jekyll模板系统，相当于静态页发布，适合博客，文档介绍等。
 - 动态程序的部分相当局限，比如没有评论，不过还好我们有解决方案。
 - 基于Git，很多东西需要动手，不像Wordpress有强大的后台。

## 创建自己的Github Pages
### 注册 GitHub
访问：http://www.github.com/

注册你的 username 和邮箱，邮箱十分重要，GitHub 上很多通知都是通过邮箱发送。

注册过程比较简单，详细也可以看：

[一步步在 GitHub上创建博客主页][4] 全系列 by pchou（推荐）

## 创建仓库
新建一个名为你的用户名.github.io的仓库，比如说，如果你的github用户名是test，那么你就新建test.github.io的仓库（必须是你的用户名，其它名称无效），将来你的网站访问地址就是 http://test.github.io 了，是不是很方便？

 - 几个注意的地方：

- 注册的邮箱一定要验证，否则不会成功；
- 仓库名字必须是：username.github.io，其中username是你的用户名；

创建成功后，以后你的博客所有代码都是放在这个仓库里啦。

## 创建SSH Key
在windows系统下进入c盘，右键点击“Git Bash Here”，然后输入命令。
<img src="https://github.com/xjt927/filerepository/blob/master/NM2$$_U77%7BFJPY@QKE%28KC%25W.png?raw=true" width="700"  /> 

 1. 检查SSH keys的设置
首先我们需要检查你电脑上现有的ssh key：
`$ cd ~/.ssh`
如果显示“No such file or directory”，跳到第三步，否则继续。

 2. 备份和移除原来的ssh key设置：
因为已经存在key文件，所以需要备份旧的数据并删除：
```
$ ls
config	id_rsa	id_rsa.pub	known_hosts
$ mkdir key_backup
$ cp id_rsa* key_backup
$ rm id_rsa*
```
 3. 生成新的SSH Key：
输入下面的代码，你的邮箱地址，就可以生成新的key文件，我们只需要默认设置就好，所以当需要输入文件名的时候，回车就好。
```
$ ssh-keygen -t rsa -C "youremail@example.com"
```
输入命令回车后出现以下信息，直接回车：
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/your_user_directory/.ssh/id_rsa):<直接回车>

- 注意 1: 此处的邮箱地址，你可以输入自己的邮箱地址；
- 注意 2: 此处的「-C」的是大写的「C」

然后系统会要你输入加密串（Passphrase），不想设置的默认回车就行：
```
Enter passphrase (empty for no passphrase):<输入加密串>
Enter same passphrase again:<再次输入加密串>
```
这个密码会在你提交项目时使用，如果为空的话提交项目时则不用输入。这个设置是防止别人往你的项目里提交内容。

- 注意：输入密码的时候没有 * 字样的，你直接输入就可以了。

**生成.ssh文件中id_rsa是私钥，不能泄露出去，id_rsa.pub是公钥。**

## 添加SSH Key到GitHub：
在本机设置 SSH Key 之后，需要添加到 GitHub上，以完成 SSH 链接的设置。

- 1、打开本地 id_rsa.pub 文件（ 参考地址 C:\Documents and Settings\Administrator\.ssh\id_rsa.pub）。此文件里面内容为刚才生成的密钥。如果看不到这个文件，你需要设置显示隐藏文件。准确的复制这个文件的内容，才能保证设置的成功。

- 2、登陆 GitHub 系统。点击右上角的 Account Settings--->SSH and GPG keys ---> New SSH key 

- 3、把你本地生成的密钥复制到里面（ key 文本框中）， 点击 Add SSH key 就ok了

- 4、添加 SSH Key 到 GitHub

## 测试
可以输入下面的命令，看看设置是否成功，`git@GitHub.com` 的部分不要修改：
```
$ ssh -T git@GitHub.com
```
如果是下面的反馈：

> The authenticity of host 'GitHub.com (207.97.227.239)' can't be established.
RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
Are you sure you want to continue connecting (yes/no)?

不要紧张，输入 yes 就好，然后会看到：

> Hi userName! You've successfully authenticated, but GitHub does not provide shell access.

设置用户信息
现在你已经可以通过 SSH 链接到 GitHub 了，还有一些个人信息需要完善的。

Git 会根据用户的名字和邮箱来记录提交。GitHub 也是用这些信息来做权限的处理，输入下面的代码进行个人信息的设置，把名称和邮箱替换成你自己的，名字必须是你的真名，而不是GitHub的昵称。
```
$ git config --global user.name "userName"//用户名
$ git config --global user.email "youremail@example.com"//填写自己的邮箱
```
SSH Key 配置成功
本机已成功连接到 GitHub。

若有问题，请重新设置。常见错误请参考：
[GitHub Help - Generating SSH Keys][5]
[GitHub Help - Error Permission denied (publickey)][6]

## 上传到Github
参考官方文档 [部署][7]

- 配置站点配置文件
打开根目录下站点配置文件_config.yml，配置有关deploy的部分：
<img src="https://github.com/xjt927/filerepository/blob/master/%25(AVBOX(1$26WIAW65%5DIEK2.png?raw=true" width="300">

```
deploy:
  type: git
  repo: git@github.com:xjt927/xjt927.github.io.git
  branch: master
```
- 安装插件
此时，直接使用`hexo d`部署到github，将出现如下错误：
```
ERROR Deployer not found: git
```
这是因为需要安装如下插件：
```
$ npm install hexo-deployer-git --save
```
- 部署到github

**注意：**

- 如果安装git客户端的时候没有勾选git命令在bash和cmd命令都有效，若是在cmd命令下则因为没有将git添加到windows的path，所以会出现错误，**一般可以尝试在blog的目录右键选`Git Bath here`再尝试`hexo d`**。
- 执行`hexo d`后报错：fatal: Not a git repository (or any of the parent directories): .git
<img src="https://github.com/xjt927/filerepository/blob/master/7$FB2LS2Z4~RHASZ4EI3IMQ.png?raw=true" width="300">  
**解决：** 把hexo文件夹下的`.deploy_git`文件夹删掉，重新编译、发布。

- `hexo d`之后等运行完毕，打开github仓库看到文件已经推送过来了，这时打开https://你的用户名.github.io/，会发现新写的文章已经生成，则表示部署到github成功。
  

## hexo主题设置
[hexo官方主题文档][12]中介绍了怎样创建主题，并给出了[hexo主题列表][13]，从中挑选喜欢的主题。对于前端不熟的我，只能参考使用现成的主题了，这是我使用一套的主题——[hexo-theme-tomotoes][14]，记录一下使用步骤。
1. [安装][15]
2. [配置][16]
3. 在参考[安装][15]配置“标签页”，“分类页”，“关于页”的设置时，将其给出的配置放到文件头三道杠“---”中间，可以是“date”下面位置。如about页面的配置：
```
---
title: about
date: 2018-04-18 14:54:10
layout: about
comments: true
reward: false
---
```
4. 在设置“themes\tomotoes\\_config.yml”主题配置文件时，文章截断要设置为`excerpt_render: false`，才能在首页截断文章。
```
mymotto: #关闭一言将true和false都清空即可
 content: Just Do It!
```

5. 新建文章之后，在文件头部写上`tags`、`categories`字段，分别对应网站的`标签`、`分类`菜单列表，例如：
```
---
title: test
abbrlink: d87f7e0c
date: 2018-04-18 15:51:18
tags: 测试标签
categories: 测试分类
---
```
6. 设置完成后使用`hexo c`、`hexo g`等命令，如果报如下错误，说明在配置文件`_config.yml`的87行前面有空格，删掉空格即可。
```
FATAL bad indentation of a mapping entry at line 87, column 2:
     feed:
     ^
```

7. 打开“themes\tomotoes\layout\\_partial\post\updated.ejs”，修改`('post.last_updated')`为`('最后更新：')`，用于文章下面的提示信息。

8. 打开“themes\tomotoes\layout\\_partial\index-item.ejs”第21行处，将`<%= __('post.continue_reading') %>`设置为`<%= __('全文阅读') %>`。

## 参考资料：
1. [Hexo官方文档][8]
2. [如何搭建一个独立博客——简明Github Pages与Hexo教程][9]
3. [【Hexo搭建独立博客全纪录】（三）使用Hexo搭建博客][10]
4. [使用hexo+github搭建免费个人博客详细教程][11]



  [1]: http://microsoft.github.io/
  [2]: http://twitter.github.io/
  [3]: http://google.github.io/material-design-icons/
  [4]: https://link.jianshu.com/?t=http://www.pchou.info/ssgithubPage/2013-01-03-build-github-blog-page-01.html
  [5]: https://link.jianshu.com/?t=http://help.GitHub.com/articles/generating-ssh-keys
  [6]: https://link.jianshu.com/?t=http://help.GitHub.com/articles/error-permission-denied-publickey
  [7]: https://hexo.io/zh-cn/docs/deployment.html
  [8]: https://hexo.io/zh-cn/docs/
  [9]: https://www.jianshu.com/p/05289a4bc8b2
  [10]: https://baoyuzhang.github.io/2017/05/12/%E3%80%90Hexo%E6%90%AD%E5%BB%BA%E7%8B%AC%E7%AB%8B%E5%8D%9A%E5%AE%A2%E5%85%A8%E7%BA%AA%E5%BD%95%E3%80%91%EF%BC%88%E4%B8%89%EF%BC%89%E4%BD%BF%E7%94%A8Hexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2/
  [11]: http://blog.haoji.me/build-blog-website-by-hexo-github.html?from=xa
  [12]: https://hexo.io/zh-cn/docs/themes.html
  [13]: https://hexo.io/themes/
  [14]: https://github.com/Tomotoes/hexo-theme-tomotoes
  [15]: https://github.com/Tomotoes/hexo-theme-tomotoes/wiki/%E5%AE%89%E8%A3%85
  [16]: https://github.com/Tomotoes/hexo-theme-tomotoes/wiki/%E9%85%8D%E7%BD%AE