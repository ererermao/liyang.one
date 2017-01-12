---
title: centos下mysqld的service服务
date: 2016-11-16 14:27:25
categories: mysql
tags: 
- centos
- mysql
- mysqld
- service
---

> linux下有的软件启动很麻烦，跟一大堆参数，比如指定配置文件路径、以何种模式启动神马的，等等。而我们装上appache或者mysql后，就可以使用service httpd start来启动，很是方便，service命令其实是跑一个shell脚本来管理，这样的话，我们自己手动写个shell脚本就可以实现service anything doanything了。另外，用chkconfig命令设置开机自动启动一个服务，该服务必须是系统服务，否则用chkconfig设置是会报错的。这样的话，把一些服务注册为系统服务，确实还是蛮必须的。而注册成系统服务，就是这个service…


&emsp;&emsp;当我们输入service命令时，linux会去/etc/rc.d/init.d下去找这个脚本运行。init.d下面放的就是很多脚本，比如service svnd start时，就去/etc/rc.d/init.d下找svnd这个脚本文件，如果这个文件不存在，则会提示不存在这个服务。所以，这个就好办了，只要在init.d目录下写个脚本，就可以用service命令在任何地方执行了。

## 1. centos注册mysql服务

&emsp;&emsp;在`/etc/init.d/`目录下创建mysql的脚本：``
```bash
#!/bin/bash
###################################################
#
#   MySQL start and stop script
#
#
###################################################
basedir=/home/falcon/mysql
datadir=/home/falcon/mysql/3306
conf=$basedir/etc/3306.cnf
mysql_user=falcon
###################################################
bindir=$basedir/bin
server_pid_file=$datadir/`/bin/hostname`.pid
pid_file=$server_pid_file
other_args="--user=$mysql_user"
PATH=/sbin:/usr/sbin:/bin:/usr/bin:$basedir/bin
export PATH
mode=$1    # start or stop
shift

#
# Use LSB init script functions for printing messages, if possible
#
lsb_functions="/lib/lsb/init-functions"
if test -f $lsb_functions ; then
  source $lsb_functions
else
  log_success_msg()
  {
    echo " SUCCESS! $@"
  }
  log_failure_msg()
  {
    echo " ERROR! $@"
  }
fi
wait_for_pid () {
  i=0
  while test $i -lt 35 ; do
    sleep 1
    case "$1" in
      'created')
        test -s $pid_file && i='' && break
        ;;
      'removed')
        test ! -s $pid_file && i='' && break
        ;;
      *)
        echo "wait_for_pid () usage: wait_for_pid created|removed"
        exit 1
        ;;
    esac
    echo $echo_n ".$echo_c"
    i=`expr $i + 1`
  done
  if test -z "$i" ; then
    log_success_msg
  else
    log_failure_msg
  fi
}

# Safeguard (relative paths, core dumps..)
cd $basedir
case "$mode" in
  'start')
    # Start daemon
    
    if test -s "$server_pid_file"
    then
echo "MySQL is running now ..."
exit 1
    fi
    echo $echo_n "Starting MySQL"
    if test -x $bindir/mysqld_safe
    then
      # Give extra arguments to mysqld with the my.cnf file. This script
      # may be overwritten at next upgrade.
      pid_file=$server_pid_file
      $bindir/mysqld_safe --defaults-file=$conf --datadir=$datadir --pid-file=$server_pid_file $other_args >/dev/null 2>&1 &
      wait_for_pid created
    else
      log_failure_msg "Couldn't find MySQL manager or server"
    fi
    ;;
  'stop')
    # Stop daemon. We use a signal here to avoid having to know the
    # root password.
    if test -s "$pid_file"
    then
      mysqlmanager_pid=`cat $pid_file`
      echo $echo_n "Shutting down MySQL"
      kill $mysqlmanager_pid
      # mysqlmanager should remove the pid_file when it exits, so wait for it.
      wait_for_pid removed
    else
      log_failure_msg "MySQL manager or server PID file could not be found!"
    fi
    ;;
  'restart')
    # Stop the service and regardless of whether it was
    # running or not, start it again.
    $0 stop  $other_args
    $0 start $other_args
    ;;
  'reload')
    if test -s "$server_pid_file" ; then
      mysqld_pid=`cat $server_pid_file`
      kill -HUP $mysqld_pid && log_success_msg "Reloading service MySQL"
      touch $server_pid_file
    else
      log_failure_msg "MySQL PID file could not be found!"
    fi
    ;;
  *)
    # usage
    echo "Usage: $0  {start|stop|restart|reload}  [ MySQL server options ]"
    exit 1
    ;;
esac
```

简化版的：
```bash
 
#!/bin/bash
#######################################################
basedir=/home/falcon/mysql
datadir=/home/falcon/data/10000
conf=$basedir/etc/10000.cnf
#######################################################

pid_file=$datadir/`/bin/hostname`.pid
MYSQLD="$basedir/bin/mysqld_safe --defaults-file=$conf"
usage(){
 echo "usage:"
 echo "  $0 start|stop|status "
 exit 1
}
if test -z $1
then
 usage
fi
STATUS=$pid_file
case "$1" in
 "start")
  if test -s "$STATUS"
  then
   echo "The MySQL is running ..."
   echo $pid_file
   exit 1
  fi
  if test -s "$STATUS"
  then
   echo "The MySQL start fail ..."
  else
   
   $MYSQLD > /dev/null 2>&1 &
  fi
 ;;
 "stop")
  pid=`cat $pid_file`
  `kill $pid > /dev/null 2>&1`
  echo "The MySQL is stop ..."
 ;;
 "reload")
  pid=`cat $pid_file`
  `kill -HUP $pid > /dev/null 2>&1`
 ;;
 "status")
 if test -s "$STATUS"
 then
 echo "The MySQL is running..."
 else
 echo "The MySQL is down..."
 fi
 ;;
 *)
 usage
 ;;
esac
exit 1
```

## 2. 设置
&emsp;&emsp;对文件添加可执行权限`chmod +x mysqld`

## 3. 测试

```bash
servcie mysqld status
```

## 4. 设置chkconfig

在脚本的前面几行加入下面句话，开头带`#`
```bash
# chkconfig: 2345 08 92
# description:  Starts, stops and saves iptables firewall
```

## 5. 开机自动启动
```bash
chkconfig mysqld on
```