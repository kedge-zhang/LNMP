#!/bin/bash
#install nginx  for  centos
#author:kedge_zhang
#date:2017.07.10

downloaddir=/usr/local/src
function version() {
cat << EOF
*******************************************************
*  "Plese choose nginx version you want to install"   *
*          1. nginx for nginx-1.12.0                  *
*          2. nginx for nginx-1.13.2                  *
*          default tengine for tengine-2.20           *
*******************************************************
EOF
}
#
##Check login
function checkroot() {
if [ $UID -ne 0 ]
then 
     echo "please login as user root"
     return 0
fi
} 
#
##check user
function check_user() {
gflag= `cat /etc/group | grep www`
[ -n "$gflag" ] && echo "group 'www' already exists"  || groupadd www
uflag=`cat  /etc/passwd  | grep nginx`
[ -n "$uflag" ] && echo "user 'www' already exists" ||  useradd -r www -g www -s /sbin/nologin
}
#
##Install devel
function install_dev() {
yum -y install gcc gcc-c++  automake autoconf libtool >/dev/null && echo 'install gcc automake autoconf libtool make OK' || echo "install gcc automake autoconf libtool make install error"
yum -y install pcre pcre-devel >/dev/null  && echo  "pcre install OK"  ||  echo  "pcre install  failed ,please check"
yum -y install zlib zlib-devel  >/dev/null  && echo  "zlib install  ok"  ||  echo  "  zlib install failed ,please check"
yum -y install openssl openssl-devel >/dev/null  && echo  "openssl install ok"  ||  echo  " openssl install  failed ,please check"

[ $? -eq 0 ]  && echo "install_dev install  ok,go next step." || echo "devel install failed ,please check"
}
#
##
function select_nginx() {
read -p "Plese choose nginx version you want to install:" version
}
#
## downloading  nginx
function download_install_nginx(){
#read -p "Plese choose nginx version you want to install:" version && 
cd  $downloaddir 
case $version  in 
"1") echo "downloading  nginx 1.12.0 " && wget  -c  http://nginx.org/download/nginx-1.12.0.tar.gz 
;;
"2") echo "downloading  nginx 1.13.2 " && wget  -c   http://nginx.org/download/nginx-1.13.2.tar.gz
;;
*)echo "downloading  tengine 2.2.0 " && wget  -c http://tengine.taobao.org/download/tengine-2.2.0.tar.gz 
;;
esac
#INSTALL
cpunum=`cat /proc/cpuinfo |grep -c processor`
case $version in 
1)tar fvx nginx-1.12.0.tar.gz && cd ${downloaddir}/nginx-1.12.0 &&  ./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx  --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=nginx --group=nginx --error-log-path=/usr/local/nginx/logs/error.log --http-log-path=/usr/local/nginx/logs/access.log  --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module  --without-http_auth_basic_module --without-http_autoindex_module --without-http_browser_module --without-http_empty_gif_module --without-http_geo_module --without-http_limit_conn_module --without-http_limit_req_module --without-http_map_module --without-http_memcached_module --without-http_referer_module --without-http_scgi_module --without-http_split_clients_module --without-http_ssi_module --without-http_upstream_ip_hash_module --without-http_upstream_keepalive_module --without-http_upstream_least_conn_module --without-http_userid_module --without-http_uwsgi_module --without-mail_imap_module --without-mail_pop3_module --without-mail_smtp_module --without-poll_module --without-select_module --http-proxy-temp-path=/var/tmp/nginx/proxy --with-cc-opt='-O2' >/dev/null && make -j$cpunum >/dev/null && make install >/dev/null 
[ $? -eq 0 ]  && echo "nginx  install  compleate,go next step." || echo "nginx install failed ,please check" 
;;
2)tar fvx nginx-1.13.2.tar.gz && cd ${downloaddir}/nginx-1.13.2 && ./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx  --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=nginx --group=nginx --error-log-path=/usr/local/nginx/logs/error.log --http-log-path=/usr/local/nginx/logs/access.log  --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module  --without-http_auth_basic_module --without-http_autoindex_module --without-http_browser_module --without-http_empty_gif_module --without-http_geo_module --without-http_limit_conn_module --without-http_limit_req_module --without-http_map_module --without-http_memcached_module --without-http_referer_module --without-http_scgi_module --without-http_split_clients_module --without-http_ssi_module --without-http_upstream_ip_hash_module --without-http_upstream_keepalive_module --without-http_upstream_least_conn_module --without-http_userid_module --without-http_uwsgi_module --without-mail_imap_module --without-mail_pop3_module --without-mail_smtp_module --without-poll_module --without-select_module --http-proxy-temp-path=/var/tmp/nginx/proxy --with-cc-opt='-O2' >/dev/null && make -j$cpunum>/dev/null && make install >/dev/null     
[ $? -eq 0 ]  && echo "nginx  install  compleate,go next step." || echo "nginx install failed ,please check"
;;
*)tar zxf tengine-2.2.0.tar.gz   && cd ${downloaddir}/tengine-2.2.0 && ./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx  --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=www --group=www --error-log-path=/usr/local/nginx/logs/error.log --http-log-path=/usr/local/nginx/logs/access.log --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module  --without-http_auth_basic_module --without-http_autoindex_module --without-http_browser_module --without-http_empty_gif_module --without-http_geo_module --without-http_limit_conn_module --without-http_limit_req_module --without-http_map_module --without-http_memcached_module --without-http_referer_module --without-http_scgi_module --without-http_split_clients_module --without-http_ssi_module --without-http_upstream_ip_hash_module --without-http_upstream_keepalive_module --without-http_upstream_least_conn_module --without-http_userid_module --without-http_uwsgi_module --without-mail_imap_module --without-mail_pop3_module --without-mail_smtp_module --without-poll_module --without-select_module --http-proxy-temp-path=/var/tmp/nginx/proxy --with-cc-opt='-O2' >/dev/null && make -j$cpunum>/dev/null && make install >/dev/null 
[ $? -eq 0 ]  && echo "tengine  install  compleate,go next step." || echo "tengine install failed ,please check" 
;;
esac
}
#
##
function conf_nginx(){
cd /etc/nginx && rm -rf nginx.conf && mkdir -p  /data/web
cat > nginx.conf <<EOF
user  nginx nginx;
 worker_processes  auto;
 error_log  logs/error.log error;
 
 pid        logs/nginx.pid;
 worker_rlimit_nofile    65536;
 
 events
 {
     use epoll;
     accept_mutex off;
     worker_connections  65536;
 }
 
 http
 {
     include       mime.types;
     default_type  text/html;    
     charset UTF-8;
     server_names_hash_bucket_size 128;
     client_header_buffer_size 4k;
     large_client_header_buffers 4 32k;
     client_max_body_size            8m;
  
     open_file_cache max=65536  inactive=60s;
     open_file_cache_valid      80s;
     open_file_cache_min_uses   1;
 
     log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
 
     access_log  logs/access.log  main;
  
     sendfile    on;
     server_tokens off;
 
     fastcgi_temp_path  /tmp/fastcgi_temp;
     fastcgi_cache_path /tmp/fastcgi_cache levels=1:2  keys_zone=cache_fastcgi:128m inactive=30m max_size=1g;
     fastcgi_cache_key $request_method://$host$request_uri;
     fastcgi_cache_valid 200 302 1h;
     fastcgi_cache_valid 301     1d;
     fastcgi_cache_valid any     1m;
     fastcgi_cache_min_uses 1;
     fastcgi_cache_use_stale error timeout http_500 http_503 invalid_header;
 
     keepalive_timeout  60;
 
     gzip  on;
     gzip_min_length 1k;
     gzip_buffers  4 64k;
     gzip_http_version 1.1;
     gzip_comp_level 2;
     gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
 
     server
     {
         listen       80;
         server_name  localhost;
         index        index.html index.php index.htm;
         root         /data/web;
 
         location ~ .+\.(php|php5)$
         {
            # fastcgi_pass   unix:/tmp/php.sock;
             fastcgi_pass   127.0.0.1:9000;
             fastcgi_index  index.php;
             include        fastcgi.conf;
             fastcgi_cache  cache_fastcgi;
         }
 
         location ~ .+\.(gif|jpg|jpeg|png|bmp|swf|txt|csv|doc|docx|xls|xlsx|ppt|pptx|flv)$
         {
             expires 30d;
         }
 
         location ~ .+\.(js|css|html|xml)$
         {
             expires 30d;
         }
 
         location /nginx-status
         {
             stub_status on;
             allow 192.168.1.0/24;
             allow 127.0.0.1;
             deny all;
         }
     }
  }
EOF
}
function service_nginx() {
echo "nginx service  is downloading by shell,please wait:"

mv /opt/nginx /etc/init.d/ && chmod +x /etc/init.d/nginx && chkconfig  nginx on && mkdir -p /var/tmp/nginx/proxy && /etc/init.d/nginx start
netstat -tnlp | grep 80
[ $? -eq 0 ]  && echo "nginx  install  OK" || echo "nginx install failed,please check"
}

function main(){
version
checkroot
select_nginx
check_user
install_dev
download_install_nginx
conf_nginx
service_nginx
}
main
