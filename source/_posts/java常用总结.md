---
title: java常用总结
abbrlink: 4bd00030
date: 2018-12-06 17:41:13
tags:
categories:
keywords:
---

获取配置文件参数
```
AppPropertiesReader.getValue("aaa.aaa_address_base")
```

json转对象

方法一：使用ObjectMapper
```
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

String pointPackJson = "json字符串";
ObjectMapper mapper =new ObjectMapper();
mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
mapper.setDateFormat(df);

if (StringUtils.isNotEmpty(pointPackJson)) {
	//json字符串转集合
    list = mapper.readValue(pointPackJson, new TypeReference<List<InventReseEntity>>() {});
	
	//json字符串转实体对象
	InventReseEntity entity = mapper.readValue(inventAllocStr, InventReseEntity.class);
}
```

方法二：使用JSONArray 
```
String pointPackJson = "json字符串";
JSONArray jsonArray=JSONArray.fromObject(pointPackJson);
for (int i=0;i<jsonArray.size();i++){
    Object o=jsonArray.get(i);
    JSONObject jsonObject=JSONObject.fromObject(o);
    InventReseEntity entity = (InventReseEntity)JSONObject.toBean(jsonObject, InventReseEntity.class);
}
```

double转String, 去掉0结尾的小数位
```
DecimalFormat decimalFormat = new DecimalFormat("###################.###########");  
System.out.println(decimalFormat.format(number));  
```
