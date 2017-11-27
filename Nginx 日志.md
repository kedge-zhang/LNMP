# Nginx-log
## 1.默认combined
```
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"';
```

## 2.变量注释
```
1.$remote_addr 与$http_x_forwarded_for 用以记录客户端的ip地址；         
```    
```
2.$remote_user ：用来记录客户端用户名称；
```
```
3.$time_local ： 用来记录访问时间与时区；  
```   
```
4.$request ： 用来记录请求的url与http协议；  
```   
```
5.$status ： 用来记录请求状态；成功是200; 
```    
```
6.$body_bytes_s ent ：记录发送给客户端文件主体内容大小；
```    
```
7.$http_referer ：用来记录从那个页面链接访问过来的；
```   
```
8.$http_user_agent ：记录客户端浏览器的相关信息；
```
![日志变量](https://i.imgur.com/xApGIBa.png)

## 3.分析
 1.根据访问IP统计UV   
```  
 awk '{print $1}'  access.log|sort | uniq -c |wc -l       
```    

 2.统计访问URL统计PV  
```
 awk '{print $7}' access.log|wc -l
```
 
3.查询访问最频繁的URL  
```
awk '{print $7}' access.log|sort | uniq -c |sort -n -k 1 -r|more
```    

4.查询访问最频繁的IP  
```
 awk '{print $1}' access.log|sort | uniq -c |sort -n -k 1 -r|more
```

5.根据时间段统计查看日志    
``` 
cat  access.log| sed -n '/14\/Mar\/2015:21/,/14\/Mar\/2015:22/p'|more
```

其中，第五条不好使,没有统计当日的的pv和uv，自己为了zabbix写了一个
pv：`cat  /usr/local/nginx/logs/access.log| sed -n /`date "+%d\/%b\/%Y"`/p |awk '{print $7}' |sort|wc -l`    
uv：`cat  /usr/local/nginx/logs/access.log| sed -n /`date "+%d\/%b\/%Y"`/p |awk '{print $1}' |sort|uniq -c |wc -l`   
这个是看当日的，看昨天的改日期格式就行。
