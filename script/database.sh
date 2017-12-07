#!/bin/bash

################################
#Job_Name= Install Percona-server
#Auth=kedge.zhang
#TIME=2017/12/7
################################

alias_name=mysql
mname=mysql-5.6.36
pname=percona-server-5.6.36-82.0
install_mname=mysql-5.6.36.tar.gz
install_pname=percona-server-5.6.36-82.0.tar.gz
install_path=/usr/local
package_path=${install_path}/src

function version() {
cat << EOF
*******************************************************
*  "Plese choose mysql version you want to install"   *
*          1. mysql for mysql5.6.36                   *
*          2. mysql for percona5.6.36                 *
*          default tengine for mysql-5.7.18           *
*******************************************************
EOF
}

## Check login
function check_root() {
if [ $UID -ne 0 ]
then 
     echo "please login as user root" >/root/.install_log
     return 0
fi
} 

## check user mysql
function check_mysql() {
gflag= `cat /etc/group | grep mysql`
[ -n "$gflag" ] && edownload_databasecho "group 'mysql' already exists"  || groupadd mysql
uflag=`cat  /etc/passwd  | grep mysql`
[ -n "$uflag" ] && echo "user 'mysql' already exists" ||  useradd -r mysql -g mysql -s /sbin/nologin
}

##  download database
function download_database(){
read -p "Plese choose databases version you want to install:" version

case $version in 
"1")
  yum -y install gcc gcc-c++  make cmake automake  autoconf libxml2 libxml2-devel zlib zlib-devel ncurses ncurses-devel readline-devel
  if [ -f ${package_path}/${install_mname} ];then
    echo "$install_mname 存在" >> /dev/null 2>&1
    cd $package_path && tar fx ${install_mname} && cd $mname
  else
    echo "$install_mname 不存在" >> /root/.install_log
    cd ${install_path}/src
    wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.36.tar.gz
  fi

  if [ $? = 0 ]; then
    cd $package_path && tar fx ${install_mname} && cd $mname
  else
    echo "wget failed mysql5.6" >> /root/.install_log
    return 1
  fi
  ;;

"2")
  yum -y install gcc gcc-c++  make cmake automake  autoconf libxml2 libxml2-devel zlib zlib-devel ncurses ncurses-devel readline-devel
  if [ -f ${package_path}/${install_mname} ];then
    echo "$install_pname 存在" > /dev/null 2>&1
    cd $package_path && tar fx ${install_pname} &&  cd $pname
  else
    echo "$install_pname 不存在" >> /root/.install_log
    cd ${install_path}/src
    wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.36-82.0/source/tarball/percona-server-5.6.36-82.0.tar.gz
  fi

  if [ $? = 0 ]; then
    cd $package_path && tar fx ${install_pname} &&  cd $pname
  else
    echo "wget failed percona5.6" >> /root/.install_log
    return 1
  fi
  ;;
*)
echo "傻逼，去你妈滴！"
exit 3
  ;;
esac
  }

function install_databases() {
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DMYSQL_UNIX_ADDR=/data/mysql/mysql.sock -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DMYSQL_USER=mysql -DWITH_MYISAM_STORAGE_ENGINE=1

make && make install
}

function mkdir_chown() {
mkdir -p /data/mysql/{binlog,data,logs,undo}
chown -R mysql.mysql /data/mysql
chown -R mysql.mysql /usr/local/mysql
}

function touch_cnf() {
mv /etc/my.cnf /etc/my.cnf.bak
cat > /etc/my.cnf << EOF
[client]
port            = 3306
socket          = /data/mysql/mysql.sock
loose-default-character-set = utf8

[mysqld]
port            = 3306
socket          = /data/mysql/mysql.sock
pid-file        =/data/mysql/mysql.pid
datadir         =/data/mysql/data
character-set-server   = utf8
default-storage-engine = InnoDB

slow_query_log          = ON
slow_query_log_file     = /data/mysql/binlog/mysql-slow.log
long_query_time         = 3

log-error               = /data/mysql/logs/mysql-error.log
log-bin                 = /data/mysql/binlog/mysql-bin
#relay_log               = mysql-relay-bin
binlog_format           = row

tmpdir                  = /tmp
EOF
  }

function  initialize_databases(){
/usr/local/mysql/scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql/  --datadir=/data/mysql/data/  --defaults-file=/etc/my.cnf >>/root/install.log 2>&1 &
sleep 30s
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x  /etc/init.d/mysqld  && chkconfig --add  mysqld && chkconfig   mysqld on
/etc/init.d/mysqld start
  }

function env_databases() {
sed -i 's/^PATH.*/&:\/usr\/local\/mysql\/bin/g' /root/.bash_profile
source /root/.bash_profile
/usr/local/mysql/bin/mysql_secure_installation
  }  

function main() {
version
check_root
check_mysql
download_database
install_databases
mkdir_chown
touch_cnf
initialize_databases
env_databases
}
main

