#!/bin/bash
logdir=/data/log/shell          #日志路径
log=$logdir/shell.log            #日志文件 
is_font=1                #终端是否打印日志: 1打印 0不打印 
is_log=0                 #是否记录日志: 1记录 0不记录
tarlist="
DBD-mysql-4.031.tar.gz
DBI-1.633.tar.gz
"
root_pwd=`pwd`
function datef(){
date "+%Y-%m-%d %H:%M:%S"
}
  
print_log(){
if [[ $is_log -eq 1  ]];then
  [[ -d $logdir ]] || mkdir -p $logdir
  echo "[ $(datef) ] $1" >> $log
fi
if [[ $is_font -eq 1  ]];then
  echo -e "[ $(datef) ] $1"
fi
}

copy_src(){
rex_src_file=`find /usr/ -name 'Rex.pm' -type f`
if [[ -z $rex_src_file ]]; then
	print_log "没有检测到Rex,请确认是否安装。"
	exit
fi
rex_src_dir=`echo "$rex_src_file" |sed 's/.pm//'`
\cp -ar $root_pwd/src/Rex/* $rex_src_dir/
if [[ $? -eq 0 ]]; then
	print_log "拷贝源文件成功!"
fi
}


copy_src