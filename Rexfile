#!/usr/bin/perl
##author: 黄高明
##qq: 530035210
##blog: http://my.oschina.net/pwd/blog
##date: 2018-04-05
##des:基于名字服务的自动化平台

#开启相关模块支持
use Rex::Commands::Rsync;
use Deploy::Db;
use Data::Dumper;
use Deploy::Core;
use Deploy::Configure;
use Common::Use;
use Deploy::rollBack;
use Rex::Group::Lookup::INI;
use Enter::route;
use logCenter::main;
use User::main;
use loadService::main;
use Enter::deploy;
use JSON::XS;
use Encode;
use IPC::Shareable;
use Common::mysql;

#自定义config配置
my $env;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key} ;
 });
Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 $key_auth = $param->{key_auth} ;
 $pass_auth = $param->{pass_auth} ;
 our $user = $param->{user} ;
 $password = $param->{password} ;
 $private_key= $param->{private_key} ;
 $public_key = $param->{public_key} ;
 $global_sudo = $param->{global_sudo} ;
 $sudo_password = $param->{sudo_password} ;
 $logfile = $param->{logfile} ;
 $groups_files = $param->{groups_file} ;
 @groups_file = split(/,/,$groups_files);
 $timeout = $param->{timeout} ;
 $max_connect_retries = $param->{max_connect_retries} ;
 $parallelism = $param->{parallelism} ;
 $default_jsonfile = $param->{default_jsonfile} ;

 });


#SSH认证模块
if( $key_auth eq "true"  && $pass_auth eq "true"  ){
Rex::Logger::info("key_auth和pass_auth不能同时为真.","error");
exit;
}
if( $key_auth ne "true"  && $pass_auth ne "true"  ){
Rex::Logger::info("key_auth和pass_auth不能同时为假.","error");
exit;
}
if( $key_auth eq "true" ){
user "$user";
private_key "$private_key";
public_key "$public_key";
password "$password";
key_auth;
}
if( $pass_auth eq "true" ){
user "$user";
password "$password";
pass_auth;
}
if( $global_sudo eq "on"  ){
sudo -on;
sudo_password "$sudo_password";
}

#环境变量设置
source_global_profile  "1" ;
#并发设置
parallelism "$parallelism";
#日志文件
logging to_file => "$logfile";
#ssh超时时间和ssh最大的尝试次数
timeout "$timeout" ;
max_connect_retries  "$max_connect_retries";
#定义服务组
if ( $groups_file[0] eq "true") {
   groups_file "$groups_file[1]";
}

desc "检查服务器信息: rex check   --k='server1 server2 ../all'";
task "check",sub{
   my $self = shift;
   my $k=$self->{k};
   my $w=$self->{w};
   my $username=$user;
   my $passwod=$self->{p};
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys; 
   my $lastnum=$keys[-1] - 1;
   my $data = [];
   if( $k eq ""  ){
     Rex::Logger::info("关键字(--k='')不能为空");
     json($w,"","关键字(--k='')不能为空",""); 
     exit;	
   }

   if( $username eq ""  ){
   Rex::Logger::info("用户名(--u='')不能为空");
   json($w,"","用户名(--u='')不能为空","");
   exit;
   }

   Rex::Logger::info("Starting ...... 操作人: $username");

   my @ks = split(/ /, $k);
   if ( $k eq "all" ){
   Rex::Logger::info("");
   Rex::Logger::info("开始检查 发布系统 服务器以及数据库配置---$keys[-1] 个.");
   for my $num (0..$lastnum) {
   Rex::Logger::info("");
   Rex::Logger::info("##############($keys[$num])###############");
   #初始化数据库信息
   my $config=Deploy::Core::init("$keys[$num]");
   #say $keys[$num];     
   #第一次连接获取远程服务器信息
   my $FistSerInfo=Deploy::Core::prepare($keys[$num],$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'},$w);
   push $data, $FistSerInfo;
   }
   Rex::Logger::info("检查 发布系统 服务器以及数据库配置完成---$keys[-1] 个.");
   }else{   
   Rex::Logger::info("");
   Rex::Logger::info("开始检查 发布系统 服务器以及数据库配置.");    
   for my $kv (@ks) {
   if ( $kv ne "" ){
   if (exists($vars{$kv})){	   
   Rex::Logger::info("");
   Rex::Logger::info("##############($kv)###############");
   #初始化数据库信息
   my $config=Deploy::Core::init("$kv");
   #第一次连接获取远程服务器信息
   my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});  
   push $data, $FistSerInfo;
   }else{
   Rex::Logger::info("关键字($kv)不存在","error");
   }
   }}
   Rex::Logger::info("检查 发布系统 服务器以及数据库配置完成.");
   json($w,"0","成功",$data);
   }
};


desc "批量执行命令行: rex run  --k='server1 server2 ../all' --cmd='ls'";
task "run",sub{
   my $start = time;
   my $self = shift;
   my $cmd = $self->{cmd};
   my $k=$self->{k};
   my $w=$self->{w};
   my $data = [];
   my @shared;
   my $username=$user;
   if( $k eq ""  ){
     Rex::Logger::info("关键字(--k='')不能为空");
     json($w,"","关键字(--k='')不能为空",$data);
     exit;
   }
   if ( $cmd eq "" ){
     Rex::Logger::info("cmd命令不能为空.");
     json($w,"","cmd命令不能为空.",$data);
     exit;
   }
   if( $username eq ""  ){
     Rex::Logger::info("用户名(--u='')不能为空");
     json($w,"","用户名(--u='')不能为空",$data);
     exit;
   }
   my $ipch = tie @shared,   'IPC::Shareable',
                           "foco",
                           {  create    => 1,
                              exclusive => 'no',
                              mode      => 0666,
                              size      => 1024*512
                           };
   
   Rex::Logger::info("Starting ...... 操作人: $username");


   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   my @ks = split(/ /, $k);
   if ( $k eq "all" ){
     Rex::Logger::info("");
     Rex::Logger::info("开始执行命令模板---$keys[-1] 个.");
     my $maxchild = 5 ;
     my $max = @keys;
     my $s;
     my %hash_pids;
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
            Rex::Logger::info("执行命令模板完成.");
            my $take_time = time - $start;
            Rex::Logger::info("总共花费时间:$take_time秒.");
            json($w,"0","成功",\@shared);
            (tied @shared)->remove;
            IPC::Shareable->clean_up;
            IPC::Shareable->clean_up_all;
            exit; #全部结束
          }
          select(undef, undef, undef, 0.25);
          my $kv = $keys[$i];
          my $child=fork(); #派生一个子进程
          if($child){   # child >; 0, so we're the parent 
            $hash_pids{$child} = $child;  
            Rex::Logger::info("父进程PID:$$ 子进程PID:$child");
          }else{ 
            # 在子进程中执行相关动作
            Rex::Logger::info("执行子进程,进程序号:$i");
            if (  $kv =~ /^\d+$/ ){
	    }else{	
                Rex::Logger::info("");
                Rex::Logger::info("##############($kv)###############");
                my $config=Deploy::Core::init("$kv");
                my $runres = run_task "Common:Use:run",on=>$config->{'network_ip'},params=>{ cmd=>"$cmd",w=>"$w" };
                $runres->{"app_key"} = $kv;
                $ipch->shlock;
                push @shared, $runres;
                $ipch->shunlock;
            }
            exit 0;             # child is done 

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

     #Rex::Logger::info("执行命令模板完成---$keys[-1] 个.");
   }else{
     Rex::Logger::info("");
     Rex::Logger::info("开始执行命令模板.");
     my $maxchild = 5 ;
     my $max = @ks;
     my $s;
     my %hash_pids;
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
            Rex::Logger::info("执行命令模板完成.");
            my $take_time = time - $start;
            Rex::Logger::info("总共花费时间:$take_time秒.");
            json($w,"0","成功",\@shared);
            (tied @shared)->remove;
            IPC::Shareable->clean_up;
            IPC::Shareable->clean_up_all;
            exit; #全部结束
          }
          select(undef, undef, undef, 0.25);
      	  my $kv = $ks[$i];
	        my $child=fork(); #派生一个子进程
          if($child){   # child >; 0, so we're the parent 
	          $hash_pids{$child} = $child;  
	          Rex::Logger::info("父进程PID:$$ 子进程PID:$child");
          }else{ 
            # 在子进程中执行相关动作
            Rex::Logger::info("执行子进程,进程序号:$i");
            if ( $kv ne "" ){
              if (exists($vars{$kv})){
                Rex::Logger::info("");
                Rex::Logger::info("##############($kv)###############");
                my $config=Deploy::Core::init("$kv");
                my $runres = run_task "Common:Use:run",on=>$config->{'network_ip'},params=>{ cmd=>"$cmd" ,w=>"$w"};
                $runres->{"app_key"} = $kv;
                $ipch->shlock;
                push @shared, $runres;
                $ipch->shunlock;

              }else{
              Rex::Logger::info("关键字($kv)不存在","error");
              }
            }
            exit 0;             # child is done 

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


   }

};

desc "获取关键词列表: rex list \n";
task "list",sub{
   my $self = shift;
   my $w =$self->{w};
   my @data;
   my $keys = Deploy::Db::getlistkey();
   my $local_names = Deploy::Db::query_local_name();
   # my $local_names = join();
   Rex::Logger::info("");
   Rex::Logger::info("应用系统: $local_names");
   Rex::Logger::info("全部关键词: $keys");
   push @data,"$local_names";
   push @data,"$keys";
   json($w,"0","成功",\@data);
};


desc "根据识别名称滚动发布: rex deploy --k='server' [--senv='uat']\n";
task "deploy",sub{
    my $self = shift;
    my $k=$self->{k};
    my $w =$self->{w};
    my $senv =$self->{senv};
    if ( "$k"  eq  "") {
      Rex::Logger::info("识别名称--k不能为空","error");
      exit;
    }
    my $deployInfo=Enter::deploy::getdepoloy($k,$w,$senv);
    Rex::Logger::info("");
    return $deployInfo;
};

desc "根据识别名称直接发布: rex release --k='server' [--senv='uat']\n";
task "release",sub{
    my $self = shift;
    my $k=$self->{k};
    my $w =$self->{w};
    my $senv =$self->{senv};
    my @data;
    my $deployInfo=Enter::deploy::release($k,$w,$senv);
    push @data,$deployInfo;
    Rex::Logger::info("");
    json($w,"0","成功",\@data);
    return $deployInfo;
};



desc "print JSON";
task json =>,sub {
    my ($w,$code,$msg,$data) = @_;
    Common::Use::json($w,$code,$msg,$data);
};