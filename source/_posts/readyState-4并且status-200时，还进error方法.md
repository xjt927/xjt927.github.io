---
title: readyState=4并且status=200时，还进error方法
tags:
  - jQuery
  - ajax
categories: jQuery
keywords: 'jQuery,ajax'
abbrlink: 59b10f7f
date: 2018-09-27 10:14:00
---
在使用jQuery.ajax方法去调用后台方法时，ajax中得参数data类型是"JSON",后台DEBUG调试，运行正常，返回正常的结果集.
但是前端一直都进到ajax的error方法，百思不得其解，后要一探究竟，在error方法的参数中加了data后，发现data中的readyState = 4 并且 status=200，这两个状态也证明ajax访问没有问题，没有出现异常。
回过头发现我在后台返回的是字符串，但并不是标准的json格式的字符串，所以前端js进入不了success。无法解析为json格式的数据，所以报错进error。
**通过后台将结果集转成json格式字符串即可。或者将data类型改为“text”.**

如果不设置dataType默认使用json格式,如果后台返回text字符串,则报错,进入error

```
getSysUserId:function(){
    $.ajax({
        url: getSysUserIdUrl + '?now=' + Math.random(),
        type: "get",
        async:false,
        dataType: "text", //如果不设置dataType默认使用json格式,如果后台返回text字符串,则报错,进入error
        success: function(result) {
            userId = result;
           if(userId == null){
               userId = 'admin';
           }
           page.logic.getUserType();
        },
        error: function(result) {
            var errorResult = $.parseJSON(result.responseText);
            layer.msg(errorResult.collection.error.message);

        }
    });
}
```