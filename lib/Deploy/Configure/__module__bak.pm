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
my $local_confdir;
my $update_local_confdir;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key};
 my $envName = Rex::Config->get_envName;
 $env = $envName if ( $envName ) ;
 });
Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 our $user = $param->{user} ;
     $softdir  = $param->{softdir};
     $configuredir  = $param->{configuredir};
     $backup_dir  = $param->{backup_dir};
     $baseapp_dir  = $param->{baseapp_dir};
     $local_confdir  = $param->{local_confdir};
     $update_local_confdir  = $param->{update_local_confdir};
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
    my $source=$self->{source};
    my %reshash ;
    my $baseconf ;
    if( $k eq ""  ){
        Rex::Logger::info("关键字(--k='')不能为空","error");
        Common::Use::json($w,"","关键字(--k='')不能为空","");
        $reshash{"code"} = -1; 
        $reshash{"msg"} = "--k is null"; 
        return \%reshash;
    }
    if( $source  eq ""){
        $baseconf = $configuredir;
    }elsif($source  eq "update"){
        $baseconf = $update_local_confdir;
    }elsif($source  eq "remote"){
        $baseconf = $local_confdir;
    }elsif($source  eq "conf"){
        $baseconf = $configuredir;
    }else{
        Rex::Logger::info("关键字(--source='')不正确","error");
        Common::Use::json($w,"","关键字(--source='')不正确","");
        $reshash{"code"} = -1; 
        $reshash{"msg"} = "--source is wrong"; 
        return \%reshash;        
    }

    my $conf = Deploy::Db::query_conf($k);
    my @conf_array = @$conf;
    my $conf_count = @conf_array;
    $reshash{conf} = $conf;
    my $datetime = strftime("%Y%m%d_%H%M%S", localtime(time));
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
            my $local_name = $config->{local_name};
            $config_dir =~ s/\/$//;
            $baseconf =~ s/\/$//;

            #同步,备份,切换
            if( $is_deloy_dir == 2   ){
                my $destDir = $config_dir."_".$datetime ;
                my $source ;
                if($source  eq "remote"){
                    $source = $baseconf ."/".$app_key."/" ;
                }else{
                    $source = $baseconf ."/".$local_name."/".$app_key."/" ;
                }
                if( !is_dir($source ) ){
                    Rex::Logger::info("$app_key 本地配置目录:$source 不存在","error");
                    Common::Use::json($w,"","$app_key 本地配置目录:$source 不存在","");
                    $reshash{"code"} = -1; 
                    $reshash{"msg"} = "$app_key 本地配置目录:$source 不存在"; 
                    exit;   
                }                
                my $upload = run_task "Common:Use:upload",
                  on     => "$network_ip",
                  params => {
                    dir1    => "$source",
                    dir2    => "$destDir",
                };
                my $code = $upload->{code};
                if( $code != 0 ){
                    Rex::Logger::info("$app_key 上传配置失败","error");
                    Common::Use::json($w,"","$app_key 上传配置失败","");
                    $reshash{"code"} = -1; 
                    $reshash{"msg"} = "$app_key 上传配置失败"; 
                    exit;
                }
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
                    destDir         => "$destDir",
                };                                  

            }elsif( $is_deloy_dir == 1  ){
                if("$configure_file_status" eq "0"){
                    my $destDir = $config_dir."_".$datetime ;
                    my $source ;
                    if($source  eq "remote"){
                        $source = $baseconf ."/".$app_key."/" ;
                    }else{
                        $source = $baseconf ."/".$local_name."/".$app_key."/" ;
                    }
                    if( !is_dir($source ) ){
                        Rex::Logger::info("$app_key 本地配置目录:$source 不存在","error");
                        Common::Use::json($w,"","$app_key 本地配置目录:$source 不存在","");
                        $reshash{"code"} = -1; 
                        $reshash{"msg"} = "$app_key 本地配置目录:$source 不存在"; 
                        exit;   
                    }                
                    my $upload = run_task "Common:Use:upload",
                      on     => "$network_ip",
                      params => {
                        dir1    => "$source",
                        dir2    => "$destDir",
                    };
                    my $code = $upload->{code};
                    if( $code != 0 ){
                        Rex::Logger::info("$app_key 上传配置失败","error");
                        Common::Use::json($w,"","$app_key 上传配置失败","");
                        $reshash{"code"} = -1; 
                        $reshash{"msg"} = "$app_key 上传配置失败"; 
                        exit;
                    }
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
                        destDir         => "$destDir",
                    };
                }else{
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
                    my @configureArray = split(",",$configure_file_list);
                    my @filesArray;
                    for my $confile (@configureArray){
                        my $configfile = $config_dir."/".$confile; 
                        my $source ;
                        if($source  eq "remote"){
                            $source = $baseconf ."/".$app_key."/" ;
                        }else{
                            $source = $baseconf ."/".$local_name."/".$app_key."/" ;
                        }                       
                        my $srcfile = $source .$confile;
                        my $dest = $config_dir."/".$confile ;
                        my $fileVar = "$srcfile:$dest"; 
                        push @filesArray,$fileVar; 
                        if( !is_file($srcfile ) ){
                            Rex::Logger::info("$app_key 本地配置:$srcfile 不存在","error");
                            Common::Use::json($w,"","$app_key 本地配置:$srcfile 不存在","");
                            $reshash{"code"} = -1; 
                            $reshash{"msg"} = "$app_key 本地配置:$srcfile 不存在"; 
                            exit;   
                        }                                                 
                    }
                    my $files = join(",",@filesArray);
                    run_task "Common:Use:syncFiles",
                      on     => "$network_ip",
                      params => {
                        files    => "$files",
                    };  

                }   
            }

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
    my $destDir=$self->{destDir};
    my $datetime = strftime("%Y%m%d_%H%M%S", localtime(time));
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
        Rex::Logger::info("($k 该配置目录和程序目录是分开部署");
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
                    Rex::Logger::info( "($k)--备份配置目录成功:  mv $config_dir $conf_desc_be_before");
                }else{
                    Rex::Logger::info( "($k)--备份配置目录失败:  mv $config_dir $conf_desc_be_before","error");
                    exit;
                }
            }else{
                Rex::Logger::info( "($k)--目录:$config_dir 是软链接,备份配置目录详情:  $conf_desc_be_before");  
                run "unlink  $config_dir";
                if ( $? eq 0) {
                    Rex::Logger::info( "($k)--取消配置目录软链接成功: unlink  $config_dir=> $conf_desc_be_before");
                }else{
                    Rex::Logger::info( "($k)--取消配置目录软链接失败: unlink  $config_dir=> $conf_desc_be_before","error");
                    exit;
                }
                my @config_dir_array = split("/",$config_dir);
                if ( $conf_desc_be_before !~  /\// ) {  
                    if($config_dir !~  /\// ){

                    }else{
                        my $config_dir_pre = $config_dir;
                        $config_dir_pre =~ s/$config_dir_array[-1]//i; 
                        $conf_desc_be_before = "$config_dir_pre/$conf_desc_be_before";                          
                    }
                
                }
            }
            Deploy::Db::updateTimes($myAppStatus, "pre_des_before_before", "only_config", $conf_desc_be_before);                     
        }
        #重建软链接
        run "ln -s $destDir $config_dir";
        if ( $? eq 0) {
            Rex::Logger::info( "($k)--配置目录新建软链接成功: ln -s $destDir $config_dir");
        }else{
            Rex::Logger::info( "($k)--配置目录新建软链接失败: ln -s $destDir $config_dir","error");
            exit;
        }        
        my $conf_desc = run "ls $config_dir -ld |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'";
        my $conf_desc_after = run "ls $config_dir -ld |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'";
        my $size = run "du -sh  $conf_desc_after |xargs ";
        Deploy::Db::updateTimes( $myAppStatus, "pre_des_after_after", "only_config", "$conf_desc_after", "$size" );
        Rex::Logger::info( "($k)--发布后配置软链接详情:  $conf_desc");            


    }elsif( $is_deloy_dir == 1 ){
        Rex::Logger::info("($k 该配置目录和程序目录是集成部署");
        if ( !is_dir($config_dir) ) {
            Rex::Logger::info("($k $config_dir目录不存在","warn");
        }else{
            my $root_name = run "echo $config_dir |awk -F'/' '{print \$NF}' ";
            my $backup = "$backup_dir/$k/conf_backup_$datetime";              
            if ( "$configure_file_status" eq "0") {
                $conf_desc_be = run "ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'";
                $conf_desc_be_before = run "ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'";
                if ( ! $conf_desc_be_before ) {
                    $conf_desc_be_before = "$backup";
                    Rex::Logger::info( "($k)--目录:$config_dir 不是软链接,备份配置目录详情:  $conf_desc_be_before");
                    run "mv $config_dir $conf_desc_be_before";
                    if ( $? eq 0) {
                        Rex::Logger::info( "($k)--备份配置目录成功:  mv $config_dir $conf_desc_be_before");
                    }else{
                        Rex::Logger::info( "($k)--备份配置目录失败:  mv $config_dir $conf_desc_be_before","error");
                        exit;
                    }
                }else{
                    Rex::Logger::info( "($k)--目录:$config_dir 是软链接,备份配置目录详情:  $conf_desc_be_before");  
                    run "unlink  $config_dir";
                    if ( $? eq 0) {
                        Rex::Logger::info( "($k)--取消配置目录软链接成功: unlink  $config_dir => $conf_desc_be_before");
                    }else{
                        Rex::Logger::info( "($k)--取消配置目录软链接失败: unlink  $config_dir => $conf_desc_be_before","error");
                        exit;
                    }
                    my @config_dir_array = split("/",$config_dir);
                    if ( $conf_desc_be_before !~  /\// ) {  
                        if($config_dir !~  /\// ){

                        }else{
                            my $config_dir_pre = $config_dir;
                            $config_dir_pre =~ s/$config_dir_array[-1]//i; 
                            $conf_desc_be_before = "$config_dir_pre/$conf_desc_be_before";                          
                        }
                    
                    }


                }
                Deploy::Db::updateTimes($myAppStatus, "pre_des_before_before", "only_config", $conf_desc_be_before);  

                #mv配置目录
                run "mv $destDir $config_dir";
                if ( $? eq 0) {
                    Rex::Logger::info( "($k)--配置目录新建目录接成功: mv $destDir $config_dir");
                }else{
                    Rex::Logger::info( "($k)--配置目录新建目录失败: mv $destDir $config_dir","error");
                    exit;
                }        
                my $conf_desc_after = $config_dir;
                my $size = run "du -sh  $conf_desc_after |xargs ";
                Deploy::Db::updateTimes( $myAppStatus, "pre_des_after_after", "only_config", "$conf_desc_after", "$size" );
                Rex::Logger::info( "($k)--发布后配置目录详情:  $config_dir");            


            }else{
                if(!is_dir($backup)){
                    mkdir($backup);
                }
                my @configure_file_list_array = split(",",$configure_file_list);
                for my $configure_file (@configure_file_list_array){
                    my $file = "$config_dir/$configure_file";
                    if(is_file($file)){
                        run "cp --parents $file $backup "; 
                        if ( $? eq 0) {
                            Rex::Logger::info( "($k)--备份成功: cp --parents $file $backup ");
                        }else{
                            Rex::Logger::info( "($k)--备份失败: cp --parents $file $backup","error");
                            exit;
                        }                           
                    }else{
                        Rex::Logger::info( "($k)--配置文件:$file 不存在,无需备份 ","warn");
                    }
                }
                Deploy::Db::updateTimes($myAppStatus, "pre_des_before_before", "only_config", $conf_desc_be_before); 
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
