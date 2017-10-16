#!/bin/bash
#install nginx  for  centos
#author:kedge_zhang
#date:2017.07.11

downloaddir=/usr/local/src

function version(){ 
cat << EOF
**********************************************
|---    Plese choose databases version    ---|
*---     1. Mariadb-10.0.xx for linux     ---*
|---     2. PXC-5.6.xx for linux          ---|
*---     3. PXC-5.7.xx for linux          ---*
|---     4. Percona-5.7.xx for linux      ---|
*---     default mysql-5.6.xx for linux   ---*
**********************************************
EOF
}

## 检测当前用户
function check_root() {
if [ $UID -ne 0 ]
then 
      echo "please login as user root"
      return 0
fi
}

## 添加mysql用户组
function check_user() {
gflag= `cat /etc/group | grep mysql`
[ -n "$gflag" ] && echo "group 'mysql' already exists"  || groupadd mysql
uflag=`cat  /etc/passwd  | grep mysql`
[ -n "$uflag" ] && echo "user 'mysql' already exists" ||  useradd -s /sbin/nologin -g mysql mysql
}

## 安装依赖
function install_devel() {

yum -y install gcc gcc-c++  make cmake automake  autoconf  zlib zlib-devel > /dev/null  && echo 'install gcc gcc-c++  make cmake automake  autoconf zlib zlib-devel OK' || echo "install gcc gcc-c++  make cmake automake  autoconf zlib zlib-devel ERROR"

yum -y install libxml2 libxml2-devel > /dev/null && echo "install  libxml2 libxml2-devel OK" || echo "install libxml2 libxml2-devel ERROR"

yum -y install ncurses ncurses-devel > /dev/null && echo "install  ncurses ncurses-devel OK" || echo "install ncurses ncurses-devel ERROR"

yum -y install readline readline-devel > /dev/null && echo "install readline readline-devel OK" || echo "install readline readline-devel ERROR"

[ $? -eq 0 ]  && echo "install_devel install  ok,go next step." || echo "devel install failed ,please check"
}

## 选择安装数据库类型
function choose_version() {
read -p "Plese choose databases type  you want to install:version"
}

## 获取资源
function download_databases() {
cd $downloaddir 
case $version in
"1")echo "downloading mariadb-10.0.30.tar.gz and jemalloc-4.5.0.tar.bz2" && wget http://pkgs.fedoraproject.org/lookaside/pkgs/jemalloc/jemalloc-4.5.0.tar.bz2/sha512/76953363fe1007952232220afa1a91da4c1c33c02369b5ad239d8dd1d0792141197c15e8489a8f4cd301b08494e65cadd8ecd34d025cb0285700dd78d7248821/jemalloc-4.5.0.tar.bz2  && wget  wget https://downloads.mariadb.org/interstitial/mariadb-10.2.6/source/mariadb-10.2.6.tar.gz/from/http%3A//mirrors.neusoft.edu.cn/mariadb/?serve 
;;
"2")
;;
"3")
;;
"4")
;;
"*")
;;
esac
}

wD
