---
title: java Collection集合删除某一元素方法汇总
date: 2018-09-24 19:55:13
tags: Java
categories: Java
keywords: Java
---

无论在自己写程序玩还是实际项目应用中，操作java.util.Collection结合都是最常用的，而且也是最重要的知识点。从集合中删除某一元素同样是很常用的操作。对了，面试中也总考察，面试官说要考察你的实际编程的能力，谁知道呢。下面总结了从集合中删除某一元素的几种方法


```
package test;
 
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.function.Predicate;
 
public class T {
 
	public static void main(String[] args) {
		//对于list添加数据，也有几种方法，性能不同，有兴趣可以自己详细了解
		List<Integer> list = new ArrayList<>(Arrays.asList(1,2,3,4,5));
		
		//List<Integer> list = new ArrayList<>();
		//Collections.addAll(list,1,2,3,4,5);
	 
		remove(list, 3);
		print(list);
	}
	
	public static void print(List<Integer> list) {
		/*for (Integer i : list) {
			System.out.println(i);
		}*/
		
		/**
		 * 利用java8新特性打印集合信息
		 */
		list.stream().forEach(System.out::println);
	}
	
	/**
	 * 删除集合某一元素的方法汇总
	 * @param list
	 * @param toRemoveValue
	 * @return
	 */
	public static List<Integer> remove(List<Integer> list, int toRemoveValue) {
		/**
		 * 方法1，利用java.util.Iterator删除某一个元素
		 */
		for (Iterator<Integer> iterator=list.iterator();iterator.hasNext();) {
			int value = iterator.next();
			if(value == toRemoveValue) {
				iterator.remove();
			}
		}
		
		Iterator<String> iter = list.iterator();  
          while (iter.hasNext()) {  
             String s = iter.next();  
             if (s.equals(toRemoveValue)) {  
                   iter.remove();  
                }  
           }
 
		//----------------------------------------------------------------------------
		/**
		 * 方法2，利用操作集合索引删除某一个元素
		 */
		for (int i = 0; i < list.size(); i++) {
			int value = list.get(i);
			if(value == toRemoveValue) {
				list.remove(i);
				i--;
			}
		}
		
		//----------------------------------------------------------------------------
		/**
		 * 方法3，利用反向遍历集合删除某一个元素
		 */
		for (int i = list.size() - 1;i > 0; i--) {
			int value = list.get(i);
			if(value == toRemoveValue) {
				list.remove(i);
			}
		}
		
		//----------------------------------------------------------------------------
		/**
		 * 方法4，利用增加一个新集合删除某一个元素
		 */
		List<Integer> toRemoveList = new ArrayList<>();
		for (int i = 0; i < list.size(); i++) {
			int value = list.get(i);
			if(value == toRemoveValue) {
				toRemoveList.add(value);
			}
		}
		
		list.removeAll(toRemoveList);
		
		//----------------------------------------------------------------------------
		/**
		 * 方法5，利用break取巧删除某一个元素，实际应用不常用
		 */
		for (int i = 0; i < list.size(); i++) {
			int value = list.get(i);
			if(value == toRemoveValue) {
				list.remove(i);
				break;
			}
		}
		
		//----------------------------------------------------------------------------
		/**
		 * 方法6，利用java8新特性删除某一个元素
		 */
		list.removeIf(value -> value==toRemoveValue);
		
		//----------------------------------------------------------------------------
		/**
		 * 方法7，利用java8新特性的forEach()方法删除某一个元素,其实不是删除，是过滤
		 */
		list.stream().filter(value -> value!=toRemoveValue).forEach(System.out::println);
		
		//----------------------------------------------------------------------------
		/**
		 * 方法8，利用java8新特性的forEach()方法删除某一个元素,其实不是删除，是过滤，等同上一种写法
		 */
		list.stream().forEach(value -> { if(value!=toRemoveValue) System.out.println(value);});
		
		
		return list;
	}
 
}

```

