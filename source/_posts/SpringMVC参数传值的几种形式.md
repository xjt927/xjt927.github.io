---
title: SpringMVC参数传值的几种形式
tags: Spring
categories: Spring
keywords: 'Spring,传值'
abbrlink: a8c3306f
date: 2018-09-29 08:47:41
---

## 方式一:HttpServletRequest
HttpServletRequest类是Servlet中的类型，代表了一个Servlet请求。无论Post还是Get请求，都能通过这种方式获取到, 但不能接收json。 
post方式的时候编码方式需设置为：`x-www-form-urlencoded`转换为键值对
```
    //http://localhost:8088/user?username=123&password=123456
    @RequestMapping("/user")
    public void getUser(HttpServletRequest request) {
        String username=request.getParameter("username");
        String password=request.getParameter("password");
        System.out.println("username is:"+username);
        System.out.println("password is:"+password); 
    }
```
如果username 或者 password 为空，不能直接拿来做参数，可能会抛空指针异常。


## 方式二:使用@PathVariable路径变量
```
    //http://localhost:8088/user1/userName=zhangsan/password=123456
    @ResponseBody
    @RequestMapping(value="/user1/{userName}/{password}",method= RequestMethod.GET)
    public void getUser(@PathVariable String userName,@PathVariable String password){
        System.out.println("username is:"+userName);
        System.out.println("password is:"+password);
    }
```
<!-- more -->

## 方式三:参数名匹配的方式
```
    @ResponseBody
    @RequestMapping(value="/user2",method= RequestMethod.GET)
    public void getUser2(String userName,String password){
        System.out.println("username is:"+userName);
        System.out.println("password is:"+password);
    }
```

## 方式四:@RequestParam方式
```
    //MultiValueMap接收多个参数
    @ResponseBody
    @RequestMapping(value="/user3",method= RequestMethod.GET)
    public void getUser3(@RequestParam String userName,
                         @RequestParam(defaultValue = "000") String password,
                         @RequestParam Long[] ids,
                         @RequestParam(value="ages[]", required = false) Long[] ages,
                         @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date,
                         @RequestParam MultiValueMap params){
        System.out.println("username is:"+userName);
        System.out.println("password is:"+password);
        System.out.println("ids is:"+ids!=null?Arrays.asList(ids):"");
        System.out.println("ages is:"+ages!=null?Arrays.asList(ages):"");
        System.out.println("date is:"+date);

        System.out.println(params.toSingleValueMap());
        System.out.println(params.getFirst("userName"));
        System.out.println(params.getFirst("password"));
        System.out.println(params.getFirst("ids"));
        System.out.println(params.getFirst("ages"));
        System.out.println(params.getFirst("date"));
    }
```

## 方式五:@ModelAttribute方式
`@ModelAttribute`属性名称可写可不写,不写也能接收到参数.
```
    //POST参数值自动绑定到model中
    @ResponseBody
    @RequestMapping(value="/user4",method= RequestMethod.GET)
    public void getUser4(@ModelAttribute User user){
        System.out.println("Name:" +user.getName());
        System.out.println("Age:" +user.getAge());
    }

    public class User {
        private String name;
        private int age;
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public int getAge() {
            return age;
        }
        public void setAge(int age) {
            this.age = age;
        }
    }
```

## 方式六：@RequestBody方式
GetMapping 不支持@RequestBody 

后端代码
```
    @PostMapping(value = "arrayPost")
    public String arrayPost(@RequestBody Long[] inventreseIds) throws Exception{
        if(inventreseIds==null||inventreseIds.length==0)
            return "";
        return inventReseService.arrayPost(inventreseIds);
    }
```

前端代码
```
    $.ajax({
        url: validationReseStatusUrl,
        data: JSON.stringify(inventreseIds),
        type: "POST",
        dataType: "text",
        contentType: "application/json;charset=utf-8",
        success: function(result) {
            if (result=="") {
                layer.msg("没有预约中的数据无法填写预约单！");
                return;
            }
            page.logic.detail(title, result, pageMode, 2);
        },
        error: function(result) {
            var errorResult = $.parseJSON(result.responseText);
            layer.msg(errorResult.collection.error.message);
        }
    });
```
