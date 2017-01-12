---
title: 亚马逊aws更改linux为root权限密码登陆
date: 2016-11-21 10:36:25
categories: aws
tags:
- linux
- centos
- aws
- 亚马逊
- root登录
---

> 我的AWS VPS的LINUX版本是centos6.5 ，首先用AWS证书验证的账户登录.

## 1、修改ROOT密码
```bash
sudo passwd root
```
## 2、修改sshd_config文件
```bash
sudo vi /etc/ssh/sshd_config

#修改这2行
PermitRootLogin yes
PasswordAuthentication yes

```

## 3、重启`ssh`就可以使用root正常登陆了
```bash
/sbin/service sshd restart
```

## 4、登录工具

pc可以使用：`SecureCRT`	  
手机可以使用：`Serverauditor`