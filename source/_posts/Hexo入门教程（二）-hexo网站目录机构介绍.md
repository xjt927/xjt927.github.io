---
title: Hexo入门教程（二）-hexo网站目录机构介绍
tags: hexo
categories: hexo
abbrlink: c0129f56
keywords: hexo,搭建,部署,Github,博客,hexo教程
date: 2018-04-18 15:52:18
---

继上一篇介绍hexo如何搭建，来了解一下hexo网站的目录结构。
.
├── _config.yml
├── package.json
├── scaffolds
├── source
|   ├── _drafts
|   └── _posts
└── themes

**_config.yml**
网站的 [配置][1] 信息，您可以在此配置大部分的参数。
<!-- more -->
**package.json**
应用程序的信息。

**scaffolds**
[模版][2] 文件夹。当您新建文章时，Hexo 会根据 scaffold 来建立文件。

Hexo的模板是指在新建的markdown文件中默认填充的内容。例如，如果您修改scaffold/post.md中的Front-matter内容，那么每次新建一篇文章时都会包含这个修改。

**source**
资源文件夹是存放用户资源的地方。除 _posts 文件夹之外，开头命名为 _ (下划线)的文件 / 文件夹和隐藏的文件将会被忽略。Markdown 和 HTML 文件会被解析并放到 public 文件夹，而其他文件会被拷贝过去。

**themes**
[主题][3] 文件夹。Hexo 会根据主题来生成静态页面。

**public**
使用 `hexo g` 命令生成的静态页面文件。

  [1]: https://hexo.io/zh-cn/docs/configuration.html
  [2]: https://hexo.io/zh-cn/docs/writing.html
  [3]: https://hexo.io/zh-cn/docs/themes.html
