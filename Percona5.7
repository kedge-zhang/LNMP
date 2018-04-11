#MYSQL 5.7

## 1.简介
* 更好的性能：对于多核CPU、固态硬盘、锁有着更好的优化，每秒100W QPS已不再是MySQL的追求，下个版本能否上200W QPS才是吾等用户更关心的
* 更好的InnoDB存储引擎
* 更为健壮的复制功能：复制带来了数据完全不丢失的方案，传统金融客户也可以选择使用MySQL数据库。此外，GTID在线平滑升级也变得可能
* 更好的优化器：优化器代码重构的意义将在这个版本及以后的版本中带来巨大的改进，Oracle官方正在解决MySQL之前最大的难题
* 原生JSON类型的支持
* 更好的地理信息服务支持：InnoDB原生支持地理位置类型，支持GeoJSON，GeoHash特性
* 新增sys库：以后这会是DBA访问最频繁的库 

## 2.源码
* 1.percona5.7
```
wget https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-5.7.21-20/source/tarball/percona-server-5.7.21-20.tar.gz
```
* 2.boost_1_59_0
```
wget https://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz/download
```

## 3.依赖
```
yum install  zlib zlib-devel readline-devel git gcc gcc-c++ make cmake bison bison-devel ncurses-devel libaio-devel perl -y
```
## 4.编译

* groupadd -g 501 mysql  &&  useradd -r -s /sbin/nologin -g 501 -u 501 mysql
* mkdir -p /data/mysql/{data,binlog,logs,undo} &&  chown -R mysql.mysql /data/mysql/

```
> cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/Percona5.7 \
-DMYSQL_DATADIR=/data/mysql/data \
-DWITH_BOOST=/usr/local/boost \
-DSYSCONFDIR=/etc \
-DMYSQL_UNIX_ADDR=/data/mysql/mysql.sock \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_EDITLINE=bundled  \
-DMYSQL_TCP_PORT=3306 \
-DEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci \
-DENABLED_LOCAL_INFILE=1 \
-DEXTRA_CHARSETS=all \
-DMYSQL_USER=mysql
```

* ./bin/mysqld --initialize-insecure --user=mysql --basedir=/usr/local/Percona5.7 --datadir=/data/mysql/data --innodb_undo_tablespaces=3
* cp support-files/mysql.server /etc/init.d/mysqld
