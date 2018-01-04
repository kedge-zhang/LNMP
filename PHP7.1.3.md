# PHP-7.1.3
## 1.安装
### 1.1 环境部署
```
##解决依赖
yum install gcc gcc-c++  libxml2 libxml2-devel curl  curl-devel libwebp.x86_64  libwebp-devel.x86_64 libwebp-tools.x86_64 libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxslt  libxslt-devel -y net-snmp net-snmp-devel bzip2-devel libmcrypt libmcrypt-devel readline readline-devel
##获取PHP
wget http://cn2.php.net/get/php-7.1.3.tar.gz/from/this/mirror
wget http://cn2.php.net/get/php-5.6.32.tar.gz/from/this/mirror
tar zxvf php-7.1.3.tar.gz && 不错cd php-7.1.10
```

### 2.2 模块解析及加载
#### 2.1 模块释义
```
   """ 安装目录 """
./configure --prefix=/usr/local/php7 \
 --with-config-file-path=/usr/local/php/etc \
   """ 整合 apache，apxs功能是使用mod_so中的LoadModule指令，加载指定模块到 apache，要求 apache 要打开SO模块 """
 --with-apxs2=/usr/local/apache/bin/apxs \
   """ 优化选项 """ 
 --enable-inline-optimization \
 --disable-debug \
 --disable-rpath \
 -enable-shared \
   """ 启用 opcache，默认为 ZendOptimizer+(ZendOpcache) """
 --enable-opcache \
   """ FPM """
 --enable-fpm \
 --with-fpm-user=www \
 --with-fpm-group=www \
   """ MySQL """
 --with-mysqli=mysqlnd \
 --with-pdo-mysql=mysqlnd \
 --with-pdo-sqlite \
   """ 国际化与字符编码支持 """
 --with-gettext \
 -enable-mbstring \
 --with-iconv \
   """ 加密算法扩展 """
 --with-mcrypt \
 --with-mhash \
 --with-openssl \
   """ 打开对jpeg图片的支持 """
 --with-jpeg-dir \  
   """ 打开对png图片的支持 """ 
 --with-png-dir \ 
   """ 打开对freetype字体库的支持 """
 --with-freetype-dir \
   """ 打开libxml2库的支持 """ 
 --with-libXML-dir \
    """ 打开xml-rpc的c语言 """
 --with-XMLrpc \
   """ 打开gd库的支持 """
 --with-gd \
   """ 数学扩展,打开图片大小调整,用到zabbix监控的时候用到了这个模块 """
 --enable-bcmath \
   """ Web 服务，soap 依赖 libxml """
 --enable-soap \
 --with-libxml-dir \
  """ 进程，信号及内存 """
 --enable-pcntl \
 --enable-shmop \
 -enable-sysvmsg \
 -enable-sysvsem \
 --enable-sysvshm \
   """ socket & curl,打开curl浏览工具的支持  """
 --enable-sockets \
 --with-curl \
   """ 压缩与归档 """
 --with-zlib \
 -enable-zip \
 --with-bz2 \
   """ 打开pear命令的支持，PHP扩展用 """
 --with-pear \  
   """ perl的正则库案安装位置 """  
 --with-pcre-dir \
   """支持FTP"""
 --enable-ftp \   
  """ GNU Readline 命令行快捷键绑定 """
 --with-readline

## 1.指定了--with-apxs2=/usr/local/apache/bin/apxs以后，就不要再激活--enable-fpm和--enable-fastCGI，apxs是以php module的模式加载PHP的。

## 2.Mysql在编译了Mysql开发library以后，可以不用指定mysql的路径。

## 3. PHP编译存在基础的依赖的关系，编译PHP首先需要安装XML扩展，因为php5核心默认打开了XML的支持，其他的基础库，相应需要：

GD -> zlib, Png, Jpg, 如果需要支持其他，仍需要根据实际情况编译扩展库，ttf库需要freetype库的支持。

--enable-magic-quotes，是一个极其不推荐的参数，当然，如果你需要PHP为你做这些底下的工作，实际上他也没有很彻底的解决问题。

--with-openssl，需要openssl库。

mysqli是MySQL团队提供的MySQL驱动，具有很多实用的功能和典型特征。不过他不是MySQL于PHP平台最好的选择，PDO被证实，是一个简易、高并发性，而且易于创建和回收的标准接口。不过PDO也经历了5.3以前的内存溢出的问题，在5.3以后，在读取Oracle的LOB资源时，若不对内存进行限制，仍会内存溢出。  

如果是产品模式，好像pear、shmop、ftp等，都不推荐使用，他们要做的事情，用C/C++，用Java，甚至其他脚本语言，都有很好很快速的选择，无需局限于使用PHP去实现。不熟悉的类库和不常用的库，也不推荐使用。magic-quote、session.auto_start、PHP服务器信息、PHP报错信息等在编译完成后，应该第一时间关闭，避免暴露服务器信息。

PHP对应的Web Server模式，Module、fastcgi、fpm只需要一种即可，服务器不是你的试验田。fastcgi可以选择Nginx和lighttpd，其实Nginx也是使用lighttpd的spwan-fcgi进行fcgi进程管理的。fpm是使用PHP自身去管理多进程，有点类似一个后端代理。无论什么模式，在发布产品服务器，都应该做进程和线程调优，做足够多的压力测试，找出最好的进程数组合。

选好一种PHP OPCode cache的扩展，这个也是很重要的，linux 2.6核心下，fcgi下，xcache有较好的实践经验，其他的在并发数增加以后，性能衰减严重。
```

#### 2.2.2 模块编译
```
./configure --prefix=/usr/local/php7 \
 --with-config-file-path=/usr/local/php7/etc \
 --enable-inline-optimization \
 --disable-debug \
 --disable-rpath \
 -enable-shared \
 --enable-opcache \
 --enable-fpm \
 --with-fpm-user=www \
 --with-fpm-group=www \
 --with-mysqli=mysqlnd \
 --with-pdo-mysql=mysqlnd \
 --with-pdo-sqlite \
 --with-gettext \
 -enable-mbstring \
 --with-iconv \
 --with-mcrypt \
 --with-mhash \
 --with-openssl \
 --with-jpeg-dir \
 --with-png-dir \
 --with-freetype-dir \
 --with-libxml-dir \
 --with-xmlrpc \
 --with-gd \
 --enable-bcmath \
 --enable-soap \
 --with-libxml-dir \
 --enable-pcntl \
 --enable-shmop \
 -enable-sysvmsg \
 -enable-sysvsem \
 --enable-sysvshm \
 --enable-sockets \
 --with-curl \
 --with-zlib \
 -enable-zip \
 --with-bz2 \
 --with-pear \
 --with-pcre-dir \
 --enable-ftp \
 --with-readline
 --enable-mysqlnd-compression-support
```
## 2.3 后续配置
```
#1. cp php.ini-development /usr/local/php7/lib/php.ini
#2. cp -R ./sapi/fpm/php-fpm  /etc/init.d/php-fpm
#3. chmod +x  /etc/init.d/php-fpm
```
