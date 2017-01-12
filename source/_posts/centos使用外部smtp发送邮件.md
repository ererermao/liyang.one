---
title: centos使用外部smtp发送邮件
date: 2016-11-10 20-20-20
categories: centos
tags: 
- mail
- smtp
- centos
- 邮件
---

在一些小的调度里面，用shell+crontab。这样比较简单和方便，但是没有通知机制。那就用mail来顶上。

## 1. 安装mail

```bash
yum install mailx  -y  # -y 默认yes
```

## 2. 配置外部smtp发送邮件

```bash
vi /etc/mail.rc
## 新增以下
set from=xxxxx@qq.com
set smtp=smtp.qq.com
set smtp-auth-user=xxxxx@qq.com
set smtp-auth-password=XXXXXXXX
set smtp-auth=login
```

## 3. 发送邮件

### 3.1 使用管道进行邮件发送

```
echo "hello" | mail -s "test" XXXXX@qq.com
```
### 3.2 使用文件进行邮件发送

```
mail -s "test" XXXXX@qq.com </opt/a.txt
```

### 3.3 发送附件

```
mail -s "test" -a /opt/b.txt XXXXX@qq.com </opt/a.txt
```
