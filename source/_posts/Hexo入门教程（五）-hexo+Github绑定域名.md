---
title: Hexo入门教程（五）-hexo+Github绑定域名
tags: Hexo
categories: Hexo
abbrlink: 431f0136
keywords: Hexo,搭建,部署,Github,博客,域名
date: 2018-04-18 15:55:18
---

首先要有自己的域名，没有域名的可以去[阿里云（万网）][1]、[godaddy][2]上买，我在阿里云买的，也用阿里云的服务器。

## 一、Github、hexo配置
1. 在github中找到自己的博客仓库，点击“Create new file”新建文件“CNAME”，注意文件名一定要大写，里面只写一行自己域名，域名前不要加http、www。
<img src="https://github.com/xjt927/filerepository/blob/master/0~%60JL6F%606J067_5BUPTJMO1.png?raw=true" width="700"  /> 

2. 在本地hexo->source文件夹下，新建文本文件“CNAME”，同样名称大写，里面只加一行自己的域名，规则同上，域名前不要加http、www。
这样做是因为，当使用`hexo d`推送到github上的时候会自动将github上的“CNAME”文件覆盖、删除掉，导致域名解析失败。
<!-- more -->
## 二、域名解析配置
1. 首先在cmd下ping一下你的github pages，比如我的github地址：
`ping xjt927.github.io`，得到地址为`151.101.229.147`。
2. 登录阿里云找到“云解析DNS”，找到自己的域名点击后面的“解析设置”，首次进入会默认配置，如果没有特殊用处可以全部删除。点击右上角“添加解析”，添加两条记录如下：
 <img src="https://github.com/xjt927/filerepository/blob/master/%7B@($F$%7DDU2TXV7HT%25O(9%5B)U.png?raw=true" width="700"  /> 

3. 等几分钟尝试打开自己的域名，自动跳转到github pages页面，到这里就成功了。


[1]: https://wanwang.aliyun.com/domain/?spm=5176.200001.n2.14.nkOQu9
[2]: https://www.godaddy.com/
