---
title: java lambda表达式常用操作
abbrlink: 5d86d660
date: 2019-02-14 14:15:06
tags:
categories:
keywords:
---
# 使用lambda表达式查找集合内属性最大值的对象
	Optional<FillRec > fillRecOp = fillRecList.stream().max(Comparator.comparing(FillRec::getScanTime));
	FillRec fillRec = fillRecOp.get();