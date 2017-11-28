#!/bin/bash
MYSQL_CMD="/usr/local/mysql/bin/mysql"
INNO_CMD="/usr/bin/innobackupex"

MY_CNF=""
MYSQL_USER=""
MYSQL_HOST=""
MYSQL_PWD=""
MYSQL_SOCK=""

BACK_FULL_DIR=""
BACK_INC_DIR=""
	if [ -d $BACK_FULL_DIR ];then
		echo "$BACK_FULL_DIR is exist,Begin to Backup"
	else	
		echo "$BACK_FULL_DIR not exist,Create dir $BACK_FULL_DIR"
		mkdir -p $BACK_FULL_DIR
	fi

ulimit -n 65535
$INNO_CMD --defaults-file=$MY_CNF  --use-memory=4G --socket=$MYSQL_SOCK --host=$MYSQL_HOST --user=$MYSQL_USER --password=$MYSQL_PWD $BACK_FULL_DIR 2>&1 | tee $BACK_FULL_DIR/`date +%Y%m%d_%H%M%S.log`

find $BACK_FULL_DIR/ -maxdepth 1 -type d -ctime +14 -exec rm -rf {} \;
find $BACK_FULL_DIR/ -name "*.log" -ctime +14 -exec rm -f {} \;
find $BACK_INC_DIR/ -maxdepth 1 -type d -ctime +14 -exec rm -rf {} \;
find $BACK_INC_DIR/ -name "*.log" -ctime +14 -exec rm -f {} \;
