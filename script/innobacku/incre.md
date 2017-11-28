```
#!/bin/sh

MYSQL_CMD="/usr/local/mysql/bin/mysql"
INNO_CMD="/usr/bin/innobackupex"

MY_CNF="/etc/my.cnf"
MYSQL_USER=""
MYSQL_HOST=""
MYSQL_PWD=""
MYSQL_SOCK=""

BACK_FULL_DIR=""
BACK_INC_DIR=""

        if [ -d $BACK_INC_DIR ];then
                echo "$BACK_INC_DIR is exist,Begin to Backup"
        else
                echo "$BACK_INC_DIR not exist,Create dir $BACK_INC_DIR"
                mkdir -p $BACK_INC_DIR
        fi

LATEST_INCR_BACKUP=`find $BACK_FULL_DIR/ -mindepth 1 -maxdepth 1 -type d -printf "%P\n"  | sort -nr | head -1`

ulimit -n 65535
$INNO_CMD --use-memory=4G --socket=$MYSQL_SOCK --user=$MYSQL_USER --host=$MYSQL_HOST --password=$MYSQL_PWD  --incremental --incremental-basedir=${BACK_FULL_DIR}/${LATEST_INCR_BACKUP} $BACK_INC_DIR/ 2>&1 | tee $BACK_INC_DIR/`date +%Y%m%d_%H%M%S.log`

```
