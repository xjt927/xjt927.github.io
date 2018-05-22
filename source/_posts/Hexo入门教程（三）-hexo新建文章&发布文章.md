---
title: Hexo入门教程（三）-hexo新建文章&发布文章
tags: Hexo
categories: Hexo
abbrlink: fbe5044a
keywords: Hexo,文章,搭建,部署,Github,博客,hexo教程
date: 2018-04-18 15:53:18
---

## 新建文章
使用cmd进入hexo网站按照目录下，在命令行中输入以下命令：

`hexo new [layout] <title>`

> **[layout]** 为指定文章的布局（layout），默认为 `post`，可以通过修改 `_config.yml` 中的 `default_layout` 参数来指定默认布局。 

> **[layout]** 可以不用写，不写就是默认布局。`hexo new <title>` 

> **`<title>`** 为你要创建的文章标题。

之后在 `source/_posts` 目录下面，多了一个`<title>.md` 的文件。
<!-- more -->
## 布局（Layout）
Hexo 有三种默认布局：`post、page` 和 `draft`，它们分别对应不同的路径，而您自定义的其他布局和 `post` 相同，都将储存到 `source/_posts` 文件夹。

布局 |	路径 |
--|--|
post |	source/_posts|
page |	source
draft |  source/_drafts

## 创建草稿
草稿文件的创建命令如下：

`hexo new draft <title>`

创建的文件会被保存到`source/_drafts`文件夹，如果有文章没写完或不想发布的，可以放到`drafts`文件夹下。

## 预览草稿
草稿默认不会显示在页面中，有两种方式可以预览草稿。

 1.  在执行 `hexo g` 命令时加上 `--draft` 参数。

`hexo s --draft`

 2.  在 `_config.yml` 文件中把 `render_drafts` 参数设为 `true` 。

`render_drafts: true`

## 草稿文章 转 发布文章
使用 `publish` 命令将草稿移动到 `source/_posts` 文件夹，该命令的使用方式与 new 十分类似，您也可在命令中指定 `layout` 来指定布局，草稿发布后`_drafts`目录下的草稿会同时删除。

 `hexo publish [layout] <title>`
 
 Hexo没有提供将草稿全部发布到`_post`目录，可以使用`hexo publish .`来发布，不过偶尔报错。

## 模版（Scaffold）
在新建文章时，Hexo 会根据 `scaffolds` 文件夹内相对应的文件来建立文件，例如：

 `hexo new photo "My Gallery"`
 
在执行这行指令时，Hexo 会尝试在 `scaffolds` 文件夹中寻找 `photo.md`，并根据其内容建立文章，以下是您可以在模版中使用的变量：

变量 | 描述
--|--|
layout | 布局
title | 标题
date | 文件建立日期
