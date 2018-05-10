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
use Common::Rexfile;
use Common::Process;

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
   Common::Rexfile::check($k,$w,$user);
};


desc "批量执行命令行: rex run  --k='server1 server2 ../all' --cmd='ls'";
task "run",sub{
   my $self = shift;
   my $cmd = $self->{cmd};
   my $k=$self->{k};
   my $w=$self->{w};
   Common::Rexfile::batchrun($k,$w,$cmd,$user);
};

desc "获取关键词列表: rex list \n";
task "list",sub{
   my $self = shift;
   my $w =$self->{w};
   my @data;
   my $keys = Deploy::Db::getlistkey();
   my $local_names = Deploy::Db::query_local_name();
   Rex::Logger::info("");
   Rex::Logger::info("应用系统: $local_names");
   Rex::Logger::info("全部关键词: $keys");
   push @data,"$local_names";
   push @data,"$keys";
   Common::Use::json($w,"0","成功",\@data);
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
    Common::Use::json($w,"0","成功",\@data);
    return $deployInfo;
};

desc "服务控制: rex service --k='server1 server2 ..' --a='start/stop/restart' [--f='' --key='' --j='']";
task "service",sub{
   my $self = shift;
   my $k=$self->{k};
   my $a=$self->{a};
   my $f=$self->{f};
   my $key=$self->{key};
   my $j=$self->{j};
   my $w=$self->{w};
   Common::Rexfile::batchservice($k,$w,$a,$f,$key,$j);
};

desc "批量文件下载 远程->本地:rex download --k='server1 server2 ..' --dir1='/tmp/1.txt' --dir2='/tmp/' [--ipsep='1']";
task "download",sub{
   my $self = shift;
   my $k=$self->{k};
   my $w=$self->{w};
   my $dir1=$self->{dir1};
   my $dir2=$self->{dir2};
   my $ipsep=$self->{ipsep};
   my $http=$self->{http};
   Common::Rexfile::batchdownload($k,$w,$dir1,$dir2,$ipsep,$http);
};

desc "批量文件上传 远程->本地:rex upload --k='server1 server2 ..' --dir1='/tmp/1.txt' --dir2='/tmp/' [--ipsep='1']";
task "upload",sub{
   my $self = shift;
   my $k=$self->{k};
   my $w=$self->{w};
   my $dir1=$self->{dir1};
   my $dir2=$self->{dir2};
   my $ipsep=$self->{ipsep};
   Common::Rexfile::batchupload($k,$w,$dir1,$dir2,$ipsep);
};
