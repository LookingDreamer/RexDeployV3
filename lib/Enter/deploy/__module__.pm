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
my $max_weight_count;
my $envDesc;
Rex::Config->register_config_handler(
    "env",
    sub {
        my ($param) = @_;
        $env = $param->{key};
        my $envName = Rex::Config->get_envName;
        $env = $envName if ( $envName );
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
        $max_weight_count = $param->{max_weight_count};
        $envDesc = $param->{envDesc};
    }
);




desc "查询滚动更新关键词";
task getdepoloy=>sub {
	my ($k,$w,$senv) = @_;
	my $is_finish = 0;
	my $datetime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
	my $subject = "灰度发布-滚动发布(0000)";	
	my %res ;
	my $deploy = Deploy::Db::getdepoloy($k);
	my @deploy = @$deploy;
	my $deploylength = @deploy;
	if ( $deploylength == 0 ) {
		$res{"code"} = 0;
		$res{"msg"} = "根据识别名称查询到关键词为空,请确认是否已经录入数据";
		Rex::Logger::info("($k) 根据识别名称查询到关键词为空,请确认是否已经录入数据","error");
		return \%res;
	}
	Rex::Logger::info("($k) 根据识别名称查询到$deploylength条记录");
	for my $info (@deploy){
		my $local_name = $info->{"local_name"};			
		my $app_key_sort = $info->{"app_key_sort"};
		my @app_keys = split(";",$app_key_sort);
		for my $app_keys (@app_keys){
			my $apps = Deploy::Db::query_keys($app_keys);
			my @apps = @$apps;
			my $appslength = @apps ;
			if ( $appslength == 0 ) {
				$res{"code"} = 0;
				$res{"msg"} = "根据识别名称($local_name)查询到关键词$app_keys记录为空,请确认是否已经录入数据";
				Rex::Logger::info("根据识别名称($local_name)查询到关键词$app_keys记录为空,请确认是否已经录入数据","error");
				return \%res;
			}

		}			

	}
	Rex::Logger::info("($k) 校验关键词完成");
	my @deployArray ;
	for my $info (@deploy){
		my $local_name = $info->{"local_name"};			
		my $app_key_sort = $info->{"app_key_sort"};
		my @app_keys = split(";",$app_key_sort);
		for my $app_keys (@app_keys){
			my $apps = Deploy::Db::query_keys($app_keys);
			my @apps = @$apps;
			my $appslength = @apps ;
			if ( $appslength == 0 ) {
				$res{"code"} = 0;
				$res{"msg"} = "根据识别名称($local_name)查询到关键词$app_keys记录为空,请确认是否已经录入数据";
				Rex::Logger::info("根据识别名称($local_name)查询到关键词$app_keys记录为空,请确认是否已经录入数据","error");
				return \%res;
			}else{
				eval {
					Rex::Logger::info("app_key->($app_keys) 开始灰度发布...");
					my $deployTask = run_task "Enter:deploy:main",params => { k => $app_keys,w=>$w,senv=>$senv};
					push @deployArray,$deployTask;
					Rex::Logger::info("app_key->($app_keys) 结束灰度发布.");
				};
				if ($@) {
					Rex::Logger::info("($app_keys) 执行灰度发布异常:$@","error");
					sendMsg($subject,"($app_keys) 执行灰度发布异常:$@",$is_finish);
					exit;
				}
			}

		}			

	}
	$is_finish = 1;
	$res{"code"} = 0;
	$res{"msg"} = "$k have deploy finshed";
	sendMsg($subject,"($k) 全部灰度发布完成",$is_finish);
	push @deployArray,\%res;
	Common::Use::json($w,"0","$k 全部灰度发布完成",\@deployArray);
	return \%res;
	

};

desc "直接发布 rex Enter:deploy:release --k='server'";
task release => sub {
    my ($k,$w,$senv,$url,$full,$set) = @_;
	my $datetime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
	my $subject = "自动发布";
	my $content = "开始时间: $datetime 发布系统: $k";
	my $is_finish = 0;
	my %res ;
	my $deployRes ;
	if ( "$k" eq "" ) {
		Rex::Logger::info("关键字(--k='')不能为空","error");
		$res{"code"} = -1;
		$res{"msg"} = "--k='' is null ";
		return \%res;	
	}
	my $deploy = Deploy::Db::query_name_keys($k);
	my @deploy = @$deploy;
	my $deploylength = @deploy;
	if ( $deploylength == 0 ) {
		$res{"code"} = -1;
		$res{"msg"} = "when k in ( $k ), local_name is null";
		Rex::Logger::info("($k) 根据识别名称local_name查询到关键词为空,请确认是否已经录入数据","error");
		return \%res;
	}
	Rex::Logger::info("($k) 根据识别名称查询到$deploylength条记录");
	sendMsg($subject,$content,$is_finish);
	my @app_keys ;
	my $app_keys_string;
	for my $info (@deploy){
		my $app_key = $info->{"app_key"};	
		push @app_keys,$app_key;	
	}
	$app_keys_string = join(" ",@app_keys);
	if ( "$url" ne "" && "$full" ne "") {
		my $name;
		if ( $full eq "1") {
			$name = "增量";
		}else{
			$name = "全量";
		}
		sendMsg($subject,"($k) http下载更新,url:$url 更新方式:$name",$is_finish);
		checkHttp($app_keys_string,$subject,$content,$is_finish,$w,$senv);
	}
	eval {
		Rex::Logger::info("$app_keys_string  开始自动发布...");
		#1.下载远程文件并同步更新目录到待发布目录
		downloadSync($app_keys_string,$subject,$content,$is_finish,$w,$senv,$url,$full,$set);
		#2.校验发布包和原包差异
		checkDiff($app_keys_string,$subject,$content,$is_finish,$w,$senv);
		#2.1 待发布程序和配置初始化命令
		initProconf($k,$subject,$content,$is_finish,$w);
		#3.开始发布		
		$deployRes = startDeplopy($app_keys_string,$subject,$content,$is_finish,$w);
		Rex::Logger::info("$app_keys_string  结束自动发布.");
	};
	if ($@) {
		Rex::Logger::info("($app_keys_string ) 执行自动发布异常:$@","error");
		sendMsg($subject,"($app_keys_string ) 执行自动发布异常:$@",$is_finish);
		$res{"code"} = -1;
		$res{"msg"} = "run deploy error: $@";
		return \%res;		
	}

	$is_finish = 1;
	$res{"code"} = 0;
	$res{"msg"} = "$k have finshed release";
	my $endtime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
	sendMsg($subject,"当前时间: $endtime  ($k) 全部自动发布完成",$is_finish);
	$res{"starttime"} = $datetime;
	$res{"endtime"} = $endtime;
	$res{"data"} = $deployRes;
	return \%res;


};



desc "灰度发布 rex Enter:deploy:main --k='server1'";
task main => sub {
    my $self = shift;
    my $k=$self->{k};
    my $w=$self->{w};
    my $senv=$self->{senv};
	my $is_finish = 0;
	my $weigts;
	my %res ;
	my $deployRes ;	
	my $datetime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
	my $subject = "灰度发布-滚动发布(0)";
	my $content = "开始时间: $datetime 发布系统: $k";
	if ( "$k" eq "" ) {
		Common::Use::json($w,"","关键字(--k='')不能为空",,"");
		Rex::Logger::info("关键字(--k='')不能为空","error");
		exit;
	}


	sendMsg($subject,$content,$is_finish);
	#0.初始化灰度发布
	Deploy::Db::update_deploy_status($k);
	#1.摘取节点并判断节点是否成功摘取
	pickLoad($k,"灰度发布-滚动发布(1)",$content,$is_finish,$w);
	if ( "$max_sleep_time" != 0 ) {
		my $subject = "灰度发布-滚动发布(2)";
		Rex::Logger::info("($k) 已配置超时时间,开始等待超时时间$max_sleep_time秒");
		sendMsg($subject,"($k) 已配置超时时间,开始等待超时时间$max_sleep_time秒",$is_finish);
		select(undef, undef, undef, $max_sleep_time);
	}
	#2.下载远程文件并同步更新目录到待发布目录
	downloadSync($k,"灰度发布-滚动发布(2)",$content,$is_finish,$w,$senv);
	#3.校验发布包和原包差异
	checkDiff($k,"灰度发布-滚动发布(3)",$content,$is_finish,$w,$senv);
	#3.1 待发布程序和配置初始化命令
	initProconf($k,"灰度发布-滚动发布(3)",$content,$is_finish,$w);
	#4.开始发布
	$deployRes = startDeplopy($k,"灰度发布-滚动发布(4)",$content,$is_finish,$w);
	#5.校验url
	checkURL($k,"灰度发布-滚动发布(5)",$content,$is_finish,$w);
	#6.添加节点并判断节点是否成功摘取
	addLoad($k,"灰度发布-滚动发布(6)",$content,$is_finish,$w);

	$res{"code"} = 0;
	$res{"msg"} = "$k have finshed deploy";
	my $endtime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
	$res{"starttime"} = $datetime;
	$res{"endtime"} = $endtime;
	$res{"data"} = $deployRes;
	return \%res;


};



#校验http下载更新时仅支持单个k
sub checkHttp{
	my ($k,$subject,$content,$is_finish,$w,$senv) = @_;
	eval {
		if ( "$senv" ne "" ) {
		  Rex::Logger::info("当url和full都存在时,senv不能同时有值","error");
		  sendMsg($subject,"当url和full都存在时,senv不能同时有值",$is_finish);
		  Common::Use::json($w,"","当url和full都存在时,senv不能同时有值","");   
		  exit;  
		}
		my $config=Deploy::Db::query_ilocal_name($k);
		my $count = $config->{count};
		my $local_name = $config->{local_name} ;
		my $check = $config->{checkdir} ;
		if ( $count ne 1 ) {
		  Rex::Logger::info("http下载更新: $k不存在或者存在多个k,目前仅支持下载单个url,单个k","error");
		  sendMsg($subject,"http下载更新: $k不存在或者存在多个k,目前仅支持下载单个url,单个k",$is_finish);
		  Common::Use::json($w,"","$k不存在或者存在多个k,目前仅支持下载单个url,单个k","");   
		  exit;  
		}


	};
	if ($@) {
		Rex::Logger::info("($k) http下载更新校验异常:$@","error");
		sendMsg($subject,"($k) http下载更新校验异常:$@",$is_finish);
		Common::Use::json($w,-1,"($k) http下载更新校验异常:$@","");
		exit;
	}

}


#6.添加节点并判断节点是否成功摘取
sub addLoad{
	my ($k,$subject,$content,$is_finish,$w) = @_;
	my $weigts;
	eval {

        for (my $var = 1; $var <= $max_weight_count; $var++) {
            Rex::Logger::info("($k) 开始修改权重($var)");
            my $f = 0;
            my @faild;
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
						$f = $f + 1;
						Rex::Logger::info("($realServer_name) 修改权重失败,没有获取负载对应的节点IP","error");
						# sendMsg($subject,"($realServer_name) 修改权重失败,没有获取负载对应的节点IP",$is_finish);
						# exit;
						push @faild,"($realServer_name) 修改权重失败,没有获取负载对应的节点IP";

					}
					if ( "$realWeigt" ne "10") {
						$f = $f + 1;
						Rex::Logger::info("($realServer_name):$realWeigts 修改权重失败","error");
						# sendMsg($subject,"($realServer_name):$realWeigts 修改权重失败",$is_finish);
						# exit;
						push @faild,"($realServer_name):$realWeigts 修改权重失败";
					}
				}
			}

            if( $f == 0 ){
                Rex::Logger::info("($k) 权重全部修改成功 权重值:10");
                last;
            }
            if ( $f != 0 && $var  == $max_weight_count ) {
                my $faildString = join(",",@faild);
                Rex::Logger::info("连续 $var 次修改权重失败: $faildString ","error");
                sendMsg($subject,"连续 $var 次修改权重失败: $faildString ",$is_finish);
                Common::Use::json($w,-1,"连续 $var 次修改权重失败: $faildString ","");
                exit;
            }
            select(undef, undef, undef, 3);

        }


		my $endtime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
		Rex::Logger::info("结束时间:$endtime ($k) 添加节点成功,结束本次节点发布");
		sendMsg($subject,"结束时间:$endtime ($k) 添加节点成功,结束本次节点发布",$is_finish);
	};
	if ($@) {
		Rex::Logger::info("($k) 添加并保存权重数据异常:$@","error");
		sendMsg($subject,"($k) 添加并保存权重数据异常:$@",$is_finish);
		Common::Use::json($w,-1,"($k) 添加并保存权重数据异常:$@","");
		exit;
	}

}

#5.校验url
sub checkURL{
	my ($k,$subject,$content,$is_finish,$w) = @_;
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
					Rex::Logger::info("校验次url失败: $errContent 校验次数:$checkurl_max_count 校验时间间隔:$checkurl_interval_time秒","error");
					sendMsg($subject,"校验次url失败: $errContent 校验次数:$checkurl_max_count 校验时间间隔:$checkurl_interval_time秒",$is_finish);
					Common::Use::json($w,-1,"校验次url失败: $errContent 校验次数:$checkurl_max_count 校验时间间隔:$checkurl_interval_time秒","");
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
		Common::Use::json($w,-1,"($k)  校验url异常:$@","");
		exit;
	}

}

#4.开始发布
sub startDeplopy{
	my ($k,$subject,$content,$is_finish,$w) = @_;
	my @deploy ;
	eval {
	    # if (is_file($deploy_finish_file)) {
	    #     unlink($deploy_finish_file);
	    # }
	    Rex::Logger::info("---------------------------start deploy--------------------------") ;
		my $deploy_res = run_task "Enter:route:deploy",params => { k => $k };

		Rex::Logger::info("保存返回发布数据: ".Dumper($deploy_res)) ;

		if ( $deploy_res  ==  undef) {
			Rex::Logger::info("($k) 发布失败,执行发布返回undef,请查看日志","error");
			sendMsg($subject,"($k) 发布失败,执行发布返回undef,请查看日志",$is_finish);
			Common::Use::json($w,-1,"失败",[{msg=>"deploy faild,query deploy info is null",code=>-1}]);
			exit;
		}

		my $code = $deploy_res->{code};		
		if ( $code != 0 ) {
			my $msg = 	$deploy_res->{msg};
			Rex::Logger::info("($k) 发布失败".$msg,"error");
			sendMsg($subject,"($k) 发布失败".$msg,$is_finish);
			Common::Use::json($w,-1,"失败",[{msg=>"deploy faild,".$msg,code=>-1}]);
			exit;
		}

		my @data;
		my $dataVar = $deploy_res->{data};
		my @deploy_result = @$dataVar;

		for my $deployData (@deploy_result){
			my $code = 	$deployData->{code};
			my $msg = 	$deployData->{msg};
			my $random = $deployData->{data};
			if ( $code != 0 ) {
				Rex::Logger::info("($k) 发布失败".$msg,"error");
				sendMsg($subject,"($k) 发布失败".$msg,$is_finish);
				Common::Use::json($w,-1,"失败",[{msg=>"deploy faild,".$msg,code=>-1}]);
				exit;
			}
			push @data,$random;

		}

		# for (my $var = 1; $var <= $deploy_max_count; $var++) {
		# 	if ( is_file($deploy_finish_file) ) {
		# 		Rex::Logger::info("检测到发布已经结束") ;
		# 		last;
		# 	}
		# 	select(undef, undef, undef, $deploy_interval_time);
		# }
		select(undef, undef, undef, 3);

	    # my $data = readFile($random_temp_file) ;
	    # my @data = @$data;
	    my $datastring = join(" ",@data);
	    Rex::Logger::info("($k) 发布随机数: $datastring");
	    my $deployInfo = Deploy::Db::query_deploy_info($datastring,$k);
	    my @deployInfo = @$deployInfo;
	    my $deployInfolength = @$deployInfo;
	    if ( $deployInfolength  ==  0 ) {
			Rex::Logger::info("($k) 发布失败,查询到发布信息为空,请查看日志","error");
			sendMsg($subject,"($k) 发布失败,查询到发布信息为空,请查看日志",$is_finish);
			Common::Use::json($w,-1,"失败",[{msg=>"deploy faild,query deploy info is null",code=>-1}]);
			exit;
	    }
	    
	    my @errDeploy ;
	    my @errDeployJson ;
	    for my $deployLine (@deployInfo){
	    	my $deploy_take = $deployLine->{"deploy_take"};
	    	my $deploy_key = $deployLine->{"deploy_key"};
	    	my $deloy_size = $deployLine->{"deloy_size"};
	    	my $deploy_ip = $deployLine->{"deploy_ip"};
	    	my $processNumber = $deployLine->{"processNumber"};
	    	# sendMsg($subject,"($deploy_key-$deploy_ip) 发布后目录:$deloy_size 发布后进程数: $processNumber 发布时间花费:$deploy_take",$is_finish);
	    	push @deploy,{
	    		deploy_key=>"$deploy_key",
	    		deploy_ip=>"$deploy_ip",
	    		deloy_size=>"$deloy_size",
	    		processNumber=>"$processNumber",
	    		deploy_take=>"$deploy_take",
	    		deloy_prodir_before=>$deployLine->{"deloy_prodir_before"},
	    		deloy_configdir_before=>$deployLine->{"deloy_configdir_before"},
	    		deloy_prodir_after=>$deployLine->{"deloy_prodir_after"},
	    		deloy_configdir_after=>$deployLine->{"deloy_configdir_after"},
	    		start_time=>$deployLine->{"start_time"},
	    		rsync_war_time=>$deployLine->{"rsync_war_time"},
	    		start_app_time=>$deployLine->{"start_app_time"},
	    		end_time=>$deployLine->{"end_time"},
	    		randomStr=>$deployLine->{"randomStr"},
	    		rollRecord=>$deployLine->{"rollRecord"},
	    		rollStatus=>$deployLine->{"rollStatus"},
	    		rollbackNumber=>$deployLine->{"rollbackNumber"},
	    		deloy_prodir_real_before=>$deployLine->{"deloy_prodir_real_before"}
	    	};
	    	if ( "$deloy_size" ne ""  &&  "$processNumber" ne "" && "$processNumber" ne "0" && "$deploy_take" ne "") {
	    		Rex::Logger::info("($deploy_key-$deploy_ip) 发布后目录:$deloy_size 发布后进程数: $processNumber 发布时间花费:$deploy_take");
	    	}else{
	    		push @errDeploy,"($deploy_key-$deploy_ip) 目录:$deloy_size 进程数: $processNumber 时间花费:$deploy_take";
	    		push @errDeployJson,"($deploy_key-$deploy_ip) dir:$deloy_size processNumber: $processNumber take:$deploy_take";
	    		Rex::Logger::info("($deploy_key-$deploy_ip) 发布后目录:$deloy_size 发布后进程数: $processNumber 发布时间花费:$deploy_take","error");
	    	}
	    	
	    }
	    if (is_file($random_temp_file)) {
	        unlink($random_temp_file);
	    }
	    my $errDeploylength = @errDeploy;
	    if ( $errDeploylength ne 0 ) {
	    	my $errDeployContent = join(",",@errDeploy);
	    	my $errDeployContentJson = join(",",@errDeployJson);
			Rex::Logger::info("($k) 发布失败.\n$errDeployContent","error");
			sendMsg($subject,"($k) 发布失败\n$errDeployContent",$is_finish);
			Common::Use::json($w,-1,"失败",[{msg=>"deploy faild:$errDeployContentJson",code=>-1}]);
			exit;
	    }

		Rex::Logger::info("($k) 发布完成");
		sendMsg($subject,"($k) 发布完成",$is_finish);		


	};
	if ($@) {
		Rex::Logger::info("($k)  发布异常:$@","error");
		sendMsg($subject,"($k)  发布异常:$@",$is_finish);
		Common::Use::json($w,-1,"失败",[{msg=>"deploy error: $@",code=>-1}]);
		exit;
	}
	return \@deploy;


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

#3.1 待发布程序和配置初始化命令
sub initProconf{
	my ($k,$subject,$content,$is_finish,$w) = @_;
	eval {

		my $errData = run_task "Deploy:Configure:config",params => { k => $k };
		if ( $errData->{"code"} != 0 ) {
			Rex::Logger::info("($k) 待发布程序和配置初始化命令失败 ".$errData->{"msg"},"error");
			sendMsg($subject,"($k)  待发布程序和配置初始化命令失败".$errData->{"msg"},$is_finish);
			Common::Use::json($w,-1,"失败",[{msg=>"待发布程序和配置初始化命令失败".$errData->{"msg"},code=>-1}]);
			exit;
		}
		Rex::Logger::info("($k) 待发布程序和配置初始化命令成功");
	};
	if ($@) {
		Rex::Logger::info("($k) 待发布程序和配置初始化命令异常:$@","error");
		sendMsg($subject,"($k)  待发布程序和配置初始化命令异常:$@",$is_finish);
		Common::Use::json($w,-1,"失败",[{msg=>"run pro and config cmd  error: $@",code=>-1}]);
		exit;
	}


}


#3.校验发布包和原包差异
sub checkDiff{
	my ($k,$subject,$content,$is_finish,$w,$senv) = @_;
	eval {
		if ( "$senv" ne "" ) {
			run_task "Enter:route:download",params => { k => $k,senv=>$senv};
		}
		my $errData = run_task "Deploy:Core:diff",params => { k => $k };
		if ( $errData->{"code"} eq "0") {
			my $allContent = "下载目录: ".$errData->{"errDownloadpro"}." ". $errData->{"errDownloadconf"}." 发布目录: ".$errData->{"errpro"}." ".$errData->{"errconf"};
			Rex::Logger::info("($k)  校验发布包和原包差异失败,目录不存在-> $allContent","error");
			sendMsg($subject,"($k)  校验发布包和原包差异失败，目录不存在-> $allContent",$is_finish);
			Common::Use::json($w,-1,"失败",[{msg=>"diff src and deploy file faild,dir is not exist: $allContent",code=>-1}]);
			exit;
		}
		my $changeContent =$errData->{"proChange"}."  ".$errData->{"confChange"} ;
		Rex::Logger::info("($k) 发布包原包差异: $changeContent");
		sendMsg($subject,"($k) 发布包原包差异: $changeContent",$is_finish);
	};
	if ($@) {
		Rex::Logger::info("($k) 校验发布包和原包差异:$@","error");
		sendMsg($subject,"($k) 校验发布包和原包差异:$@",$is_finish);
		Common::Use::json($w,-1,"失败",[{msg=>"diff src and deploy file  file error: $@",code=>-1}]);
		exit;
	}


}


#2.下载远程文件并同步更新目录到待发布目录
sub downloadSync(){
	my ($k,$subject,$content,$is_finish,$w,$senv,$url,$full,$set) = @_;
	Rex::Logger::info("($k) senv:$senv url:$url full:$full set:$set");
	eval {
		if ( "$senv" ne "" ) {
			run_task "Enter:route:download",params => { k => $k,usetype=>"conf",rsyncdelete=>"1"};
		}else{
			if ( "$url" ne "" && "$full" ne "") {
				run_task "Enter:route:download",params => { k => $k,update => 1,rsyncdelete=>"1"};
			}else{
				run_task "Enter:route:download",params => { k => $k,rsyncdelete=>"1"};
			}			
		}
		
		if ( "$senv" ne "" ) {
			run_task "Enter:route:download",params => { k => $k,senv=>$senv,update => 1};
		}
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
			Common::Use::json($w,-1,"失败",[{msg=>"$errDir is not exist",code=>-1}]);
			Rex::Logger::info("($k)  同步更新目录到待发布目录失败,更新目录($errDir)不存在","error");
			sendMsg($subject,"($k)  同步更新目录到待发布目录失败,更新目录($errDir)不存在",$is_finish);
			exit;
		}

		if ( "$url" ne "" && "$full" ne "") {
			my $httpc =  run_task "Enter:route:downloadCombile",params => { k => $k,url=>$url,full => $full,dest => 1,set=>$set};
			my $httpcode = $httpc->{code};
			my $urlmsg = $httpc->{msg};
			if ( $httpcode != 1 ){
				Rex::Logger::info("($k) 合并下载包到$k的softdir目录失败: $urlmsg","error");
				Common::Use::json($w,-1,"($k) 合并下载包到$k的softdir目录失败: $urlmsg","");
				sendMsg($subject,"($k) 合并下载包到$k的softdir目录失败: $urlmsg",$is_finish);
				exit;
			}
		}

	};
	if ($@) {
		Rex::Logger::info("($k) 下载远程文件并同步更新目录到待发布目录异常:$@","error");
		sendMsg($subject,"($k) 下载远程文件并同步更新目录到待发布目录异常:$@",$is_finish);
		Common::Use::json($w,-1,"失败",[{msg=>"download file error: $@",code=>-1}]);
		exit;
	}

}



#1.摘取节点并判断节点是否成功摘取
sub pickLoad{
	my ($k,$subject,$content,$is_finish,$w) = @_;
	my $weigts;
	eval {

		for (my $var = 1; $var <= $max_weight_count; $var++) {
			Rex::Logger::info("($k) 开始修改权重($var)");
			run_task "loadService:main:update",params => { k => $k,w => 0};
			run_task "loadService:main:queryk",params => { k => $k};
			$weigts = run_task "Deploy:Db:query_weight",params => { app_key => $k};
			my $f = 0;
			my @faild;
			for my $weight (@$weigts) {
				my $realWeigts = $weight->{"weight"};
				my $realServer_name = $weight->{"server_name"};
				my $realNetwork_ip = $weight->{"network_ip"};
				my @realWeigtsArray = split(",",$realWeigts);
				for my $realWeigt (@realWeigtsArray){

					if ( "$realWeigt" eq "NULL") {
						$f = $f + 1;
						Rex::Logger::info("($realServer_name) 第($var)次 修改权重失败,没有获取负载对应的节点IP","error");
						# sendMsg($subject,"($realServer_name) 修改权重失败,没有获取负载对应的节点IP",$is_finish);
						# exit;
						push @faild,"($realServer_name) 修改权重失败,没有获取负载对应的节点IP";
					}
					if ( "$realWeigt" ne "0") {
						$f = $f + 1;
						Rex::Logger::info("($realServer_name):$realWeigts 第($var)次 修改权重失败","error");
						# sendMsg($subject,"($realServer_name):$realWeigts 修改权重失败",$is_finish);
						# exit;
						push @faild,"($realServer_name):$realWeigts 修改权重失败";
					}
				}
			}
			if( $f == 0 ){
				Rex::Logger::info("($k) 权重全部修改成功 权重值:0");
				last;
			}
			if ( $f != 0 && $var  == $max_weight_count ) {
				my $faildString = join(",",@faild);
				Rex::Logger::info("连续 $var 次修改权重失败: $faildString ","error");
				sendMsg($subject,"连续 $var 次修改权重失败: $faildString ",$is_finish);
				Common::Use::json($w,-1,"连续 $var 次修改权重失败: $faildString ","");
				exit;
			}
			select(undef, undef, undef, 3);
		}

		Rex::Logger::info("($k) 摘取节点成功");
		sendMsg($subject,"($k) 摘取节点成功",$is_finish);
	};
	if ($@) {
		Rex::Logger::info("($k) 摘取并保存权重数据异常:$@","error");
		sendMsg($subject,"($k) 摘取并保存权重数据异常:$@",$is_finish);
		Common::Use::json($w,-1,"($k) 摘取并保存权重数据异常:$@","");
		exit;
	}

}

sub sendMsg{
	my ($subject,$content,$is_finish) = @_;
	my $content = "(".$envDesc.") ".$content;
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
			$ret = run_task "Common:Use:get",params => { url => $qq_config_obj->{"url"}."&message=$content"."&content=$content",header=>$qq_config_obj->{"header"}};
		}else{
			$ret = run_task "Common:Use:post",params => { url => $qq_config_obj->{"url"},header=>$qq_config_obj->{"header"},param=>'{"content":"$content","message":"$content"}'};			
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
