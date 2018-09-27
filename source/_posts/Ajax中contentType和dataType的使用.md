---
title: Ajax中contentType和dataType的使用
tags:
  - jQuery
  - ajax
categories: jQuery
keywords: 'jQuery,ajax'
abbrlink: 19ed10ec
date: 2018-09-27 10:30:38
---

```
getUserType:function(){
    $.ajax({
        url: getUserTypeUrl + '?now=' + Math.random(),
        data: {"userId":userId},
        type: "get",
        async:false,
        dataType: "text",
		contentType:'application/json; charset=utf-8',
        success: function(result) {
            userType = result;
            if (userType == UserTypeEnum.Other)
            {
                alert('没有数据权限，退出页面');
                return;
            }
            else if (userType == UserTypeEnum.Customer){
               page.logic.getCustomerId();
            }else {
                page.logic.initCustormer();
            }
        },
        error: function(result) {
            var errorResult = $.parseJSON(result.responseText);
            layer.msg(errorResult.collection.error.message);
        }
    })
}
```

其中：
- `cache`
 类型：Boolean
 默认值: true，dataType 为 script 和 jsonp 时默认为 false。设置为 false 将不缓存此页面。
 
- `async`
 类型：Boolean
 默认值: true。默认设置下，所有请求均为异步请求。如果需要发送同步请求，请将此选项设置为 false。
 
- `data`
 类型：String
 往后台发送请求带的参数,类型如下
 `data: {"key1":value,"key2":value2}//key,value形式传参`
 `data: JSON.stringify(idsArray)//转换成字符串传参`

- `dataType`
 类型：String
 决定请求返回的数据类型;支持json,XML,html,jsonp,script,text
 
- `contentType`
 类型：String
 发送信息至服务器时内容编码类型
 默认值: `"application/x-www-form-urlencoded"`
`contentType:'text/plain;charset=UTF-8'`
`contentType:'application/json; charset=utf-8'`

