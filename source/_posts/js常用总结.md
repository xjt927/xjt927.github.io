---
title: js常用总结
abbrlink: d8fb25d2
date: 2018-10-16 11:28:57
tags:
categories:
keywords:
---

# setTimeout()定时器

定义和用法
setTimeout() 方法用于在指定的毫秒数后调用函数或计算表达式。
```
setTimeout(code,millisec);
setTimeout(function(){ page.logic.initTable()}, 100);
```

参数：
code：必需。要调用的函数后要执行的 JavaScript 代码串。
millisec：必需。在执行代码前需等待的毫秒数。

**提示和注释**
**提示：setTimeout() 只执行 code 一次。如果要多次调用，请使用 setInterval() 或者让 code 自身再次调用 setTimeout()。**

停止setTimeout()
```
t=setTimeout("timedCount()",1000);
clearTimeout(t);
```

# setInterval()倒计时

```
if (data && data.length > 0) {
	//在启动倒计时前先清除倒计时
    cutTime(null, null, true);
    for (var i = 0; i < data.length; i++) {
        var inventreseId = data[i].inventreseId;
        var countDownTime = data[i].countDownTime;
		//启动倒计时
        cutTime(countDownTime, inventreseId, false);
        var html = '<div class="cont-box bg-color" id="div' + inventreseId + '"><div style="height:30px; line-height:30px;padding: 0 25px;"><span class="" style="float:left;"><input type="hidden" value="' + inventreseId + '"/>' + data[i].customerName + '</span><span class="" style="float:right" id="reseStatusShow">' + data[i].reseStatusShow + '</span></div>' +
            '<div style="height:30px; line-height:30px;padding: 0 25px;"><span style="width:33%;float:left; text-align:left;" title="' + data[i].productName + '">' + data[i].productName + '</span><span style="width:33%;float:left; text-align:center;" title="' + data[i].productGradeName + '">' + data[i].productGradeName + '</span><span style="width:33%;float:left; text-align:right;">' + data[i].reseQty + '<i>' + data[i].measUnitName + '</i></span></div>' +
            '<div id="time" style="height:24px; line-height:24px; text-align:center;background:#ce0c0c;color:#fff;"><span id=\'' + inventreseId + '\'></span></div></div>';
        $('#makeModal').append(html);
    }
}
```

```
//使用setInterval方法，实现倒计时
function cutTime(countDownTime, container, isClean) {
        var timer = setInterval(function() {
            if (isClean) {
				//为避免倒计时重复，先清除倒计时
                clearInterval(timer);
                return;
            }
            if (countDownTime >= 0) {
                IOL.util.ShowCountDown(countDownTime, container);
                countDownTime--;
            } else {
				//倒计时为0秒时，清除倒计时
                clearInterval(timer);
                $("#div" + container + " #time").css({ "background": "#ccc" });
                $("#div" + container + " #reseStatusShow").text('已失效');
                return;
            }
        }, 1000);
    }
```

```
/**
 * 计算倒计时公共方法
 *
 * @author jiangtao.xue 2018-10-10
 * @param countDownTime 秒数
 * @param idName id标签名称
 * @returns {boolean}
 */
IOL.util.ShowCountDown=function(countDownTime,idName) {
    var leftsecond = countDownTime;
    var day1=Math.floor(leftsecond/(60*60*24));
    var hour=Math.floor((leftsecond-day1*24*60*60)/3600);
    var minute=Math.floor((leftsecond-day1*24*60*60-hour*3600)/60);
    var second=Math.floor(leftsecond-day1*24*60*60-hour*3600-minute*60);
    if(day1 < 10){day1 = "0"+day1;}
    if(hour < 10){hour = "0"+hour;}
    if(minute < 10){minute = "0"+minute;}
    if(second < 10){second = "0"+second;}
    //var cc = document.getElementById(idName);
    //cc.innerHTML = "剩余：<em class='wxmr4'>"+day1+"</em>天<em class='wxml4'>"+hour+"</em>：<em>"+minute+"</em>：<em>"+second+"</em>";
    $("#"+idName).text(minute+":"+second);
}
```

# jquery验证
```
formValidate: function() {
    $("#AddOrEditModal").validate({
        //验证commbotree
        ignore: "",
        //失去焦点时不验证
        onfocusout: false,
        rules: {
            armyday: {
                required: true,
                rangelength: [0, 100]
            },
            startDate: {
                required: true
            },
            endDate: {
                required: true
            },
            des: {
                rangelength: [0, 1000]
            }
        },
        messages: {
            'armyday': {
                required: "不能为空！",
            }
        },
        showErrors: function(errorMap, errorList) {
            if (errorList.length > 0) {
                layer.msg(errorList[0].message);
            }
        }});
},
```

# 检查字符串或者对象是否为空
```
/**
 * 检查字符串或者对象是否为空
 *
 * isEmpty(" ") //true
 * isEmpty("") //true
 * isEmpty("\n") //true
 * isEmpty("a") //false
 * isEmpty(null) //true
 * isEmpty(undefined) //true
 * isEmpty(false) //true
 * isEmpty([]) //true
 * @param obj
 * @returns {boolean}
 */
IOL.util.isEmpty = function (obj) {
    return (!obj || $.trim(obj) === "");
};
```