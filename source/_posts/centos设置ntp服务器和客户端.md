---
title: centos设置ntp服务器和客户端
categories: centos
tags: 
- centos
- ntp
- 服务端
- 客户端
---

> NTP（Network Time Protocol）是用来使计算机时间同步化的一种协议，它可以使计算机对其服务器或时钟源做同步化，它可以提供高精准度的时间校正。本例讲解如何在CentOS6.3上配置NTP服务器和NTP客户端，可使多台客户机的时间与指定的NTP服务器的时间保持一致。从而保证了多台服务器的时间同步。


## 1、安装ntp和修改时区
简单点之间用yum安装
```bash
yum -y install ntp

cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

## 2、设置服务端192.168.0.25
修改`/etc/ntp.cnf`
```bash
#限定了哪些主机可以从本NTP服务器同步时间，默认的配置文件里是没有这句话的。加入这句话后，表明，只有192.168.0 这个网段的主机可以从本NTP服务器同步时间。nomodify  表明客户端不可以修改服务器的地址
restrict 192.168.0.1/24 mask 255.255.255.0 nomodify   

#远程服务器地址
server time-b.nist.gov

#默认的配置文件里这两个是被注释掉的。如果第二部配置的server time-b.nist.gov无效时，则NTP服务器会根据这里的配置，把自己的时间做为NTP服务器的时间，即和自己同步。考虑到有的局域网里不可以访问外网，所有这里需要把这个配置项用上，即把前面的注释符#号去掉就可以了。

server  127.127.1.0     # local clock  
fudge   127.127.1.0 stratum 10

```
记着关闭防火墙或者开放123端口  

重启服务`servcice ntpd resatrt`   
NTP服务启动后大约需要3～5分钟的时间才会进行一次时间同步。可以通过命令ntpstat查看同步情况，

## 3、设置客户端
修改`/etc/ntp.cnf`
```bash
server 192.168.0.25
```
然后重启服务`servcice ntpd resatrt`

## 4、相关命令
- 查看系统时间：date
- 查看与上层ntp服务器的关系：ntpq -p
- 查看是否更新了自己的时间：ntpstat