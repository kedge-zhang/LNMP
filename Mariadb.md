#  [Centos 7x编译安装MariaDB-10.0.xx](http://www.cnblogs.com/hukey/p/6654285.html)

##1.安装jemalloc
```
#使用jemalloc对MySQL内存进行优化。

[root@mysql src]# tar xf jemalloc-4.2.0.tar.bz2 
[root@mysql src]# cd jemalloc-4.2.0
[root@mysql jemalloc-4.2.0]# ./configure --prefix=/usr/local/jemalloc
[root@mysql jemalloc-4.2.0]# make && make install 
[root@mysql jemalloc-4.2.0]# echo '/usr/local/jemalloc/lib/' > /etc/ld.so.conf.d/local.conf
[root@mysql jemalloc-4.2.0]# ldconfig
[root@mysql jemalloc-4.2.0]# ln -vs /usr/local/jemalloc/lib/libjemalloc.so.2 /usr/local/lib/libjemalloc.so
```

##2.安装mariadb
### 2.1 创建mysql（mariadb）用户
```
useradd -s /sbin/nologin -M mysql
```
### 2.2 创建软连接（方便mysql升级）
```
ln -s mariadb-10.2.4-linux-x86_64  mysql
```
### 2.3 创建数据目录并授权
```
mkdir -p /data/3306/mysql/{binlog,data,logs,undo}
chown -R mysql.mysql /data/3306
chown -R /usr/local/mysql
```
### 2.4编译
```
[root@mysql src]# tar xf mariadb-10.0.30.tar.gz 
[root@mysql src]# cd mariadb-10.0.30
[root@mysql mariadb-10.0.30]# yum install cmake openssl-devel zlib-devel ncurses-devel -y
[root@mysql mariadb-10.0.30]# mkdir -pv /data/mysql/{data,bin_log,run,log,tmp}
[root@mysql mariadb-10.0.30]# groupadd -g 3306 mysql
[root@mysql mariadb-10.0.30]# useradd -u 3306 -g 3306 -s /sbin/nologin -M mysql
[root@mysql mariadb-10.0.30]# cmake . -LH
[root@mysql mariadb-10.0.30]# cmake . \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/data/mysql/data \
-DTMPDIR=/usr/local/mysql/tmp \
-DMYSQL_UNIX_ADDR=/data/mysql/run/mysqld.sock \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1  \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1  \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1  \
-DWITH_TOKUDB_STORAGE_ENGINE=1 \
-DWITH_XTRADB_STORAGE_ENGINE=1  \
-DWITH_ARIA_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_SPHINX_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1  \
-DWITH_EXTRA_CHARSETS=all \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' \
-DWITH_SAFEMALLOC=OFF \
-DWITH_DEBUG=0 \
-DENABLE_PROFILING=1 \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DWITH_LIBWRAP=0

[root@bogon mariadb-10.0.30]# make && make install

```
2.4 mariadb配置文件my.cnf
```
[client]
port            = 3306
socket          = /data/3306/mysql/mysql.sock
loose-default-character-set = utf8
[mysqld]
port            = 3306
socket          = /data/3306/mysql/mysql.sock
pid-file        =/data/3306/mysql/mysql.pid
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
slow_query_log_file     = /data/3306/mysql/logs/mysql-slow.log
long_query_time         = 3 

log-error               = /data/3306/mysql/logs/mysql-error.log


log-bin                 = /data/3306/mysql/binlog/mysql-bin
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

innodb_undo_logs                =128
innodb_undo_tablespaces         =6
innodb_undo_directory           =/data/3306/mysql/undo

datadir                         =/data/3306/mysql/data
innodb_data_home_dir            = /data/3306/mysql/data
innodb_data_file_path           = ibdata1:1000M;ibdata2:1000M;ibdata3:1000M;ibdata4:100M:autoextend
innodb_log_group_home_dir       = /data/3306/mysql/data
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
### 2.5MariaDB数据库初始化
```
/usr/local/mysql/scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql/  --datadir=/data/3306/mysql/data/  --defaults-file=/etc/my.cnf 
```
### 2.6设置MariaDB环境变量
```
echo 'export MYSQL="/usr/local/mysql/"' >>.bash_profile 
echo 'export PATH="$MYSQL/bin:$PATH"' >>.bash_profile 
```
### 2.7配置MariaDB启动
```
cp  /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x  /etc/init.d/mysqld 
chkconfig --add  mysqld
chkconfig   mysqld on
/etc/init.d/mysqld start
``` 
### 2.8  配置MariaDB启动
```
cp  /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x  /etc/init.d/mysqld 
chkconfig --add  mysqld
chkconfig   mysqld on
/etc/init.d/mysqld start
```
### 2.9 MariaDB默认root密码为空，我们需要执行安全脚本
```
/usr/local/mysql/bin/mysql_secure_installation
```
这个脚本会弹出一些交互式问答，来进行MariaDB的安全设置
首先要输入root密码(root密码为空)
```
Enter current password for root (enter for none): 
```
如果出现如下错误需要做软连接
```
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
```
创建软连接
```
ln -s  /data/3306/mysql/mysql.sock  /tmp/mysql.sock
```
回车后继续执行
```
Set root password? [Y/n] 
```
设置root密码，默认选项为Yes，我们直接回车，提示输入密码，在这里设置您的MariaDB的root账户密码。
```
Set root password? [Y/n] y
New password: 
Re-enter new password:
```
是否移除匿名用户，默认选项为Yes，建议按默认设置，回车继续。

```
Remove anonymous users? [Y/n] 
```
是否禁止root用户远程登录？如果您只在本机内访问MariaDB，建议按默认设置，回车继续。 如果您还有其他云主机需要使用root账号访问该数据库，则需要选择n。
```
Remove test database and access to it? [Y/n]
```
是否删除测试用的数据库和权限？ 建议按照默认设置，回车继续。

```
Reload privilege tables now? [Y/n]
```
是否重新加载权限表？因为我们上面更新了root的密码，这里需要重新加载，回车。
```
Reload privilege tables now? [Y/n]
```
完成后你会看到success提示，MariaDB安全设置成功，接下来你可以登陆MariaDB了。
```
mysql -uroot -p
```
按提示输入root密码，就会进入MariaDB的交互界面，说明已经安装成功。

### 3 模块说明
```
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \     　　# 安装根目录
-DMYSQL_DATADIR=/data/mysql/data \     　　　　　# 数据存储目录
-DTMPDIR=/data/mysql/tmp \     　　　　　　　　　　# 临时文件存放目录
-DMYSQL_UNIX_ADDR=/data/mysql/run/mysqld.sock \     # UNIX socket文件
-DSYSCONFDIR=/etc \                     　　　　　　　　# 配置文件存放目录
-DWITH_MYISAM_STORAGE_ENGINE=1 \         　　 # Myisam 引擎支持
-DWITH_INNOBASE_STORAGE_ENGINE=1  \     　　# innoDB 引擎支持
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \         　  # ARCHIVE 引擎支持
-DWITH_BLACKHOLE_STORAGE_ENGINE=1  \     # BLACKHOLE 引擎支持
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \     # PERFSCHEMA 引擎支持
-DWITH_FEDERATED_STORAGE_ENGINE=1  \     # FEDERATEDX 引擎支持
-DWITH_TOKUDB_STORAGE_ENGINE=1 \         # TOKUDB 引擎支持
-DWITH_XTRADB_STORAGE_ENGINE=1  \         # XTRADB 引擎支持
-DWITH_ARIA_STORAGE_ENGINE=1 \             # ARIA 引擎支持
-DWITH_PARTITION_STORAGE_ENGINE=1 \     # PARTITION 引擎支持
-DWITH_SPHINX_STORAGE_ENGINE=1 \         # SPHINX 引擎支持
-DWITH_READLINE=1 \                     # readline库
-DMYSQL_TCP_PORT=3306 \                 # TCP/IP端口
-DENABLED_LOCAL_INFILE=1  \             # 启用加载本地数据
-DWITH_EXTRA_CHARSETS=all \             # 扩展支持编码 ( all | utf8,gbk,gb2312 | none )
-DEXTRA_CHARSETS=all \                     # 扩展字符支持
-DDEFAULT_CHARSET=utf8 \                 # 默认字符集
-DDEFAULT_COLLATION=utf8_general_ci \     # 默认字符校对
-DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' \ # Jemalloc内存管理库
-DWITH_SAFEMALLOC=OFF \                 # 关闭默认内存管理
-DWITH_DEBUG=0 \                        # 关闭调试模式        
-DENABLE_PROFILING=1 \                     # 启用性能分析功能
-DWITH_SSL=system \                        # 使用系统上的自带的SSL库
-DWITH_ZLIB=system \                     # 使用系统上的自带的zlib库
-DWITH_LIBWRAP=0                         # 禁用libwrap库
```
