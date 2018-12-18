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
```
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

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