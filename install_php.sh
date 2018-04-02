#!/bin/bash
Zero="0"
#version="版本号"
home_path=/usr/local
code_path=/usr/local/src

## login root
echo  -e "\033[31m ###################### 环境检测 ###################### \033[0m"
sleep 1;
if [ $UID -ne 0 ];
then
     echo "please login as user root"
     return 0
fi

old_port=`netstat -ntlp | grep php-fpm | grep -v grep | awk '{print $4}'`
old_pid=`netstat -ntlp | grep php-fpm | grep -v grep | awk '{print $7}'`
[ -n ${old_pid} ] &&  echo -e "\033[31m 服务器已安装php,详细情况如下 \033[0m" && echo -e "\033[31m ${old_port}  ${old_pid} \033[0m"

## 选择可安装的php版本号
echo  -e "\033[31m ###################### 提供安装版本 ###################### \033[0m"
cat << EOF
*******************************************************
*  "Plese choose php version you want to install"     *
*                1. php-5.6.33                        *
*                2. php-7.0.27                        *
*                3. php-7.2.1                         *
*             default PHP for php-7.1.13              *
*******************************************************
EOF

## downloading php
echo  -e "\033[31m ###################### 下载PHP ###################### \033[0m"
read -p "Plese choose php verison you want to install:" num

cd ${code_path}
[ -f mirror ] && rm -rf mirror
case $num in
  "1") version="php-5.6.33" && echo "downloading php-5.6.33" && wget  http://hk2.php.net/get/php-5.6.33.tar.gz/from/this/mirror && [ $? -ne 0 ] && echo "php5.6.33 下载失败" && exit
  ;;
  "2") version="php-7.0.27" && echo "downloading php-7.0.27" && wget  http://hk2.php.net/get/php-7.0.27.tar.gz/from/this/mirror && [ $? -ne 0 ] && echo "php7.0.27 下载失败" && exit
  ;;
  "3") version="php-7.2.1" && echo "downloading php-7.2.1"  && wget  http://hk2.php.net/get/php-7.2.1.tar.gz/from/this/mirror  && [ $? -ne 0 ] && echo "php7.2.1 下载失败" && exit
  ;;
  *)   version="php-7.1.13" && echo "downloading php-7.1.13" && wget  http://hk2.php.net/get/php-7.1.13.tar.gz/from/this/mirror && [ $? -ne 0 ] && echo "php7.1.3 下载失败" && exit
  ;;
esac

## YUM安装依赖
echo  -e "\033[31m ###################### YUM安装依赖 ###################### \033[0m"
sleep 1;
yum -y install gcc gcc-c++ autoconf libxml2 libxml2-devel curl  curl-devel libwebp.x86_64  libwebp-devel.x86_64 libwebp-tools.x86_64 libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxslt  libxslt-devel net-snmp net-snmp-devel bzip2-devel libmcrypt libmcrypt-devel readline readline-devel zlib zlib-devel

## 新建 WWW 用户
echo  -e "\033[31m ###################### 新建 WWW 用户 ###################### \033[0m"
sleep 1;
gflag= `cat /etc/group | grep www`
[ -n "$gflag" ] && echo "group 'www' already exists"  || groupadd  www
uflag=`cat  /etc/passwd  | grep www`
[ -n "$uflag" ] && echo "user 'www' already exists" ||  useradd -r -s /sbin/nologin -g www  www

## Install PHP
echo  -e "\033[31m ###################### Install PHP ###################### \033[0m"
configure5="./configure --prefix=$home_path/$version --with-config-file-path=$home_path/$version/etc --enable-inline-optimization  --disable-debug --disable-rpath --enable-shared --enable-opcache --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-pdo-mysqlnd --with-pdo-sqlite --with-mysqli=mysqlnd --with-gettext -enable-mbstring --with-iconv-dir --with-mhash --with-openssl --with-jpeg-dir --with-png-dir --with-freetype-dir --with-libxml-dir --with-xmlrpc --with-gd --with-libxml-dir --with-curl --with-zlib --with-bz2 --with-pear --with-pcre-dir --with-mcrypt --enable-mbregex --enable-mbstring --enable-bcmath --enable-soap --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets  --enable-xml --enable-zip  --enable-ftp --with-readline --enable-mysqlnd-compression-support"
configure7="./configure --prefix=$home_path/$version --with-config-file-path=$home_path/$version/etc --enable-inline-optimization  --disable-debug --disable-rpath --enable-shared --enable-opcache --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-pdo-mysqlnd --with-pdo-sqlite --with-mysqli=mysqlnd --with-gettext -enable-mbstring --with-iconv-dir --with-mhash --with-openssl --with-jpeg-dir --with-png-dir --with-freetype-dir --with-libxml-dir --with-xmlrpc --with-gd --with-libxml-dir --with-curl --with-zlib --with-bz2 --with-pear --with-pcre-dir --with-mcrypt --enable-mbregex --enable-mbstring --enable-bcmath --enable-soap --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets  --enable-xml --enable-zip  --enable-ftp --with-readline --enable-mysqlnd-compression-support"

[ -d ${code_path}/$version ] && rm -rf $version
if [ $num -gt 5 ];
then
    cd $code_path && tar fvx  mirror && cd $version && $configure7 && make && make install
else
    cd $code_path && tar fvx  mirror && cd $version && $configure5 && make && make install
fi

## cp相关文件
echo  -e "\033[31m ###################### 复制相关文件 ###################### \033[0m"
if [ $num -gt 5 ];
then
    cd $code_path/$version && $code_path/$version/build/shtool install -c ext/phar/phar.phar $home_path/$version/bin && ln -s -f phar.phar $home_path/$version/bin/phar && cp php.ini-development $home_path/$version/etc/php.ini
    cd $home_path/$version/etc && cp php-fpm.conf.default php-fpm.conf && cp php-fpm.d/www.conf.default php-fpm.d/www.conf && echo "export PATH=\$PATH:${home_path}/$version/bin" >> /etc/profile
    if [ -f /etc/init.d/php-fpm7 ];
    then
        echo "/etc/init.d/php-fpm7 已存在"
        read -p "输入启动脚本名称:" name
       cp $code_path/$version/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm$name &&  chmod +x /etc/init.d/php-fpm$name
    else
       cp $code_path/$version/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm7 &&  chmod +x /etc/init.d/php-fpm7
    fi

else
    cd $code_path/$version && $code_path/$version/build/shtool install -c ext/phar/phar.phar $home_path/$version/bin && ln -s -f phar.phar $home_path/$version/bin/phar && cp php.ini-development $home_path/$version/etc/php.ini
    cd $home_path/$version/etc && cp php-fpm.conf.default php-fpm.conf && echo "export PATH=\$PATH:${home_path}/$version/bin" >> /etc/profile
    if [ -f /etc/init.d/php-fpm56 ];
    then
        echo "/etc/init.d/php-fpm56 已存在"
        read -p "输入启动脚本名称:" name
       cp $code_path/$version/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm$name &&  chmod +x /etc/init.d/php-fpm$name
    else
       cp $code_path/$version/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm56 &&  chmod +x /etc/init.d/php-fpm56
    fi
    echo "安装完成,请启动测试"
fi

exit 0

#php composer
# /usr/local && curl -sS https://getcomposer.org/installer | $home_path/bin/php && ln -s /usr/local/composer.phar  /usr/local/bin/composer && chmod +x /usr/local/composer.phar  /usr/local/bin/composer && ln -s  /usr/local/composer.phar /usr/bin/composer && composer about

