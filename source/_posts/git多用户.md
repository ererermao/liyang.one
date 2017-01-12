---
title: git多用户
date: 2016-11-07 18:44:59
categories: git
tags:
- git
- git多用户
---



## 1. 生成key
终端下执行 :

```bash
> cd ~/.ssh
ssh-keygen -t rsa -C 'xxxxx@github.com' -f id_rsa_github
```
其中` xxxxx@github.com` 替换为你的邮箱， ` id_rsa_github `为生成文件文件名，执行后会问你是否需要` enter a passphrase`， 默认一路确认就行。

## 2. 添加到 ssh-agent
将新生成的key 添加到 ssh-agent
```bash
ssh-agent -s
ssh-add ~/.ssh/id_rsa_github
```
同时也可以通过命令 ssh-add -l 查看之前已添加的key。

## 3. 添加公匙到账户
```
clip < ~/.ssh/id_rsa_github.pub
```
重复执行以上步骤,配置你的其他账户
```
ssh-keygen -t rsa -C 'xxxxx@qq.com' -f id_rsa_qq
```

## 4. 配置

```bash
> cd ~/.ssh/  
> vi config
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_rsa_github
    User name1
Host git.coding.net
    HostName git.coding.net
    IdentityFile ~/.ssh/id_rsa_qq
    User name2 
```


## 5. 测试

```
ssh -vT git@github.com
ssh -vT git.coding.net
```

## 6. 有可能碰到的问题

### 1、Could not open a connection to your authentication agent？应该是 ssh-agent 没有启动，执行以下命令启动

```bash
eval `ssh-agent -s`
ssh-add
```

### 2、Permission denied，

这个问题，注意一下配置文件里面的Host和HostName

> 转自：[https://segmentfault.com/a/1190000007116113](https://segmentfault.com/a/1190000007116113)