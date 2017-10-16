# Percona-Server
## 1.准备工作
```
1.安装依赖
# yum -y install gcc gcc-c++  make cmake automake  autoconf libxml2 libxml2-devel zlib zlib-devel ncurses ncurses-devel readline-devel

2.获取源码包
wget  https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-5.7.18-15/source/tarball/percona-server-5.7.18-15.tar.gz
或
wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.36-82.0/source/tarball/percona-server-5.6.36-82.0.tar.gz
```
## 2. 部署过程

```
# useradd -s /sbin/nologin -M mysql
# tar fvx percona-server-5.6.36-82.0.tar.gz  -C /usr/local/src/
# cd /usr/local/src/percona-server-5.6.36-82.0/

# cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql/ -DSYSCONFDIR=/etc -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DMYSQL_UNIX_ADDR=/var/run/mysql.sock -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DMYSQL_USER=mysql
# make && make install
```
## 3.初始化
```
# mkdir -p /data/mysql/{binlog,data,logs,undo}
# chown -R mysql.mysql /data/mysql
# chown -R mysql.mysql /usr/local/mysql

# /usr/local/mysql/scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql/  --datadir=/data/mysql/data/  --defaults-file=/etc/my.cnf 
```
## 4.配置启动
```
# echo 'export MYSQL="/usr/local/mysql/"' >> /root/.bash_profile 
# echo 'export PATH="$MYSQL/bin:$PATH"' >> /root/.bash_profile 
# source /root/.bash_profile

# cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
# chmod +x  /etc/init.d/mysqld 
# chkconfig --add  mysqld
# chkconfig   mysqld on
# /etc/init.d/mysqld start
```
## 5.设置密码
```
#/usr/local/mysql/bin/mysql_secure_installation

# use mysql;
# select user,host,password from user;
# update user set password=password('这里是密码') where  user='root';
# flush privileges;
```
## 6.my.cnf实例
```
[client]
port            = 3306
socket          = /data/mysql/mysql.sock
loose-default-character-set = utf8
[mysqld]
port            = 3306
socket          = /data/mysql/mysql.sock
pid-file        =/data/mysql/mysql.pid
server-id              = 20
character-set-server   = utf8
default-storage-engine = InnoDB

extra_max_connections=3

default-time-zone='+8:00'

lc-messages_dir=/usr/local/mysql/share
lc-messages=en_US
skip-slave-start
skip-name-resolve
skip-external-locking
log-slave-updates
#slave-skip-errors        = 1062,1146
#userstat_running         =1

lock_wait_timeout        = 10

#crash safe options
#relay_log_recovery        =1
#master_info_repository    =TABLE
#relay_log_info_repository =TABLE

back_log                = 500
max_allowed_packet      = 1073741824
table_open_cache             = 8192
max_connections         = 20000
max_connect_errors      = 800

key_buffer_size              = 128M
sort_buffer_size        = 8M
read_buffer_size        = 2M
read_rnd_buffer_size    = 8M
join_buffer_size        = 4M
tmp_table_size          = 512M
max_heap_table_size     = 512M
binlog_cache_size       = 8M
myisam_sort_buffer_size = 64M
thread_cache_size       = 500
query_cache_size        = 0M

slow_query_log          = ON
slow_query_log_file     = /data/mysql/binlog/mysql-binmysql/logs/mysql-slow.log
long_query_time         = 3 

log-error               = /data/mysql/logs/mysql-error.log


log-bin                 = /data/mysql/binlog/mysql-bin
#relay_log               = mysql-relay-bin
binlog_format           = row 

tmpdir                  = /tmp
#thread_concurrency      = 16


secure_auth        = 1
local-infile       = 0
event_scheduler    = OFF
explicit_defaults_for_timestamp=on


innodb_file_per_table    = 1
innodb_file_format       = barracuda
#innodb_file_format_check = barracuda
innodb_open_files        = 4096


#undo file location info

#innodb_undo_logs                =128
#innodb_undo_tablespaces         =6
#innodb_undo_directory           =/data/mysql/undo

datadir                         =/data/mysql/data
innodb_data_home_dir            = /data/mysql/data
innodb_data_file_path           = ibdata1:1000M;ibdata2:1000M;ibdata3:1000M;ibdata4:100M:autoextend
innodb_log_group_home_dir       = /data/mysql/data
innodb_table_locks              = 0
innodb_buffer_pool_size         = 6G

#innodb_additional_mem_pool_size = 16M
innodb_log_file_size            = 512M
innodb_log_files_in_group       = 2
innodb_log_buffer_size          = 100M
innodb_flush_method             = O_DIRECT
innodb_flush_log_at_trx_commit  = 0
innodb_old_blocks_time          =1000
innodb_stats_on_metadata        = OFF
#log_slow_verbosity     = microtime,innodb
slave_net_timeout      =60

#set innodb hi partitions
innodb_buffer_pool_populate=1
thread_pool_size        = 50
thread_handling=pool-of-threads
thread_pool_oversubscribe= 40

innodb_max_dirty_pages_pct      = 60      
innodb_write_io_threads         = 16         
innodb_read_io_threads          = 8           
innodb_adaptive_flushing        = 1  
#innodb_adaptive_checkpoint      = changecheckpoint_before_use
innodb_io_capacity              = 200         
#innodb_thread_concurrency       = threadconcurrency_before_use
sync_binlog                     = 100

[mysqldump]
quick
max_allowed_packet = 64M

[mysql]
no-auto-rehash
max_allowed_packet      = 64M
prompt="\\u@\\h> "
no-auto-rehash
show-warnings

[isamchk]
key_buffer       = 256M
sort_buffer_size = 256M
read_buffer      = 2M
write_buffer     = 2M

[myisamchk]
key_buffer       = 256M
sort_buffer_size = 256M
read_buffer      = 2M
write_buffer     = 2M

[mysqlhotcopy]
interactive-timeout
```
