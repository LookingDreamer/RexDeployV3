package Common::Rexfile;

use Rex -base;
use Data::Dumper;
use IPC::Shareable;
use POSIX;

#desc "检查服务器信息: rex check   --k='server1 server2 ../all'";
sub check{
	my ($k,$w,$username) = @_;	 
	my $keys=Deploy::Db::getallkey();
	my @keys=split(/,/, $keys);
	my %vars = map { $_ => 1 } @keys; 
	my $lastnum=$keys[-1] - 1;
	my $data = [];
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
			}
		}
		Rex::Logger::info("检查 发布系统 服务器以及数据库配置完成.");
		Common::Use::json($w,"0","成功",$data);
	}

}


sub batchrun{
   my ($k,$w,$cmd,$username) = @_;
   my $params = { cmd=>"$cmd" ,wb=>1,w=>$w};
   my $result = Common::Process::moreProcess($k,$w,"批量命令模块","Common:Use:run",$params) ;
   Common::Use::json($w,"0","成功",[$result]);

};

sub batchservice{
   my ($k,$w,$a,$f,$key,$j) = @_;
   my $params = { a=>"$a" ,f=>"$f",key=>"$key",j=>"$j"};
   my $result = Common::Process::moreProcess($k,$w,"服务控制模块","Deploy:FirstConnect:services",$params) ;
   Common::Use::json($w,"0","成功",[$result]);
};

sub batchdownload{
   my ($k,$w,$dir1,$dir2,$ipsep,$http)= @_;
   my $params = { dir1=>"$dir1" ,dir2=>$dir2,ipsep=>$ipsep,http=>$http};
   my $result = Common::Process::moreProcess($k,$w,"批量文件下载","Common:Use:download",$params) ;
   Common::Use::json($w,"0","成功",[$result]);
};

sub batchupload{
   my ($k,$w,$dir1,$dir2,$ipsep)= @_;
   my $params = { dir1=>"$dir1" ,dir2=>$dir2,ipsep=>$ipsep};
   my $result = Common::Process::moreProcess($k,$w,"批量文件上传","Common:Use:upload",$params) ;
   Common::Use::json($w,"0","成功",[$result]);
};

sub batchrollback{
   my ($k,$w,$rollstatus) = @_;
   my $params = {w=>"$w",rollstatus=>"$rollstatus"};
   my $result = Common::Process::moreProcess($k,$w,"应用回滚","Enter:route:rollback",$params,"1") ;
   Common::Use::json($w,"0","成功",[$result]);
};

sub batchcheckurl{
   my ($k,$w,$rollstatus) = @_;
   my $params = {w=>"$w"};
   my $result = Common::Process::moreProcess($k,$w,"校验url","loadService:main:check",$params,"1") ;
   Common::Use::json($w,"0","成功",[$result]);
};

sub batchqueryk{
   my ($k,$w,$file) = @_;
   my $params = {file=>"$file"};
   my $result = Common::Process::moreProcess($k,$w,"负载均衡查询","loadService:main:queryk",$params,"1") ;
   Common::Use::json($w,"0","成功",[$result]);
};

sub batchupdatek{
   my ($k,$w,$weight) = @_;
   my $params = {w=>"$weight"};
   my $result = Common::Process::moreProcess($k,$w,"负载均衡修改","loadService:main:update",$params,"1") ;
   Common::Use::json($w,"0","成功",[$result]);
};

sub batchgetLog{
   my ($k,$w,$download_local) = @_;
   my $params = {download_local=>$download_local};
   my $result = Common::Process::moreProcess($k,$w,"日志下载","logCenter:main:getLog",$params,"1") ;
   Common::Use::json($w,"0","成功",[$result]);
};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Common::Rexfile/;

 task yourtask => sub {
    Common::Rexfile::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
