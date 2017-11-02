# mysql

## 1.安装依赖
```
yum -y install gcc gcc-c++  make cmake automake  autoconf libxml2 libxml2-devel zlib zlib-devel ncurses ncurses-devel readline-devel
```
## 2.获取安装包
```
#5.6
wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.36.tar.gz

5.7 
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18.tar.gz

#5.7（含有boost）
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.18.tar.gz
````
## 3.mysql 安装
### 3.1 新建用户
```
useradd -s /sbin/nologin -M mysql
```
### 3.2 解压编译
```
1. tar fvx mysql-5.6.36.tar.gz

2. cd  mysql-5.6.36/

3. cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DSYSCONFDIR=/etc \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DMYSQL_UNIX_ADDR=/var/run/mysql.sock 
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DMYSQL_USER=mysql \
-DWITH_MYISAM_STORAGE_ENGINE=1

4.make && make install
```
## 4.初始化
### 4.1 目录 、授权
```
mkdir -p /data/mysql/{binlog,data,logs,undo}
chown -R mysql.mysql /data/mysql
chown -R mysql.mysql /usr/local/mysql
```
### 4.2 初始化
```
/usr/local/mysql/scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql/  --datadir=/data/mysql/data/  --defaults-file=/etc/my.cnf 
```

## 5.配置启动
```
echo 'export MYSQL="/usr/local/mysql/"' >> /root/.bash_profile 
echo 'export PATH="$MYSQL/bin:$PATH"' >> /root/.bash_profile 
source /root/.bash_profile

cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x  /etc/init.d/mysqld 
chkconfig --add  mysqld
chkconfig   mysqld on
/etc/init.d/mysqld start
```
## 6.设置密码
```
1.设置密码
# /usr/local/mysql/bin/mysql_secure_installation

2.修改密码
# use mysql;
# select user,host,password from user;
# update user set password=password('这里是密码') where  user='root';
# flush privileges;
```
## 7.start || shutdown
### 7.1start
```
mysqld [--defaults-file=/etc/my.cnf] [--user=mysql] [--pid-file=/var/lib/mysql/3306.pid] &
./mysqld_safe --defaults-file=/data/mysql3307/etc/my.cnf --user=mysql &
客户端连接:mysql --defaults-file=/data/mysql3307/etc/my.cnf
            or
		     	mysql -S /var/run/mysql.sock
```
### 7.2shutdown
```
mysqladmin -uroot -pxxx shutdown -S /var/run/mysql.sock
```

