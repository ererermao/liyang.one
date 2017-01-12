---
title: ss用一段时间卡？vps定时重启试试
categories: ss
tags: 
- vps
- ss
- shadowsocks
---

> 用了半个月的ss后，速度变的相当慢。找了各种办法，无解。后来重启后速度又杠杠的跑了起来。  

## 1. 添加定时重启vps
```bash
crontab -e				#编辑任务列表

#新增：注意用root用户添加
	01 21 * * * /sbin/roboot	  #由于vps的时间要晚8个小时，又懒得去修改时间就这样吧。
```

## 2. 开机自动启动ss服务等

```bash 
# ss的开机启动
	chkconfig supervisord  on
# 锐速开机启动
	chkconfig serverSpeeder on
# net-speeder的开机启动
	echo 'nohup /usr/local/net_speeder/net_speeder eth0 "ip" >/var/log/net_speeder 2>&1 &' >> /etc/rc.local
```


## 3.补充：Crontab基本格式：

```bash
*　 *　 *　 *　　*　　command
分　时　日　月　 周　 命令
```