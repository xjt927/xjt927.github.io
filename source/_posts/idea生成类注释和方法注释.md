---
title: idea生成类注释和方法注释
abbrlink: 54ef10dc
date: 2020-01-08 17:01:54
tags:
categories:
keywords:
---

groovyScript("def result=''; def params=\"${_1}\".replaceAll('[\\\\[|\\\\]|\\\\s]', '').split(',').toList(); for(i = 0; i < params.size(); i++) {if(params[i] == '') return result;if(i==0) result += '\\n'; result+='  * @param ' + params[i] +': '+ ((i < params.size() - 1) ? '\\n' : '')}; return result", methodParameters())