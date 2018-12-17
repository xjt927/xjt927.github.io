---
title: 'C#读取地磅（电子秤）串口'
abbrlink: 7f88541c
date: 2018-12-11 19:36:00
tags:
categories:
keywords:
---
```
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading;

namespace IOLWinService
{
    /// <summary>
    /// 电子秤接口信息类，封装COM口数据
    /// </summary>
    public class WeightInformation
    {
        string _wdata;
        string _wunit;
        string _qdata;
        string _qunit;
        string _percentage;

        /// <summary>
        /// 获取或设置重量
        /// </summary>
        public string WData
        {
            get { return this._wdata; }
            set { this._wdata = value; }
        }

        /// <summary>
        /// 获取或设置重量单位
        /// </summary>
        public string WUnit
        {
            get { return this._wunit; }
            set { this._wunit = value; }
        }

        /// <summary>
        /// 获取或设置数量
        /// </summary>
        public string QData
        {
            get { return this._qdata; }
            set { this._qdata = value; }
        }

        /// <summary>
        /// 获取或设置数量单位
        /// </summary>
        public string QUnit
        {
            get { return this._qunit; }
            set { this._qunit = value; }
        }

        /// <summary>
        /// 获取或设置百分数
        /// </summary>
        public string Percentage
        {
            get { return this._percentage; }
            set { this._percentage = value; }
        }

        /// <summary>
        /// 读取地磅的全部信息
        /// </summary>
        public string Res;
    }

    /// <summary>
    /// 电子称数据读取类
    /// </summary>
    public class WeightReader : IDisposable
    {
        #region 字段、属性与构造函数

        public WeightReader()
        {
            try
            {
                ASCIIEncoding aSCII = new ASCIIEncoding(); 
                byte[] bt = new byte[] { (byte)2 };
                string str = aSCII.GetString(bt);

                sp = new SerialPort();

                //设置参数
                sp.PortName = "COM1" //通信端口
                sp.BaudRate = "9600" //串行波特率
                sp.DataBits = 8; //每个字节的标准数据位长度
                sp.StopBits = StopBits.One; //设置每个字节的标准停止位数
                sp.Parity = Parity.None; //设置奇偶校验检查协议
                sp.ReadTimeout = 3000; //单位毫秒
                sp.WriteTimeout = 3000; //单位毫秒
                //串口控件成员变量，字面意思为接收字节阀值，
                //串口对象在收到这样长度的数据之后会触发事件处理函数
                //一般都设为1
                sp.ReceivedBytesThreshold = 1; 
                sp.Handshake = Handshake.RequestToSend;  
                this.Speed = Speed;
                if (!sp.IsOpen)
                {
                    sp.Open();
                } 
            }
            catch
            {
                LogHelper.WriteErrorLog(string.Format("无法初始化串口{0}!", ConfigurationManager.AppSettings["PortName"])); 
            }
        }

        SerialPort sp;
        int _speed = 300;

        /// <summary>
        /// 获取或设置电脑取COM数据缓冲时间，单位毫秒
        /// </summary>
        public int Speed
        {
            get { return this._speed; }
            set
            {
                if (value < 300)
                    throw new Exception("串口读取缓冲时间不能小于300毫秒!");
                this._speed = value;
            }
        }

        public bool InitCom(string PortName)
        {
            return this.InitCom(PortName, 4800, 300);
        }

        /// <summary>
        /// 初始化串口
        /// </summary>
        /// <param name="PortName">数据传输端口</param>
        /// <param name="BaudRate">波特率</param>
        /// <param name="Speed">串口读数缓冲时间</param>
        /// <returns></returns>
        public bool InitCom(string PortName, int BaudRate, int Speed)
        {
            try
            {
                sp = new SerialPort(PortName, BaudRate, Parity.None, 8);
                sp.ReceivedBytesThreshold = 10;
                sp.Handshake = Handshake.RequestToSend;
                sp.Parity = Parity.None;
                sp.ReadTimeout = 600;
                sp.WriteTimeout = 600;
                this.Speed = Speed;
                if (!sp.IsOpen)
                {
                    sp.Open();
                }
                return true;
            }
            catch
            {
                throw new Exception(string.Format("无法初始化串口{0}!", PortName));
            }
        }

        #endregion

        #region 串口数据读取方法

        public WeightInformation ReadInfo()
        {
            try
            {
                string src = this.ReadCom();
                LogHelper.WriteLog(src);
                WeightInformation info = new WeightInformation();
                info.WData = this.DecodeWeightData(src);
                info.WUnit = this.DecodeWeightUnit(src);
                info.Percentage = this.DecodePercentage(src);
                info.QData = this.DecodeQualityData(src);
                info.QUnit = this.DecodeQualityUnit(src);
                info.Res = src;
                return info;
            }
            catch (Exception e)
            {
                LogHelper.WriteErrorLog(e);
                throw e;
            }
        }

        /// <summary>
        /// 将COM口缓存数据全部读取
        /// </summary>
        /// <returns></returns>
        private string ReadCom() //返回信息 
        {
            try
            {
                if (this.sp.IsOpen)
                {
                    Thread.Sleep(this._speed);
                    string res = "";
                    //for (int i = 0; i < 5; i++)
                    //{
                    byte[] buffer = new byte[sp.BytesToRead];
                    sp.Read(buffer, 0, buffer.Length);

                    res = System.Text.Encoding.ASCII.GetString(buffer);
                    //if (res != "")
                    //    break;
                    //}
                    if (res == "")
                    {
                        LogHelper.WriteErrorLog("串口读取数据为空，参数设置是否正确!");
                    }
                    return res;
                }

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw e;
            }
            finally
            {
                if (sp != null && sp.IsOpen)
                {
                    sp.Close();
                    LogHelper.WriteLog("串口已关闭");
                }
            }
            return "";
        }

        #endregion

        #region  基本取数方法

        /// <summary>
        /// 从字符串中取值
        /// </summary>
        /// <param name="head">起始字符串</param>
        /// <param name="intervalLen">间隔位长度</param>
        /// <param name="valueLen">值长度</param>
        /// <param name="src">源字符串</param>
        /// <returns></returns>
        private string DecodeValue(string head, int intervalLen, int valueLen, string src)
        {
            int index = src.IndexOf(head);
            return src.Substring(index + intervalLen, valueLen);
        }

        /// <summary>
        /// 取重量
        /// </summary>
        /// <param name="srcString">源字符串</param>
        /// <returns></returns>
        private string DecodeWeightData(string srcString)
        {
            return this.DecodeValue("GS,", 3, 8, srcString);
        }

        /// <summary>
        /// 取重量单位
        /// </summary>
        /// <param name="srcString">源字符串</param>
        /// <returns></returns>
        private string DecodeWeightUnit(string srcString)
        {
            return this.DecodeValue("GS,", 12, 2, srcString);
        }

        /// <summary>
        /// 取百分数
        /// </summary>
        /// <param name="srcString">源字符串</param>
        /// <returns></returns>
        private string DecodePercentage(string srcString)
        {
            return this.DecodeValue("U.W.", 4, 14, srcString);
        }

        /// <summary>
        /// 取数量
        /// </summary>
        /// <param name="srcString">源字符串</param>
        /// <returns></returns>
        private string DecodeQualityData(string srcString)
        {
            return this.DecodeValue("PCS", 3, 9, srcString);
        }

        /// <summary>
        /// 取数量单位
        /// </summary>
        /// <param name="srcString">源字符串</param>
        /// <returns></returns>
        private string DecodeQualityUnit(string srcString)
        {
            return this.DecodeValue("PCS", 12, 3, srcString);
        }

        #endregion

        #region 释放所有资源

        public void Dispose()
        {
            if (sp != null && sp.IsOpen)
            {
                sp.Close();
            }
        }

        #endregion
    }
}
```