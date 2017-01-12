---
title: cdh搭建hadoop集群-hive错误集
categories: hive
date: 2016-12-06 19:47:47
tages: 
- cdh
- hadoop
- hive
- 错误
---


### 1、Specified key was too long; max key length is 767 bytes

```bash
create database hive DEFAULT CHARSET latin1; 
```
这里由于mysql的最大索引长度导致，MySQL的varchar主键只支持不超过768个字节 或者 768/2=384个双字节 或者 768/3=256个三字节的字段 而 GBK是双字节的，UTF-8是三字节的  
解决办法：数据库的字符集除了system为utf8，其他最好为latin1，否则可能出现如上异常，在mysql机器的上运行:

### 2、javax.jdo.JDODataStoreException: Error executing SQL query "select "DB_ID" from "DBS""

原因：很简单，就是没有创建存放hive元数据的表。在CDH页面找了很久，发现配置也正确也能正常连接上但是就是不能自动创建
解决办法：/opt/cloudera/parcels/CDH-5.4.2-1.cdh5.4.2.p0.2/lib/hive/scripts/metastore/upgrade/mysql/ 里面是mysql的相关的sql脚本，直接拿到mysql执行。