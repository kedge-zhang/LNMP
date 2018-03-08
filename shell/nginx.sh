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
uflag=`cat  /etc/passwd  | grep www`
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
1)tar fvx nginx-1.12.0.tar.gz && cd ${downloaddir}/nginx-1.12.0 &&  ./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx  --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=www --group=www --error-log-path=/usr/local/nginx/logs/error.log --http-log-path=/usr/local/nginx/logs/access.log  --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module  --without-http_auth_basic_module --without-http_autoindex_module --without-http_browser_module --without-http_empty_gif_module --without-http_geo_module --without-http_limit_conn_module --without-http_limit_req_module --without-http_map_module --without-http_memcached_module --without-http_referer_module --without-http_scgi_module --without-http_split_clients_module --without-http_ssi_module --without-http_upstream_ip_hash_module --without-http_upstream_keepalive_module --without-http_upstream_least_conn_module --without-http_userid_module --without-http_uwsgi_module --without-mail_imap_module --without-mail_pop3_module --without-mail_smtp_module --without-poll_module --without-select_module --http-proxy-temp-path=/var/tmp/nginx/proxy --with-cc-opt='-O2' >/dev/null && make -j$cpunum >/dev/null && make install >/dev/null 
[ $? -eq 0 ]  && echo "nginx  install  compleate,go next step." || echo "nginx install failed ,please check" 
;;
2)tar fvx nginx-1.13.2.tar.gz && cd ${downloaddir}/nginx-1.13.2 && ./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx  --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=www --group=www--error-log-path=/usr/local/nginx/logs/error.log --http-log-path=/usr/local/nginx/logs/access.log  --with-pcre --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module  --without-http_auth_basic_module --without-http_autoindex_module --without-http_browser_module --without-http_empty_gif_module --without-http_geo_module --without-http_limit_conn_module --without-http_limit_req_module --without-http_map_module --without-http_memcached_module --without-http_referer_module --without-http_scgi_module --without-http_split_clients_module --without-http_ssi_module --without-http_upstream_ip_hash_module --without-http_upstream_keepalive_module --without-http_upstream_least_conn_module --without-http_userid_module --without-http_uwsgi_module --without-mail_imap_module --without-mail_pop3_module --without-mail_smtp_module --without-poll_module --without-select_module --http-proxy-temp-path=/var/tmp/nginx/proxy --with-cc-opt='-O2' >/dev/null && make -j$cpunum>/dev/null && make install >/dev/null     
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
user www www;
worker_processes auto;

error_log /data/logs/nginx/error.log crit;
pid /var/run/nginx.pid;
worker_rlimit_nofile 51200;

events {
  use epoll;
  worker_connections 51200;
  multi_accept on;
}

http {
  include mime.types;
  default_type application/octet-stream;
  server_names_hash_bucket_size 128;
  client_header_buffer_size 32k;
  large_client_header_buffers 4 32k;
  client_max_body_size 1024m;
  client_body_buffer_size 10m;
  sendfile on;
  tcp_nopush on;
  keepalive_timeout 120;
  server_tokens off;
  tcp_nodelay on;

  fastcgi_connect_timeout 300;
  fastcgi_send_timeout 300;
  fastcgi_read_timeout 300;
  fastcgi_buffer_size 64k;
  fastcgi_buffers 4 64k;
  fastcgi_busy_buffers_size 128k;
  fastcgi_temp_file_write_size 128k;
  fastcgi_intercept_errors on;

  #Gzip Compression
  gzip on;
  gzip_buffers 16 8k;
  gzip_comp_level 6;
  gzip_http_version 1.1;
  gzip_min_length 256;
  gzip_proxied any;
  gzip_vary on;
  gzip_types
    text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml
    text/javascript application/javascript application/x-javascript
    text/x-json application/json application/x-web-app-manifest+json
    text/css text/plain text/x-component
    font/opentype application/x-font-ttf application/vnd.ms-fontobject
    image/x-icon;
  gzip_disable "MSIE [1-6]\.(?!.*SV1)";

  #If you have a lot of static files to serve through Nginx then caching of the files' metadata (not the actual files' contents) can save some latency.
  open_file_cache max=1000 inactive=20s;
  open_file_cache_valid 30s;
  open_file_cache_min_uses 2;
  open_file_cache_errors on;

##websocket
 # map $http_upgrade $connection_upgrade {
 #       default upgrade;
 #       ''      close;
 #   }
########################## vhost #############################
  include vhost/*.conf;
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
