---
title: java 调用 .net webservice接口
abbrlink: cd4d2bae
date: 2018-10-17 18:38:39
tags: 
categories:
keywords:
---

java项目中需要调用.net的webservice接口，以下是生成web proxy步骤。

# 使用eclipse中Web Service Client模板

1. 新建一个`java project`，或者`dynamic web project`都是可以的
2. 点击菜单栏File => New => Other =>Web Services => Web Service Client
3. 在`Service definition`选项中输入我们的wcf服务地址：http://localhost:8514/Service1.svc?wsdl，一定要注意在svc后面加上一个wsdl，这样就方便java proxy找到，然后左下角有一个“温度计”，调到`Deploy client`模式就好，然后继续点击下一步。
4. 下一步`Output folder`为生成的代码目录。
5. 点击`Finish`发现生成好了代码。

# 调用接口

```
public class Program {
    public static void main(String[] args) throws RemoteException {
        IService1Proxy proxy = new IService1Proxy();
        String result = proxy.getData(12345);
        System.out.println(result);
    }
}
```

# 调用.net webservice接口的问题

以下是webservice的web.config配置文件。
```
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <configSections>
    <sectionGroup name="spring">
      <section name="context" type="Spring.Context.Support.ContextHandler,Spring.Core" />
      <section name="objects" type="Spring.Context.Support.DefaultSectionHandler,Spring.Core" />
      <section name="parsers" type="Spring.Context.Support.NamespaceParsersSectionHandler, Spring.Core" />
    </sectionGroup>
    <sectionGroup name="common">
      <section name="logging" type="Common.Logging.ConfigurationSectionHandler, Common.Logging" />
    </sectionGroup>
  </configSections>
  <connectionStrings />
  <spring xmlns="http://www.springframework.net">
    <parsers>
      <parser type="Spring.Data.Config.DatabaseNamespaceParser, Spring.Data" />
      <parser type="Spring.Transaction.Config.TxNamespaceParser, Spring.Data" />
    </parsers>
    <context>
      <resource uri="~/Config/Base.xml" />
    </context>
    <objects xmlns="http://www.springframework.net" />
  </spring>
  <common>
    <logging>
      <factoryAdapter type="Common.Logging.Log4Net.Log4NetLoggerFactoryAdapter, Common.Logging.Log4Net1211">
        <arg key="configType" value="FILE-WATCH" />
        <arg key="configFile" value="~/Config/Log4Net.xml" />
      </factoryAdapter>
    </logging>
  </common>
  <runtime>
    <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
      <dependentAssembly>
        <assemblyIdentity name="Common.Logging" publicKeyToken="af08829b84f0328e" />
        <bindingRedirect oldVersion="2.1.1.0" newVersion="2.1.2.0" />
      </dependentAssembly>
    </assemblyBinding>
  </runtime>
  <system.web>
    <compilation targetFramework="4.5" />
    <authentication mode="Windows" />
    <httpModules>
      <add name="Spring" type="Spring.Context.Support.WebSupportModule, Spring.Web" />
      <add name="OpenSessionInView" type="Spring.Data.NHibernate.Support.OpenSessionInViewModule,Spring.Data.NHibernate33" />
    </httpModules>
    <pages controlRenderingCompatibilityVersion="3.5" clientIDMode="AutoID" />
  </system.web>
  <system.webServer>
    <validation validateIntegratedModeConfiguration="false" />
    <modules runAllManagedModulesForAllRequests="true">
      <add name="Spring" type="Spring.Context.Support.WebSupportModule, Spring.Web" />
      <add preCondition="integratedMode" name="OpenSessionInView" type="Spring.Data.NHibernate.Support.OpenSessionInViewModule,Spring.Data.NHibernate33" />
    </modules>
    <handlers>
      <add name="Spring.WebPageHandler" path="*.aspx" verb="*" type="Spring.Web.Support.PageHandlerFactory, Spring.Web" />
      <add name="Spring.WebSupportHandler" path="ContextMonitor.ashx" verb="*" type="Spring.Web.Support.ContextMonitor, Spring.Web" />
    </handlers>
        <directoryBrowse enabled="false" />
  </system.webServer>
  <system.serviceModel>
    <bindings>
      <wsHttpBinding>
        <binding name="NoneSecurity" maxBufferPoolSize="2147483647" maxReceivedMessageSize="2147483647" useDefaultWebProxy="false" closeTimeout="00:10:00" openTimeout="00:10:00" receiveTimeout="00:10:00" sendTimeout="00:30:00">
          <readerQuotas maxStringContentLength="12000000" maxArrayLength="12000000" />
          <security mode="None" />
        </binding>
        <binding name="WSHttpBinding_ITwoWayAsyncVoid" />
      </wsHttpBinding>
      <basicHttpBinding>
        <binding name="JobCreatorSoapBinding" />
      </basicHttpBinding>
    </bindings>
    <client>
      <!--向应用推送用户的功能调用的推送用户服务URL-->
      <endpoint address="http://1.1.1.1:8080/PushUserService/PublishUserService.svc" binding="wsHttpBinding" bindingConfiguration="WSHttpBinding_ITwoWayAsyncVoid" contract="PushUserService.WcfService_PushUser" name="WSHttpBinding_ITwoWayAsyncVoid"></endpoint>
      <endpoint address="http://1.1.1.1/BrightSM/services/JobCreator" binding="basicHttpBinding" bindingConfiguration="JobCreatorSoapBinding" contract="JobCreatorService.JobCreator" name="JobCreator" />
    </client>
    <services>
      <service name="PCITC.MES.IP.AAA.AppService.AuthenticateService" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
        <endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IAuthenticateService" />
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" />
      </service>
      <service name="PCITC.MES.IP.AAA.AppService.AuthorizeService" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
        <endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IAuthorizeService" />
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" />
      </service>
      <service name="PCITC.MES.IP.AAA.AppService.IntegrateService" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
        <endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IIntegrateService" />
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" />
      </service>
    </services>
    <behaviors>
      <serviceBehaviors>
        <behavior name="PCITC.MES.IP.AAA.AppServiceBehavior">
          <serviceMetadata httpGetEnabled="true" />
          <serviceDebug includeExceptionDetailInFaults="true" />
        </behavior>
        <behavior name="">
          <serviceMetadata httpGetEnabled="true" httpsGetEnabled="true" />
          <serviceDebug includeExceptionDetailInFaults="false" />
        </behavior>
      </serviceBehaviors>
    </behaviors>
    <serviceHostingEnvironment aspNetCompatibilityEnabled="false" multipleSiteBindingsEnabled="true" minFreeMemoryPercentageToActivateService="0" />
  </system.serviceModel>
  <appSettings>
    <!--很重要-->
    <add key="Spring.Data.NHibernate.Support.OpenSessionInViewModule.SessionFactoryObjectName" value="sessionFactory" />
    <add key="webpages:Version" value="2.0.0.0" />
    <add key="webpages:Enabled" value="false" />
    <add key="PreserveLoginUrl" value="true" />
    <add key="ClientValidationEnabled" value="true" />
    <add key="UnobtrusiveJavaScriptEnabled" value="true" />
    <!--访问应用的鉴权属性编码和操作编码-->
    <add key="prop-code-for-app" value="APP" />
    <add key="op-code-for-access-app" value="ACCESS" />
    <add key="TestOrgUnitCode" value="IP" />
    <!--Redis缓存配置-->
    <add key="CacheEnabled" value="false" />
    <add key="RedisReadWriteHosts" value="1.1.1.1:6379" />
    <add key="RedisReadOnlyHosts" value="1.1.1.1:6379" />
    <add key="MaxWritePoolSize" value="30" />
    <add key="MaxReadPoolSize" value="30" />
    <!--AD域认证信息-->
    <add key="ADPath" value="LDAP://1.1.1.1" />
    <!--//TJSH-DC-01.sinopec.ad" />--> 
    <!-- 程序需要模拟登录连接的域账号信息 -->
    <add key="SysADAccount" value="" />
    <add key="SysADPassword" value="" />
    <!-- 安全时间戳差异值，单位为秒 -->
    <add key="TimestampThreshold" value="30" />
    <!--是否开启数据缓存（注：IPWeb和ManagementService, AppService都有该配置，请保持一致），默认为false -->
    <add key="DataCache" value="true" />
    <!-- 缓存时效(分钟)，新缓存一天后过期 -->
    <add key="ChacheExpirationInMinutes" value="1440" />
  </appSettings>
</configuration>
<!--ProjectGuid: {C1BF5946-76AD-4652-ACF4-17A9B1C30283}-->
```

配置文件中的这段代码是自动生成的，其中binding是服务端配置的传输协议为`basicHttpBinding`，bindingConfiguration指定客户端binding的具体设置，指向<bindings>元素下同类型binding的name为`JobCreatorSoapBinding`
```
<endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IAuthorizeService" />
```

生成的代码不正确，需要做如下修改
```
<endpoint address="" binding="basicHttpBinding" bindingConfiguration="JobCreatorSoapBinding" contract="PCITC.MES.IP.AAA.AppService.IAuthorizeService" />
```

原来的service
```
      <service name="PCITC.MES.IP.AAA.AppService.AuthenticateService" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
        <endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IAuthenticateService" />
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" />
      </service>
```
修改后的代码
```
       <service name="PCITC.MES.IP.AAA.AppService.AuthenticateService_Basic" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
		<!--<endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IAuthenticateService" />-->
        	<endpoint address="" binding="customBinding" bindingConfiguration="customBindingForJavaClient" />
		<endpoint address="" binding="basicHttpBinding" bindingConfiguration="JobCreatorSoapBinding" contract="PCITC.MES.IP.AAA.AppService.IAuthenticateService" />
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" /> 
```

最终的配置文件如下：

```
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <configSections>
    <sectionGroup name="spring">
      <section name="context" type="Spring.Context.Support.ContextHandler,Spring.Core" />
      <section name="objects" type="Spring.Context.Support.DefaultSectionHandler,Spring.Core" />
      <section name="parsers" type="Spring.Context.Support.NamespaceParsersSectionHandler, Spring.Core" />
    </sectionGroup>
    <sectionGroup name="common">
      <section name="logging" type="Common.Logging.ConfigurationSectionHandler, Common.Logging" />
    </sectionGroup>
  </configSections>
  <connectionStrings />
  <spring xmlns="http://www.springframework.net">
    <parsers>
      <parser type="Spring.Data.Config.DatabaseNamespaceParser, Spring.Data" />
      <parser type="Spring.Transaction.Config.TxNamespaceParser, Spring.Data" />
    </parsers>
    <context>
      <resource uri="~/Config/Base.xml" />
    </context>
    <objects xmlns="http://www.springframework.net" />
  </spring>
  <common>
    <logging>
      <factoryAdapter type="Common.Logging.Log4Net.Log4NetLoggerFactoryAdapter, Common.Logging.Log4Net1211">
        <arg key="configType" value="FILE-WATCH" />
        <arg key="configFile" value="~/Config/Log4Net.xml" />
      </factoryAdapter>
    </logging>
  </common>
  <runtime>
    <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
      <dependentAssembly>
        <assemblyIdentity name="Common.Logging" publicKeyToken="af08829b84f0328e" />
        <bindingRedirect oldVersion="2.1.1.0" newVersion="2.1.2.0" />
      </dependentAssembly>
    </assemblyBinding>
  </runtime>
  <system.web>
    <compilation targetFramework="4.5" />
    <authentication mode="Windows" />
    <httpModules>
      <add name="Spring" type="Spring.Context.Support.WebSupportModule, Spring.Web" />
      <add name="OpenSessionInView" type="Spring.Data.NHibernate.Support.OpenSessionInViewModule,Spring.Data.NHibernate33" />
    </httpModules>
    <pages controlRenderingCompatibilityVersion="3.5" clientIDMode="AutoID" />
  </system.web>
  <system.webServer>
    <validation validateIntegratedModeConfiguration="false" />
    <modules runAllManagedModulesForAllRequests="true">
      <add name="Spring" type="Spring.Context.Support.WebSupportModule, Spring.Web" />
      <add preCondition="integratedMode" name="OpenSessionInView" type="Spring.Data.NHibernate.Support.OpenSessionInViewModule,Spring.Data.NHibernate33" />
    </modules>
    <handlers>
      <add name="Spring.WebPageHandler" path="*.aspx" verb="*" type="Spring.Web.Support.PageHandlerFactory, Spring.Web" />
      <add name="Spring.WebSupportHandler" path="ContextMonitor.ashx" verb="*" type="Spring.Web.Support.ContextMonitor, Spring.Web" />
    </handlers>
        <directoryBrowse enabled="false" />
  </system.webServer>
  <system.serviceModel>
    <bindings>
      <wsHttpBinding>
        <binding name="NoneSecurity" maxBufferPoolSize="2147483647" maxReceivedMessageSize="2147483647" useDefaultWebProxy="false" closeTimeout="00:10:00" openTimeout="00:10:00" receiveTimeout="00:10:00" sendTimeout="00:30:00">
          <readerQuotas maxStringContentLength="12000000" maxArrayLength="12000000" />
          <security mode="None" />
        </binding>
        <binding name="WSHttpBinding_ITwoWayAsyncVoid" />
      </wsHttpBinding>
	  **<customBinding>
        <binding name="customBindingForJavaClient">
          <httpTransport/>
          <textMessageEncoding messageVersion="Soap12" />
        </binding>
      </customBinding>**
      <basicHttpBinding>
        <binding name="JobCreatorSoapBinding" />
      </basicHttpBinding>
    </bindings>
    <client>
      <!--向应用推送用户的功能调用的推送用户服务URL-->
      <endpoint address="http://1.1.1.1:8080/PushUserService/PublishUserService.svc" binding="wsHttpBinding" bindingConfiguration="WSHttpBinding_ITwoWayAsyncVoid" contract="PushUserService.WcfService_PushUser" name="WSHttpBinding_ITwoWayAsyncVoid"></endpoint>
      <endpoint address="http://1.1.1.1/BrightSM/services/JobCreator" binding="basicHttpBinding" bindingConfiguration="JobCreatorSoapBinding" contract="JobCreatorService.JobCreator" name="JobCreator" />
    </client>
    <services>
	**<service name="PCITC.MES.IP.AAA.AppService.AuthenticateService_Basic" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
		<!--<endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IAuthenticateService" />-->
        	<endpoint address="" binding="customBinding" bindingConfiguration="customBindingForJavaClient" />
		<endpoint address="" binding="basicHttpBinding" bindingConfiguration="JobCreatorSoapBinding" contract="PCITC.MES.IP.AAA.AppService.IAuthenticateService" />
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" /> 
      </service>**
      <service name="PCITC.MES.IP.AAA.AppService.AuthorizeService" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
        **<endpoint address="" binding="basicHttpBinding" bindingConfiguration="JobCreatorSoapBinding" contract="PCITC.MES.IP.AAA.AppService.IAuthorizeService" />**
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" />
      </service>
      <service name="PCITC.MES.IP.AAA.AppService.IntegrateService" behaviorConfiguration="PCITC.MES.IP.AAA.AppServiceBehavior">
        <endpoint address="" binding="wsHttpBinding" bindingConfiguration="NoneSecurity" contract="PCITC.MES.IP.AAA.AppService.IIntegrateService" />
        <endpoint address="mex" binding="mexHttpBinding" contract="IMetadataExchange" />
      </service>
    </services>
    <behaviors>
      <serviceBehaviors>
        <behavior name="PCITC.MES.IP.AAA.AppServiceBehavior">
          <serviceMetadata httpGetEnabled="true" />
          **<serviceDebug includeExceptionDetailInFaults="false" />**
        </behavior>
        <behavior name="">
          <serviceMetadata httpGetEnabled="true" httpsGetEnabled="true" />
          <serviceDebug includeExceptionDetailInFaults="false" />
        </behavior>
      </serviceBehaviors>
    </behaviors>
    <serviceHostingEnvironment aspNetCompatibilityEnabled="false" multipleSiteBindingsEnabled="true" minFreeMemoryPercentageToActivateService="0" />
  </system.serviceModel>
  <appSettings>
    <!--很重要-->
    <add key="Spring.Data.NHibernate.Support.OpenSessionInViewModule.SessionFactoryObjectName" value="sessionFactory" />
    <add key="webpages:Version" value="2.0.0.0" />
    <add key="webpages:Enabled" value="false" />
    <add key="PreserveLoginUrl" value="true" />
    <add key="ClientValidationEnabled" value="true" />
    <add key="UnobtrusiveJavaScriptEnabled" value="true" />
    <!--访问应用的鉴权属性编码和操作编码-->
    <add key="prop-code-for-app" value="APP" />
    <add key="op-code-for-access-app" value="ACCESS" />
    <add key="TestOrgUnitCode" value="IP" />
    <!--Redis缓存配置-->
    <add key="CacheEnabled" value="false" />
    <add key="RedisReadWriteHosts" value="1.1.1.1:6379" />
    <add key="RedisReadOnlyHosts" value="1.1.1.1:6379" />
    <add key="MaxWritePoolSize" value="30" />
    <add key="MaxReadPoolSize" value="30" />
    <!--AD域认证信息-->
    <add key="ADPath" value="LDAP://1.1.1.1" />
    <!--//TJSH-DC-01.sinopec.ad" />--> 
    <!-- 程序需要模拟登录连接的域账号信息 -->
    <add key="SysADAccount" value="" />
    <add key="SysADPassword" value="" />
    <!-- 安全时间戳差异值，单位为秒 -->
    <add key="TimestampThreshold" value="30" />
    <!--是否开启数据缓存（注：IPWeb和ManagementService, AppService都有该配置，请保持一致），默认为false -->
    <add key="DataCache" value="true" />
    <!-- 缓存时效(分钟)，新缓存一天后过期 -->
    <add key="ChacheExpirationInMinutes" value="1440" />
  </appSettings>
</configuration>
<!--ProjectGuid: {C1BF5946-76AD-4652-ACF4-17A9B1C30283}-->
```