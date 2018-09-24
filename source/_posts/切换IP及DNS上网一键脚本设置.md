---
title: 切换IP及DNS上网一键脚本设置
tags: Bat脚本
categories: Bat
keywords: Bat脚本
abbrlink: 1ab46bf
date: 2018-08-05 19:56:28
---

三种上网设置，bat脚本如下
---------文件1 select.bat
```
@echo off 
echo 快速设置IP地址和DNS为"自动获得"
echo.netsh int ip set addr "本地连接" dhcpnetsh int ip set dns "本地连接" dhcp
@echo off    
echo  ----------------------------   
echo (1).自动获取 
echo (2).自由上网  
echo (3).自由上网(备用)
echo  ----------------------------   
echo 选择你要设置的网络:   
set /p x=   
if %x%*==1* goto a   
if %x%*==2* goto b 
if %x%*==3* goto c 
ipconfig/flushdns 
:a   
AutoDNS.bat
:b
PureDNS.bat
:c
PureDNS(pre).bat
echo 即将自动退出。。。
ping -n 6 127.0>nul 
```
---------文件2 AutoDNS.bat
```
@echo off 
echo 快速设置IP地址和DNS为"自动获得"
echo.netsh int ip set addr "本地连接" dhcpnetsh int ip set dns "本地连接" dhcp
@echo off    
echo  ----------------------------   
echo (1).自由上网   
echo (2).自动获取
echo  ----------------------------   
netsh interface IP set address name="本地连接" source=dhcp
netsh interface ip set dns name="本地连接" source=dhcp
ipconfig/flushdns 
echo 即将自动退出。。。
ping -n 6 127.0>nul  
```
---------文件3 PureDNS.bat
```
@echo off
echo 如360等安全软件拦截请务必选择允许
echo 正在为您设置DNS
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
netsh interface ip set dns name="本地连接" source=static addr=123.207.137.88 register=PRIMARY
netsh interface ip add dns name="本地连接" addr=115.159.220.214 index=2
netsh interface ip set dns name="无线网络连接" source=static addr=123.207.137.88 register=PRIMARY
netsh interface ip add dns name="无线网络连接" addr=115.159.220.214 index=2
ipconfig/flushdns
echo 即将自动退出。。。
ping -n 6 127.0>nul
```
---------文件4 PureDNS(pre).bat
```
@echo off
echo 如360等安全软件拦截请务必选择允许
echo 正在为您设置可用DNS
echo 若仍无法上网请手动设置为自动获取DNS
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
netsh interface ip set dns name="本地连接" source=static addr=223.5.5.5 register=PRIMARY
netsh interface ip add dns name="本地连接" addr=180.76.76.76 index=2
netsh interface ip set dns name="无线网络连接" source=static addr=223.5.5.5 register=PRIMARY
netsh interface ip add dns name="无线网络连接" addr=180.76.76.76 index=2
ipconfig/flushdns
echo 即将自动退出。。。
ping -n 10 127.0>nul
```


自己修改的bat一

```

@echo off
:: 管理员运行
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit

echo 如360等安全软件拦截请务必选择允许
echo 正在为您设置可用DNS
echo 若仍无法上网请手动设置为自动获取DNS
echo  ----------------------------   
echo (1).自动获取 DNS
echo (2).设置 DNS
echo  ----------------------------   
echo 选择你要设置的网络:   
set /p x=   
if %x%*==1* goto a   
if %x%*==2* goto b 
ipconfig/flushdns 

:a    
(
echo 正在设置自动获取 DNS ...
netsh interface ip set dns  "本地连接"  dhcp
)
:b
(
echo 正在添加本机首选DNS服务器...
netsh interface ip set dns name="本地连接" source=static addr=10.238.255.139 register=PRIMARY
echo 正在添加备用DNS服务器...
netsh interface ip add dns name="本地连接" addr=202.106.196.115 index=2
)
echo 即将自动退出。。。

ping -n 10 127.0>nul
```
自己修改bat二
```

@echo off
:: 管理员运行
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit

echo 如360等安全软件拦截请务必选择允许
echo 正在为您设置可用DNS
echo 若仍无法上网请手动设置为自动获取DNS
echo  ----------------------------   
echo (1).自动获取 DNS
echo (2).设置 DNS
echo  ----------------------------   
echo 选择你要设置的网络:   
set /p x=   
if %x%*==1* goto a   
if %x%*==2* goto b 

:a    
(
echo 正在设置自动获取 DNS ...
netsh interface ip set dns  "本地连接"  dhcp
ipconfig/flushdns   
pause
exit 
)
:b
(
echo 正在添加本机首选DNS服务器...
netsh interface ip set dns name="本地连接" source=static addr=10.238.255.139 register=PRIMARY
echo 正在添加备用DNS服务器...
netsh interface ip add dns name="本地连接" addr=202.106.196.115 index=2
ipconfig/flushdns   
pause
exit 
)
```

