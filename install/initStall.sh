#!/bin/bash
logdir=/data/log/shell          #日志路径
log=$logdir/shell.log            #日志文件
is_font=1                #终端是否打印日志: 1打印 0不打印
is_log=0                 #是否记录日志: 1记录 0不记录
yum_file='install/rex.repo'
DbLibconfigs="lib/Deploy/Core/__module__.pm;lib/Deploy/Db/__module__.pm"
DbSQL='install/autotask.sql'
RexSRC='src/Rex/'
installRexSRC='/usr/share/perl5/vendor_perl/Rex'
DBD_gz="install/packages/DBD-mysql-4.031.tar.gz"
DBI_gz="install/packages/DBI-1.633.tar.gz"
Mojo_gz="install/packages/Mojolicious-7.10.tar.gz"
JSON_gz="install/packages/JSON-PP-2.27400.tar.gz"
datef(){
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


install(){

  if [[ `which rex` ]];then
    print_log "rex框架已经安装."
  else
    print_log "开始安装rex框架..."
    \cp $yum_file /etc/yum.repos.d/
    yum install rex -y
    print_log "安装rex框架完成."
  fi

  print_log "开始安装perl/db支持"
  > /tmp/perlModule.txt
  perl_module_dir=$(perl -e 'print "@INC"' |sed "s/ /\n/g")
  for i in $perl_module_dir
  do
    if [[ -d $i  ]];then
      find $i  -name '*.pm' -print >> /tmp/perlModule.txt
    fi

  done
  dbi_list=$(cat /tmp/perlModule.txt |grep "DBI.pm" |wc -l)
  dbd_list=$(cat /tmp/perlModule.txt |grep DBD |grep mysql |wc -l)
  mojo_list=$(cat /tmp/perlModule.txt |grep Mojo |grep JSON |wc -l)
  json_list=$(cat /tmp/perlModule.txt |grep JSON |grep PP |wc -l)

  #开始安装相关依赖 
  [[ `yum list installed |grep zlib-devel` ]]  ||  yum install zlib-devel  -y
  [[ `yum list installed |grep perl-ExtUtils-CBuilder` ]] || yum install perl-ExtUtils-CBuilder -y
  [[ `yum list installed |grep perl-ExtUtils-MakeMaker` ]] || yum install  perl-ExtUtils-MakeMaker  -y
  [[ `yum list installed |grep gcc` ]] || yum install gcc  -y

  if [[ $dbi_list -eq 0  ]];then
    #DBI安装
    print_log "DBI模块开始安装."
    tar -zxvf $DBI_gz -C /tmp
    cd /tmp/DBI-1.633
    perl Makefile.PL
    make
    make install
    print_log "DBI模块安装完成."
    cd -
  else
    print_log "DBI模块已经安装."
  fi
  if [[ $dbd_list -eq 0  ]];then
    print_log "DBD::mysql模块开始安装."
    #DBD安装
    tar -zxvf $DBD_gz -C /tmp
    cd /tmp/DBD-mysql-4.031
    perl Makefile.PL
    make
    make install
    print_log "DBD::mysql模块安装完成."
    cd -
  else
    print_log "DBD::mysql模块已经安装."
  fi
  if [[ $mojo_list -eq 0  ]];then
    print_log "Mojo::JSON模块开始安装."
    #DBD安装
    tar -zxvf $Mojo_gz -C /tmp
    cd /tmp/Mojolicious-7.10
    perl Makefile.PL
    make
    make install
    print_log "Mojo::JSON模块安装完成."
    cd -
  else
    print_log "Mojo::JSON模块已经安装."
  fi
  if [[ $json_list -eq 0  ]];then
    print_log "JSON::PP模块开始安装."
    #DBD安装
    tar -zxvf $JSON_gz -C /tmp
    cd /tmp/JSON-PP-2.27400
    perl Makefile.PL
    make
    make install
    print_log "JSON:PP模块安装完成."
    cd -
  else
    print_log "JSON:PP模块已经安装."
  fi
  #expect安装
  #yum install expect* -y
  print_log "安装perl支持完成"
}

#处理化配置文件以及导入数据库
setConfig(){
  mysql -V
  if [[ $? -ne 0 ]];then
    yum install mysql -y
  fi
  read -p '请输入数据库地址:' mysql_host
  read -p '请输入数据库端口:' mysql_port
  read -p '请输入数据库用户:' mysql_user
  read -p '请输入数据库密码:' mysql_pass
  read -p '请输入数据库名:' mysql_dbname
  mysql -h$mysql_host -u$mysql_user -p$mysql_pass -P$mysql_port  -e "use $mysql_dbname;"
  if [[ $? -ne 0  ]];then
    print_log "连接数据库失败或数据库autotask不存在,请检查数据库配置."
    exit
  else
    print_log "数据库连接成功."
  fi
  print_log "开始灌入数据"
  if [[ ! -f $DbSQL   ]];then
    print_log "$DbSQL:SQL文件不存在"
    exit
  fi
  mysql -h$mysql_host -u$mysql_user -p$mysql_pass -P$mysql_port  --default-character-set=utf8 $mysql_dbname < $DbSQL
  if [[ $? -eq 0  ]];then
    print_log "灌入数据成功"
  else
    print_log "灌入数据失败."
  fi

  # print_log "初始化数据库配置"
  # file_list=$(echo "$DbLibconfigs" | sed  's/;/\n/')
  # for file in $file_list
  # do
  #   database=$(grep 'dsn' $file  |grep '=' |awk -F'database' '{print $2}' |awk -F';'  '{print $1}' |awk -F'=' '{print $2}')
  #   host=$(grep 'dsn' $file  |grep '=' |awk -F';' '{print $(NF-1)}' |awk -F'=' '{print $2}')
  #   port=$(grep 'dsn' $file  |grep '=' |awk -F';' '{print $NF}' |awk -F'=' '{print $2}' |awk -F'\"' '{print $1}')
  #   user=$(grep 'user' $file  |grep '='  |awk -F'\"' '{print $2}')
  #   password=$(grep 'password' $file  |grep '='  |awk -F'\"' '{print $2}' )
   
  #   sed -i "s/$host/$mysql_host/" $file
  #   sed -i "s/$port/$mysql_port/" $file
  #   sed -i "s/user     => \"$user\"/user     => \"$mysql_user\"/" $file
  #   sed -i "s/password => \"$password\"/password => \"$mysql_pass\"/" $file
  #   sed -i "s/dsn      => \"DBI:mysql:database=$database/dsn      => \"DBI:mysql:database=$mysql_dbname/" $file
      	
  #   print_log "配置完成:$file"
  # done
  # print_log "初始化数据库配置完成"
  
  print_log "初始化rex模块包"
  if [[ ! -d $installRexSRC ]]; then
    print_log "$installRexSRC Rex的目录不存在,请确认是否正确安转Rex,或手工确认Rex源码位置."
    exit
  fi

  if [[ ! -d $RexSRC ]]; then
    print_log "$RexSRC目录不存在"
    exit
  fi
  \cp  $RexSRC/*  $installRexSRC/  -ar
  if [[ $? -eq 0  ]];then
    print_log "初始化rex模块包成功"
  else
    print_log "初始化rex模块包失败"
  fi

}

case $1 in
setConfig )
setConfig
;;
instalib )
install
;;
* )
echo -e "
自动安装配置脚本\n用法示例: \n1.安装依赖包:  ./initStall.sh  instalib  \n2.初始化配置 ./initStall.sh  setConfig"
;;

esac
