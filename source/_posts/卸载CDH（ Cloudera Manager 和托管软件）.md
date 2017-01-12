---
title: 卸载CDH（ Cloudera Manager 和托管软件）
date: 2016-11-14 20:13:13
categories: hadoop
tags: 
- 卸载CDH
- cloudera
- cdh
---



## 1. 一些默认的地址

```
/var/lib/flume-ng 
/var/lib/hadoop* 
/var/lib/hue 
/var/lib/navigator 
/var/lib/oozie 
/var/lib/solr 
/var/lib/sqoop* 
/var/lib/zookeeper 
/dfs 
/mapred /yarn
```

## 2. 恢复未完成的安装

```bash
rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera*
```

## 2. 停止各种cdh和cm服务
可以直接在界面上面定制

## 3. 删除cm server上的服务及安装

```bash
service cloudera-scm-server stop
service cloudera-scm-server-db stop
service cloudera-scm-agent hard_stop
yum remove 'cloudera-manager-*'

yum clean all 
```

## 4. 手动删除数据文件

### 4.1 删除 Cloudera Manager 数据
```bash
rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera*
```

### 4.2 删除 Cloudera Manager 锁定文件
```bash
rm /tmp/.scm_prepare_node.lock
```

### 4.3 删除用户数据
```bash
rm -Rf /var/lib/flume-ng /var/lib/hadoop* /var/lib/hue /var/lib/navigator /var/lib/oozie /var/lib/solr /var/lib/sqoop* /var/lib/zookeeper
rm -Rf /dfs /mapred /yarn
```


## 5. 快速操作

```bash
1.
service cloudera-scm-server stop
service cloudera-scm-server-db stop
service cloudera-scm-agent hard_stop
yum remove 'cloudera-manager-*'
yum remove enterprise*

2.
rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera*
rm /tmp/.scm_prepare_node.lock
rm -Rf /var/lib/flume-ng /var/lib/hadoop* /var/lib/hue /var/lib/navigator /var/lib/oozie /var/lib/solr /var/lib/sqoop* /var/lib/zookeeper
rm -Rf /dfs /mapred /yarn
```