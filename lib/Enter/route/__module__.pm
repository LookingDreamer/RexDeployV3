package Enter::route;

use Rex -base;
use Rex::Commands::Rsync;
use Rex::Commands::Fs;
use Deploy::Db;
use Data::Dumper;
use Deploy::Core;
use Common::Use;
use Deploy::rollBack;
use Rex::Group::Lookup::INI;
use POSIX;
use IPC::Shareable;
my $s;
my $i;
my %hash_pids; 
my $env;
my $update_local_prodir;
my $update_local_confdir;
my $random_temp_file;
my $deploy_finish_file;
my $process_temp_dir;
my $parallelism;
my $httpdowndir;
my $default_basehttp;
my $default_basehttp2;
my $is_check_dir;
my $softdir;
my $update_local_prodir;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key} ;
 });
Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 our $user = $param->{user} ;
     $update_local_prodir   = $param->{update_local_prodir};
     $update_local_confdir  = $param->{update_local_confdir};
     $random_temp_file  = $param->{random_temp_file};
     $deploy_finish_file  = $param->{deploy_finish_file};
     $process_temp_dir  = $param->{process_temp_dir};
     $parallelism  = $param->{parallelism};
     $httpdowndir  = $param->{httpdowndir};
     $default_basehttp  = $param->{default_basehttp};
     $is_check_dir  = $param->{is_check_dir};
     $softdir  = $param->{softdir};
     $update_local_prodir  = $param->{update_local_prodir};
     $default_basehttp2  = $param->{default_basehttp2};
 });
my $maxchild = $parallelism;

desc "应用下载模块: rex  Enter:route:download   --k='server1 server2 ../groupname/all' [--update='1'] [--senv='uat'] [--type='pro/conf/all']";
task "download",sub{
   my $self = shift;
   my $k=$self->{k};
   my $senv=$self->{senv};
   my $type=$self->{type};
   my $update=$self->{update};
   my $usetype=$self->{usetype};
   my $w=$self->{w};
   my $username=$user;
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   my $locals=Deploy::Db::ilocalname();
   my @locals=split(/,/, $locals);
   my %localvars = map { $_ => 1 } @locals;
   my $lastnum=$locals[-1] - 1;
   my $start = time;
   my @ks = split(/ /, $k);
   my $maxchild = $parallelism ;
   my $max = @ks;
   my %reshash;
   my @data ;
   my $srck = $k ;
   my @sharedown;
   my $mainProces = $$;
   $reshash{"params"} = {k=>"$k",senv=>"$senv",type=>"$type",update=>"$update",usetype=>"$usetype",w=>"$w"};
    
   if( $k eq ""  ){
       Rex::Logger::info("关键字(--k='')不能为空");
       Common::Use::json($w,"","关键字(--k='')不能为空","");
       exit;
   }
   if( $username eq ""  ){
       Rex::Logger::info("用户名(--u='')不能为空");
       Common::Use::json($w,"","用户名(--u='')不能为空","");
       exit;
   }

   #如果是上传到更新目录，先清空更新目录
   if ( "$update" eq "1") {
      # if (  is_dir($update_local_prodir)) {
      #     rmdir("$update_local_prodir");
      # }
      # if (  is_dir($update_local_confdir)) {
      #     rmdir("$update_local_confdir");
      # }

      if ( ! is_dir($update_local_prodir)) {
          mkdir("$update_local_prodir");
      }
      if ( ! is_dir($update_local_confdir)) {
          mkdir("$update_local_confdir");
      }
   }
   my $query_prodir_key ;
   my $start = time();
   Rex::Logger::info("Starting ...... 操作人: $username");
   if ( $k eq "all" ){
      my $keys=Deploy::Db::getallkey();
      my @keysArray=split(/,/, $keys);
      pop @keysArray;
      $k = join(" ",@keysArray);
   }else{
      my $query_local_prodir_key = Deploy::Db::query_local_app_key($k);
      my @query_local_prodir_key = @$query_local_prodir_key ;
      my @app_key_array;
      for my $prolocal (@query_local_prodir_key){
          my $app_key = $prolocal->{"app_key"};
          push @app_key_array,$app_key;
      }
      my $app_key_count = @app_key_array;
      my $app_key_str = join(" ",@app_key_array);
      $k = $app_key_str;    
   }


  @ks = split(/ /, $k);;
  $max = @ks;
  my $kstring = join(" ",@ks); 
  $reshash{"k"} = $kstring ;
  $reshash{"parallelism"} = $maxchild ;
  if ( $max > 0  ) {
    Rex::Logger::info("----------多线程名字下载模式---------");
    Rex::Logger::info("----------$kstring---------");
    $query_prodir_key = Deploy::Db::query_prodir_key($kstring);
  }else{
    Common::Use::json($w,"","没有匹配到数据，请确认传参 k=$k 是否正确","");
    Rex::Logger::info("没有匹配到数据，请确认传参 k=$srck  是否正确","error"); 
    exit;
  }

   Rex::Logger::info("");
   Rex::Logger::info("开始下载远程服务器数据到本地.");
   Rex::Logger::info("当前并发数: $maxchild.");

  my $ipch = tie @sharedown,   'IPC::Shareable',
                         "foco",
                         {  create    => 1,
                            exclusive => 'no',
                            mode      => 0666,
                            size      => 1024*512
                         };

   #根据的传值key来下载应用
  for(my $g=0; $g < $max ;){
    $g = $g+$maxchild;
    $s = $g-$maxchild ;
    my $initNumber;
    my $maxNumber;
    if( $g > $max ){
      $initNumber = 0 ;
      $maxNumber = $max;
      Rex::Logger::info("并发控制:($s - $max)");
    }else{
      $initNumber = $g-$maxchild ;
      $maxNumber = $g;
      Rex::Logger::info("并发控制:($s - $g)");
    }


    for($i=$initNumber;$i<$maxNumber;$i++){

      select(undef, undef, undef, 0.25);
        my $kv = $ks[$i];
        my $child=fork(); #派生一个子进程
      if($child){   # child >; 0, so we're the parent 
          $hash_pids{$child} = $child;  
          Rex::Logger::info("父进程PID:$$ 子进程PID:$child");
      }else{ 
        #在子进程中执行相关动作开始
        Rex::Logger::info("执行子进程,进程序号:$i");
        if ( $kv ne "" ){
           if (exists($vars{$kv})){
           Rex::Logger::info("");
           Rex::Logger::info("##############($kv)###############");
           my $config=Deploy::Core::init("$kv");
           if ( "$senv"  ne "" ) {
               my $localName = $config->{'local_name'};
               my $envConfig = Common::mysql::getEnvConfig($localName,$senv) ;
               if ($envConfig  == 1 ) {
                  Rex::Logger::info("$senv环境,查询$localName应用数据为空,退出","error");
                  exit;
               }
               if ($envConfig  == 2 ) {
                  Rex::Logger::info("$senv环境,查询$localName应用数据返回多条记录,退出","error");
                  exit;
               }
               if ( $envConfig->{"code"} != undef &&  $envConfig->{"code"} > 0  ) {
                  Rex::Logger::info("$senv环境校验参数失败,退出","error");
                  exit;
               }
               Rex::Logger::info("开始同步$senv环境$localName的数据到本地......");
               $config=$envConfig ;
           }
           # my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});
            my $downloadres = Deploy::Core::downloading($kv,$config->{'app_key'},$config->{'pro_dir'},$config->{'network_ip'},$config->{'config_dir'},$config,$update,$config->{'local_name'},$query_prodir_key,$senv,$type,$usetype);               
            my $single = {"mainProcess"=>"$mainProces","data"=>$downloadres}  ;   
            $ipch->shlock;
            push @sharedown, $single;
            $ipch->shunlock;          

           }else{
           Rex::Logger::info("关键字($kv)不存在","error");
           }
       }
        exit 0;             # child is done
        #在子进程中执行相关动作结束
     } 
    }
    #收割并等待子进程完成
    while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
      my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
      if ($kid and exists $hash_pids{$kid}) {
        delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
      }
    }
  }

  #最后一次收割并等待子进程完成
  while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
      my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
      if ($kid and exists $hash_pids{$kid}) {
          delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
      }
  }
  Rex::Logger::info("执行下载模板完成.");
  my $take_time = time - $start;
  Rex::Logger::info("总共花费时间:$take_time秒.");
  # return ;
  # exit; 
  #全部结束

   Rex::Logger::info("");
   Rex::Logger::info("下载远程服务器数据到本地完成.");
   $reshash{"take"} = $take_time ;

    #重新返回该进程的数据
    my $allCount =@sharedown;
    my @mainShared;
    my $u = 0 ;
    my @deleteArray;
    
    Rex::Logger::info("当前全局内存存储变量数量: $allCount");
    for (my $var = 0; $var < $allCount; $var++) {
       my $process = $sharedown[$var]->{"mainProcess"};
       if ( "$process" eq "$mainProces" ) {
           $u = $u + 1;
           push @mainShared,$sharedown[$var] ;
           push @deleteArray,$var;
       }
    }
    my $i = 0;
    for (@deleteArray) {
        my $deleteIndex = $_-$i ;
        my $deleteprocess = $sharedown[$deleteIndex]->{"mainProcess"};
        if ( "$deleteprocess" eq "$mainProces"  ) {
            splice(@sharedown, $deleteIndex, 1);
        }       
        $i++;
    } 

    my $allCount =@sharedown;

    Rex::Logger::info("当前全局内存存储变量数量: $allCount 当前实际使用变量数量: $u");

   
    my $sharedownCount = @mainShared;
    my %result = (
       msg => "success",
       code  => 0,
       count  => $sharedownCount,
       data => [@mainShared] ,
       srcdata => \%reshash
    );
    $result{"mainProcess"} = $mainProces;
    # (tied @sharedown)->remove;
    # IPC::Shareable->clean_up;
    # IPC::Shareable->clean_up_all;
    Common::Use::json($w,"0","成功",[\%result]);

    return \%result;
};





desc "应用发布模块: rex  Enter:route:deploy --k='server1 server2 ..' \n";
task "deploy", sub {
   my $self = shift;
   my $k=$self->{k};
   my $w=$self->{w};
   my $username=$user;
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   my $start = time;
   my @errData ;
   my @randomArray ;
   undef %hash_pids;
   my %hash_pids;
   push @errData,1;
   my @sharedeploy;
   my $mainProces = $$;
   my %result;

   $result{"k"} = $k ;
   $result{"parallelism"} = $parallelism ;
   $result{"mainProcess"} = $mainProces;
   if( $k eq ""  ){
     Rex::Logger::info("关键字(--k='')不能为空","error");
     $result{"code"} = -1;
     $result{"msg"} = " --k is null";
     return \%result;
   }

   if( $username eq ""  ){
     Rex::Logger::info("操作人(--u='')不能为空");
     $result{"code"} = -1;
     $result{"msg"} = " --u is null";
     return \%result;
   }

   Rex::Logger::info("Starting ...... 操作人: $username");

  my $deploy = Deploy::Db::query_name_keys($k);
  my @deploy = @$deploy;
  my $deploylength = @deploy;
  if ( $deploylength == 0 ) {
    Rex::Logger::info("($k) 根据识别名称local_name查询到关键词为空,请确认是否已经录入数据","error");
     $result{"code"} = -1;
     $result{"msg"} = "query k or local_name return is null";
     return \%result;
  }
  Rex::Logger::info("($k) 根据识别名称查询到$deploylength条记录");
  my @app_keys ;
  my $app_keys_string;
  for my $info (@deploy){
    my $app_key = $info->{"app_key"}; 
    push @app_keys,$app_key;  
  }
  $k = join(" ",@app_keys);

  my $ipch = tie @sharedeploy,   'IPC::Shareable',
                         "foco",
                         {  create    => 1,
                            exclusive => 'no',
                            mode      => 0666,
                            size      => 1024*512,
                            # destroy   => 'yes',
                         };


   my @ks = split(/ /, $k);
   my $max = @ks;

   Rex::Logger::info("");
   Rex::Logger::info("开始应用发布模块.");
   Rex::Logger::info("当前并发数: $maxchild  当前主进程: $mainProces");

  #根据的传值key来下载应用
  for(my $g=0; $g < $max ;){
    $g = $g+$maxchild;
    $s = $g-$maxchild ;
    my $initNumber;
    my $maxNumber;
    if( $g > $max ){
      $initNumber = 0 ;
      $maxNumber = $max;
      Rex::Logger::info("并发控制:($s - $max)");
    }else{
      $initNumber = $g-$maxchild ;
      $maxNumber = $g;
      Rex::Logger::info("并发控制:($s - $g)");
    }


    for($i=$initNumber;$i<$maxNumber;$i++){

      select(undef, undef, undef, 0.25);
        my $kv = $ks[$i];
        my $child=fork(); #派生一个子进程
      if($child){   # child >; 0, so we're the parent 
          $hash_pids{$child} = $child;  
          Rex::Logger::info("父进程PID:$$ 子进程PID:$child");
      }else{ 
        #在子进程中执行相关动作开始
          Rex::Logger::info("执行子进程,进程序号:$i");
          if ( $kv ne "" ){
              if (exists($vars{$kv})){
                  Rex::Logger::info("");
                  Rex::Logger::info("##############($kv)###############");
                  #1.初始化数据库信息
                  my $config;
                  my $FistSerInfo;
                  my $dir;
                  my $myAppStatus;     
                  my $config=Deploy::Core::init("$kv");
                  my $auto_deloy;
                  #2.判断是否加入了自动发布
                  $auto_deloy=$config->{'auto_deloy'};
                  if ( $auto_deloy eq "0"){
                      Rex::Logger::info("($kv)--该应用没有加入自动发布","warn");
                      my $single = {"mainProcess"=>"$mainProces","app_key"=>$kv,"data"=>$myAppStatus,"code"=> -1 ,"msg"=>"($kv)--have not add deploy(auto_deloy = 0)"}  ;  
                      $ipch->shlock;
                      push @sharedeploy, $single ;
                      $ipch->shunlock;
                      exit 0;
                  }
                  #3.查询该系统是否处于发布的状态,并记录初始化的的信息
                  my $myAppStatus=Deploy::Db::getDeployStatus($kv,$config->{'network_ip'},"$username");
                  Rex::Logger::info("($kv) 生成随机数: $myAppStatus");

                  if($myAppStatus eq "1" ){
                      Rex::Logger::info("($kv)--该应用正在发布,跳过本次操作.","warn");
                      my $single = {"mainProcess"=>"$mainProces","app_key"=>$kv,"data"=>$myAppStatus,"code"=> -1 ,"msg"=>"($kv)--is deploying"}  ;  
                      $ipch->shlock;
                      push @sharedeploy, $single ;
                      $ipch->shunlock;
                      exit 0 ;
                  }
                  my $single = {"mainProcess"=>"$mainProces","app_key"=>$kv,"data"=>$myAppStatus,"code"=> 0 ,"msg"=>"get random success"}  ;  
                  $ipch->shlock;
                  push @sharedeploy, $single ;
                  $ipch->shunlock;

                  #4.第一次连接获取远程服务器信息
                  my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});
                  #5.上传程序目录和配置目录
                  my $dir=Deploy::Core::uploading($kv,$config->{'local_name'},$config->{'pro_dir'},$config->{'network_ip'},$config->{'config_dir'},$config->{'app_key'},$config->{'is_deloy_dir'},$config->{'pro_dir'},$config->{'config_dir'},"$myAppStatus");  
                  #6.更改软链接,重启应用
                  run_task "Deploy:Core:linkrestart",on=>$config->{'network_ip'},params=>{ k => $kv,config =>$config,FistSerInfo=>$FistSerInfo,dir=>$dir,myAppStatus=>"$myAppStatus"}; 
              }else{
                  Rex::Logger::info("关键字($kv)不存在","error");
                  my $single = {"mainProcess"=>"$mainProces","app_key"=>$kv,"data"=>"","code"=> -1 ,"msg"=>"($kv)--is not exist"}  ;  
                  $ipch->shlock;
                  push @sharedeploy, $single ;
                  $ipch->shunlock;
                  exit 0;
              }
          }
          exit 0;             # child is done
        #在子进程中执行相关动作结束
     } 
    }
    #收割并等待子进程完成
    while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
      my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
      if ($kid and exists $hash_pids{$kid}) {
        delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
      }
    }
  }

  #最后一次收割并等待子进程完成
  while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
      my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
      if ($kid and exists $hash_pids{$kid}) {
          delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
      }
  }


  #全部结束
  Rex::Logger::info("应用发布模块完成.");
  my $take_time = time - $start;
  Rex::Logger::info("总共花费时间:$take_time秒.");

  # my $fh = file_write "$deploy_finish_file";
  # $fh->write("总共花费时间:$take_time秒");
  # $fh->close;

  $result{"take"} = $take_time ;

    #重新返回该进程的数据
    my $allCount =@sharedeploy;
    my @mainShared;
    my $u = 0 ;
    my @deleteArray;
    
    Rex::Logger::info("当前全局内存存储变量数量: $allCount");
    for (my $var = 0; $var < $allCount; $var++) {
       my $process = $sharedeploy[$var]->{"mainProcess"};
       if ( "$process" eq "$mainProces" ) {
           $u = $u + 1;
           push @mainShared,$sharedeploy[$var] ;
           push @deleteArray,$var;
       }
    }

    my $i = 0;
    for (@deleteArray) {
        my $deleteIndex = $_-$i ;
        my $deleteprocess = $sharedeploy[$deleteIndex]->{"mainProcess"};
        if ( "$deleteprocess" eq "$mainProces"  ) {
            splice(@sharedeploy, $deleteIndex, 1);
        }       
        $i++;
    }      
    my $allCount =@sharedeploy;

    Rex::Logger::info("当前全局内存存储剩余变量数量: $allCount 当前实际使用变量数量: $u");

   
    my $sharedownCount = @mainShared;
    my %result = (
       msg => "success",
       code  => 0,
       count  => $sharedownCount,
       data => [@mainShared] ,
       srcdata => \%result
    );
    
    # (tied @sharedown)->remove;
    # IPC::Shareable->clean_up;
    # IPC::Shareable->clean_up_all;
    Common::Use::json($w,"0","成功",[\%result]);

    return \%result;




};

desc "应用回滚模块: rex  Enter:route:rollback  --rollstatus=0 --k='server1 server2 ..' \n--rollstatus=0:回滚到上一次最近版本(默认值).\n--rollstatus=1:根据数据库字段rollStatus=1回滚.";
task "rollback", sub {
   my $self = shift;
   my $k=$self->{k};
   my $username=$user;
  
   my $rollstatus=$self->{rollstatus};
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   my $auto_deloy;
   my %reshash ;
   $reshash{"k"} = "$k" ;
   $reshash{"rollstatus"} = "$rollstatus" ;
   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   $reshash{"code"} = -1 ;
   $reshash{"msg"} = "--k is null" ;
   return \%reshash;
   }

   if( $username eq ""  ){
   Rex::Logger::info("用户名(--u='')不能为空");
   $reshash{"code"} = -1 ;
   $reshash{"msg"} = "username is null" ;
   return \%reshash;
   }


   if( $rollstatus eq ""  ){
   Rex::Logger::info("回滚status不能为空(--rollstatus='')不能为空");
   $reshash{"code"} = -1 ;
   $reshash{"msg"} = "rollstatus can not be null" ;
   return \%reshash;
   }

   Rex::Logger::info("Starting ...... 操作人: $username");

   my @data;

   my @ks = split(/ /, $k);

   Rex::Logger::info("");
   Rex::Logger::info("开始应用回滚模块.");
   my %singleData ; 
   for my $kv (@ks) {
   if ( $kv ne "" ){
   if (exists($vars{$kv})){
   Rex::Logger::info("");
   Rex::Logger::info("##############($kv)###############"); 
   #初始化数据库信息
   $singleData{"k"} = $kv;
   my $config=Deploy::Core::init("$kv");
   $singleData{"config"} = $config;
   #判断是否加入了自动发布
   $auto_deloy=$config->{'auto_deloy'};
   if ( $auto_deloy eq "0"){
   $singleData{"errmsg"} ="($kv)--have not add deploy" ;
   push @data,\%singleData;
   Rex::Logger::info("($kv)--该应用没有加入自动发布","warn");
   next;
   } 

   #查询该系统是否处于发布的状态,并记录初始化的的信息
   my $myAppStatus=Deploy::Db::getDeployStatus($kv,$config->{'network_ip'},"$username");
   $singleData{"myAppStatus"} ="$myAppStatus" ;
   if($myAppStatus eq "1" ){
   $singleData{"errmsg"} ="($kv)--is deploying" ;
   push @data,\%singleData;    
   Rex::Logger::info("($kv)--该应用正在发布,跳过本次操作.","warn");
   next;
   } 
   #第一次连接获取远程服务器信息
   my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});    
   #获取上一个最近发布的版本记录
   my $getLastDeloy=Deploy::Db::getLastDeloy($kv,$rollstatus);
   $singleData{"getLastDeloy"} =$getLastDeloy;
   if( $getLastDeloy eq "0" ){
   $singleData{"errmsg"} ="($kv)--have not deploy record" ;
   push @data,\%singleData;    
   Rex::Logger::info("($kv)--该应用没有发布记录,跳过本次操作.","warn");
   next;
   };
   #若rollstatus=1
   if( $getLastDeloy eq "2" ){
   $singleData{"errmsg"} ="($kv)--have not deploy record where rollstatus=1" ;
   push @data,\%singleData;     
   Rex::Logger::info("($kv)--rollstatus=1时,数据中没有rollStatus=1的发布记录,跳过本次操作.","warn");
   next;
   };
   #若rollstatus=1
   if( $getLastDeloy eq "3" ){
   $singleData{"errmsg"} ="($kv)--have too many deploy record where rollstatus=1" ;
   push @data,\%singleData;     
   Rex::Logger::info("($kv)--rollstatus=1时,数据中存在rollStatus=1多条发布记录,跳过本次操作.","warn");
   next;
   };
   #更改软链接,重启应用
   run_task "Deploy:rollBack:linkrestart",on=>$config->{'network_ip'},params=>{ k => $kv,network_ip =>$config->{'network_ip'},ps_num=>$FistSerInfo->{'ps_num'},pro_key=>$config->{'pro_key'},pro_init=>$config->{'pro_init'},pro_dir=>$config->{'pro_dir'},config_dir=>$config->{'config_dir'},is_deloy_dir=>$config->{'is_deloy_dir'},myAppStatus=>"$myAppStatus",getLastDeloy=>$getLastDeloy}; 
   push @data,\%singleData;  
   }else{
   $singleData{"errmsg"} ="($kv)--app_key have not exist" ;
   push @data,\%singleData;      
   Rex::Logger::info("关键字($kv)不存在","error");
   }
   }}
   Rex::Logger::info("应用回滚模块完成.");
   $reshash{"data"} = \@data;
   return \%reshash;
};


desc "应用服务模块: rex  Enter:route:service --k='server1 server2 ..' --a='start/stop/restart' [--f='' --key='' --j='']";
task "service", sub {
   my $self = shift;
   my $k=$self->{k};
   my $a=$self->{a};
   my $j=$self->{j};
   my $f=$self->{f};
   my $key=$self->{key};
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;
   }
   if( $a eq ""  ){
   Rex::Logger::info("关键字(--a='')不能为空","error");
   exit;
   }
   
   my @ks = split(/ /, $k);

   Rex::Logger::info("");
   Rex::Logger::info("开始应用服务控制模块.");
   for my $kv (@ks) {
   if ( $kv ne "" ){
   if (exists($vars{$kv})){
   Rex::Logger::info("");
   Rex::Logger::info("##############($kv)###############");

   my $config=Deploy::Core::init("$kv");
   $config->{'action'} = "$a" ;
   $config->{'jsonfile'} = "$j" ;
   $config->{'services_file'} = "$f" ;
   $config->{'key'} = "$key" ;
   my $FistSerInfo=run_task "Deploy:FirstConnect:services",on=>$config->{'network_ip'},params => { config => $config};
   # Common::Use::jsondump($FistSerInfo);

   }else{
   Rex::Logger::info("关键字($kv)不存在","error");
   }
   }}
   Rex::Logger::info("应用服务控制模块完成.");
};



sub saveFile{
  my ($file,$content) = @_;
  my @data ; 
  $data[0] = "1";
  if ( "$file" ne "" ) {
   my $fh;
   eval {
        $fh = file_append "$file";
    };
    if ($@) {
        Rex::Logger::info("写入文件:$file 异常:$@","error");
        $data[0] = "0";
        $data[1] = "写入文件:$file 异常:$@";
        return \@data;
    } 
   
   $fh->write("$content");
   $fh->close;

  }
  $data[1] = "写入文件:$file $content 成功";
  return \@data;

};

desc "程序包Http下载合并  rex Enter:route:downloadCombile --k='server' --url='http://download.52zzb.com/1/cm-20180515-142727.tar.gz'
--downdir: 自定义下载目录
--set: 根据配置文件合并url
--full: 1增量更新 2全量更新
--dest: 1配置文件定义的softdir 2配置文件定义的update_local_prodir
";
task "downloadCombile",sub{
   my $self = shift;
   my $k=$self->{k};
   my $w=$self->{w};
   my $url=$self->{url};
   my $downdir=$self->{downdir};
   my $set=$self->{set};
   my $full=$self->{full};
   my $dest=$self->{dest};
   my %reshash ;
   my $now = strftime("%Y%m%d_%H%M%S", localtime(time));
   if ( $k eq "" ){
      Rex::Logger::info("k参数不能为空","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "k params is null";    
      return \%reshash;
   }
   if ( "$set" eq "3.102" ) {
     $url = $default_basehttp."/".$url;
   }elsif( "$set" eq "3.228" ){
     $url = $default_basehttp2."/".$url;
   }
   if ( $url eq "" ){
      Rex::Logger::info("url参数不能为空","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "url params is null";    
      return \%reshash;
   } 
   if ( "$downdir" eq "" ) {
      $downdir = $httpdowndir."/".$now;
   }
   my $config=Deploy::Db::query_ilocal_name($k);
   my $count = $config->{count};
   my $local_name = $config->{local_name} ;
   my $check = $config->{checkdir} ;
   my $predir = $config->{predir} ;
   if ( $count ne 1 ) {
      Rex::Logger::info("$k不存在或者存在多个k,目前仅支持下载单个url,单个k","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "$k is wrong ,please comfire";    
      return \%reshash;    
   }
   if ( "$local_name" eq "") {
      Rex::Logger::info("$k查询到local_name为空","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "$k local_name is null,please comfire";    
      return \%reshash;  
   }
   Rex::Logger::info("关联应用:$local_name 下载url:$url 下载路径: $downdir");
   if ( ! is_dir($downdir) ) {
      mkdir($downdir);
   }
   my $download = run_task "Common:Use:download",params => { dir1 => $url,dir2 => $downdir,http => 1};
   if ( $download->{code} == 0  ) {
      Rex::Logger::info("http下载成功");
   }else{
      Rex::Logger::info("http下载失败","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "http download faild";    
      return \%reshash;
   }
   my $localFile = $download->{download}->{localPath};
   my $fileJude = run "file -i $localFile";
   Rex::Logger::info("下载文件: $localFile");
   my $fileType;
   if ( $fileJude =~ m/application\/x-gzip/ ) { 
      $fileType = "tar";
   }elsif($fileJude =~ m/application\/zip/ ){
      $fileType = "zip";
   }else{
      $fileType = "file";
   }
   if ( $localFile =~ m/.jar$/ ) { 
      $fileType = "file";
   }   
   my $notFound = run "grep '404 Not Found' $localFile |wc -l";
   if ( $notFound > 0  ) {
      Rex::Logger::info("$url 访问404,请确认url是否正确 ","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "$url return 404";    
      return \%reshash;
   }
   Rex::Logger::info("下载文件类型: $fileType");
   my $unzip = unztar($localFile,$fileType,$downdir) ;
   my $code = $unzip->{code} ;
   my $res = $unzip->{res} ;
   if (  $code == -1  ) {
      Rex::Logger::info("解压文件: $localFile 失败: $res ","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "unzip $localFile faild";    
      return \%reshash;
   }
   Rex::Logger::info("解压成功");
   my $checkRes = checkDir($downdir,$is_check_dir,$check);
   if ( ! $checkRes ) {
      Rex::Logger::info("校验$downdir 目录列表失败,请检查该目录是否在允许列表之内","error");
      $reshash{"code"} = -1;
      $reshash{"msg"} = "check $downdir faild";    
      return \%reshash;
   }
   my $combileRes;
   if ( "$full" ne "" && "$dest" ne "") {
      $combileRes = combile($full,$dest,$local_name,$downdir,$predir);
      my $msg = $combileRes->{msg} ; 
      if ( $combileRes->{code} != 1  ) {
          Rex::Logger::info("合并http包失败: $msg  ","error");
          $reshash{"code"} = -1;
          $reshash{"msg"} = "combile http package faild";    
          return \%reshash;
      }
   }
   $reshash{"code"} = 1;
   $reshash{"msg"} = "success";
   return \%reshash;

};



#合并拷贝
sub combile{
   my ($full,$dest,$local_name,$downdir,$predir) = @_;
   my (%hash,$remoteDir) ;
   if ( "$dest"  eq "1" ) {
      $remoteDir = $softdir."/".$local_name;
   }elsif( "$dest"  eq "2"  ){
      $remoteDir = $update_local_prodir."/".$local_name;
   }else{
      $hash{"code"} = -1 ;
      $hash{"msg"} = "dest params is not in 1,2" ;
      Rex::Logger::info("dest参数不正确,仅支持1,2","error");
      return \%hash;
   } 
   if ( "$predir" ne ""  ) {
      $remoteDir = $remoteDir ."/". $predir;
   }
   if( ! is_dir($remoteDir) ){
      mkdir($remoteDir);
   }
   if ( "$full"  eq "1" ) {
      my $checkNumber= run "ls $remoteDir/ |wc -l";
      if (  $? ne 0 ) {
         Rex::Logger::info("执行查询目录失败: ls $remoteDir/ |wc -l","error");
         $hash{"code"} = -1 ;
         $hash{"msg"} = "cmd: ls $remoteDir/ |wc -l faild" ;
         return \%hash; 
      }
      if ( "$checkNumber" eq "0" ) {
         Rex::Logger::info("增量合并模式下,原目录为空:$remoteDir/ ","error");
         $hash{"code"} = -1 ;
         $hash{"msg"} = "$remoteDir must not be empty" ;
         return \%hash; 
      }
      run "cp -ar $downdir/* $remoteDir/"
   }elsif( "$full"  eq "2"  ){
     if( is_dir($remoteDir) ){
        rmdir($remoteDir);
     }
      mkdir($remoteDir);
      run "cp -ar $downdir/* $remoteDir/"
   }else{
      $hash{"code"} = -1 ;
      $hash{"msg"} = "full params is not in 1,2" ;
      Rex::Logger::info("full参数不正确,仅支持1,2","error");
      return \%hash;
   } 
   if ( $? ne 0 ) {
      Rex::Logger::info("合并$downdir => $remoteDir/ 失败","error");
      $hash{"code"} = -1 ;
      $hash{"msg"} = "combile $downdir => $remoteDir/ faild" ;
      return \%hash;      
   }
   Rex::Logger::info("合并$downdir => $remoteDir/ 成功");
   $hash{"code"} = 1 ;
   $hash{"msg"} = "success" ;
   return \%hash;   
} 


#校验第1级文件或者目录
sub checkDir{
   my ($dir,$is_check_dir,$check) = @_;
   if ( $is_check_dir != 1 ) {
      Rex::Logger::info("全局校验参数未开启");
      return 1 ;
   }
   my @checkArray = split(",",$check);
   my $localDirNames = run "ls $dir |xargs  |sed 's/ /,/g'";
   if ( $? != 0 ) {
      Rex::Logger::info("执行查询本地下载目录失败","error");
      return 0;
   }
   if ( "$localDirNames" eq "") {
      Rex::Logger::info("查询本地下载目录列表为空","error");
      return 0;
   }
   my @localDirNamesArray = split(",",$localDirNames);
   for  my $dir(@localDirNamesArray){
      if ( ! grep /^$dir$/, @checkArray) { 
          Rex::Logger::info("$dir 不在允许的列表之中:$check ","error");
          return 0 ; 
      }  
   }
   Rex::Logger::info("校验成功");
   return 1 ; 

};

#解压文件
sub unztar{
   my ($file,$type,$dir) = @_;
   my $res ; 
   my %hash ;
   my $cmd ;
   if ( ! is_file($file) ) {
     $hash{"code"} = -1 ; 
     $hash{"res"} = "$file is not exist" ; 
     return \%hash;
   }
   if ( !is_dir($dir) ) {
     mkdir($dir);
   }
   if ( $type eq "tar" ) {  
     $cmd = "tar -zxf $file -C $dir" ; 
   }elsif ( $type eq "zip" ) {
     $cmd  = "unzip $file -d $dir";
   }
   Rex::Logger::info("解压命令: $cmd");    
   $res = run "$cmd";
   if ( $? eq 0  ) {
     $hash{"code"} = 1 ;
   }else{      
     $hash{"code"} = -1 ; 
   }
   if ( $type ne "file" ) {
     unlink($file);
   }
   $hash{"res"} = $res ;
   $hash{"cmd"} = $cmd ;
   return \%hash;

}

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Enter::route/;

 task yourtask => sub {
    Enter::route::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut