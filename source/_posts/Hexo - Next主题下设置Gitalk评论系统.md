---
title: Hexo - Next主题下设置Gitalk评论系统
tags:
  - hexo
  - Gitalk
categories: hexo
abbrlink: a3b6b471
date: 2018-05-02 10:16:17
---

# 前言
本来不想写这篇博客的，网上有很多这样的教程，配置过程也很简。无奈我在配置过程中遇到几个坑，遂记录之。

# 什么GitHub OAuth
>OAuth（开放授权）是一个开放标准，允许用户让第三方应用访问该用户在某一网站上存储的私密的资源（如照片，视频，联系人列表），而无需将用户名和密码提供给第三方应用。 ---- 百度百科

OAuth协议的认证和授权的过程如下：
- 用户打开我的博客后，我想要通过GitHub获取改用户的基本信息
- 在转跳到GitHub的授权页面后，用户同意我获取他的基本信息
- 博客获得GitHub提供的授权码，使用该授权码向GitHub申请一个令牌
- GitHub对博客提供的授权码进行验证，验证无误后，发放一个令牌给博客端
- 博客端使用令牌，向GitHub获取用户信息
- GitHub 确认令牌无误，返回给我基本的用户信息
<!-- more -->

# Gitalk介绍
Gitalk 是一个基于 Github Issue 和 Preact 开发的评论插件。
## Gitalk地址：
[Gitalk项目地址][1] 、[Gitalk中文说明][2] 、[Gitalk在线示例][3]

## Gitalk特性
- 使用 Github 登录
- 支持多语言 [en, zh-CN, zh-TW, es-ES, fr, ru]
- 支持个人或组织
- 无干扰模式（设置 distractionFreeMode 为 true 开启）
- 快捷键提交评论 （cmd|ctrl + enter）

# Next主题下设置Gitalk
## 注册一个新的OAuth应用程序
   注册链接：https://github.com/settings/applications/new
<img src="https://github.com/xjt927/filerepository/blob/master/SMRVW%5DJ8IXU%60AR%60%7DXR@L6%25W.png?raw=true" width="500">

## 参数说明：
- Application name： # 应用名称，随意
- Homepage URL： # 网站URL，如https://xjt927.github.io
- Application description # 描述，随意
- Authorization callback URL：# 网站URL，https://xjt927.github.io

## **注意：**
> 如果你的`Github Pages`已经绑定了域名，这两个参数`Homepage URL`、`Authorization callback URL`需要写你自己的域名。

我的就是绑定域名的，注册结果如下：
<img src="https://github.com/xjt927/filerepository/blob/master/%7B%5BR8LMB%6028%25@90IVJBHEPMN.png?raw=true" width="500">

注册成功后会得到`Client ID`、`Client Secret` 两个参数。
<img src="https://github.com/xjt927/filerepository/blob/master/%256HKBTCK%7DD%7B%5BS%7BBBL~G%2570L.png?raw=true" width="500">

## gitalk.swig
新建/layout/_third-party/comments/gitalk.swig文件，并添加内容：
```
{% if page.comments && theme.gitalk.enable %}
  <link rel="stylesheet" href="https://unpkg.com/gitalk/dist/gitalk.css">
  <script src="https://unpkg.com/gitalk/dist/gitalk.min.js"></script>
   <script type="text/javascript">
        var gitalk = new Gitalk({
          clientID: '{{ theme.gitalk.ClientID }}',
          clientSecret: '{{ theme.gitalk.ClientSecret }}',
          repo: '{{ theme.gitalk.repo }}',
          owner: '{{ theme.gitalk.githubID }}',
          admin: ['{{ theme.gitalk.adminUser }}'],
          id: location.pathname,
          distractionFreeMode: '{{ theme.gitalk.distractionFreeMode }}'
        })
        gitalk.render('gitalk-container')           
       </script>
{% endif %}
```
## comments.swig
修改/layout/_partials/comments.swig，文件最下面找到
```
  {% elseif theme.valine.appid and theme.valine.appkey %}
    <div class="comments" id="comments">
    </div>
  {% endif %}
```

在`</div>`标签上添加内容如下：
```
{% elseif theme.gitalk.enable %}
 <div id="gitalk-container"></div>
```
最后结果是这样滴：
```
  {% elseif theme.valine.appid and theme.valine.appkey %}
    <div class="comments" id="comments">
    </div>
	
  	{% elseif theme.gitalk.enable %}
	<div id="gitalk-container"></div>
  {% endif %}
```

## index.swig
修改layout/_third-party/comments/index.swig，在最后一行添加内容：
```
{% include 'gitalk.swig' %}
```
## gitalk.styl
新建/source/css/_common/components/third-party/gitalk.styl文件，添加内容：
```
.gt-header a, .gt-comments a, .gt-popup a
  border-bottom: none;
.gt-container .gt-popup .gt-action.is--active:before
  top: 0.7em;
```
## third-party.styl
修改/source/css/_common/components/third-party/third-party.styl，在最后一行上添加内容，引入样式：
```
@import "gitalk";
```
## _config.yml
在主题配置文件next/_config.yml中添加如下内容：
```
gitalk:
  enable: true
  githubID: 你的Github账号  # 例：xjt927   
  repo: 你的Github Pages项目名称   # 例：xjt927.github.io
  ClientID: 你的ClientID
  ClientSecret: 你的ClientSecret
  adminUser: 你的Github账号 #指定可初始化评论账户
  perPage: 15 #每页多少个评论
  pagerDirection: last  #排序方式是从旧到新（first）还是从新到旧（last）
  createIssueManually: true #如果当前页面没有相应的 isssue ，且登录的用户属于 admin，则会自动创建 issue。如果设置为 true，则显示一个初始化页面，创建 issue 需要点击 init 按钮。
  distractionFreeMode: true #是否启用快捷键(cmd|ctrl + enter) 提交评论.
```
到此已经配置完成了，使用`hexo clean`、`hexo g`、`hexo s`， 本地查看文章下面是否有github相关内容。

# 其他
1. 每篇文章都需要github登录授权一下，才能在`issues`下生成评论，如果浏览器记住密码的话，只需要点开文章就可以。
2. [hexo next 主题配置 gitalk 评论后无法初始化创建 issue][4]
3. [报错出现 Error: Validation Failed.][5] 
4. [关于Gitalk其他问题][6]


  [1]: https://github.com/gitalk/gitalk
  [2]: https://github.com/gitalk/gitalk/blob/master/readme-cn.md
  [3]: https://gitalk.github.io/
  [4]: https://github.com/gitalk/gitalk/issues/115
  [5]: https://github.com/gitalk/gitalk/issues/102
  [6]: https://github.com/gitalk/gitalk/issues