---
title: 使用Topshelf创建Windows服务
abbrlink: f0ebd003
date: 2018-12-17 16:04:59
tags:
categories:
keywords:
---

在C#项目中使用`nuget`引用`Topshelf`最新版本，因为`Topshelf`需要依赖`Log4Net`，所以还得引用`Topshelf.Log4Net`

[Topshelf地址][1]
[Topshelf.Log4Net地址][2]
[Topshelf-Git地址][3]
[Topshelf官方地址][4]

# 初始化Topshelf
```
    class Program
    {
        static void Main(string[] args)
        {
            try
            {  
                LogHelper.WriteLog("正在准备安装服务");
                //定义类加定时器，并实现 ServiceControl,ServiceSuspend,ServiceShutdown 接口
                HostFactory.Run(o =>
                {
                    o.Service<WcfControl>();
                    o.RunAsLocalSystem();
                    o.SetServiceName("IOLService");
                    o.SetDisplayName("地磅服务");
                    o.SetDescription("地磅服务，实现读取地磅数据和红外对射的WCF服务。");
                });
            }
            catch (Exception e)
            {
                LogHelper.WriteErrorLog(e);
            } 
    }
```

# Topshelf的服务类实现
```

    /// <summary>
    /// 自定义类加定时器，并实现 ServiceControl,ServiceSuspend,ServiceShutdown 接口。
    /// </summary>
    public class WcfControl : ServiceControl, ServiceSuspend, ServiceShutdown
    {
        public ServiceHost Host;

        public WcfControl()
        {
            LogHelper.WriteLog("服务正在运行");
        }

        bool ServiceControl.Start(HostControl hostControl)
        {
            Host = new ServiceHost(typeof(DbService));
            Host.Open();
            LogHelper.WriteLog("服务已开启");
            return true;
        }

        bool ServiceControl.Stop(HostControl hostControl)
        {
            Host.Close();
            LogHelper.WriteLog("服务已停止");
            return true;
        }

        bool ServiceSuspend.Pause(HostControl hostControl)
        {
            //...逻辑代码
            LogHelper.WriteLog("服务已暂停");
            return true;
        }

        bool ServiceSuspend.Continue(HostControl hostControl)
        {
            //...逻辑代码
            LogHelper.WriteLog("服务继续运行");
            return true;
        }

        void ServiceShutdown.Shutdown(HostControl hostControl)
        {
            //...逻辑代码
            LogHelper.WriteLog("服务已关闭");
        }
    }
```

# Topshelf结合wcf接口使用

## wcf接口定义
```
    /// <summary>
    /// wcf接口
    /// </summary>
    [ServiceContract]
    public interface IDbService
    {
        /// <summary>
        /// 红外对射接口
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        ResultEntity GetResult();

        /// <summary>
        /// 称重接口读取逻辑
        /// </summary>
        /// <returns></returns>
        [OperationContract]
        decimal? GetPz();

    }
```

## wcf接口实现
```

    /// <summary>
    /// wcf接口实现
    /// </summary>
    public class DbService : IDbService
    {
        /// <summary>
        /// 红外对射方法
        /// </summary>
        /// <returns></returns>
        public ResultEntity GetResult()
        {
            try
            {
                HwCommData hwCommData = new HwCommData();
                return hwCommData.GetHwInfo();
            }
            catch (Exception e)
            {
                LogHelper.WriteErrorLog(e); 
            }
            return new ResultEntity();
        }

        /// <summary>
        /// 获取地磅数据
        /// </summary>
        /// <returns></returns>
        public decimal? GetPz()
        {
            try
            {
                decimal errorValue = 10; //误差值 
                DbCommData commData = new DbCommData();
                List<decimal> pzData = commData.GetInfo();
                if (pzData.Count > 0)
                {
                    for (int i = 1; i < pzData.Count; i++)
                    {
                        if (Math.Abs(pzData[0] - pzData[i]) > errorValue)
                        { 
                            return 0;
                        }
                    }
                    return pzData[pzData.Count - 1];
                }
            }
            catch (Exception e)
            {
                LogHelper.WriteErrorLog(e);
            }
            return null;
        }
    } 
```

  [1]: https://www.nuget.org/packages/Topshelf
  [2]: https://www.nuget.org/packages/Topshelf.Log4Net/
  [3]: https://github.com/Topshelf/Topshelf
  [4]: http://topshelf-project.com/