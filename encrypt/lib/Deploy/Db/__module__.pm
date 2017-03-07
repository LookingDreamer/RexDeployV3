package Deploy::Db;

use Rex -base;
use Data::Dumper;
use Rex::Commands::DB {
	dsn      => "DBI:mysql:database=autotask;host=tdsql-qc4b1vpn.shjr.cdb.myqcloud.com;port=9",
		 user     => "autotask_waiwang",
		 password => "autotask_waiwang!@#",
};
my $env;
my $table;
my $deploy_table;
my $deploy_status_table;
my $external_status;
my $external_deploy_config_table;
Rex::Config->register_config_handler("env", sub {
		my ($param) = @_;
		$env = $param->{key} ;
		});
Rex::Config->register_config_handler("$env", sub {
		my ($param) = @_;
		$external_status = $param->{external_status} ;
		if($external_status eq "true"){
		$table = $param->{external_deploy_config_table};
		}else{
		$table = $param->{deploy_config_table} ;
		}
		$deploy_table = $param->{deploy_record_table} ;
		$deploy_status_table = $param->{deploy_status_table} ;
		});

desc "数据库模块: 获取服务器信息";
task getconfig => sub {
	my $self = shift;
	my $app_key = $self->{app_key};
	if( $app_key eq "" ) {
		return 0;
	}
	Rex::Logger::info("读取数据库表数据:$table");
	my @data = db select => {
		fields => "*",
		       from  => $table,
		       where  => "app_key='$app_key'",
	};
	my %config=();
	my $config ;
	shift my @ids;
	for my $list (@data) {
		push(@ids,$list->{'id'});
		$config{id}=$list->{'id'};
		$config{app_key}=$list->{'app_key'};
		$config{depart_name}=$list->{'depart_name'};
		$config{server_name}=$list->{'server_name'};
		$config{network_ip}=$list->{'network_ip'};
		$config{cpu}=$list->{'cpu'};
		$config{mem}=$list->{'mem'};
		$config{disk}=$list->{'disk'};
		$config{pro_type}=$list->{'pro_type'};
		$config{config_dir}=$list->{'config_dir'};
		$config{pro_dir}=$list->{'pro_dir'};
		$config{log_dir}=$list->{'log_dir'};
		$config{pro_key}=$list->{'pro_key'};
		$config{pro_init}=$list->{'pro_init'};
		$config{pro_port}=$list->{'pro_port'};
		$config{system_type}=$list->{'system_type'};
		$config{created_time}=$list->{'created_time'};
		$config{updated_time}=$list->{'updated_time'};
		$config{status}=$list->{'status'};
		$config{note}=$list->{'note'};
		$config{mask}=$list->{'mask'};
		$config{local_name}=$list->{'local_name'};
		$config{is_deloy_dir}=$list->{'is_deloy_dir'};
		$config{auto_deloy}=$list->{'auto_deloy'};
		$config{container_dir}=$list->{'container_dir'};
		$config{backupdir_same_level}=$list->{'backupdir_same_level'};
		$config{deploydir_same_level}=$list->{'deploydir_same_level'};
		$config{server_name}=$list->{'server_name'};

		$config{config_dir}=~ s/ //g;
		$config{pro_dir}=~ s/ //g;
#$config{log_dir}=~ s/ //g;
		$config{pro_init}=~ s/ //g;   
			$config{network_ip}=~ s/\s+$//;
		$config{network_ip}=~ s/^\s+//;
		$config{app_key}=~ s/ //g;   
			$config{local_name}=~ s/ //g;   
			$config{container_dir}=~ s/ //g;
	}
	my $len=@ids;
	if($len == 0 ){
		return 1;
	}
	if($len != 1){
		return 2;		
#  Rex::Logger::info("( $app_key )--该关键字匹配到多个应用系统,请到数据库配置中确认配置是否OK.");
		exit
	}
	return \%config;
#  Rex::Logger::info("从数据库初始化数据完成...");
};

desc "获取所有应用系统的APP_KEY";
task getallkey=>sub {
	my @data = db select => {
		fields => "app_key",
		       from  => $table,
		       where  => "app_key != '' and app_key is not null and auto_deloy=1",
	};
	shift my @keys;
	for my $list (@data) {
		push(@keys,$list->{'app_key'});
	}
	my $len=@keys;
	if($len == 0 ){
		Rex::Logger::info("没有找到任何的应用系统关键字.");
		exit;
	}
	push(@keys,$len);
	my $keys = join(",", @keys);
	return $keys;
};

task getlistkey=>sub {
	my @data = db select => {
		fields => "app_key",
		       from  => $table,
		       where  => "app_key != '' and app_key is not null and auto_deloy=1",
	};
	shift my @keys;
	for my $list (@data) {
		push(@keys,$list->{'app_key'});
	}
	my $len=@keys;
	if($len == 0 ){
		Rex::Logger::info("没有找到任何的应用系统关键字.");
		exit;
	}
	push(@keys,$len);
	my $keys = join(" ", @keys);
	return $keys;
};

desc "获取非base应用系统的localname";
task ilocalname=>sub {
	my @data = db select => {
		fields => "local_name",
		       from  => $table,
		       where  => "app_key is not null and  app_key !='' and auto_deloy=1 ",
	};
	shift my @keys;
	for my $list (@data) {
		push(@keys,$list->{'local_name'});
	}
	my $len=@keys;
	if($len == 0 ){
		Rex::Logger::info("没有找到任何非base应用系统关键字.");
		exit;
	}
	push(@keys,$len);
	my $keys = join(",", @keys);
	return $keys;
};


desc "根据localname获取app_key";
task localname_appkey=>sub {
	my  $local_name  = $_[0];
	my @data = db select => {
		fields => "app_key",
		       from  => $table,
		       where  => "local_name = '$local_name' order by app_key and auto_deloy=1",
	};
	shift my @keys;
	for my $list (@data) {
		push(@keys,$list->{'app_key'});
	}
	my $len=@keys;
	if($len == 0 ){
		Rex::Logger::info("没有找到任何的应用系统关键字.");
		exit;
	}
	push(@keys,$len);
	my $keys = join(",", @keys);
	return $keys;
};

desc "根据关键词获取分组";
task getgroup => sub {
	my @data = db select => {
		fields => "network_ip",
		       from  => $table,
		       where  => "network_ip != '' and network_ip is not null order by network_ip",
	};
	shift my @ips;
	for my $list (@data) {
		push(@ips,$list->{'network_ip'});
	}
	my $ips = join(",", @ips);
	return $ips;    
};

desc "获取local_name列表";
task getlocalname=>sub {
#获取local_name,app_key
	my @data = db select => {
		fields => "local_name,app_key",
		       from  => $table,
		       where  => "app_key !='' and app_key is not null  and auto_deloy=1",
	};
	shift my @bases;
	for my $list (@data) {
		my $second_list = $list->{'local_name'}." ".$list->{'app_key'};
		push(@bases,$second_list);
	}
	my $base_str = join(",", @bases);;
	return $base_str;

};
desc "获取应用的发布状态";
task "getDeployStatus",sub {
	my  $k  = $_[0];
	my  $deploy_ip  = $_[1];
	my  $operator  = $_[2];
	my  $time = run "date '+%Y-%m-%d %H:%M:%S'";
	my  $version = run "date '+%Y_%m%d'";
	my  $randomStr = run "date '+%s%N'" ;
#say "$deploy_ip  $operator $time  $version";

	Rex::Logger::info("($k)--开始获取&更新发布状态.");
#开始更新发布状态
	my @data = db select => {
		fields => "status",
		       from  => $deploy_status_table,
		       where  => "deploy_key = '$k'",
	};
	if($data[0]->{'status'} eq "1" ){
		return 1;
	}	

	if($data[0]->{'status'} eq ""){
		db insert => "$deploy_status_table", {
			deploy_key => "$k",
				   deploy_ip => "$deploy_ip",
				   deploy_version => "$version",
				   deploy_people => "$operator",
				   start_time => "$time",
				   status => 1,
		};
	}

	if($data[0]->{'status'} eq "0"){
		db update => "$deploy_status_table", {
			set => {
				deploy_ip => "$deploy_ip",
					  deploy_version => "$version",
					  deploy_people => "$operator",
					  start_time => "$time",
					  status => 1,
			},
			    where => "deploy_key='$k'",
		};
	}   

#开始更新发布记录
	my @result = db select => {
		fields => "status",
		       from  => $deploy_table,
		       where  => "deploy_key = '$k'",
	};
	db insert => "$deploy_table", {
		deploy_key => "$k",
			   deploy_ip => "$deploy_ip",
			   deploy_version => "$version",
			   deploy_people => "$operator",
			   start_time => "$time",
			   randomStr => "$randomStr",
			   status => 1,
	};
	Rex::Logger::info("($k)--获取&更新发布状态完成.");
	return "$randomStr";
};

desc "更新应用发布状态";
task "updateDeployDes",sub {
#my  $k  = $_[0];
#my  $deploy_ip  = $_[1];
#my  $operator  = $_[2];
#my  $time = run "date '+%Y-%m-%d %H:%M:%S'";
#my  $version = run "date '+%Y_%m%d'";
	say "11";


};

desc "更新发布&传包&启动时间";
task "updateTimes",sub {
	my  $myAppStatus  = $_[0];
	my  $TimeChoice = $_[1];
	my  $rsync_war_time = run "date '+%Y-%m-%d %H:%M:%S'";
	my  $deloy_size = "1111";

#更新传包时间
	if ( $TimeChoice eq "rsync_endtime" ){
		Rex::Logger::info("[SQL:更新传包时间]update $deploy_table set rsync_war_time='$rsync_war_time' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				rsync_war_time => "$rsync_war_time",
			},
			    where => "randomStr = '$myAppStatus'",#
		};
	};

	if ( $TimeChoice eq "pre_des_before" ){
		Rex::Logger::info("[SQL:更新前的移除真实程序后备份目录]update $deploy_table set deloy_prodir_before='$_[2]' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				deloy_prodir_before => "$_[2]",
			},
			    where => "randomStr = '$myAppStatus'",
		};
	};

	if ( $TimeChoice eq "pre_des_real_before" ){
		Rex::Logger::info("[SQL:更新前的程序真实目录]update $deploy_table set deloy_prodir_real_before='$_[2]' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				deloy_prodir_real_before => "$_[2]",
			},
			    where => "randomStr = '$myAppStatus'",
		};
	};


	if ( $TimeChoice eq "pre_des_before_before" ){
		Rex::Logger::info("[SQL:更新前的程序软连接]update $deploy_table set deloy_prodir_before='$_[2]',deloy_configdir_before = '$_[3]' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				deloy_prodir_before => "$_[2]",
						    deloy_configdir_before => "$_[3]",
			},
			    where => "randomStr = '$myAppStatus'",
		};
	};

	if ( $TimeChoice eq "pre_des_after" ){
		my $deloy_prodir_after = $_[2];
		my $deloy_size  = $_[3];
		Rex::Logger::info("[SQL:更新后的程序软连接]update $deploy_table set deloy_prodir_after='$deloy_prodir_after',deloy_size='$deloy_size' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				deloy_prodir_after => "$deloy_prodir_after",
						   deloy_size => "$deloy_size",
			},
			    where => "randomStr = '$myAppStatus'",
		};
	};

	if ( $TimeChoice eq "pre_des_after_after" ){
		my $deloy_prodir_after = $_[2];
		my $deloy_size  = $_[4];
		Rex::Logger::info("[SQL:更新后的程序软连接]update $deploy_table set deloy_prodir_after='$deloy_prodir_after',deloy_configdir_after ='$_[3]',deloy_size='$deloy_size' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				deloy_prodir_after => "$deloy_prodir_after",
						   deloy_configdir_after =>"$_[3]",
						   deloy_size => "$deloy_size",
			},
			    where => "randomStr = '$myAppStatus'",
		};
	};


	if ( $TimeChoice eq "app_start_time" ){
		Rex::Logger::info("[SQL:更新APP启动时间]update $deploy_table set app_start_time = '$rsync_war_time' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				start_app_time => "$rsync_war_time",
			},
			    where => "randomStr = '$myAppStatus'",
		};
	}

	if ( $TimeChoice eq "deploy_end" ){
		my $processNumber = $_[2];
		Rex::Logger::info("[SQL:更新完成时间和进程数量和状态]update $deploy_table set end_time='$rsync_war_time',processNumber='$processNumber',status=0 where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				end_time => "$rsync_war_time",
					 processNumber => "$processNumber",
					 status => 0,
			},
			    where => "randomStr = '$myAppStatus'",
		};
	};

	if ( $TimeChoice eq "deploy_finish" ){
		Rex::Logger::info("[SQL:更新完成状态]uupdate $deploy_status_table set status=0 where  deploy_key = '$_[2]' .");
		db update => "$deploy_status_table", {
			set => {
				status => 0,
			},
			    where => "deploy_key = '$_[2]'",
		};

		Rex::Logger::info("[SQL:查询各个流程中的时间] select start_time,rsync_war_time,start_app_time,end_time from $deploy_table  where  randomStr = '$myAppStatus'.");
		my @data = db select => {
			fields => "start_time,rsync_war_time,start_app_time,end_time",
			       from  => "$deploy_table",
			       where  => "randomStr = '$myAppStatus'",
		};  
		my $startTime = run " date -d  '$data[0]->{'start_time'}' +%s";
		my $rsyncWarTime = run " date -d  '$data[0]->{'rsync_war_time'}' +%s";
		my $startAppTime = run " date -d  '$data[0]->{'start_app_time'}' +%s";
		my $endTime = run " date -d  '$data[0]->{'end_time'}' +%s";
		my $totalTime = run "expr $endTime - $startTime ";
		my $rsyncTime = run "expr $rsyncWarTime - $startTime ";
		my $startAppTime = run "expr $endTime - $startAppTime ";

		Rex::Logger::info("[SQL:更新总花费时间]update $deploy_table set deploy_take = 'Total Take:$totalTime || Rsync Time:$rsyncTime || Start App Time:$startAppTime' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				deploy_take => "Total Take:$totalTime || Rsync Time:$rsyncTime || Start App Time:$startAppTime",
			},
			    where => "randomStr = '$myAppStatus'",
		};


	};

	if ( $TimeChoice eq "deploy_roll_finish" ){
		Rex::Logger::info("[SQL:更新完成状态]uupdate $deploy_status_table set status=0 where  deploy_key = '$_[2]' .");
		db update => "$deploy_status_table", {
			set => {
				status => 0,
			},
			    where => "deploy_key = '$_[2]'",
		};

		Rex::Logger::info("[SQL:查询各个流程中的时间] select start_time,rsync_war_time,start_app_time,end_time from $deploy_table  where  randomStr = '$myAppStatus'.");
		my @data = db select => {
			fields => "start_time,rsync_war_time,start_app_time,end_time",
			       from  => "$deploy_table",
			       where  => "randomStr = '$myAppStatus'",
		};
#查询这个程序的已经有的回滚次数
		my @rollNumber = db select => {
			fields => "rollbackNumber",
			       from  => "$deploy_table",
			       where  => "randomStr = '$_[3]'",
		};
		my $startTime = run " date -d  '$data[0]->{'start_time'}' +%s";
		my $startAppTime = run " date -d  '$data[0]->{'start_app_time'}' +%s";
		my $endTime = run " date -d  '$data[0]->{'end_time'}' +%s";
		my $totalTime = run "expr $endTime - $startTime ";
		my $startAppTime = run "expr $endTime - $startAppTime ";
		my $nowNumber = $rollNumber[0]->{'rollbackNumber'} ;
		my $rollbackNumber= run "expr $nowNumber  + 1"; 

		Rex::Logger::info("[SQL:更新总花费时间]update $deploy_table set deploy_take = 'Total Take:$totalTime || Start App Time:$startAppTime' where  randomStr = '$myAppStatus' .");
		db update => "$deploy_table", {
			set => {
				deploy_take => "Total Take:$totalTime  || Start App Time:$startAppTime",
					    rollRecord => 1,
			},
			    where => "randomStr = '$myAppStatus'",
		};
		db update => "$deploy_table", {
			set => {
				rollbackNumber => $rollbackNumber,
			},
			    where => "randomStr = '$_[3]'",
		}; 

		if( $_[4] eq "1" ){
			db update => "$deploy_table", {
				set => {
					rollStatus => 0,
				},
				    where => "randomStr = '$_[3]'",
			};

		}


	};



};


desc "获取应用最近一次发布记录.";
task "getLastDeloy",sub {
	my  $k  = $_[0];
	my  $rollstatus = $_[1];

	Rex::Logger::info("[SQL:获取应用发布记录] select deloy_prodir_before,deloy_configdir_before,deloy_prodir_after,deloy_configdir_after,end_time from $deploy_table where deploy_key='$k' order by end_time desc limit 1");
	my @data = db select => {
		fields => "deloy_prodir_before,deloy_configdir_before,deloy_prodir_after,deloy_configdir_after,end_time,randomStr",
		       from  => "$deploy_table",
		       where  => "deploy_key='$k' order by end_time desc limit 1",
	};
	my %queryInfo=();
	my $queryInfo;

	if( $data[0]->{'deloy_prodir_before'} eq "" ){
		db update => "$deploy_status_table", {
			set => {
				status => 0,
			},
			    where => "deploy_key = '$k'",
		};

		return 0;
	};

	if ( $rollstatus  eq "1" ){
		Rex::Logger::info("[SQL:根据数据库状态来获取回滚版本,select deloy_prodir_before,deloy_configdir_before,deloy_prodir_after,deloy_configdir_after,end_time from $deploy_table where 
				deploy_key='$k' where rollStatus=1 and deploy_key='$k'");

		my @rolldata = db select => {
			fields => "deloy_prodir_before,deloy_configdir_before,deloy_prodir_after,deloy_configdir_after,end_time,randomStr,rollStatus",
			       from  => "$deploy_table",
			       where  => "deploy_key='$k' and rollStatus=1",
		};
		my $len=@rolldata;
		if($len eq "0" ){
			db update => "$deploy_status_table", {
				set => {
					status => 0,
				},
				    where => "deploy_key = '$k'",
			};
			return 2;
		} 

		if($len gt "1" ){
			db update => "$deploy_status_table", {
				set => {
					status => 0,
				},
				    where => "deploy_key = '$k'",
			};
			return 3;
		}

		$queryInfo{'deloy_prodir_before'}=$rolldata[0]->{'deloy_prodir_before'} ;
		$queryInfo{'deloy_configdir_before'}=$rolldata[0]->{'deloy_configdir_before'} ;
		$queryInfo{'deloy_prodir_after'}=$rolldata[0]->{'deloy_prodir_after'} ;
		$queryInfo{'deloy_configdir_after'}=$rolldata[0]->{'deloy_configdir_after'} ;
		$queryInfo{'end_time'}=$rolldata[0]->{'end_time'} ;
		$queryInfo{'randomStr'}=$rolldata[0]->{'randomStr'} ;
		$queryInfo{'rollstatus'}=1 ;

		Rex::Logger::info("($k)--获取到rollStatus=1发布时间:$queryInfo{'end_time'} 链接状态:$queryInfo{'deloy_prodir_before'} $queryInfo{'deloy_configdir_before'} ");

		return \%queryInfo;
	}

	$queryInfo{'deloy_prodir_before'}=$data[0]->{'deloy_prodir_before'} ;
	$queryInfo{'deloy_configdir_before'}=$data[0]->{'deloy_configdir_before'} ;
	$queryInfo{'deloy_prodir_after'}=$data[0]->{'deloy_prodir_after'} ;
	$queryInfo{'deloy_configdir_after'}=$data[0]->{'deloy_configdir_after'} ;
	$queryInfo{'end_time'}=$data[0]->{'end_time'} ;
	$queryInfo{'randomStr'}=$data[0]->{'randomStr'} ;

	Rex::Logger::info("($k)--获取到上次发布时间:$queryInfo{'end_time'} 链接状态:$queryInfo{'deloy_prodir_before'} $queryInfo{'deloy_configdir_before'} ");

	return \%queryInfo;

};


desc "初始化发布状态";
task initdb=>sub {

	my @data = db update => "$deploy_status_table", {
		set => {
			status => 0,
		},
		    where => "status = 1",
	};

	Rex::Logger::info("初始化发布状态完成.");
};


desc "根据关键词显示名称";
task showname=>sub {
	my $ip = @_[0];
	if($ip eq ""){
		return "null";
	}
	my @data = db select => {
		fields => "server_name",
		       from  => $table,
		       where  => "network_ip='$ip' or external_ip='$ip' ",
	};
	shift my @names;
	for my $list (@data) {
		push(@names,$list->{'server_name'});
	}
	my $len=@names;
	if($len == 0 ){
		return "none";
	}
	my $names_string = join(",", @names);
	return $names_string;
};


desc "根据app_key返回配置文件组";
task configure_group=>sub {
	my $self = shift;
	my $app_key = $self->{app_key};

	my @configure_file_status = db select => {
		fields => "configure_file_status",
		       from  => $table,
		       where  => "app_key='$app_key' ",
	};

	if ($configure_file_status[0]{'configure_file_status'}  eq "0" ) {
		return "0";
	}

	my @configure_file_list = db select => {
		fields => "configure_file_list",
		       from  => $table,
		       where  => "app_key='$app_key' ",
	};
# say Dumper(@configure_file_list);exit;
# say Dumper();exit;
	return $configure_file_list[0]{'configure_file_list'};
# shift my @names;
# for my $list (@data) {
# push(@names,$list->{'server_name'});
# }
# my $len=@names;
# if($len == 0 ){
#   return "none";
# }
# my $names_string = join(",", @names);
# return $names_string;
};

desc "根据server_name返回服务器信息";
task search_info=>sub {
	my $search = @_[0];
	if( $search eq "" ){
		return 0 ;
	}

	my @server_list = db select => {
		fields => "*",
		       from  => $table,
		       where  => "server_name like '%$search%'  or network_ip like '%$search%' or external_ip like '%$search%' ",
	};
	my $count= @server_list;
	unshift(@server_list,$count);
	#say Dumper(@server_list);exit;
	return \@server_list;

};

desc "返回当前环境关键信息";
task server_info=>sub {
	my @server_list = db select => {
		fields => "server_name,network_ip,external_ip",
		       from  => $table,
		       where  => " network_ip is not null or network_ip !='' ",
	};
	my $count= @server_list;
	unshift(@server_list,$count);
	# say Dumper(@server_list);exit;
	return \@server_list;
};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

include qw/Deploy::Db/;

task yourtask => sub {
	Deploy::Db::example();
};

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
