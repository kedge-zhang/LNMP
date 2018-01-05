#!/bin/bash
Zero="0"
version="php-7.1.8"
home_path=/usr/local/php7
code_path=/usr/local/src

function check_root() {
echo "############################ checke root ##########################"
if [ $UID -ne 0 ];
then 
     echo "please login as user root"
     return 0
fi
}

function yum_devel() {
echo "############################ 安装依赖 ##########################"
yum -y install gcc gcc-c++ autoconf libxml2 libxml2-devel curl  curl-devel libwebp.x86_64  libwebp-devel.x86_64 libwebp-tools.x86_64 libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxslt  libxslt-devel net-snmp net-snmp-devel bzip2-devel libmcrypt libmcrypt-devel readline readline-devel
}

function check_user() {
echo "############################ checke www ##########################"
gflag= `cat /etc/group | grep www`
[ -n "$gflag" ] && echo "group 'www' already exists"  || groupadd -g 501 www
uflag=`cat  /etc/passwd  | grep www`
[ -n "$uflag" ] && echo "user 'www' already exists" ||  useradd -r -s /sbin/nologin -g 501 -u 501 www 
}

function wget_php() {
echo "############################ wget package ##########################"
if [ -f $code_path/mirror ];
then
    cd $code_path && rm -rf mirror
    wget http://hk2.php.net/get/$version.tar.gz/from/this/mirror
else
   cd $code_path
   wget http://hk2.php.net/get/$version.tar.gz/from/this/mirror
fi
echo "Downloading ......"
if [ $? -ne 0];
then 
    echo "Downloading fair"
    return 0
fi
}

function install_php() {
echo "############################ install php ##########################"
cd $code_path
if [ -d $version ];
then
   rm -rf $version
   tar fvx mirror > /dev/null 2>&1  && cd $version
else
   tar fvx mirror > /dev/null 2>&1  && cd $version
fi
 ./configure --prefix=$home_path --with-config-file-path=$home_path/etc --enable-inline-optimization  --disable-debug --disable-rpath --enable-shared --enable-opcache --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-pdo-mysql --with-pdo-sqlite --with-pdo-sqlite --with-gettext -enable-mbstring --with-iconv-dir --with-mhash --with-openssl --with-jpeg-dir --with-png-dir --with-freetype-dir --with-libxml-dir --with-xmlrpc --with-gd --with-libxml-dir --with-curl --with-zlib --with-bz2 --with-pear --with-pcre-dir --enable-mbregex --enable-mbstring --enable-bcmath --enable-soap --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --enable-mysqlnd --enable-xml --enable-zip  --enable-ftp --with-readline --enable-mysqlnd-compression-support && make && make test && make install
}

function other_configure() {
cd $code_path/$version && $code_path/$version/build/shtool install -c ext/phar/phar.phar $home_path/bin && ln -s -f phar.phar /usr/local/php7/bin/phar && cp php.ini-development $home_path/etc/php.ini && cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm7 && chmod +x /etc/init.d/php-fpm7

cd $home_path/etc && cp -rf php-fpm.conf.default php-fpm.conf &&  cp -rf php-fpm.d/www.conf.default php-fpm.d/www.conf && /etc/init.d/php-fpm7 start && echo "export PATH=\$PATH:${home_path}/bin" >> /etc/profile

}

function install_composer() {
cd /usr/local && curl -sS https://getcomposer.org/installer | $home_path/bin/php && ln -s /usr/local/composer.phar  /usr/local/bin/composer && chmod +x /usr/local/composer.phar  /usr/local/bin/composer && ln -s  /usr/local/composer.phar /usr/bin/composer && composer about
}

function main() {
check_root
yum_devel
check_user
wget_php
install_php
other_configure
install_composer
}
main
