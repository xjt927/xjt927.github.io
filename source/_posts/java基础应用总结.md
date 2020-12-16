---
title: java基础应用总结
date: 2020-12-09 09:36:28
tags:
categories:
keywords:
---



使用lombok简化代码

```
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
class MemberBase{
	...
}

		//使用builder功能
        MemberBase memberBase = MemberBase.builder()
                .id(entity.getId())
                .cardNo(entity.getCardNo())
                .point(entity.getPoint().add(cardPointRecordDto.getPointValue()))
                .build();
```



使用lambda表达式

**串行流 Stream**：适合存在线程安全问题、阻塞任务、重量级任务，以及需要使用同一事务的逻辑。

**并行流parallelStream**：适合没有线程安全问题、较单纯的数据处理任务。



使用Date对象计算时间区间now.after() 、now.before()

```
Date now = new DateTime();
List<CardPointRule> filterCardPointRule = cardPointRules.parallelStream()
        .filter(cpr -> now.after(cpr.getBeginDate()) && now.before(cpr.getEndDate()))
        .collect(Collectors.toList());
```



快捷对象赋值

```
CardPointRecord cardPointRecord = new CardPointRecord();
CardPointRecordDto cardPointRecordDto = cardDto;

BeanUtil.copyProperties(cardPointRecordDto, cardPointRecord);
```



使用hutool组件计算时间推移

```
DateUtil.offset(now, DateField.YEAR, offset);

	//代码实现
    public static DateTime offset(Date date, DateField dateField, int offset) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(dateField.getValue(), offset);
        return new DateTime(cal.getTime());
    }
```

