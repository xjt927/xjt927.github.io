---
title: python日常学习总结
date: 2020-11-28 10:51:04
tags:
categories:
keywords:
---

## 三元运算符

```
 result = a if b else c
```

如果b为true则result = a，否则为c。



## if判断条件

```
//当a不为None时
if a:

//当a为None时
if a is None:

//当a为None时
if not a:

```

## dict字典

```
{'Debit': round(float(sum([t.Debit for t in lst_trans])), 2),
 'Room': round(sum([t.Debit for t in lst_trans if t.AccItemCode in [1001, 1003]]), 2),
 'Goods': round(sum([t.Debit for t in lst_trans if t.AccItemCode == 1002]), 2)}
 
//round(number, ndigits=None): 保留数值精度 
```

## for循环

```
//将指定属性for循环为一个数组
[t.Debit for t in lst_trans]
//增加判断条件
[t.Debit for t in lst_trans if t.AccItemCode in [1001, 1003]]
[t.Debit for t in lst_trans if t.AccItemCode and t.AccItemCode > 100 ]

//将循环得到的数组sum求和
sum([t.Debit for t in lst_trans])


```

## post发送数据

```

dict_data = obj2dict(obj_gres)
post_data= json.dumps(dict_data)

header = {'content-type': 'application/json;charset=UTF-8'}
req = urllib2.Request(web.config.sys.hkcrm.url + 'guestFile/addUpdate', data=post_data, headers=header)
response = urllib2.urlopen(req, timeout=30)
response_text = response.read()


def obj2dict(obj):
    """
    summary:
    将object转换成dict类型
    """
    memberlist = [m for m in dir(obj)]
    _dict = {}
    for m in memberlist:
        if m[0] != "_" and not callable(m):
            data =  '' if str(getattr(obj, m))=='None' else str(getattr(obj, m))
            _dict[m] =data
    return _dict

```

```
meb = json_to_obj(input.get('meb'))
post_data = str(obj_to_json(meb))

header = {'content-type': 'application/json;charset=UTF-8'}
req = urllib2.Request(web.config.sys.hkcrm.url + 'memberBase/addMember', data=post_data, headers=header)
response = urllib2.urlopen(req, timeout=30)
response_text = response.read()
```