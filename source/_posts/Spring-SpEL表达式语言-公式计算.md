---
title: Spring-SpEL表达式语言-公式计算
date: 2018-09-20 19:51:06
tags: [Spring,SpEL]
categories: Spring
keywords: Spring,SpEL,表达式
---

业务需求,计算财务月报报表,如下:

![mark](http://blog.xuejiangtao.com/blog/180924/K98ml852AA.png)

将公式写到xml文件中,程序读取到文件内容,将内容使用spel表达式公式计算出来,公式本身也是给list集合赋值的操作.

下面是公式部分:
```

        //创建解析器
        ExpressionParser parser = new SpelExpressionParser();
        //创建上下文环境
        StandardEvaluationContext context = new StandardEvaluationContext();
        //将list集合赋值给context
        context.setVariable("list", list);

        //读取xml文件
        DocumentBuilderFactory a = DocumentBuilderFactory.newInstance();
        DocumentBuilder b = a.newDocumentBuilder();
        Resource resource = new ClassPathResource("financeMonRep_Formula.xml");
        InputStream inputStream = resource.getInputStream();
        Document document = b.parse(inputStream);

        NodeList nodeList = document.getElementsByTagName("item");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Element element = (Element) nodeList.item(i);
            //读取公式
            String formula = element.getAttribute("value");
            //计算公式
            Expression exp = parser.parseExpression(formula);
        }

```
下面是xml文件内容:

![mark](http://blog.xuejiangtao.com/blog/180924/AcDC4Ed7Hk.png)


