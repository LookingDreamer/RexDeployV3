package logCenter::main;

use Rex -base;
use Deploy::Db;
use Deploy::Core;
use Data::Dumper;
use Common::Use;
use POSIX qw(strftime); 
my $env;
my $download_dir;
my $log_rsync_server;
my $log_rsync_user;
my $log_rsync_pass;
my $log_rsync_module;
my $max_grep_row;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key} ;
 });
Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 $download_dir = $param->{download_dir} ;
 $log_rsync_server = $param->{log_rsync_server} ;
 $log_rsync_user = $param->{log_rsync_user} ;
 $log_rsync_pass = $param->{log_rsync_pass} ;
 $log_rsync_module = $param->{log_rsync_module} ;
 $max_grep_row = $param->{max_grep_row} ;
 });

desc "查看实时日志\n1.0 rex  logCenter:main:liveLog  --search='cm58'\n2.0 rex -H '115.159.235.58' logCenter:main:liveLog  --log='/data/log/cm/catalina.out.2017-03-06'\n";
task "liveLog", sub {
	my $self = shift;
	my $log = $self->{log};
	my $search = $self->{search};

	if( $log eq "" and $search eq "" ){
		Rex::Logger::info("日志参数或者搜索关键词不能同时为空","error");
		exit;			
	}
	if( $log ne "" and $search eq ""  ){
		my $server = Rex->get_current_connection()->{'server'};
		my $names = Deploy::Db::showname($server);
		if ( ! is_file($log) ) {
			Rex::Logger::info("\033[0;32m[$server]-[$names] \033[0m $log 远程日志文件不存在.","error");
			exit;
		}
		tail "$log", sub {
			my ($data) = @_;

			if($names eq "none"){
				print "[$server] >> $data\n";

			}elsif($names eq "null"){
				print "[$server] >> $data\n";

			}else{
				print "\033[0;32m[$server]-[$names] \033[0m >> $data\n";

			}

		};
	}elsif($log eq "" and $search ne ""){
		my @search;
        my @search = search($search);
        my $network_ip = $search[0][0];
        my $log = $search[0][1];
        my $names = $search[0][2];
        my $external_ip = $search[0][3];
        Rex::Logger::info("服务器内网地址:$network_ip,服务器外网地址:$external_ip");
        Rex::Logger::info("服务器名称:$names");
        run_task "logCenter:main:loglive",on=>$network_ip,params => { log => $log,names=>$names}

	}else{
		my $server = Rex->get_current_connection()->{'server'};
		my $names = Deploy::Db::showname($server);
		if ( ! is_file($log) ) {
			Rex::Logger::info("\033[0;32m[$server]-[$names] \033[0m $log 远程日志文件不存在.","error");
			exit;
		}
		tail "$log", sub {
			my ($data) = @_;

			if($names eq "none"){ 
				print "[$server] >> $data\n";

			}elsif($names eq "null"){
				print "[$server] >> $data\n";

			}else{
				print "\033[0;32m[$server]-[$names] \033[0m >> $data\n";

			}

		};


	}

};

task "loglive", sub {
	my $self = shift;
    my $log=$self->{log};
    my $names=$self->{names};
	tail "$log", sub {
	my ($data) = @_;
	my $server = Rex->get_current_connection()->{'server'};
	
	if ( ! is_file($log) ) {
		Rex::Logger::info("\033[0;32m[$server]-[$names] \033[0m $log 远程日志文件不存在.","error");
		exit;
	}

	if($names eq "none"){
		print "[$server] >> $data\n";

	}elsif($names eq "null"){
		print "[$server] >> $data\n";

	}else{
		print "\033[0;32m[$server]-[$names] \033[0m >> $data\n";

	}
};

};

desc "查看日志列表\n1.0 rex  logCenter:main:lookLog  --search='cm58'\n2.0 rex -H '115.159.235.58' logCenter:main:lookLog  --logdir='/data/log/cm/'\n";
task "lookLog", sub {
	my $self = shift;
	my $logdir = $self->{logdir};
	my $search = $self->{search};
	my $more = $self->{more} ;
	my $myFiles;

	if( $logdir eq "" and $search eq "" ){
		Rex::Logger::info("日志目录参数或者搜索关键词不能同时为空","error");
		exit;			
	}
	if ( $more eq "") {
		$more = '0';
	}
	if( $logdir ne "" and $search eq ""  ){
		my $server = Rex->get_current_connection()->{'server'};
		my $names = Deploy::Db::showname($server);
		if ( ! is_dir($logdir) ) {
			Rex::Logger::info("服务器: [$server]-[$names] $logdir远程日志目录不存在.","error");
			exit;
		}
		Rex::Logger::info("[$server]-[$names] 远程日志目录:$logdir");
		if ( $more eq '1') {
			Rex::Logger::info("当前日志目录所有日志如下:");
			$myFiles = run "ls -lht --time-style='+%Y-%m-%d %H:%M:%S' $logdir |awk '{print \$5,\$6,\$7,\$8}' |column -t  ";
		}else{
			Rex::Logger::info("最近30条日志记录,如若需要更前的日志,可以加上参数--more='1'");
			$myFiles = run "ls -lht --time-style='+%Y-%m-%d %H:%M:%S' $logdir |head -n 30  |awk '{print \$5,\$6,\$7,\$8}' |column -t  ";			
		}
		Rex::Logger::info("\n$myFiles");
		exit;
	}elsif($logdir eq "" and $search ne ""){
		my @search;
        my @search = search($search);
        my $network_ip = $search[0][0];
        my $log = $search[0][1];
        my $names = $search[0][2];
        my $external_ip = $search[0][3];
        my $logdir = $search[0][4];
        Rex::Logger::info("服务器内网地址:$network_ip,服务器外网地址:$external_ip");
        Rex::Logger::info("服务器名称:$names");
        run_task "logCenter:main:listFile",on=>$network_ip,params => { logdir => $logdir,more=>$more}

	}else{
		my $server = Rex->get_current_connection()->{'server'};
		my $names = Deploy::Db::showname($server);
		if ( ! is_dir($logdir) ) {
			Rex::Logger::info("服务器: [$server]-[$names] $logdir远程日志目录不存在.","error");
			exit;
		}
		Rex::Logger::info("[$server]-[$names] 远程日志目录:$logdir");
		Rex::Logger::info("最近30条日志记录,如若需要更前的日志,可以自行根据日志规律组合日志路径");
		my $myFiles = run "ls -lht --time-style='+%Y-%m-%d %H:%M:%S'  /data/log/cm |head -n 30  |awk '{print \$5,\$6,\$7,\$8}' |column -t  ";
		Rex::Logger::info("\n$myFiles");
		exit;

	}

};

task "listFile",sub{
	my $self = shift;
	my $logdir = $self->{logdir};
	my $more = $self->{more};
	my $myFiles;
	if ( $more eq '1') {
		Rex::Logger::info("当前日志目录所有日志如下:");
		$myFiles = run "ls -lht --time-style='+%Y-%m-%d %H:%M:%S' $logdir |awk '{print \$5,\$6,\$7,\$8}' |column -t  ";
	}else{
		Rex::Logger::info("最近30条日志记录,如若需要更前的日志,可以加上参数--more='1'");
		$myFiles = run "ls -lht --time-style='+%Y-%m-%d %H:%M:%S' $logdir |head -n 30  |awk '{print \$5,\$6,\$7,\$8}' |column -t  ";			
	}
	Rex::Logger::info("\n$myFiles");
	exit;
};

desc "下载日志模块\n1.0 rex  logCenter:main:getLog  --search='cm58'\n2.0 rex -H '115.159.235.58' logCenter:main:getLog  --log='/data/log/cm/catalina.out.2017-03-06'\n";
task "getLog", sub {
	my $self = shift;
	my $log = $self->{log};
	my $search = $self->{search};
	my $download_local = $self->{download_local};

	if( $log eq "" and $search eq "" ){
		Rex::Logger::info("日志参数或者搜索关键词不能同时为空","error");
		exit;			
	}
	if ( $download_local eq "") {
		$download_local = '0';
	}
	if( $log ne "" and $search eq ""  ){
		my $server = Rex->get_current_connection()->{'server'};
		my $names = Deploy::Db::showname($server);
		if ( ! is_file($log) ) {
			Rex::Logger::info("\033[0;32m[$server]-[$names] \033[0m $log 远程日志文件不存在.","error");
			exit;
		}
		Rex::Logger::info("服务器:[$server]-[$names] 远程日志:$log");
		my $download = "$download_dir$server/";
		my $size = run "du -sh $log";
		Rex::Logger::info("当前日志文件大小:$size");
		if ( $download_local eq '1' ) {
			LOCAL{
				if ( ! is_dir($download) ) {
					mkdir($download);
					Rex::Logger::info("创建本地目录:$download");
				}else{
					Rex::Logger::info("本地目录:$download已经存在");
				}
			};
			Rex::Logger::info("开始下载远程日志文件");
			run_task "Common:Use:download",on=>"$server",params => {dir1=>"$log",dir2=>"$download"};
		}else{
			Rex::Logger::info("开始上传到存储中心...");
			my $res = run "echo '$log_rsync_pass' > /tmp/rsync_passwd && chmod 600 /tmp/rsync_passwd &&  rsync -vzrtopg --progress --password-file=/tmp/rsync_passwd $log $log_rsync_user\@$log_rsync_server\:\:$log_rsync_module\/$server/ && result=\$? ;echo status=\$result";
			Rex::Logger::info("$res");
			if ( $res =~ /status=0/ ) {
				Rex::Logger::info("上传成功,请到存储中心下载,下载路径:http://172.16.0.244:81/logupload/$server/");
			}else{
				Rex::Logger::info("上传失败,请联系运维人员处理.");
			}

		}

	}elsif($log eq "" and $search ne ""){
		my @search;
        my @search = search($search);
        my $network_ip = $search[0][0];
        my $log = $search[0][1];
        my $names = $search[0][2];
        my $external_ip = $search[0][3];
        Rex::Logger::info("服务器内网地址:$network_ip,服务器外网地址:$external_ip");
        Rex::Logger::info("服务器名称:$names,服务器日志:$log");
		my $download = "$download_dir$network_ip/";
		# my $size = run "du -sh $log";
		# Rex::Logger::info("当前日志文件大小:$size");
		if ( $download_local eq '1' ) {
			LOCAL{
				if ( ! is_dir($download) ) {
					mkdir($download);
					Rex::Logger::info("创建本地目录:$download");
				}else{
					Rex::Logger::info("本地目录:$download已经存在");
				}
			};
			Rex::Logger::info("开始下载远程日志文件");
			run_task "Common:Use:download",on=>"$network_ip",params => {dir1=>"$log",dir2=>"$download"};
		}else{
			Rex::Logger::info("开始上传到存储中心...");
			my $cmd="echo '$log_rsync_pass' > /tmp/rsync_passwd && chmod 600 /tmp/rsync_passwd &&  rsync -vzrtopg --progress --password-file=/tmp/rsync_passwd $log $log_rsync_user\@$log_rsync_server\:\:$log_rsync_module\/$network_ip/ && result=\$? ;echo status=\$result";
			my $res=run_task "Common:Use:apirun",on=>"$network_ip",params => {cmd=>"$cmd"};			
			Rex::Logger::info("$res");
			if ( $res =~ /status=0/ ) {
				Rex::Logger::info("上传成功,请到存储中心下载,下载路径:http://172.16.0.244:81/logupload/$network_ip/");
			}else{
				Rex::Logger::info("上传失败,请联系运维人员处理.");
			}

		}

	}else{
		my $server = Rex->get_current_connection()->{'server'};
		my $names = Deploy::Db::showname($server);
		if ( ! is_file($log) ) {
			Rex::Logger::info("\033[0;32m[$server]-[$names] \033[0m $log 远程日志文件不存在.","error");
			exit;
		}
		Rex::Logger::info("服务器:[$server]-[$names] 远程日志:$log");
		my $download = "$download_dir$server/";
		my $size = run "du -sh $log";
		Rex::Logger::info("当前日志文件大小:$size");
		if ( $download_local eq '1' ) {
			LOCAL{
				if ( ! is_dir($download) ) {
					mkdir($download);
					Rex::Logger::info("创建本地目录:$download");
				}else{
					Rex::Logger::info("本地目录:$download已经存在");
				}
			};
			Rex::Logger::info("开始下载远程日志文件");
			run_task "Common:Use:download",on=>"$server",params => {dir1=>"$log",dir2=>"$download"};
		}else{
			Rex::Logger::info("开始上传到存储中心...");
			my $res = run "echo '$log_rsync_pass' > /tmp/rsync_passwd && chmod 600 /tmp/rsync_passwd &&  rsync -vzrtopg --progress --password-file=/tmp/rsync_passwd $log $log_rsync_user\@$log_rsync_server\:\:$log_rsync_module\/$server/ && result=\$? ;echo status=\$result";
			Rex::Logger::info("$res");
			if ( $res =~ /status=0/ ) {
				Rex::Logger::info("上传成功,请到存储中心下载,下载路径:http://172.16.0.244:81/logupload/$server/");
			}else{
				Rex::Logger::info("上传失败,请联系运维人员处理.");
			}

		}

	}

};

desc "查询当前列表\nrex logCenter:main:queryList\n";
task "queryList", sub {
	my @res ;
	my @res = Deploy::Db::server_info();
	my $count = $res[0][0];
	for my $num (1..$count) {
		my $name = $res[0][$num]{"server_name"};
		my $external_ip = $res[0][$num]{"external_ip"};
		my $network_ip = $res[0][$num]{"network_ip"};
		printf("%-30s%-30s%-30s\n",$name,$external_ip,$network_ip);
	}
};

desc "日志文件过滤\n1.0 rex  logCenter:main:grepLog  --search='cm58' --grep='进入CM 后台' \n2.0 rex -H '115.159.235.58' logCenter:main:grepLog  --log='/data/log/cm/catalina.out.2017-03-06' --grep='进入CM 后台'\n";
task "grepLog", sub {
	my $self = shift;
	my $log = $self->{log};
	my $search = $self->{search};
	my $grep = $self->{grep};
	my $debug = $self->{debug};

	if( $log eq "" and $search eq "" ){
		Rex::Logger::info("日志参数或者搜索关键词不能同时为空","error");
		exit;			
	}
	if( $grep eq ""){
		Rex::Logger::info("过滤关键词不能为空","error");
		exit;	
	}
	if ( $debug eq "") {
		$debug = 0 ;
	}

	if($log eq "" and $search ne ""){
		my @search;
        my @search = search($search);
        my $network_ip = $search[0][0];
        my $log = $search[0][1];
        my $names = $search[0][2];
        my $external_ip = $search[0][3];
        Rex::Logger::info("服务器内网地址:$network_ip,服务器外网地址:$external_ip");
        Rex::Logger::info("服务器名称:$names 服务器日志:$log");

		my $cmd = "du -sh $log ; grep  '$grep' $log |wc -l ";
		my $output=run_task "Common:Use:apirun",on=>"$network_ip",params => {cmd=>"$cmd"};
		my @output_list = split(/$log/, $output);
		$output_list[1] =~ s/\n//;
		Rex::Logger::info("过滤关键词:$grep ");
		Rex::Logger::info("日志文件:$log 日志大小:$output_list[0] 过滤后行数:$output_list[1]");
		my $output_grep;
		my $now = strftime("%Y%m%d_%H%M%S", localtime(time));
		my $grep_log = "$log"."_grep_$now";
		if ( $output_list[1] > $max_grep_row) {
			if ( $debug eq '1' or $debug eq 1 ) {
				my $cmd = "grep  '$grep' $log > $grep_log && result=\$? ;echo status=\$result";
				my $resgrep = run_task "Common:Use:apirun",on=>"$network_ip",params => {cmd=>"$cmd"};
				if ( $resgrep =~ /status=0/ ) {
					Rex::Logger::info("生成过滤文件成功:$grep_log");
				}else{
					Rex::Logger::info("生成过滤文件失败:$grep_log");
					exit;
				}				
				Rex::Logger::info("保存过滤后日志到文本:$grep_log");
				Rex::Logger::info("开始上传过滤后文件到存储中心...");
				my $cmd = "echo '$log_rsync_pass' > /tmp/rsync_passwd && chmod 600 /tmp/rsync_passwd &&  rsync -vzrtopg --progress --password-file=/tmp/rsync_passwd $grep_log $log_rsync_user\@$log_rsync_server\:\:$log_rsync_module\/$network_ip/ && result=\$? ;echo status=\$result";
				my $res=run_task "Common:Use:apirun",on=>"$network_ip",params => {cmd=>"$cmd"};
				Rex::Logger::info("$res");
				if ( $res =~ /status=0/ ) {
					Rex::Logger::info("上传成功,请到存储中心下载,下载路径:http://172.16.0.244:81/logupload/$network_ip/");
				}else{
					Rex::Logger::info("上传失败,请联系运维人员处理.");
				}
			}else{
				Rex::Logger::info("过滤后的内容行数大于$max_grep_row,默认只显示后$max_grep_row行,如果想显示更多结果,请添加参数--debug=1 ","warn");
				my $cmd = "grep  '$grep' $log |tail -n $max_grep_row";
				$output_grep=run_task "Common:Use:apirun",on=>"$network_ip",params => {cmd=>"$cmd"};
			}
		}else{
			my $cmd = "grep  '$grep' $log";
			$output_grep=run_task "Common:Use:apirun",on=>"$network_ip",params => {cmd=>"$cmd"};
		}
		if ( $output_grep ne "" ) {
			Rex::Logger::info("过滤内容如下:");
			print("\n$output_grep\n");
		}
		exit;


	}else{

		my $server = Rex->get_current_connection()->{'server'};
		my $names = Deploy::Db::showname($server);
		if ( ! is_file($log) ) {
			Rex::Logger::info("\033[0;32m[$server]-[$names] \033[0m $log 远程日志文件不存在.","error");
			exit;
		}
		my $output = run "du -sh $log ; grep  --color '$grep' $log |wc -l ";
		my @output_list = split(/$log/, $output);
		$output_list[1] =~ s/\n//;
		Rex::Logger::info("服务器:[$server]-[$names]");
		Rex::Logger::info("过滤关键词:$grep ");
		Rex::Logger::info("日志文件:$log 日志大小:$output_list[0] 过滤后行数:$output_list[1]");
		my $output_grep;
		my $now = strftime("%Y%m%d_%H%M%S", localtime(time));
		my $grep_log = "$log"."_grep_$now";
		if ( $output_list[1] > $max_grep_row) {
			if ( $debug eq '1' or $debug eq 1 ) {
				run "grep  '$grep' $log > $grep_log";
				if ( is_file($grep_log) ) {
					Rex::Logger::info("生成过滤文件成功:$grep_log");
				}else{
					Rex::Logger::info("生成过滤文件失败:$grep_log");
					exit;
				}
				Rex::Logger::info("保存过滤后日志到文本:$grep_log");
				Rex::Logger::info("开始上传过滤后文件到存储中心...");
				my $res = run "echo '$log_rsync_pass' > /tmp/rsync_passwd && chmod 600 /tmp/rsync_passwd &&  rsync -vzrtopg --progress --password-file=/tmp/rsync_passwd $grep_log $log_rsync_user\@$log_rsync_server\:\:$log_rsync_module\/$server/ && result=\$? ;echo status=\$result";
				Rex::Logger::info("$res");
				if ( $res =~ /status=0/ ) {
					Rex::Logger::info("上传成功,请到存储中心下载,下载路径:http://172.16.0.244:81/logupload/$server/");
				}else{
					Rex::Logger::info("上传失败,请联系运维人员处理.");
				}
			}else{
				Rex::Logger::info("过滤后的内容行数大于$max_grep_row,默认只显示后$max_grep_row行,如果想显示更多结果,请添加参数--debug=1 ","warn");
				$output_grep = run "grep  '$grep' $log |tail -n $max_grep_row";
			}
		}else{
			$output_grep = run "grep  '$grep' $log";
		}
		if ( $output_grep ne "" ) {
			Rex::Logger::info("过滤内容如下:");
			print("\n$output_grep\n");
		}
		exit;

	}

};


sub search{

	my $search = @_[0];
	my @config;
	my @data;
	my $log;
	if( $search eq ""){
		Rex::Logger::info("搜索关键词不能为空","error");
		exit;
	}
	my @config=Deploy::Db::search_info("$search");
	my $count = $config[0][0];
	my $queryLogDir = $config[0][1]{'log_dir'};
	my $queryLogFile = $config[0][1]{'logfile'};
	my $network_ip = $config[0][1]{'network_ip'};
	my $external_ip = $config[0][1]{'external_ip'};
	my $names = $config[0][1]{'server_name'};
	Rex::Logger::info("返回$count条数据");
	if( $count == 0 ){
		Rex::Logger::info("查询数据为空,请检查搜索关键词.","error");
		exit;	
	}
	if(  $count > 1  ){
		my @server_name ;
		for my $num (1..$count) {
			my $content = "$config[0][$num]{'server_name'}"."|"."$config[0][$num]{'network_ip'}"."|"."$config[0][$num]{'external_ip'}";
			unshift(@server_name,$content);
		}
		my $server_name_string = join( ",", @server_name );

		Rex::Logger::info("返回数据:$server_name_string");
		Rex::Logger::info("提示: 单用户模式不能同时操作2个以上服务器!","error");
		exit;
	}
	if( $queryLogDir ne "" and $queryLogFile ne "" ){
		Rex::Logger::info("日志路径:$queryLogDir");
	}else{
		Rex::Logger::info("日志路径:$queryLogDir 或 日志文件:$queryLogFile 为空","error");
		exit;
	}
	if ( $queryLogFile =~ /#/ ) {
		my @queryLogFileList=split(/#/, $queryLogFile);
		my $today=strftime($queryLogFileList[1], localtime(time));
		my $LogFile="$queryLogFileList[0]$today";
		$log="$queryLogDir/$LogFile";
	}else{
		$log="$queryLogDir/$queryLogFile";
	}
	Rex::Logger::info("日志文件:$log");
	unshift(@data,$queryLogDir);
	unshift(@data,$external_ip);
	unshift(@data,$names);
	unshift(@data,$log);
	unshift(@data,$network_ip);
	return \@data;

}


1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

include qw/logCenter::main/;

task yourtask => sub {
	logCenter::main::example();
};

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
