---
title: CDH安装hadoop集群（目前更新到一半，待续）
date: 2016-11-07 09:49:01
categories: hadoop
tags:
- chd
- hadoop
- vm
- hadoop集群安装
---


## 1. 虚拟机设置（这里使用的是nat模式）

### 1.1 子网IP段和子网掩码
> vm>>编辑>>虚拟网络编辑器>>VMnet8>>勾选连接到此网络>>子网Ip和子网掩码设置

![image](http://ofyose6ar.bkt.clouddn.com/2016110101.png)

### 1.2 网关设置
> vm>>编辑>>虚拟网络编辑器>>VMnet8>>NAT设置

![image](http://ofyose6ar.bkt.clouddn.com/2016110102.png)

### 1.3 如果子网连不上宿主机或者宿主机ping通虚拟机
> 网络共享中心>>更改适配器设置>>VMnet8>>属性>>TCP/IPv4>>使用静态

![image](http://ofyose6ar.bkt.clouddn.com/2016110103.png)

## 2.虚拟机安装

### 2.1 虚拟机下载地址：
[http://www.centoscn.com/plus/download.php?open=2&id=2196&uhash=a6241d87fed784a11883750b](http://www.centoscn.com/plus/download.php?open=2&id=2196&uhash=a6241d87fed784a11883750b)
### 2.2 安装（略）

## 3. 虚拟机基本配置（root用户）

### 3.1 ip设置
> vi /etc/sysconfig/network-scripts/ifcfg-eth0 

```bash
DEVICE=eth0
BOOTPROTO=static
HWADDR=00:0C:29:89:7A:DC
ONBOOT=yes
IPADDR=192.168.136.111
NETMASK=255.255.255.0
GATEWAY=192.168.136.2
DNS1=192.168.136.2
```
### 3.2 修改主机名字
> vi /etc/sysconfig/network
```bash
NETWORKING=yes
NETWORKING_IPV6=no
HOSTNAME=cdh.master
```
### 3.3 创建hadoop用户
```bash
groupadd hadoop             #添加一个叫hadoop的用户组
useradd hadoop -g hadoop    #添加一个hadoop用户并加入hadoop组
```
### 3.4 赋予sudo权限
> vi /etc/sudoers
```bash
hadoop ALL=(ALL) ALL        #在sudoers尾部加上这一行
```

修改hostname:
vi /etc/sysconfig/network

修改hosts   #设置hosts文件，这样计算机之间就可以用计算机名来访问了
vi /etc/hsots

 service network restart

配置ssh免密码登录

ssh-keygen -t rsa -P ""

scp id_rsa.pub cdh.scm:/root/.ssh/id_rsa.pub.master
scp id_rsa.pub cdh.scm:/root/.ssh/id_rsa.pub.slave01
scp id_rsa.pub cdh.scm:/root/.ssh/id_rsa.pub.slave02
scp id_rsa.pub cdh.scm:/root/.ssh/id_rsa.pub.slave03

cat id_rsa.pub >> authorized_keys
cat id_rsa.pub.master >> authorized_keys
cat id_rsa.pub.slave01 >> authorized_keys
cat id_rsa.pub.slave02 >> authorized_keys
cat id_rsa.pub.slave03 >> authorized_keys

scp authorized_keys cdh.master:/root/.ssh/
scp authorized_keys cdh.slave01:/root/.ssh/
scp authorized_keys cdh.slave02:/root/.ssh/
scp authorized_keys cdh.slave03:/root/.ssh/

chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys

## 4. 配置JDK

> 建议用root用户安装，使用时配置环境变量

### 4.1 下载JDK（建议使用oraclejdk,不建议使用openjdk）
[http://www.oracle.com/technetwork/java/javase/index.html](http://www.oracle.com/technetwork/java/javase/index.html)

### 4.2 上传（略）

### 4.3 解压安装
这里上传到`/opt`目录下的
```bash 
tar -xzvf /opt/jdk-7u80-linux-x64.tar.gz     #解压
mv /opt/jdk1.7.0_80 /usr/local/jdk1.70_80 	 #移动到/usr/lcoal
```

### 4.4 给hadoop用户配置java环境
> vi ~/.bashrc
新增以下
```bash
export JAVA_HOME=/usr/local/jdk1.70_80
export PATH=$PATH:$JAVA_HOME/bin
```

### 切换回hadoop测试

echo $JAVA_HOME

输出

## 5. 克隆虚拟机

### 5.1 克隆2台

### 5.2 修改ip和网卡地址

Bringing up interface eth0:  Error: No suitable device found: no device found for connection 'System eth0'.

service network restart

### 5.3 测试

http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/cloudera-manager.repo
http://archive.cloudera.com/cm5/installer/5.4.5/cloudera-manager-installer.bin
http://101.96.10.60/archive.cloudera.com/cm5/redhat/6/x86_64/cm/5.4.5/RPMS/


rpm 安装顺序

enterprise-debuginfo-5.4.5-1.cm545.p0.5.el6.x86_64.rpm
cloudera-manager-daemons-5.4.5-1.cm545.p0.5.el6.x86_64.rpm
cloudera-manager-server-5.4.5-1.cm545.p0.5.el6.x86_64.rpm
cloudera-manager-server-db-2-5.4.5-1.cm545.p0.5.el6.x86_64.rpm
cloudera-manager-agent-5.4.5-1.cm545.p0.5.el6.x86_64.rpm

所依赖的服务：

yum -y install postgresql-server postgresql httpd perl bind-utils libxslt cyrus-sasl-gssapi redhat-lsb cyrus-sasl-plain portmap fuse fuse-libs nc python-setuptools

yum -y install httpd perl bind-utils libxslt cyrus-sasl-gssapi redhat-lsb cyrus-sasl-plain portmap fuse fuse-libs nc python-setuptools


安装报错：
SELinux is enabled. It must be disabled to install and use this product.

是由于没有关闭：SELinux

setenforce 0  临时关闭
修改 /etc/selinux/config 下的 SELINUX=disabled （重启后永久生效）


cp cloudera-manager.repo /etc/yum.repos.d

yum list|grep cloudera
#如果列出的不是你安装的版本，执行下面命令重试
yum clean all 
yum list | grep cloudera


yum -y install *.rpm


cp CDH-5.4.2-1.cdh5.4.2.p0.2-el6.parcel CDH-5.4.2-1.cdh5.4.2.p0.2-el6.parcel.sha manifest.json /opt/cloudera/parcel-repo

scp -r /opt/cdh cdh.slave01:/opt/
scp -r /opt/cdh cdh.slave02:/opt/
scp -r /opt/cdh cdh.slave03:/opt/


yum -y install ntp
chkconfig ntp no 
ntpdate -u ntp.sjtu.edu.cn

--- 一定要记住关闭防火墙 不然在yum的时候会报错 couldn't connect to host 或者一些另外的错误



恢复未完成的安装

rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera*

有的时候可能出现网路问题导致不能连接



错误： Package does not match intended download. Suggestion: run yum --enablerepo=cloudera-manager clean metadata
http://blog.csdn.net/huangyanlong/article/details/44050117

设置hosts 记着重启服务。

如果还是报错 yum clean all

Error: Cannot find a valid baseurl for repo: base

新增rpm
mkdir -p cm5/redhat/6/x86_64/cm/5/RPMS/x86_64/

将rpm拷贝到该路径


新增xml
mkdir cm5/redhat/6/x86_64/cm/5/repodata/


安装mysql 
然后db 配置mysql
启动scm
然后图形安装 报错
手动安装

yum install --skip-broken cloudera-manager-daemons-5.4.5-1.cm545.p0.5.el6.x86_64.rpm cloudera-manager-agent-5.4.5-1.cm545.p0.5.el6.x86_64.rpm

继续安装，然后这个包一直下载不了，自动安装 ：bigtop-tomcat
yum install --skip-broken 

由于依赖 bigtop-utils 那就又下载然后继续一起安装


yum install -y --skip-broken bigtop-tomcat-0.7.0+cdh5.4.5+0-1.cdh5.4.5.p0.8.el6.noarch.rpm bigtop-utils-0.7.0+cdh5.4.5+0-1.cdh5.4.5.p0.8.el6.noarch.rpm 

又来一个 hadoop-kms
yum install -y 

不行了，这个依赖的包太多了，只能放大招

把 archive.cloudera.com 映射到自己的机器上面。前提是：自己下载有完整的包

1、htdocs\cm5\redhat\6\x86_64  把下载的cdh目录拷贝到 htdocs\cm5\redhat\6\x86_64 目录下
2、设置hosts  172.16.100.23 archive.cloudera.com

172.16.100.23 为自己机器的 Apache2.2服务的机器
ping archive.cloudera.com ip为自己机器就行了


然而不知道为什么它要去找高版本，我的服务器上面只有5.4.5版本



放弃 使用这种方式

换一种 选择存储器的时候选择  parcel 方式

把 parcel拷贝到 /opt/cloudera/parcel-repo/ 目录下

忘记添加主机了 

关机 全部重启

service cloudera-scm-server start
service cloudera-scm-server restart

启动比较慢，如果是急性子可以看看日志

tail -f  /var/log/cloudera-scm-server/cloudera-scm-server.log

cdh安装中遇到“正在获取安装锁”
解决办法：进入/tmp 目录，ls -a查看，删除scm_prepare_node.*的文件，以及.scm_prepare_node.lock文件。 


数据库连接不上


grant all on cdh.* TO 'root'@'%' IDENTIFIED BY '123';

FLUSH   PRIVILEGES; 

返回 在继续

报错：JDBC driver cannot be found. Unable to find the JDBC database jar on host : cdh.slave01.
拷贝jar到该目录
/usr/share/java/mysql-connector-java.jar

/var/log/cloudera-scm-installer : 安装日志目录。 
/var/log/* : 相关日志文件（相关服务的及CM的）。 
/usr/lib64/cmf/ : Agent程序代码。 
/var/lib/cloudera-scm-server-db/data : 内嵌数据库目录。 
/usr/bin/postgres : 内嵌数据库程序。 
/etc/cloudera-scm-agent/ : agent的配置目录。 
/etc/cloudera-scm-server/ : server的配置目录。 
/etc/clouder-scm-server/db.properties 默认元数据库用户名密码配置 
/opt/cloudera/parcels/ : Hadoop相关服务安装目录。 
/opt/cloudera/parcel-repo/ : 下载的服务软件包数据，数据格式为parcels。 
/opt/cloudera/parcel-cache/ : 下载的服务软件包缓存数据。 
/etc/hadoop/* : 客户端配置文件目录。



1、机器选型
	小型机--百万级别--成本太高。不适用
	pcservice--第一选择（屌丝逆袭）
	云主机（阿里云、腾讯云、亚马逊云）--创业公司首选（资金不足，数据逐步增大）
 	pc--（实验环境）

2、软件选型
	oraclejdk
	hadoop:	
		a、apache
		b、cdh
		c、hdp
	os:
		centos6.5

3、网络设备








|机器 	|   	  |    	   |  	   |  	   | 	12 |
|-------|:-------:|:------:|:-----:|:-----:|:-----:|
|CDH 	|SCM* 	  |
|master |namenode | 	   | rm1   | 	   |zk     |
|slave01|namenode |datanode|rm 2   | nm    |ZK 	   |
|slave02|		  |datanode| 	   | nm    |ZK     |
|slave02|		  |datanode| 	   | nm    |ZK     |



##########################################################################################


1、使用lvm分区，然后安装centos分区

关闭防火墙：
service iptables stop
chkconfig iptables off

2、安装jdk


-----------------------------------------------------
3、克隆机器

service iptables stop
chkconfig iptables off

ifconfig 查看mac地址 
vi /etc/sysconfig/network-sicp/ifcfg-eth0

servcice network restart

-------------------------------------------------

4、在管理机器上面安装mysql
5、创建数据库
create database cdh DEFAULT CHARACTER SET utf8;
grant all on cdh.* TO 'root'@'%' IDENTIFIED BY '123';
flush privileges; #刷新权限


直接赋予超级权限：
grant all privileges on *.* to hive@"%"identified by "123456";
flush privileges; #刷新权限

5、上传jdbc包
-mkdir -p /usr/share/java/
- cp /opt /usr/share/java/mysql-connector-java.jar

6、使用官网中B的方式安装
7、安装cloudera-manager 这一些  安装顺序如下


cloudera-manager-daemons-5.4.5-1.cm545.p0.5.el6.x86_64.rpm
cloudera-manager-server-5.4.5-1.cm545.p0.5.el6.x86_64.rpm
cloudera-manager-agent-5.4.5-1.cm545.p0.5.el6.x86_64.rpm
enterprise-debuginfo-5.4.5-1.cm545.p0.5.el6.x86_64.rpm

#设置托管服务的数据库为mysql
sh /usr/share/cmf/schema/scm_prepare_database.sh mysql cdh root 123

不知道为什么设置了，还是要下载psotgrepsql

放大招： rpm -i --force --nodeps rpmname

cloudera-manager-server-db-2-5.4.5-1.cm545.p0.5.el6.x86_64.rpm




8、复制托管服务软件包到目录


---------------------------------------------------------------------------------------------
CDH-5.4.2-1.cdh5.4.2.p0.2-el6.parcel
manifest.json
CDH-5.4.2-1.cdh5.4.2.p0.2-el6.parcel.sha

将上面3个文件都拷贝到下以下目录
/opt/cloudera/parcel-repo

cp /opt/scm/CDH-5.4.2-1.cdh5.4.2.p0.2-el6.parcel /opt/scm/CDH-5.4.2-1.cdh5.4.2.p0.2-el6.parcel.sha /opt/scm/manifest.json /opt/cloudera/parcel-repo/

安装 cloudera-manager-agent-5.4.5-1.cm545.p0.5.el6.x86_64.rpm  cloudera-manager-daemons-5.4.5-1.cm545.p0.5.el6.x86_64.rpm

yum install -y --skip-broken cloudera-manager-daemons-5.4.5-1.cm545.p0.5.el6.x86_64.rpm cloudera-manager-agent-5.4.5-1.cm545.p0.5.el6.x86_64.rpm


添加hosts
10 修改 /etc/hosts

增加

192.168.136.10 cdh.scm
192.168.136.11 cdh.master
192.168.136.12 cdh.slave1
192.168.136.13 cdh.slave2
192.168.136.14 cdh.slave3

--------------------------------------------------------------------------------------------------

9、启动服务

tail -f  /var/log/cloudera-scm-server/cloudera-scm-server.log



10 修改 /etc/hosts

增加

172.16.3.31 kvm
172.16.3.32 cdh.scm
172.16.3.33 cdh.master
172.16.3.34 cdh.slave01
172.16.3.35 cdh.slave02
172.16.3.36 cdh.slave03

192.168.136.11 cdh.master
192.168.136.12 cdh.slave1
192.168.136.13 cdh.slave2
192.168.136.14 cdh.slave3



添加主机

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/defrag


/opt/mysql/bin/mysqld_safe --defaults-file=/opt/mysql/my.cnf

注意：
select host,user,password from mysql.user; 

mysql 通过主机名的密码是多少



内存大小问题
/etc/default/cloudera-scm-server

mysql 自动启动脚本有问题。
需要重新写一个


service cloudera-scm-server start
service cloudera-scm-server restart

Event Server 运行不良  一直找不到原因，后来发现 Selinux 没有关


setenforce 0  临时关闭
修改 /etc/selinux/config 下的 SELINUX=disabled （重启后永久生效）


Cloudera 建议将 /proc/sys/vm/swappiness 设置为 0。当前设置为 60。
echo 0 > /proc/sys/vm/swappiness

检查主机正确性时出现 “已启用“透明大页面”，它可能会导致重大的性能问题。” 的警告，进行如下设定
# vi /etc/sysctl.conf
vm.swappiness = 0
# sysctl –p

检查主机正确性时出现 “已启用“透明大页面”，它可能会导致重大的性能问题。” 的警告，进行如下设定
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/enabled


2016-11-25 15:33:34,586 WARN 358018152@scm-web-10:com.cloudera.server.web.cmf.EventsController: (2 skipped) Exception querying events
org.apache.avro.AvroRemoteException: java.net.ConnectException: 拒绝连接


create database cdh DEFAULT CHARACTER SET utf8;
create database hive DEFAULT CHARACTER SET utf8;
create database oozie DEFAULT CHARACTER SET utf8;

grant all on hive.* TO 'root'@'%' IDENTIFIED BY '123';
grant all on oozie.* TO 'root'@'%' IDENTIFIED BY '123';

grant all on hue.* to 'root'@'%' identified by '123';

flush privileges; #刷新权限

grant select,insert,update,delete on %.* to root@"cdh.scm" identified by "123456"; 



/etc/hadoop/conf.impala/hdfs-site.xml
/etc/hadoop/conf.empty/hdfs-site.xml
/usr/lib/hadoop-0.20-mapreduce/example-confs/conf.pseudo/hdfs-site.xml
/usr/lib/hadoop-0.20-mapreduce/example-confs/conf.secure/hdfs-site.xml
/usr/lib/spark-1.6.2/conf/hdfs-site.xml


52:54:00:FE:42:EA



sh /usr/share/cmf/schema/scm_prepare_database.sh mysql cdh root 123
sh /usr/share/cmf/schema/scm_prepare_database.sh mysql cdh root 123