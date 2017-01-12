---
title: centos源码安装mysql5.1.28
date: 2016-11-14 20::49:45
categories: mysql
tags: 
- mysql
- 源码
- centos
---

## 1. centos配置

### 1.1 安装需要用到的软件
ncurses-devel：编译的时候需要，没有的话：configure: error: No curses/termcap library found
gcc-c++：安装的时候需要，没有的话：../depcomp: line 512: exec: g++: not found
```bash
yum -y install gcc-c++ ncurses-devel
```
### 1.2 创建mysql 用户
```bash
groupadd mysql
useradd -g mysql mysql
```


## 2. 下载

下载mysql的安装包 ** 5.1版本以前用configure进行编译，5.1之后的版本用cmake进行编译。**


## 3. 解压安装

### 3.1 解压
解压到`/opt`目录下
```bash
tar -axvf mysql-5.1.28-rc.tar.gz -C /opt
```

### 3.2 编译
--prefix：安装目录   
--with-charset：字符集编码  
--with-plugins：存储引擎
```bash
./configure --prefix=/opt/mysql  --with-charset=utf8 --with-plugins=innobase
```

### 3.3 安装
```bash
make
make install
```

## 4. 配置与初始化

### 4.1 修改my.cnf

系统默认是按/etc/my.cnf-----/etc/mysql/my.cnf----/opt/mysql/my.cnf的顺序读取配置文件的，当有多个配置文件时，mysql会以读取到的最后一个配置文件中的参数为准。  
具体优化就不说了，这里就基本配置。 
在安装目录下share/mysql/ 下找到my-medium.cnf,，将它拷贝到安装目录并且重命名为my.cnf
```bash
# 修改下面3个参数   /opt/mysql 为安装目录
datadir=/opt/mysql/var
socket=/opt/mysql/mysql.sock
basedir=/opt/mysql
```

### 4.2 mysql服务启动脚本
```bash
cp support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig mysql on
``` 

### 4.3 初始化数据库表
```bash
chown mysql.mysql -R /opt/mysql

./mysql/bin/mysql_install_db --user=root --datadir=/opt/mysql/var
```

### 4.4 启动数据库

```bash
./mysql/bin/mysqld_safe --defaults-file=/opt/mysql/my.cnf

#如果报错要学会看错误日志：
more /opt/mysql/var/cdh.scm.err

```
### 4.5 修改密码并进入数据库
```bash
./mysql/bin/mysqladmin -h '127.0.0.1' -u root password 123
./mysql/bin/mysql -h '127.0.0.1' -u root -p
```

## 5. 可能遇到的错误 
### 5.1 fatal error: Can't change to run as user 'mysql' ;  Please check that the user exists! 
```bash
rm -rf /etc/my.cnf 
```
然后在重新初始化数据库表 ok 成功

### 5.2 unknown option '--skip-federated'

将my.cnf文件中的skip-federated注释掉即可