---
title: java命令打jar包
date: 2021-06-22 14:29:02
tags:
categories:
keyword
---



# java文件

```
import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.nio.charset.Charset;

/**
 * @Auther: xuejiangtao
 * @Date: 2021-05-22 19:48
 * @Description:
 */
public class test {
    public static void main(String[] args) {
        String s = doGet("http://hq.sinajs.cn/list=s_sz399001");
        System.out.println(s);
    }

    public static String doGet(String url) {
        CloseableHttpClient httpClient = null;
        CloseableHttpResponse response = null;
        String result = "";

        try {
            httpClient = HttpClients.createDefault();

            HttpGet httpGet = new HttpGet(url);

            httpGet.setHeader("Authorization", "Bearer da3efcbf-0845-4fe3-8aba-ee040be542c0");

            RequestConfig requestConfig = RequestConfig.custom().setConnectTimeout(35000).setConnectionRequestTimeout(35000).setSocketTimeout(60000).build();

            httpGet.setConfig(requestConfig);

            response = httpClient.execute(httpGet);

            HttpEntity entity = response.getEntity();
            result = EntityUtils.toString(entity);
            String charset = null;
            Header contentType= response.getEntity().getContentType();
            if (contentType != null) {
                final HeaderElement values[] = entity.getContentType().getElements();
                if (values.length > 0) {
                    final NameValuePair param = values[0].getParameterByName("charset");
                    if (param != null) {
                        charset = param.getValue();
                    }
                }
            }
            if (charset == null) {
                charset = "UTF-8";
            }
            //获取Charset ，并判断，如果不是utf-8就转换成utf-8
            if (charset.toLowerCase() == "utf-8"){

            }else{
                if (result != null) {
                    //用旧的字符编码解码字符串。解码可能会出现异常。
//                    byte[] bs = result.getBytes(charset);
                    byte[] bs = result.getBytes(Charset.forName("UTF-8"));
                    //用新的字符编码生成字符串
                    result= new String(bs, "UTF-8");
                }
            }

        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (null != response) {
                try {
                    response.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (null != httpClient) {
                try {
                    httpClient.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return result;
    }
}

```

# 编译

```
javac -cp .:rt.jar:httpclient-4.5.3.jar:httpcore-4.4.6.jar:httpmime-4.5.jar:spring-jcl-5.2.5.RELEASE.jar test.java
```

编译时将java类引用的包放到java类文件同级目录下



# 执行

```
java -cp .:rt.jar:httpclient-4.5.3.jar:httpcore-4.4.6.jar:httpmime-4.5.jar:spring-jcl-5.2.5.RELEASE.jar test
```





![mark](http://blog.xuejiangtao.com/blog/20210622/HjCmE1icW76D.png?imageslim)
