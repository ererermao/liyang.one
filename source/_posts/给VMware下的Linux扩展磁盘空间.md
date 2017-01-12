---
title: 给VMware下的Linux扩展磁盘空间（以CentOS6.3为例）
date: 2016-11-17 19:05:05
categories: centos
tags: 
- centos
- vm
- lvm
---


> 前提是使用的lvm逻辑卷分区，才能这样扩展。

查看挂载点：


```bash  
df -h
#显示：  
文件系统 容量 已用 可用 已用%% 挂载点  
/dev/mapper/vg_dc01-lv_root  
                       47G   12G   34G  25% /
tmpfs                 504M   88K  504M   1% /dev/shm
/dev/sda1             485M   31M  429M   7% /boot
 
```

## 一、扩展VMWare硬盘空间
关闭Vmware 的 Linux系统，这样，才能在VMWare菜单中设置：
```
　　VM -> Settings... -> Hardware -> Hard Disk -> Utilities -> Expand
```
　　输入你想要扩展到多少G。本文假设你新增加了 30G
## 二、对新增加的硬盘进行分区、格式化
这里进行一个极简化的介绍，非常简化，但很全面，上面已经知道增加了空间的硬盘是 ` /dev/sda`。
```bash
#分区：
fdisk /dev/sda　　　　#操作 /dev/sda 的分区表
p　　　　　　　#查看已分区数量（我看到有两个 /dev/sda1 /dev/sda2）
n　　　　　　　#新增加一个分区
p　　　　　　　#分区类型我们选择为主分区
3　　　　　　  #分区号选3（因为1,2已经用过了，见上）
回车　　　　　　#默认（起始扇区）
回车　　　　　　#默认（结束扇区）
t　　　　　　　#修改分区类型
3　　　　　　  #选分区
8e　　　　　　#修改为LVM（8e就是LVM）
w　　　　　　#写分区表
q　　　　　　#完成，退出fdisk命令
#系统提示你重启，重启吧.
#开机后，格式化：
mkfs.ext3 /dev/sda3

```
##三、添加新LVM到已有的LVM组，实现扩容
```bash
lvm　　　　　　　　　　　　　　　　　　进入lvm管理
lvm> pvcreate /dev/sda3　　　　　　　　　这是初始化刚才的分区，必须的
lvm> vgextend vg_dc01 /dev/sda3　　　将初始化过的分区加入到虚拟卷组vg_dc01
lvm>lvextend -L +29.9G /dev/vg_dc01/lv_root　　扩展已有卷的容量（29.9G这个数字在后面解释）
lvm>pvdisplay　　　　　　　　　　　　　　查看卷容量，这时你会看到一个很大的卷了
lvm>quit　　　　　　　　　　　　　　　　　退出
```
上面那个 29.9G 怎么来的呢？因为你在VMWare新增加了30G，但这些空间不能全被LVM用了，你可以在上面的lvextend操作中一个一个的试探，比如 29.9G, 29.8G ... 直到不报错为止，这样你就可以充分使用新增加的硬盘空间了，当然这是因为我不懂才用的笨办法，高手笑笑就过了吧。（我更不懂啊，原作者，我直接上了29.9G，结果就OK了）  
以上只是卷扩容了，下面是文件系统的真正扩容，输入以下命令：  
```bash
resize2fs /dev/vg_dc01/lv_root

#再运行下：
df -h

```
查看下我们机器性感的硬盘吧。