---
title: 'C#调用C++接口读取地磅数据，红外线对射'
date: 2018-12-17 16:31:18
tags:
categories:
keywords:
---
# c++红外线接口
```

    /// <summary>
    /// 红外对射接口
    /// </summary>
    class ADSAPI32
    {
        /// <summary>
        /// 打开红外对射
        /// add by jiangtao.xue 2018-12-08
        /// </summary> 
        /// <returns></returns>
        [DllImport("ADSAPI32.dll",  EntryPoint = "DRV_DeviceOpen")]
        public static extern UInt16 DRV_DeviceOpen(int DeviceNum, ref int DriverHandle);

        /// <summary>
        /// 关闭红外对射
        /// add by jiangtao.xue 2018-12-08
        /// </summary> 
        /// <returns></returns>
        [DllImport("ADSAPI32.dll", EntryPoint = "DRV_DeviceClose")]
        public static extern UInt16 DRV_DeviceClose(ref int DriverHandle);

        /// <summary>
        /// 获取错误信息
        /// add by jiangtao.xue 2018-12-08
        /// </summary> 
        /// <returns></returns>
        [DllImport("ADSAPI32.dll",  EntryPoint = "DRV_GetErrorMessage")]
        public static extern int DRV_GetErrorMessage(int li_errcode, string ls_szErrMsg);

        /// <summary>
        /// 读取红外对射数据
        /// add by jiangtao.xue 2018-12-08
        /// </summary> 
        /// <returns></returns>
        [DllImport("ADSAPI32.dll",  EntryPoint = "DRV_DioReadBit")]
        public static extern UInt16 DRV_DioReadBit(int DriverHandle,ref PtDioReadBit DioReadBit);

        /// <summary>
        /// 获取红外对射地址
        /// add by jiangtao.xue 2018-12-08
        /// </summary> 
        /// <returns></returns>
        [DllImport("ADSAPI32.dll",  EntryPoint = "DRV_GetAddress")]
        public static extern IntPtr DRV_GetAddress(ref int refvalue);
    }
```

# 红外对射操作类
```

    /// <summary>
    /// 红外对射操作类
    /// </summary>
    class HwCommData
    {
        public ResultEntity GetHwInfo()
        {
            ResultEntity resultEntity = new ResultEntity();

            int ilDriverhandle = 0;
            string isErrMsg = "";
            int refvalue = 0;
            string ls_password = "";
            try
            {
                #region //初始化

                UInt16 ilErrcode = ADSAPI32.DRV_DeviceOpen(0, ref ilDriverhandle);
                if (ilErrcode != 0)
                {
                    //获取异常信息
                    int errCode = ADSAPI32.DRV_GetErrorMessage(ilErrcode, isErrMsg);

                    resultEntity = new ResultEntity
                    {
                        DeviceSuccess = false,
                        ErrMsg = $"{errCode}：工业控制板初始化失败{isErrMsg}!",
                        State = 0
                    };
                    return resultEntity;
                }

                #endregion

                #region //读取红外对准标识(1正常，0未对准)

                PtDioReadBit ptDioReadBit;
                ptDioReadBit.Port = 0;
                ptDioReadBit.Bit = 1;
                ptDioReadBit.State = ADSAPI32.DRV_GetAddress(ref refvalue);
                ilErrcode = ADSAPI32.DRV_DioReadBit(ilDriverhandle, ref ptDioReadBit);
                if (refvalue == 1)
                {
                    if (ls_password != "1")
                    {
                        resultEntity = new ResultEntity
                        {
                            DeviceSuccess = true,
                            ErrMsg = "车辆入口位置不正，请重新过磅！",
                            State = 0
                        };
                        return resultEntity;
                    }
                }

                ptDioReadBit.Port = 0;
                ptDioReadBit.Bit = 0;
                ptDioReadBit.State = ADSAPI32.DRV_GetAddress(ref refvalue);
                ilErrcode = ADSAPI32.DRV_DioReadBit(ilDriverhandle, ref ptDioReadBit);
                if (refvalue == 1)
                {
                    if (ls_password != "1")
                    {
                        resultEntity = new ResultEntity
                        {
                            DeviceSuccess = true,
                            ErrMsg = "车辆入口位置不正，请重新过磅！",
                            State = 0
                        };
                        return resultEntity;
                    }
                }

                #endregion

                #region //红外设备关闭

                ilErrcode = ADSAPI32.DRV_DeviceClose(ref ilDriverhandle);
                if (ilErrcode != 0)
                {
                    //获取异常信息
                    int errCode = ADSAPI32.DRV_GetErrorMessage(ilErrcode, isErrMsg);
                    resultEntity = new ResultEntity
                    {
                        DeviceSuccess = false,
                        ErrMsg = $"{errCode}工业控制板关闭失败{isErrMsg}!",
                        State = 0
                    };
                    return resultEntity;
                } 

                #endregion

                resultEntity = new ResultEntity
                {
                    DeviceSuccess = true,
                    ErrMsg = "车辆位置正常!",
                    State = 1
                };
                return resultEntity;
            }
            catch (Exception e)
            {
                LogHelper.WriteErrorLog(e);

                resultEntity = new ResultEntity
                {
                    DeviceSuccess = false,
                    ErrMsg = "程序异常!",
                    State = 0
                };
                return resultEntity;
            }
        }
    }

    public class ResultEntity
    {
        public ResultEntity()
        {
            DeviceSuccess = false;
        }

        /// <summary>
        /// 程序是否成功
        /// </summary>
        public bool DeviceSuccess;

        /// <summary>
        /// 错误信息
        /// </summary>
        public string ErrMsg;

        /// <summary>
        /// 状态（0和1）0不成功，1成功
        /// </summary>
        public UInt16 State;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PtDioReadBit
    { 
        public UInt16 Port;
        public UInt16 Bit;
        public IntPtr State;
    }
```

# 地磅串口操作类
```

    /// <summary>
    /// 地磅串口操作类
    /// </summary>
    class DbCommData
    {
        readonly SerialPort _serialPort;      //初始化串口设置 
        int _speed = 200;
        public DbCommData()
        {
            try
            {
                _serialPort = new SerialPort();
                //设置参数
                _serialPort.PortName = ConfigurationManager.AppSettings["PortName"].ToString(); //通信端口
                _serialPort.BaudRate = Int32.Parse(ConfigurationManager.AppSettings["BaudRate"].ToString()); //串行波特率
                _serialPort.DataBits = 8; //每个字节的标准数据位长度
                _serialPort.StopBits = StopBits.One; //设置每个字节的标准停止位数
                _serialPort.Parity = Parity.None; //设置奇偶校验检查协议
                _serialPort.ReadTimeout = 3000; //单位毫秒
                _serialPort.WriteTimeout = 3000; //单位毫秒
                //串口控件成员变量，字面意思为接收字节阀值，
                //串口对象在收到这样长度的数据之后会触发事件处理函数
                //一般都设为1
                _serialPort.ReceivedBytesThreshold = 1;
                _serialPort.Handshake = Handshake.RequestToSend;
                this.Speed = Speed;
            }
            catch
            {
                LogHelper.WriteErrorLog(string.Format("无法初始化串口{0}!", ConfigurationManager.AppSettings["PortName"]));
            }
        }

        /// <summary>
        /// 解析读取皮重结果
        /// </summary>
        /// <returns></returns>
        public List<decimal> GetInfo()
        {
            try
            {
                int loop = 0;
                List<decimal> pzDataList = new List<decimal>();
                 
                while (pzDataList.Count <= 10 && loop <= 20)
                {
                    string lsRead = this.ReadCom(); 
                    int liLen = lsRead.Length;
                    int liPos = lsRead.IndexOf((char) 2);
                    if (liPos != -1 && liLen - liPos >= 17)
                    {
                        if (!String.IsNullOrEmpty(lsRead))
                        {
                            string subNum = lsRead.Substring(liPos + 4, 6); 
                            try
                            {
                                var ldPz = decimal.Parse(subNum);
                                var lsA = lsRead.Substring(liPos + 2, 1);
                                if (lsA == "2" || lsA == "3" || lsA == "6" || lsA == "7")
                                {
                                    ldPz = -ldPz;
                                }
                                pzDataList.Add(ldPz);
                            }
                            catch (Exception e)
                            {
                                LogHelper.WriteErrorLog(e.StackTrace);
                            } 
                        }
                    }
                    loop++; 
                }
                return pzDataList;
            }
            catch (Exception e)
            {
                LogHelper.WriteErrorLog(e);
            }
            return new List<decimal>();
        }

        /// <summary>
        /// 获取或设置电脑取COM数据缓冲时间，单位毫秒
        /// </summary>
        public int Speed
        {
            get { return this._speed; }
            set
            {
                if (value < 200)
                    LogHelper.WriteErrorLog("串口读取缓冲时间不能小于200毫秒!");
                this._speed = value;
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
                if (!_serialPort.IsOpen)
                {
                    _serialPort.Open();
                }
                if (this._serialPort.IsOpen)
                {
                    Thread.Sleep(this._speed);
                    string res = "";
                    //for (int i = 0; i < 5; i++)
                    //{
                    byte[] buffer = new byte[_serialPort.BytesToRead];
                    _serialPort.Read(buffer, 0, buffer.Length);

                    res = System.Text.Encoding.ASCII.GetString(buffer);
                    //}
                    if (res == "")
                    {
                        LogHelper.WriteErrorLog("串口读取数据为空!");
                    }
                    return res;
                }
                else
                {
                    LogHelper.WriteErrorLog("串口没有打开!");
                }
            }
            catch (Exception e)
            {
                LogHelper.WriteErrorLog(e); 
            }
            finally
            {
                if (_serialPort != null && _serialPort.IsOpen)
                {
                    _serialPort.Close();
                }
            }
            return "";
        }
    }
```
