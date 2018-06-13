package Deploy::Configure;

use Rex -base;
use Deploy::Db;
use DBI;
use Data::Dumper;
use Rex::Misc::ShellBlock;
use POSIX qw(strftime); 

my $env;
my $softdir;
my $configuredir;
my $backup_dir;
my $baseapp_dir;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key} ;
 });
Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 our $user = $param->{user} ;
     $softdir  = $param->{softdir};
     $configuredir  = $param->{configuredir};
     $backup_dir  = $param->{backup_dir};
     $baseapp_dir  = $param->{baseapp_dir};
 });


desc "配置文件初始化 rex Deploy:Configure:config --k='server'";
task config => sub {
    my $self = shift;
    my $k=$self->{k};
    my $w=$self->{w};
    my %reshash ;
    if( $k eq ""  ){
	    Rex::Logger::info("关键字(--k='')不能为空");
	    Common::Use::json($w,"","关键字(--k='')不能为空","");
        $reshash{"code"} = -1; 
        $reshash{"msg"} = "--k is null"; 
	    return \%reshash;
    }
    my $diff_pro = Deploy::Db::query_local_pro_cmd($k);
    my @diff_pro_array = @$diff_pro;
    my $diff_pro_count = @diff_pro_array;
    my $run_pro_cmd ;
    $reshash{diff_pro} = $diff_pro;
    if ( $diff_pro_count > 0 ) {
    	Rex::Logger::info("$k 存在工程路径自定义命令执行");
    	$run_pro_cmd = run_pro_cmd($diff_pro);
        $reshash{run_pro_cmd} = $run_pro_cmd;
    	if ( $run_pro_cmd->{code} != 0 ) {
    		Rex::Logger::info("$k 执行程序初始化命令失败","error");           
            $reshash{"code"} = -1; 
            $reshash{"msg"} = "init pro faild".$run_pro_cmd->{msg}; 
            Common::Use::json($w,"","失败",[\%reshash ]);            
    		return \%reshash;
    	}
    }else{
    	Rex::Logger::info("$k 不存在工程路径自定义命令执行");
    }

    my $diff_conf = Deploy::Db::query_local_conf_cmd($k);
    my @diff_conf_array = @$diff_conf;
    my $diff_conf_count = @diff_conf_array;
    my $run_conf_cmd ;
    $reshash{diff_conf} = $diff_conf;
    if ( $diff_conf_count > 0 ) {
        Rex::Logger::info("$k 存在配置路径自定义命令执行");
        $run_conf_cmd = run_conf_cmd($diff_conf);
        $reshash{run_conf_cmd} = $run_conf_cmd;
        if ( $run_conf_cmd->{code} != 0 ) {
            Rex::Logger::info("$k 执行配置初始化命令失败","error");            
            $reshash{"code"} = -1; 
            $reshash{"msg"} = "init config faild ".$run_conf_cmd->{msg}; 
            Common::Use::json($w,"","失败",[\%reshash ]);
            return \%reshash;
        }
    }else{
        Rex::Logger::info("$k 不存在配置路径自定义命令执行");
    }
    $reshash{"code"} = 0; 
    $reshash{"msg"} = "run init pro and config success"; 
    Common::Use::json($w,"0","成功",[\%reshash]);
    return \%reshash;

};


desc "配置文件同步 rex Deploy:Configure:sync --k='server'";
task sync => sub {
    my $self = shift;
    my $k=$self->{k};
    my $w=$self->{w};
    my %reshash ;
    if( $k eq ""  ){
        Rex::Logger::info("关键字(--k='')不能为空");
        Common::Use::json($w,"","关键字(--k='')不能为空","");
        $reshash{"code"} = -1; 
        $reshash{"msg"} = "--k is null"; 
        return \%reshash;
    }

    my $conf = Deploy::Db::query_conf($k);
    my @conf_array = @$conf;
    my $conf_count = @conf_array;
    $reshash{conf} = $conf;
    if ( $conf_count > 0 ) {
        Rex::Logger::info("$k 开始执行配置文件同步");
        for my $config (@conf_array){
            my $app_key = $config->{app_key};
            my $pro_dir = $config->{pro_dir};
            my $config_dir = $config->{config_dir};
            my $is_deloy_dir = $config->{is_deloy_dir};
            my $configure_file_status = $config->{configure_file_status};
            my $configure_file_list = $config->{configure_file_list};
            my $network_ip = $config->{network_ip};
            run_task "Deploy:Configure:backup",
              on     => "$network_ip",
              params => {
                app_key    => "$app_key",
                pro_dir    => "$pro_dir",
                config_dir => "$config_dir",
                is_deloy_dir          => "$is_deloy_dir",
                configure_file_status       => "$configure_file_status",
                configure_file_list         => "$configure_file_list",
                network_ip         => "$network_ip",
            };

        }

        Rex::Logger::info("$k 结束执行配置文件同步");
    }else{
        Rex::Logger::info("$k 不存在配置项文件同步或者$k不存在","error");            
        $reshash{"code"} = -1; 
        $reshash{"msg"} = "$k 不存在配置项文件同步或者$k不存在"; 
        Common::Use::json($w,"","失败",[\%reshash ]);
        return \%reshash;        
    }
    $reshash{"code"} = 0; 
    $reshash{"msg"} = "执行配置同步成功"; 
    Common::Use::json($w,"0","成功",[\%reshash]);
    return \%reshash;

};

desc "配置文件备份 rex Deploy:Configure:backup --k='server'";
task backup => sub {
    my $self = shift;
    my $k=$self->{app_key};
    my $config_dir=$self->{config_dir};
    my $is_deloy_dir=$self->{is_deloy_dir};
    my $configure_file_status=$self->{configure_file_status};
    my $configure_file_list=$self->{configure_file_list};
    my $network_ip=$self->{network_ip};
    my $datetime = strftime("%Y%m%d_%H%M%S", localtime(time));
    $config_dir =~ s/\/$//;
    my $myAppStatus=Deploy::Db::getDeployStatus($k,$network_ip,"configureUser");
    if($myAppStatus eq "1" ){
        run_task "Deploy:Db:initdb";
        $myAppStatus=Deploy::Db::getDeployStatus($k,$network_ip,"configureUser");
    }
    Rex::Logger::info("($k) 生成随机数: $myAppStatus");    
    my %data ; 
    my $link_status = run "ls $config_dir -ld |grep '^l' |wc -l";
    my $conf_desc_be;
    my $conf_desc_be_before;    
    if( $is_deloy_dir == 2  ){
        #配置目录存在就备份
        if ( !is_dir($config_dir) ) {
            Rex::Logger::info("($k $config_dir目录不存在","warn");
        }else{
            $conf_desc_be = run "ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'";
            $conf_desc_be_before = run "ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'";
            if ( ! $conf_desc_be_before ) {
                $conf_desc_be_before = "${config_dir}_nolinkbak_${datetime}";
                Rex::Logger::info( "($k)--目录:$config_dir 不是软链接,备份配置目录详情:  $conf_desc_be_before");
                run "mv $config_dir $conf_desc_be_before";
                if ( $? eq 0) {
                    Rex::Logger::info( "($k)--备份配置目录成功:  $conf_desc_be_before");
                }else{
                    Rex::Logger::info( "($k)--备份配置目录失败:  $conf_desc_be_before","error");
                    exit;
                }
            }else{
                Rex::Logger::info( "($k)--目录:$config_dir 是软链接,备份配置目录详情:  $conf_desc_be_before");  
                run "unlink  $config_dir";
                if ( $? eq 0) {
                    Rex::Logger::info( "($k)--取消配置目录软链接成功:  $conf_desc_be_before");
                }else{
                    Rex::Logger::info( "($k)--取消配置目录软链接失败:  $conf_desc_be_before","error");
                    exit;
                }
            }
            Deploy::Db::updateTimes($myAppStatus, "pre_des_before_before", "", $conf_desc_be_before);                     
        }

    }elsif( $is_deloy_dir == 1 ){
        if ( !is_dir($config_dir) ) {
            Rex::Logger::info("($k $config_dir目录不存在","warn");
        }else{
            my $root_name = run "echo $config_dir |awk -F'/' '{print \$NF}' ";
            my $backup = "$backup_dir/$root_name/$datetime";              
            if ( "$configure_file_status" eq "0") {
                
            }
          
        }

    }else{
        Rex::Logger::info( "($k)--不支持的is_deloy_dir,请确认is_deloy_dir是否配置正确","error");
        exit;        
    }

};

sub run_pro_cmd {
	my ($diff_pro)= @_;
    my @diff_pro_array = @$diff_pro;
    my %reshash ; 
    my @data ; 
    $reshash{"code"} = 0 ;
    $reshash{"msg"} = "run cmd success" ;
    for my $pro (@diff_pro_array){
    	my %singleData ; 
    	my $local_name = $pro->{"local_name"};
    	my $pro_cmd = $pro->{"local_pro_cmd"};
    	my $run_dir = $softdir."/".$local_name ; 
        Rex::Logger::info("$local_name 执行路径: $run_dir");
        Rex::Logger::info("$local_name 执行命令: \n$pro_cmd");
    	$singleData{"local_name"} = $local_name;
    	$singleData{"pro_cmd"} = $pro_cmd;
    	$singleData{"run_dir"} = $run_dir;

        if ( ! is_dir($run_dir) ) {
            Rex::Logger::info("$local_name 执行路径: $run_dir 不存在","error");
            $reshash{"code"} = -1 ;
            $reshash{"msg"} = "run cmd path is not exist: $run_dir" ;
            return \%reshash;
        }
    	my $runres;
    	eval {
    		# $runres = run " cd $run_dir && $pro_cmd";
  $runres = shell_block <<EOF;
    cd $run_dir
    $pro_cmd
EOF

    		if ( $? != 0 ) {
    			Rex::Logger::info("$local_name 执行路径: $run_dir 执行命令: $pro_cmd 执行失败: $runres","error");
	    		$reshash{"code"} = -1 ;
	    		$reshash{"msg"} = "run cmd faild: $runres,return code is not 0" ;
                $reshash{"runres"} = "$runres" ;
	    		return \%reshash;
    		}else{
                $reshash{"runres"} = "$runres" ;
                Rex::Logger::info("$local_name 执行路径: $run_dir 执行成功");
                Rex::Logger::info("$local_name 执行返回内容: $runres");
    		}
    	};
    	if ($@) {
    		push @data,\%singleData;
    		$reshash{"code"} = -1 ;
    		$reshash{"msg"} = "run cmd except: $@" ;
    		return \%reshash;
    	}
    	push @data,\%singleData;
    		
    }
    $reshash{"data"} =\@data; 
    return \%reshash;

}


sub run_conf_cmd {
    my ($diff_conf)= @_;
    my @diff_conf_array = @$diff_conf;
    my %reshash ; 
    my @data ; 
    $reshash{"code"} = 0 ;
    $reshash{"msg"} = "run cmd success" ;
    for my $conf (@diff_conf_array){
        my %singleData ; 
        my $local_name = $conf->{"local_name"};
        my $conf_cmd = $conf->{"local_conf_cmd"};
        my $app_key = $conf->{"app_key"};
        my $run_dir = $configuredir."/".$local_name."/". $app_key; 
        Rex::Logger::info("$local_name/$app_key 执行路径: $run_dir");
        Rex::Logger::info("$local_name/$app_key 执行命令: \n$conf_cmd");
        $singleData{"local_name"} = $local_name;
        $singleData{"conf_cmd"} = $conf_cmd;
        $singleData{"run_dir"} = $run_dir;

        if ( ! is_dir($run_dir) ) {
            Rex::Logger::info("$local_name/$app_key 执行路径: $run_dir 不存在","error");
            $reshash{"code"} = -1 ;
            $reshash{"msg"} = "run cmd path is not exist: $run_dir" ;
            return \%reshash;
        }
        my $runres;
        eval {
            # $runres = run " cd $run_dir && $conf_cmd";
  $runres = shell_block <<EOF;
    cd $run_dir
    $conf_cmd
EOF

            if ( $? != 0 ) {
                Rex::Logger::info("$local_name/$app_key 执行路径: $run_dir 执行命令: $conf_cmd 执行失败: $runres","error");
                $reshash{"code"} = -1 ;
                $reshash{"msg"} = "run cmd faild: $runres,return code is not 0" ;
                $reshash{"runres"} = "$runres" ;
                return \%reshash;
            }else{
                $reshash{"runres"} = "$runres" ;
                Rex::Logger::info("$local_name/$app_key 执行路径: $run_dir 执行成功");
                Rex::Logger::info("$local_name/$app_key 执行返回内容: $runres");
            }
        };
        if ($@) {
            push @data,\%singleData;
            $reshash{"code"} = -1 ;
            $reshash{"msg"} = "run cmd except: $@" ;
            return \%reshash;
        }
        push @data,\%singleData;
            
    }
    
    
    $reshash{"data"} =\@data; 
    return \%reshash;

}

task example => sub {
    # file "/data/www/ins_share/cm/config/config.properties",
    # content   => template("file/data/www/ins_share/cm/config/config.properties", mysql_server => $mysql_server),
    # on_change => sub {
    #     print "have changed!";
    # };
    my $app_key ='cm-test';
    my $dbh = DBI->connect("DBI:mysql:autotask_jry:127.0.0.1", 'root', 'root');
    my $query_info = $dbh->prepare(qq{
       select local_name,env from pre_server_detail 
       where app_key='$app_key';
    });
    $query_info->execute();
    #$dbh->do(“UPDATE test1 SET time=now()”); 直接执行不需要execute

    #读取记录,返回数组[索引]
    # while ( my @row = $sth->fetchrow_array() )
    # {
    #        # print join('\t', @row)."\n";
    #        print "$row[0], $row[1], $row[2]\n";
    # }

    #读取记录,返回数组[字典]
    # while ( my $record = $query_info->fetchrow_hashref() ) {
    #     for my $field( keys %{$record} ) {
    #         print "$field: $record->{$field}\t\n";
    #         if($field eq "local_name"){
    #             $local_name = $record->{$field};
    #         }           
    #          if($field eq "env"){
    #             $env = $record->{$field};
    #         }

    #     }

    # }
    #查询local_name,env
    my @query_info_row = $query_info->fetchrow_array();
    my $local_name = $query_info_row[0];
    my $env = $query_info_row[1];
    if($local_name eq ""){
        Rex::Logger::info("查询到local_name为空",'error');
        exit;
    }
    

    #查询配置组和模板id
    my $query_info = $dbh->prepare(qq{
       select * from pre_auto_configure 
       where local_name='$local_name' ;
    });
    $query_info->execute();
    my @query_info_row = $query_info->fetchrow_array();
    my $link_template_id = $query_info_row[2];
    my $configure_group = $query_info_row[3];
    my @configure_group_list = split( /,/, $configure_group );

    #查询模板变量
    my $query_template_vars = "select * from pre_auto_template_vars where id in ($link_template_id) and env='$env';";
    my $query_info = $dbh->prepare(qq{
       $query_template_vars
    });
    Rex::Logger::info("SQL: $query_template_vars");
    $query_info->execute();
    my %template_vars;
    while ( my ($id, $template_vars_name, $template_vars_value) = $query_info->fetchrow_array() )  {
          # print "$template_vars_name, $template_vars_value";         
         $template_vars{$template_vars_name}=$template_vars_value;
    }

    for my $configure_file (@configure_group_list) {
        my $file = "files$configure_file";
        my $remotefile = "/tmp$configure_file";
        # say Dumper(%template_vars);exit;
        Rex::Logger::info("$file --> $remotefile");
        say template("$file",\%template_vars);
        file "$remotefile ",
        content   => template("$file", \%template_vars),
        on_change => sub {
            say "have changed!";
        };
        
        
    }
    $query_info->finish();

};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Deploy::Configure/;

 task yourtask => sub {
    Deploy::Configure::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
