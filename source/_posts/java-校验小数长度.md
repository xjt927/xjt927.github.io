---
title: java 校验小数长度
date: 2018-10-19 09:11:32
tags:
categories:
keywords:
---

````
    if (entity.getGoodsNum() != null){
        BigDecimal b = new BigDecimal(entity.getGoodsNum());
        String goodsNum = b.toPlainString();//String.valueOf(entity.getGoodsNum());
        if (goodsNum.indexOf('.') != -1){
            if (goodsNum.length()>21){
                throw new Exception("数值型，最大长度20位，保留5位小数!");
            }
        }else{
            if (goodsNum.length()>20){
                throw new Exception("数值型，最大长度20位，保留5位小数!");
            }
    
        }
        String regexp = "^((([1-9][0-9]){0,19})|([0]\\.\\d{1,5}|[1-9][0-9]*\\.\\d{1,5}))$";
        boolean result = goodsNum.matches(regexp);
        if (!result){
            throw new Exception("数值型，最大长度20位，保留5位小数!");
        }
    }else{
        throw new Exception("提货量不能为空!");
    }
````