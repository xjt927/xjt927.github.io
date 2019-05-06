---
title: 使用selenium模拟登录
abbrlink: '10477358'
date: 2019-03-19 14:24:55
tags:
categories:
keywords:
---
# Selenium （浏览器自动化测试框架）
Selenium 是一个用于Web应用程序测试的工具。Selenium测试直接运行在浏览器中，就像真正的用户在操作一样。支持的浏览器包括IE（7, 8, 9, 10, 11），Mozilla Firefox，Safari，Google Chrome，Opera等。这个工具的主要功能包括：测试与浏览器的兼容性——测试你的应用程序看是否能够很好得工作在不同浏览器和操作系统之上。测试系统功能——创建回归测试检验软件功能和用户需求。支持自动录制动作和自动生成 .Net、Java、Perl等不同语言的测试脚本。

下面重点介绍基于chromedriver实现的一些功能。

//输入账号
driver.findElement(By.name("username")).clear();
driver.findElement(By.name("username")).sendKeys(username);

//输入密码
Actions actions = new Actions(driver);
actions.moveToElement(driver.findElement(By.id("pass")));
actions.click();
actions.sendKeys(Keys.CONTROL, "a").keyUp(Keys.CONTROL).perform();
actions.sendKeys(Keys.DELETE).perform();
actions.click();
actions.sendKeys(passwd);
actions.build().perform();

//点击登录
driver.findElement(By.id("btnLogin")).click();

					
//执行屏幕截取
File srcFile = ((TakesScreenshot)driver).getScreenshotAs(OutputType.FILE);  
//利用FileUtils工具类的copyFile()方法保存getScreenshotAs()返回的文件;"屏幕截图"即时保存截图的文件夹
org.apache.commons.io. FileUtils.copyFile(srcFile, new File( "D:/aaa/a.png")); 



完整代码如下：
```
    /**
     * 驱动浏览器登录
     *
     * @param username
     * @param passwd
     * @return
     */
    public void loginBySelenium(String username, String passwd) {
        String pageSource = "";
        try {
            logger.info("开始初始化浏览器");
            DriverConfig config = new DriverConfig();
            config.setLoadTimeout(300);
            config.setLoadJsTimeout(300);

            if (OSinfo.isWindows()) {
                logger.info("识别是windows");
                config.setPath(chrome_windows_path).setDriverName(DriverConfig.CHROME);
            } else {
                logger.info("识别是linux");
                config.setPath(phantomjs_linux_path).setDriverName(DriverConfig.CHROME);
            }

            //设置不打开浏览器加载内容
            config.getOptionsMaps().put("--no-sandbox", null);
            config.getOptionsMaps().put("--disable-dev-shm-usage", null);
            config.getOptionsMaps().put("--disable-gpu", null);
            config.getOptionsMaps().put("--headless", null);
            config.getOptionsMaps().put("blink-settings=imagesEnabled=false", null);

            factory = DriverFactory.create(config);
            //设置浏览器头
            factory.executeJs("Object.defineProperty(navigator,'webdriver',{get:function(){return false;}});");
            factory.executeJs("Object.defineProperty(navigator,'$cdc_asdjflasutopfhvcZLmcfl_',{get:function(){return false;}});");

            WebDriver driver = factory.getWebDriver();
            driver.get("https://www.baidu.com");
            driver.switchTo().frame("frameLogin");

            Set<Cookie> cookies = driver.manage().getCookies();
            StringBuilder cookieSb = new StringBuilder();
            for (Cookie cookie : cookies) {
                cookieSb.append(cookie.getName()).append("=").append(cookie.getValue()).append(";");
            }

            es.setCookieString(cookieSb.toString().substring(0, cookieSb.length() - 1));

            int item = 0;
            while (item <= 4 && StringUtils.isEmpty(pageSource)) {
                pageSource = driver.getPageSource();
                map = new HashMap<>();
                logger.info("使用chrome第{}次获取网页内容", ++item);

                if (StringUtils.isNotEmpty(pageSource)) {
                    Document doc = Jsoup.parse(pageSource);
                    String loginVal = doc.getElementById("__loginVal").val();

                    String vCode = getVCode(loginVal);

                    factory.findElement(By.name("txtLoginID")).clear();
                    factory.findElement(By.name("txtLoginID")).sendKeys(username);

                    Actions actions = new Actions(driver);
                    actions.moveToElement(factory.findElement(By.id("pass")));
                    actions.click();
                    actions.sendKeys(Keys.CONTROL, "a").keyUp(Keys.CONTROL).perform();
                    actions.sendKeys(Keys.DELETE).perform();
                    actions.click();
                    actions.sendKeys(passwd);
                    actions.build().perform();

                    factory.findElement(By.id("txtValCode")).clear();
                    factory.findElement(By.id("txtValCode")).sendKeys(vCode);
                    factory.findElement(By.id("btnLogin")).click();
                    try {
                        pageSource = driver.getPageSource();
                    } catch (UnhandledAlertException ex) {
                        try {
                            Alert alert = driver.switchTo().alert();
                            String alertText = alert.getText();
                            logger.info("警报数据：{}", alertText);
                            alert.accept();
                            pageSource = "";
                            continue;
                        } catch (NoAlertPresentException e) {
                            logger.error("驱动浏览器异常", e);
                        }
                    }
                    if (StringUtils.isEmpty(pageSource) || pageSource.contains("value=\"登入\"") || pageSource.contains("value=\"LOGIN\"")) {
                        pageSource = "";
                        continue;
                    }
					//打开iframe页面
                    driver.navigate().to("https://www.baidu.com");

                    cookies = driver.manage().getCookies();
                    cookieSb = new StringBuilder();
                    for (Cookie cookie : cookies) {
                        cookieSb.append(cookie.getName()).append("=").append(cookie.getValue()).append(";");
                    }

                    es.setCookieString(cookieSb.toString().substring(0, cookieSb.length() - 1)); 

                    logger.info("页面执行完成");
                } else {
                    logger.info("初始化页面内容为空，获取不到登录秘钥！");
                    pageSource = "";
                    continue;
                }
            }
        } catch (Exception e) {
            logger.error("使用chromedriver加载页面出现问题，可能请求超时", e);
        } finally {
            closeBrowser();
        }
    }
```	
 