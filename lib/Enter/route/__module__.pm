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
my $maxchild = 5 ;
my $s;
my $i;
my %hash_pids; 
my $env;
my $update_local_prodir;
my $update_local_confdir;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key} ;
 });
Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 our $user = $param->{user} ;
     $update_local_prodir   = $param->{update_local_prodir};
     $update_local_confdir  = $param->{update_local_confdir};
 });

desc "应用下载模块: rex  Enter:route:download   --k='server1 server2 ../groupname/all' [--update='1']";
task "download",sub{
   my $self = shift;
   my $k=$self->{k};
   my $update=$self->{update};
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
   # my $maxchild = 5 ;
   my $max = @ks;
    

   if( $k eq ""  ){
       Rex::Logger::info("关键字(--k='')不能为空");
   exit;
   }
   if( $username eq ""  ){
       Rex::Logger::info("用户名(--u='')不能为空");
   exit;
   }

   if ( "$update" eq "1") {
      if (  is_dir($update_local_prodir)) {
          rmdir("$update_local_prodir");
      }
      if (  is_dir($update_local_confdir)) {
          rmdir("$update_local_confdir");
      }
   }

   Rex::Logger::info("Starting ...... 操作人: $username");
   if ( $k eq "all" ){
       Rex::Logger::info("");
       Rex::Logger::info("开始下载远程服务器数据到本地---$keys[-1] 个.");
       for my $num (0..$lastnum) {
           Rex::Logger::info("");
           Rex::Logger::info("##############($keys[$num])###############");
           my $config=Deploy::Core::init("$keys[$num]");
           my $FistSerInfo=Deploy::Core::prepare($keys[$num],$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});
           Deploy::Core::downloading($keys[$num],$config->{'app_key'},$config->{'pro_dir'},$config->{'network_ip'},$config->{'config_dir'},$config,$update);	
       }
       Rex::Logger::info("下载远程服务器数据到本地完成---$keys[-1] 个.");
   }else{
   Rex::Logger::info("");
   Rex::Logger::info("开始下载远程服务器数据到本地.");
  
   #根据分组来下载应用
   for my $kv (@ks) {
       if ( $kv ne "" ){
           if (exists($localvars{$kv})){
               Rex::Logger::info("");
               Rex::Logger::info("##############【全部分区($kv)】###############");
               
               my $apps=Deploy::Db::localname_appkey($kv);
               my @apps=split(/,/, $apps);
               my %appvars = map { $_ => 1 } @apps;
               my $lastnums=$apps[-1] - 1;
               for my $num1 (0..$lastnums) {
                   Rex::Logger::info("");
                   Rex::Logger::info("##############($apps[$num1])###############");
                   my $config=Deploy::Core::init("$apps[$num1]");
                   my $FistSerInfo=Deploy::Core::prepare($apps[$num1],$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});
                   Deploy::Core::downloading($apps[$num1],$config->{'app_key'},$config->{'pro_dir'},$config->{'network_ip'},$config->{'config_dir'},$config,$update); 
               } 
           }
       }
   }  
   
   #根据的传值key来下载应用
	for(my $g=0; $g < $max ;){
		$g = $g+$maxchild;
		$s = $g-$maxchild ;
		if( $g > $max ){
		  Rex::Logger::info("并发控制:($s - $max)");
		}else{
		  Rex::Logger::info("并发控制:($s - $g)");
		}

		for($i=$g-$maxchild;$i<$g;$i++){
		  if( $i == $max  ){
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
		    exit; 
		    #全部结束
		  }
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
		       my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});
		       Deploy::Core::downloading($kv,$config->{'app_key'},$config->{'pro_dir'},$config->{'network_ip'},$config->{'config_dir'},$config,$update);	
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

   Rex::Logger::info("");
   Rex::Logger::info("下载远程服务器数据到本地完成.");
   }
};


desc "应用发布模块: rex  Enter:route:deploy --k='server1 server2 ..' \n";
task "deploy", sub {
   my $self = shift;
   my $k=$self->{k};
   my $username=$user;
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   my $start = time;
   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;
   }

   if( $username eq ""  ){
   Rex::Logger::info("操作人(--u='')不能为空");
   exit;
   }

   Rex::Logger::info("Starting ...... 操作人: $username");


   my @ks = split(/ /, $k);
   my $max = @ks;

   Rex::Logger::info("");
   Rex::Logger::info("开始应用发布模块.");
   for(my $g=0; $g < $max ;){
		$g = $g+$maxchild;
		$s = $g-$maxchild ;
		if( $g > $max ){
		  Rex::Logger::info("并发控制:($s - $max)");
		}else{
		  Rex::Logger::info("并发控制:($s - $g)");
		}

		for($i=$g-$maxchild;$i<$g;$i++){
		  if( $i == $max  ){
		     #最后一次收割并等待子进程完成
		     while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
		       my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
		       if ($kid and exists $hash_pids{$kid}) {
		         delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
		       }
		     }
		    Rex::Logger::info("应用发布模块完成.");
		    my $take_time = time - $start;
		    Rex::Logger::info("总共花费时间:$take_time秒.");
		    exit; 
		    #全部结束
		  }
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
				   #初始化数据库信息
				   my $config;
				   my $FistSerInfo;
		                   my $dir;
  				   my $myAppStatus;			
				   my $config=Deploy::Core::init("$kv");
				   my $auto_deloy;
				   #判断是否加入了自动发布
				   $auto_deloy=$config->{'auto_deloy'};
				   if ( $auto_deloy eq "0"){
				     Rex::Logger::info("($kv)--该应用没有加入自动发布","warn");
				     # next;
				     exit 0;
				   }
				   #查询该系统是否处于发布的状态,并记录初始化的的信息
				   my $myAppStatus=Deploy::Db::getDeployStatus($kv,$config->{'network_ip'},"$username");
				   if($myAppStatus eq "1" ){
				     Rex::Logger::info("($kv)--该应用正在发布,跳过本次操作.","warn");
				     # next;
				     exit 0;
				   }
				   #第一次连接获取远程服务器信息
				   my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});
				   #上传程序目录和配置目录
				   my $dir=Deploy::Core::uploading($kv,$config->{'local_name'},$config->{'pro_dir'},$config->{'network_ip'},$config->{'config_dir'},$config->{'app_key'},$config->{'is_deloy_dir'},$config->{'pro_dir'},$config->{'config_dir'},"$myAppStatus");	
				   #更改软链接,重启应用
				   #run_task "Deploy:Core:linkrestart",on=>$config->{'network_ip'},params=>{ k => $kv,network_ip =>$config->{'network_ip'},ps_num=>$FistSerInfo->{'ps_num'},pro_key=>$config->{'pro_key'},pro_init=>$config->{'pro_init'},remote_prodir=>$dir->{'remote_prodir'},remote_configdir=>$dir->{'remote_configdir'},pro_dir=>$config->{'pro_dir'},config_dir=>$config->{'config_dir'},is_deloy_dir=>$config->{'is_deloy_dir'},localdir=>$dir->{'localdir'},local_config_dir=>$dir->{'local_config_dir'},myAppStatus=>"$myAppStatus",backupdir_same_level=>$config->{'backupdir_same_level'},deploydir_same_level=>$config->{'deploydir_same_level'}};	
				   run_task "Deploy:Core:linkrestart",on=>$config->{'network_ip'},params=>{ k => $kv,config =>$config,FistSerInfo=>$FistSerInfo,dir=>$dir,myAppStatus=>"$myAppStatus"};	
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
   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;
   }

   if( $username eq ""  ){
   Rex::Logger::info("用户名(--u='')不能为空");
   exit;
   }


   if( $rollstatus eq ""  ){
   Rex::Logger::info("回滚status不能为空(--rollstatus='')不能为空");
   exit;
   }

   Rex::Logger::info("Starting ...... 操作人: $username");


   my @ks = split(/ /, $k);

   Rex::Logger::info("");
   Rex::Logger::info("开始应用回滚模块.");
   for my $kv (@ks) {
   if ( $kv ne "" ){
   if (exists($vars{$kv})){
   Rex::Logger::info("");
   Rex::Logger::info("##############($kv)###############");
   #初始化数据库信息
   my $config=Deploy::Core::init("$kv");
   #判断是否加入了自动发布
   $auto_deloy=$config->{'auto_deloy'};
   if ( $auto_deloy eq "0"){
   Rex::Logger::info("($kv)--该应用没有加入自动发布","warn");
   next;
   } 

   #查询该系统是否处于发布的状态,并记录初始化的的信息
   my $myAppStatus=Deploy::Db::getDeployStatus($kv,$config->{'network_ip'},"$username");
   if($myAppStatus eq "1" ){
   Rex::Logger::info("($kv)--该应用正在发布,跳过本次操作.","warn");
   next;
   } 
   #第一次连接获取远程服务器信息
   my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});    
   #获取上一个最近发布的版本记录
   my $getLastDeloy=Deploy::Db::getLastDeloy($kv,$rollstatus);
   if( $getLastDeloy eq "0" ){
   Rex::Logger::info("($kv)--该应用没有发布记录,跳过本次操作.","warn");
   next;
   };
   #若rollstatus=1
   if( $getLastDeloy eq "2" ){
   Rex::Logger::info("($kv)--rollstatus=1时,数据中没有rollStatus=1的发布记录,跳过本次操作.","warn");
   next;
   };
   #若rollstatus=1
   if( $getLastDeloy eq "3" ){
   Rex::Logger::info("($kv)--rollstatus=1时,数据中存在rollStatus=1多条发布记录,跳过本次操作.","warn");
   next;
   };
   #更改软链接,重启应用
   run_task "Deploy:rollBack:linkrestart",on=>$config->{'network_ip'},params=>{ k => $kv,network_ip =>$config->{'network_ip'},ps_num=>$FistSerInfo->{'ps_num'},pro_key=>$config->{'pro_key'},pro_init=>$config->{'pro_init'},pro_dir=>$config->{'pro_dir'},config_dir=>$config->{'config_dir'},is_deloy_dir=>$config->{'is_deloy_dir'},myAppStatus=>"$myAppStatus",getLastDeloy=>$getLastDeloy}; 

   }else{
   Rex::Logger::info("关键字($kv)不存在","error");
   }
   }}
   Rex::Logger::info("应用回滚模块完成.");
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