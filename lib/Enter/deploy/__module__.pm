package Enter::deploy;

use Rex -base;
use Data::Dumper;
use JSON qw( decode_json );
use Encode;
use URI::Escape;
use POSIX qw(strftime); 
use POSIX; 

my $env;
my $is_weixin;
my $is_qq;
my $weixin_config;
my $qq_config;
my $finish_qq_config;
my $max_sleep_time;
my $random_temp_file;
my $checkurl_max_count;
my $checkurl_interval_time;
my $checkurl_init_time;
my $deploy_finish_file;
my $deploy_max_count;
my $deploy_interval_time;
Rex::Config->register_config_handler(
    "env",
    sub {
        my ($param) = @_;
        $env = $param->{key};
    }
);
Rex::Config->register_config_handler(
    "$env",
    sub {
        my ($param) = @_;
        $is_weixin = $param->{is_weixin};
        $is_qq = $param->{is_qq};
        $weixin_config = $param->{weixin_config};
        $qq_config = $param->{qq_config};
        $finish_qq_config = $param->{finish_qq_config};
        $max_sleep_time = $param->{max_sleep_time};
        $random_temp_file = $param->{random_temp_file};
        $checkurl_max_count = $param->{checkurl_max_count};
        $checkurl_interval_time = $param->{checkurl_interval_time};
        $checkurl_init_time = $param->{checkurl_init_time};
        $deploy_finish_file = $param->{deploy_finish_file};
        $deploy_max_count = $param->{deploy_max_count};
        $deploy_interval_time = $param->{deploy_interval_time};
    }
);

desc "灰度发布 rex Enter:deploy:main --k='server1'";
task main => sub {
    my $self = shift;
    my $k=$self->{k};
	my $is_finish = 0;
	my $weigts;
	my $datetime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
	my $subject = "灰度发布-滚动发布(0)";
	my $content = "开始时间: $datetime 发布系统: $k";
	if ( "$k" eq "" ) {
		Rex::Logger::info("关键字(--k='')不能为空","error");
	    exit;	
	}


	# startDeplopy($k,$subject,$content,$is_finish);
	# print "end";
	# exit;

	sendMsg($subject,$content,$is_finish);
	#0.初始化灰度发布
	Deploy::Db::update_deploy_status($k);
	#1.摘取节点并判断节点是否成功摘取
	pickLoad($k,$subject,$content,$is_finish);
	if ( "$max_sleep_time" != 0 ) {
		my $subject = "灰度发布-滚动发布(1-2)";
		Rex::Logger::info("($k) 已配置超时时间,开始等待超时时间$max_sleep_time秒");
		sendMsg($subject,"($k) 已配置超时时间,开始等待超时时间$max_sleep_time秒",$is_finish);
		select(undef, undef, undef, $max_sleep_time);
	}
	#2.下载远程文件并同步更新目录到待发布目录
	downloadSync($k,$subject,$content,$is_finish);
	#3.校验发布包和原包差异
	checkDiff($k,$subject,$content,$is_finish);
	#4.开始发布
	startDeplopy($k,$subject,$content,$is_finish);
	#5.校验url
	checkURL($k,$subject,$content,$is_finish);
	#6.添加节点并判断节点是否成功摘取
	addLoad($k,$subject,$content,$is_finish);
};


#6.添加节点并判断节点是否成功摘取
sub addLoad{
	my ($k,$subject,$content,$is_finish) = @_;
	my $subject = "灰度发布-滚动发布(6)";
	my $weigts;
	eval {
		run_task "loadService:main:update",params => { k => $k,w => 10};
		run_task "loadService:main:queryk",params => { k => $k};
		$weigts = run_task "Deploy:Db:query_weight",params => { app_key => $k};
		for my $weight (@$weigts) {
			my $realWeigts = $weight->{"weight"};
			my $realServer_name = $weight->{"server_name"};
			my $realNetwork_ip = $weight->{"network_ip"};
			my @realWeigtsArray = split(",",$realWeigts);
			for my $realWeigt (@realWeigtsArray){
				if ( "$realWeigt" eq "NULL") {
					Rex::Logger::info("($realServer_name) 修改权重失败,没有获取负载对应的节点IP","error");
					sendMsg($subject,"($realServer_name) 修改权重失败,没有获取负载对应的节点IP",$is_finish);
					exit;
				}
				if ( "$realWeigt" ne "10") {
					Rex::Logger::info("($realServer_name):$realWeigts 修改权重失败","error");
					sendMsg($subject,"($realServer_name):$realWeigts 修改权重失败",$is_finish);
					exit;
				}
			}
		}
		my $endtime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
		Rex::Logger::info("开始时间:$endtime ($k) 添加节点成功,结束本次节点发布");
		sendMsg($subject,"开始时间:$endtime ($k) 添加节点成功,结束本次节点发布",$is_finish);
	};
	if ($@) {
		Rex::Logger::info("($k) 添加并保存权重数据异常:$@","error");
		sendMsg($subject,"($k) 添加并保存权重数据异常:$@",$is_finish);
		exit;
	}

}

#5.校验url
sub checkURL{
	my ($k,$subject,$content,$is_finish) = @_;
	my $subject = "灰度发布-滚动发布(5)";
	eval {
		Rex::Logger::info("($k) 校验url 应用启动初始化中...等待$checkurl_init_time秒");
		select(undef, undef, undef, $checkurl_init_time);
		for (my $var = 1; $var <= $checkurl_max_count; $var++) {
			Rex::Logger::info("($k) 校验url第$var次");
			my $errData = run_task "loadService:main:check",params => { k => $k };
			my @errData = @$errData;
			my $errContent = join(",",@errData);
			if ( $errData[0] == 0  ) {
				Rex::Logger::info("校验url第$var次失败: $errContent","error");
				if ( $var == $checkurl_max_count) {
					Rex::Logger::info("校验次url失败: $errContent 校验次数:$checkurl_max_count 校验时间间隔:$checkurl_interval_time","error");
					sendMsg($subject,"校验次url失败: $errContent 校验次数:$checkurl_max_count 校验时间间隔:$checkurl_interval_time",$is_finish);
					exit;
				}
				
			}
			if ( $errData[0] == 1 ) {
				last;
			}
			select(undef, undef, undef, $checkurl_interval_time);
		}
		Rex::Logger::info("($k) 校验url成功");
		sendMsg($subject,"($k) 校验url成功",$is_finish);
	};
	if ($@) {
		Rex::Logger::info("($k) 校验url异常:$@","error");
		sendMsg($subject,"($k)  校验url异常:$@",$is_finish);
		exit;
	}

}

#4.开始发布
sub startDeplopy{
	my ($k,$subject,$content,$is_finish) = @_;
	my $subject = "灰度发布-滚动发布(4)";
	eval {
	    if (is_file($deploy_finish_file)) {
	        unlink($deploy_finish_file);
	    }
		run_task "Enter:route:deploy",params => { k => $k };

		for (my $var = 1; $var <= $deploy_max_count; $var++) {
			if ( is_file($deploy_finish_file) ) {
				Rex::Logger::info("检测到发布已经结束") ;
				last;
			}
			select(undef, undef, undef, $deploy_interval_time);
		}
		select(undef, undef, undef, 3);

	    my $data = readFile($random_temp_file) ;
	    my @data = @$data;
	    my $datastring = join(" ",@data);
	    Rex::Logger::info("($k) 发布随机数: $datastring");
	    my $deployInfo = Deploy::Db::query_deploy_info($datastring,$k);
	    my @deployInfo = @$deployInfo;
	    my $deployInfolength = @$deployInfo;
	    if ( $deployInfolength  ==  0 ) {
			Rex::Logger::info("($k) 发布失败,查询到发布信息为空,请查看日志","error");
			sendMsg($subject,"($k) 发布失败,查询到发布信息为空,请查看日志",$is_finish);
			exit;
	    }
	    
	    my @errDeploy ;
	    for my $deployLine (@deployInfo){
	    	my $deploy_take = $deployLine->{"deploy_take"};
	    	my $deploy_key = $deployLine->{"deploy_key"};
	    	my $deloy_size = $deployLine->{"deloy_size"};
	    	my $deploy_ip = $deployLine->{"deploy_ip"};
	    	my $processNumber = $deployLine->{"processNumber"};
	    	# sendMsg($subject,"($deploy_key-$deploy_ip) 发布后目录:$deloy_size 发布后进程数: $processNumber 发布时间花费:$deploy_take",$is_finish);
	    	if ( "$deloy_size" ne ""  &&  "$processNumber" ne "" && "$processNumber" ne "0" && "$deploy_take" ne "") {
	    		Rex::Logger::info("($deploy_key-$deploy_ip) 发布后目录:$deloy_size 发布后进程数: $processNumber 发布时间花费:$deploy_take");
	    	}else{
	    		push @errDeploy,"($deploy_key-$deploy_ip) 目录:$deloy_size 进程数: $processNumber 时间花费:$deploy_take";
	    		Rex::Logger::info("($deploy_key-$deploy_ip) 发布后目录:$deloy_size 发布后进程数: $processNumber 发布时间花费:$deploy_take","error");
	    	}
	    	
	    }
	    if (is_file($random_temp_file)) {
	        unlink($random_temp_file);
	    }
	    my $errDeploylength = @errDeploy;
	    if ( $errDeploylength ne 0 ) {
	    	my $errDeployContent = join(",",@errDeploy);
			Rex::Logger::info("($k) 发布失败.\n$errDeployContent");
			sendMsg($subject,"($k) 发布失败\n$errDeployContent",$is_finish);
			exit;
	    }

		Rex::Logger::info("($k) 发布完成");
		sendMsg($subject,"($k) 发布完成",$is_finish);



	};
	if ($@) {
		Rex::Logger::info("($k)  发布异常:$@","error");
		sendMsg($subject,"($k)  发布异常:$@",$is_finish);
		exit;
	}



}

#读取,分割的数据文件
sub readFile{
		my ($file) = @_;
	    my $datastring;
	    my @data;
	    open(DATA, "<$file") or  Rex::Logger::info("$file 文件无法打开, $!","error");        
	    while(<DATA>){
	       my @singleData = split(",",$_) ;	
	       for my $var (@singleData) {
	       		if ( "$var"  ne "") {
	       			push @data,$var;
	       		}
	       }

	    }
	    close(DATA) || die Rex::Logger::info("$file 文件无法关闭","error");
	    return \@data;

}

#3.校验发布包和原包差异
sub checkDiff{
	my ($k,$subject,$content,$is_finish) = @_;
	my $subject = "灰度发布-滚动发布(3)";
	eval {
		# do something risky...
		my $errData = run_task "Deploy:Core:diff",params => { k => $k };
		if ( $errData->{"code"} eq "0") {
			my $allContent = "下载目录: ".$errData->{"errDownloadpro"}." ". $errData->{"errDownloadconf"}." 发布目录: ".$errData->{"errpro"}." ".$errData->{"errconf"};
			Rex::Logger::info("($k)  校验发布包和原包差异失败,目录不存在-> $allContent","error");
			sendMsg($subject,"($k)  校验发布包和原包差异失败，目录不存在-> $allContent",$is_finish);
			exit;
		}
		my $changeContent =$errData->{"proChange"}."====>".$errData->{"confChange"} ;
		Rex::Logger::info("($k) 发布包原包差异: $changeContent");
		sendMsg($subject,"($k) 发布包原包差异: $changeContent",$is_finish);
	};
	if ($@) {
		Rex::Logger::info("($k) 校验发布包和原包差异:$@","error");
		sendMsg($subject,"($k) 校验发布包和原包差异:$@",$is_finish);
		exit;
	}


}


#2.下载远程文件并同步更新目录到待发布目录
sub downloadSync(){
	my ($k,$subject,$content,$is_finish) = @_;
	my $subject = "灰度发布-滚动发布(2)";
	eval {
		run_task "Enter:route:download",params => { k => $k};
		my $errData = run_task "Deploy:Core:syncpro",params => { k => $k,update => 1};
		my @errData = @$errData;
		my $errDatalen =@errData ;
		my $errCode = $errData[0];
		my $errDir ;
		if( "$errDatalen" eq "3" ){
			$errDir = $errData[1]." ".$errData[2];
		}
		if( "$errDatalen" eq "2" ){
			$errDir = $errData[1];
		}
		if ( "$errCode" eq "0") {
			Rex::Logger::info("($k)  同步更新目录到待发布目录失败,更新目录($errDir)不存在","error");
			sendMsg($subject,"($k)  同步更新目录到待发布目录失败,更新目录($errDir)不存在",$is_finish);
			exit;
		}

	};
	if ($@) {
		Rex::Logger::info("($k) 下载远程文件并同步更新目录到待发布目录:$@","error");
		sendMsg($subject,"($k) 下载远程文件并同步更新目录到待发布目录:$@",$is_finish);
		exit;
	}

}



#1.摘取节点并判断节点是否成功摘取
sub pickLoad{
	my ($k,$subject,$content,$is_finish) = @_;
	my $weigts;
	my $subject = "灰度发布-滚动发布(1-1)";
	eval {
		run_task "loadService:main:update",params => { k => $k,w => 0};
		run_task "loadService:main:queryk",params => { k => $k};
		$weigts = run_task "Deploy:Db:query_weight",params => { app_key => $k};
		for my $weight (@$weigts) {
			my $realWeigts = $weight->{"weight"};
			my $realServer_name = $weight->{"server_name"};
			my $realNetwork_ip = $weight->{"network_ip"};
			my @realWeigtsArray = split(",",$realWeigts);
			for my $realWeigt (@realWeigtsArray){
				if ( "$realWeigt" eq "NULL") {
					Rex::Logger::info("($realServer_name) 修改权重失败,没有获取负载对应的节点IP","error");
					sendMsg($subject,"($realServer_name) 修改权重失败,没有获取负载对应的节点IP",$is_finish);
					exit;
				}
				if ( "$realWeigt" ne "0") {
					Rex::Logger::info("($realServer_name):$realWeigts 修改权重失败","error");
					sendMsg($subject,"($realServer_name):$realWeigts 修改权重失败",$is_finish);
					exit;
				}
			}
		}
		Rex::Logger::info("($k) 摘取节点成功");
		sendMsg($subject,"($k) 摘取节点成功",$is_finish);
	};
	if ($@) {
		Rex::Logger::info("($k) 摘取并保存权重数据异常:$@","error");
		sendMsg($subject,"($k) 摘取并保存权重数据异常:$@",$is_finish);
		exit;
	}

}

sub sendMsg{
	my ($subject,$content,$is_finish) = @_;
	sendWeixin($is_weixin,$weixin_config,$subject,$content);
	sendQQ($is_qq,$qq_config,$finish_qq_config,$content,$is_finish);	
}

sub sendWeixin{
	my ($is_weixin,$weixin_config,$subject,$content) = @_;
	my $weixin_config_obj;
	my $ret ;
	if ( $is_weixin eq "1" && "$subject" ne "" && "$content" ne "") {
		Rex::Logger::info("开始发送微信消息,微信主题: $subject 微信内容: $content");
		eval {
			$weixin_config_obj = decode_json($weixin_config);
		};
		if ($@) {
			Rex::Logger::info("解析微信配置异常,请确认微信配置项(weixin_config)是否为正确的json格式","error");
			return ;
		}
		if( $weixin_config_obj->{"params"} eq "" ){
			$ret = run_task "Common:Use:get",params => { url => $weixin_config_obj->{"url"}."&subject=$subject&content=$content",header=>$weixin_config_obj->{"header"}};
		}else{
			$ret = run_task "Common:Use:post",params => { url => $weixin_config_obj->{"url"},header=>$weixin_config_obj->{"header"},param=>'{"subject":"$subject","content":"$content"}'};			
		}
		
		Rex::Logger::info("结束发送微信消息,微信主题: $subject 微信内容: $content");
	}

}

sub sendQQ{
	my ($is_qq,$qq_config,$finish_qq_config,$content,$is_finish) = @_;
	my $qq_config_obj;
	my $ret ;
	if ( $is_qq eq "1"  && "$content" ne "") {
		Rex::Logger::info("开始发送QQ消息, 消息内容: $content");
		eval {
			if ( "$is_finish" eq "0") {
				$qq_config_obj = decode_json($qq_config);
			}else{
				$qq_config_obj = decode_json($finish_qq_config);
			}
			
		};
		if ($@) {
			Rex::Logger::info("解析QQ配置异常,请确认QQ配置项(qq_config)是否为正确的json格式","error");
			return ;
		}
		if( $qq_config_obj->{"params"} eq "" ){
			$ret = run_task "Common:Use:get",params => { url => $qq_config_obj->{"url"}."&content=$content",header=>$qq_config_obj->{"header"}};
		}else{
			$ret = run_task "Common:Use:post",params => { url => $qq_config_obj->{"url"},header=>$qq_config_obj->{"header"},param=>'{"content":"$content"}'};			
		}
		
		Rex::Logger::info("结束开始发送QQ消息, 消息内容: $content");
	}

}


1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Enter::deploy/;

 task yourtask => sub {
    Enter::deploy::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
