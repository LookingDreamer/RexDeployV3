package Deploy::Core;

use Rex -base;
use Data::Dumper;
use Deploy::FirstConnect;
use Rex::Commands::DB {
    dsn      => "DBI:mysql:database=autotask;host=127.0.0.1;port=3306",
    user     => "root",
    password => "root",
};
use Deploy::Db;
use Rex::Commands::Rsync;
use Rex::Commands::Sync;
use Deploy::other;
use Rex::Misc::ShellBlock;
use Common::Use;
use Rex::Commands::Fs;
use Predeploy::Judge;
use Cos::Upload;

my $env;
my $table_string;
my @string;
my $softdir;
my $configuredir;
my $local_prodir;
my $local_confdir;
my $temp;
my $download_all;
my $is_link;
my $is_stop;
my $is_start;
my $download_record_log;
my $backup_dir;
my $baseapp_dir;
my $update_local_prodir;
my $update_local_confdir;
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
        $table_string        = $param->{table_string};
        @string              = split( /,/, $table_string );
        $softdir             = $param->{softdir};
        $configuredir        = $param->{configuredir};
        $local_prodir        = $param->{local_prodir};
        $local_confdir       = $param->{local_confdir};
        $backup_dir          = $param->{backup_dir};
        $baseapp_dir         = $param->{baseapp_dir};
        $temp                = $param->{temp};
        $is_link             = $param->{is_link};
        $is_stop             = $param->{is_stop};
        $is_start            = $param->{is_start};
        $download_record_log = $param->{download_record_log};
        $download_all        = $param->{download_all};
        $update_local_prodir        = $param->{update_local_prodir};
        $update_local_confdir        = $param->{update_local_confdir};
    }
);

my $datetime = run "date '+%Y%m%d_%H%M%S'";

desc "加载数据库数据";
task init => sub {
    my $k = $_[0];
    Rex::Logger::info("开始从数据库初始化数据...");
    my $config = run_task "Deploy:Db:getconfig", params => { app_key => "$k" };
    if ( $config == 0 ) {
        Rex::Logger::info( "($k)--系统应用关键字不能为空", "error" );
        exit;
    }
    elsif ( $config == 2 ) {
        Rex::Logger::info(
"($k)--该关键字匹配到多个应用系统,请到数据库配置中确认配置是否OK.",
            "error"
        );
        exit;
    }
    elsif ( $config == 1 ) {
        Rex::Logger::info(
"($k)--该关键字没有匹配到应用系统,请到数据库配置中确认配置是否OK.",
            "error"
        );
        exit;
    }
    Rex::Logger::info(
"($k)--获取到该服务器: id:$config->{'id'},app_key:$config->{'app_key'},其他信息请见数据库."
    );
    Rex::Logger::info("($k)--数据库初始化数据完成...");
    Rex::Logger::info(
"($k)--Get配置-1:id:$config->{'id'},app_key:$config->{'app_key'},pro_init:$config->{'pro_init'},pro_type:$config->{'pro_type'},network_ip:$config->{'network_ip'}"
    );
    Rex::Logger::info(
"($k)--Get配置-2:pro_key:$config->{'pro_key'},pro_dir:$config->{'pro_dir'},config_dir:$config->{'config_dir'},server_name:$config->{'server_name'}"
    );
    Rex::Logger::info(
"##############[$config->{'server_name'}]###############"
    );

    #判断关键字段是否为空
    for my $name (@string) {
        if ( $config->{$name} eq "" ) {
            Rex::Logger::info(
                "($k)--关键字段:$name为空,请检查数据库配置.",
                "warn" );
            exit;
        }
    }
    return $config;

};

desc "获远程服务器信息";
task prepare => sub {
    my $k          = $_[0];
    my $network_ip = $_[1];
    my $pro_init   = $_[2];
    my $pro_key    = $_[3];
    my $pro_dir    = $_[4];
    my $config_dir = $_[5];

    #获取远程服务器信息
    Rex::Logger::info(
        "($k)--第一次连接,获取远程服务器基本信息.");
    my $FistSerInfo = run_task "Deploy:FirstConnect:getserinfo",
      on     => $network_ip,
      params => {
        pro_init   => "$pro_init",
        pro_key    => "$pro_key",
        pro_dir    => "$pro_dir",
        config_dir => "$config_dir"
      };

    #启动文件判断
    if ( $FistSerInfo->{'pro_init'} == 0 ) {
        Rex::Logger::info( "($k)--系统启动文件不存在:$pro_init",
            "error" );

        #exit;
    }
    else {
        Rex::Logger::info("($k)--启动文件: $pro_init:存在OK");
    }

    #工程目录和配置目录判断
    if ( $FistSerInfo->{'pro_dir'} == 0 ) {
        Rex::Logger::info( "($k)--系统工程目录不存在:$pro_dir",
            "error" );
    }
    else {
        Rex::Logger::info("($k)--工程目录: $pro_dir:存在OK");
    }
    if ( $FistSerInfo->{'config_dir'} == 0 ) {
        Rex::Logger::info( "($k)--系统配置目录不存在:$config_dir",
            "error" );
    }
    else {
        Rex::Logger::info("($k)--配置目录: $config_dir:存在OK");
    }

    #进程判断
    if ( $FistSerInfo->{'ps_num'} == 0 ) {
        Rex::Logger::info( "($k)--系统应用进程不存在", "warn" );
    }
    else {
        Rex::Logger::info("($k)--系统进程存在:$FistSerInfo->{'ps_num'}.");
    }
    Rex::Logger::info("($k)--第一次连接,初始化服务器信息完成.");

    #say Dumper($FistSerInfo);
    return $FistSerInfo;
};

desc "程序&配置传输 本地->远程";
task upload => sub {
    my $self         = shift;
    my $dir1         = $self->{dir1};
    my $dir2         = $self->{dir2};
    my $dir3         = $self->{dir3};
    my $dir4         = $self->{dir4};
    my $is_deloy_dir = $self->{is_deloy_dir};
    my $k            = $self->{k};
    my $network_ip   = Rex::get_current_connection()->{server};
    $dir1 =~ s/\/$//;
    $dir2 =~ s/\/$//;
    $dir3 =~ s/\/$//;
    $dir4 =~ s/\/$//;
    $dir1 = $dir1 . "/";
    $dir3 = $dir3 . "/";

    #   rsync开启sudo时需要开启权限
    #    if ( $rsync_sudo eq "off"){
    my $rnd_dir = "/data/tmp/" . get_random( 8, 'a' .. 'z' ) . "_rex_$datetime";
    if ( !is_dir("$rnd_dir") ) {
        mkdir("$rnd_dir");
        Rex::Logger::info("($k)--创建临时目录$rnd_dir.");
    }
    chmod 777, "$rnd_dir";
    my $remote_dir       = $rnd_dir . "/program";
    my $remote_configdir = $rnd_dir . "/configdir";
    mkdir "$remote_dir",       mode => 1777;
    mkdir "$remote_configdir", mode => 1777;
    Rex::Logger::info(
"($k)--创建临时程序目录$remote_dir 和配置目录$remote_configdir."
    );

    if ( $is_deloy_dir == 1 ) {
        Rex::Logger::info("($k)--开始传输程序目录.");
        Rex::Logger::info("syncing $dir1 => $dir2");
        # sync $dir1, $remote_dir,
        #   {
        #     exclude => [ "*.sw*", "*.tmp", "*.log", "*nohup.out", "*.svn*" ],
        #     parameters => '--backup --delete --progress',
        #   };
        run_task "Common:Use:upload",
        on     => "$network_ip",
        params => { dir1 => "$dir1", dir2 => "$remote_dir" };

        mv( $remote_dir, $dir2 );
        Rex::Logger::info("($k)--传输程序目录完成: mv( $remote_dir, $dir2 ) ");
    }
    elsif ( $is_deloy_dir == 2 ) {

        Rex::Logger::info("($k)--开始传输程序和配置目录.");
        Rex::Logger::info("syncing $dir1 => $dir2 &  syncing $dir3 => $dir4");

        # sync $dir1, $remote_dir, {

        #     #   sync_up $dir1,$dir2, {
        #     exclude => [ "*.sw*", "*.tmp", "*.log", "*nohup.out", "*.svn*" ],
        #     parameters => '--backup --delete --progress',
        # };
        run_task "Common:Use:upload",
        on     => "$network_ip",
        params => { dir1 => "$dir1", dir2 => "$dir2" };

        # sync $dir3, $remote_configdir,
        #   {
        #     exclude => [ "*.sw*", "*.tmp", "*.log", "*nohup.out", "*.svn*" ],
        #     parameters => '--backup --delete --progress',
        #   };
        run_task "Common:Use:upload",
        on     => "$network_ip",
        params => { dir1 => "$dir3", dir2 => "$remote_configdir" };

        mv( "$remote_dir",       "$dir2" );
        mv( "$remote_configdir", "$dir4" );
        Rex::Logger::info("($k)--传输程序和配置目录完成. mv $remote_dir $dir2; mv $remote_configdir $dir4 ");
    }
    else {
        Rex::Logger::info(
"上传目录的数量不正确,一般上传目录分为:程序目录和配置目录或者程序目录.",
            "error"
        );
    }
    if ( is_dir("$rnd_dir") ) {
        rmdir("$rnd_dir");
        Rex::Logger::info("($k)--删除临时目录$rnd_dir.");
    }

};

desc "程序&配置传输 远程->本地";
task download => sub {
    my $self = shift;
    my $dir1 = $self->{dir1};
    my $dir2 = $self->{dir2};
    my $dir3 = $self->{dir3};
    my $dir4 = $self->{dir4};
    my $k    = $self->{k};
    $dir1 =~ s/\/$//;
    $dir2 =~ s/\/$//;
    $dir3 =~ s/\/$//;
    $dir4 =~ s/\/$//;
    $dir1 = $dir1 . "/";
    $dir3 = $dir3 . "/";

    if ( !is_dir("$dir1") ) {
        Rex::Logger::info( "($k)--远程程序目录:$dir1不存在", "error" );
        exit;
    }
    if ( !is_dir("$dir3") ) {
        Rex::Logger::info( "($k)--本地配置目录:$dir3 不存在",
            "error" );
        exit;
    }
    Rex::Logger::info("($k)--syncing $dir1 => $dir2");
    sync $dir1, $dir2,
      {
        download   => 1,
        exclude    => [ "*.sw*", "*.tmp", "*.log", "*nohup.out", "*.svn*" ],
        parameters => '--delete --progress',
      };
    Rex::Logger::info("($k)--syncing $dir3 => $dir4");
    sync $dir3, $dir4,
      {
        download   => 1,
        exclude    => [ "*.sw*", "*.tmp", "*.log", "*nohup.out", "*.svn*" ],
        parameters => '--delete --progress',
      };

};

desc "程序&配置发布-> 本地->远程";
task uploading => sub {
    my $k                 = $_[0];
    my $local_name        = $_[1];
    my $remotedir         = $_[2];
    my $network_ip        = $_[3];
    my $app_key           = $_[5];
    my $is_deloy_dir      = $_[6];
    my $pro_dir           = $_[7];
    my $config_dir        = $_[8];
    my $remote_confir_dir = $_[4];
    our $myAppStatus = $_[9];

    #my  $datetime = run "date '+%Y%m%d_%H%M%S'" ;
    $remotedir =~ s/\/$//;
    $remotedir = "${remotedir}_${datetime}";
    our $localdir = "$softdir/$local_name/";
    my $localdir_app = "${temp}${local_name}/${app_key}";
    $remote_confir_dir =~ s/\/$//;
    $remote_confir_dir = "${remote_confir_dir}_${datetime}";
    my $local_config_dir = "$configuredir$local_name/$app_key/";

    #my $local_config_dir_app = "${configuredir}${local_name}s/${app_key}/";
    LOCAL {
        if ( !is_dir("$localdir") ) {
            Rex::Logger::info( "($k)--本地程序目录:$localdir 不存在",
                "error" );
            exit;
        }
        if ( !is_dir("$local_config_dir") ) {
            Rex::Logger::info(
                "($k)--本地配置目录:$local_config_dir 不存在",
                "error" );
            exit;
        }
    };

#根据is_deloy_dir的值,判断是否需要再次将本地配置文件,再次合并到本地工程目录里面。
    LOCAL {
        my $current_server = connection->server;
        if ( $is_deloy_dir == 1 ) {

#say "pro_dir=$pro_dir config_dir=$config_dir localdir=$localdir local_config_dir=$local_config_dir";
            $pro_dir =~ s/\/$//g;
            $config_dir =~ s/\/$//g;
            $config_dir =~ s/$pro_dir//g;
            $localdir =~ s/\/$//;
            $local_config_dir =~ s/\/$//;

#多进程发布目录改进
#example:/data/RexDeploy/softdir/messagePush => /data/RexDeploy/softdir/messagePushs/{messagePushs1/2/3/...}
            if ( is_dir("$localdir_app") ) {
                rmdir("$localdir_app");
            }
            mkdir("$localdir_app");
            Rex::Logger::info(
                "($k)--同步复制本地工程:$localdir/ => $localdir_app");
            cp( "${localdir}/*", "$localdir_app" );
            our $localdir = $localdir_app;

            Rex::Logger::info(
"($k)--合并配置文件到工程[$current_server]: rsync -ar  $local_config_dir/  $localdir$config_dir "
            );

            #run "rm -rf $localdir/$config_dir";
            run "rsync -ar  $local_config_dir/  $localdir$config_dir";

            #say "rm -rf $localdir/$config_dir";
            #say "rsync -ar  $local_config_dir/  $localdir$config_dir";
            #exit;
        }
    };

    #   Rex::Logger::info("($k)--开始传输程序和配置目录." );
    run_task "Deploy:Core:upload",
      on     => "$network_ip",
      params => {
        dir1         => "$localdir",
        dir2         => "$remotedir",
        dir3         => "$local_config_dir",
        dir4         => "$remote_confir_dir",
        is_deloy_dir => "$is_deloy_dir",
        k            => "$k"
      };
    Deploy::Db::updateTimes( $myAppStatus, "rsync_endtime" );

    #   Rex::Logger::info("($k)--传输程序和配置目录完成.");
    my $dir;
    $dir->{'remote_prodir'} = $remotedir;
    if ( $is_deloy_dir == 1 ) {
        $dir->{'remote_configdir'} = "null";
    }
    else {
        $dir->{'remote_configdir'} = $remote_confir_dir;
    }
    $dir->{'localdir'}         = $localdir;
    $dir->{'local_config_dir'} = $local_config_dir;
    return $dir;
};

desc "程序&配置下载-> 远程->本地";
task downloading => sub {
    our $k = $_[0];
    my $local_name        = $_[1];
    my $remotedir         = $_[2];
    my $network_ip        = $_[3];
    my $remote_confir_dir = $_[4];
    my $config            = $_[5];
    my $update            = $_[6];
    my $relocal_name            = $_[7];
    my $query_prodir_key            = $_[8];
    my $senv            = $_[9];
    my $type            = $_[10];
    my $usetype            = $_[11];
    my $datetime          = run "date '+%Y%m%d_%H%M%S'";
    my @query_prodir_key = @$query_prodir_key  ;
    my @pro_key_array;
    my $start_time ;
    my $end_time ;
    for my $pro (@query_prodir_key){
        my $proapp_key = $pro->{"app_key"};
        push @pro_key_array,$proapp_key;
    }
    my $srck = $local_name;
    $local_name = $k;
    if ( $remotedir =~ m/\/$/ ) {
        $remotedir = "${remotedir}";
    }
    else {
        $remotedir = "${remotedir}/";
    }
    my $localdir = "$local_prodir$local_name/";
    if ( $remote_confir_dir =~ m/\/$/ ) {
        $remote_confir_dir = "${remote_confir_dir}";
    }
    else {
        $remote_confir_dir = "${remote_confir_dir}/";
    }
    my $local_config_dir = "$local_confdir$local_name/";

#say $remotedir . " || $localdir". " || $remote_confir_dir" . " || $local_config_dir"  ;
#exit

    if ( "$usetype" eq "pro" ) {
        if (  is_dir("$localdir") ) {
            Rex::Logger::info("($k)--删除原有本地程序目录: $localdir");
            rmdir("$localdir");
        }
    }elsif( "$usetype" eq "conf" ){
        if (  is_dir("$local_config_dir") ) {
            Rex::Logger::info("($k)--删除原有本地配置目录: $local_config_dir");
            rmdir("$local_config_dir");
        }
    }else{

        if (  is_dir("$localdir") ) {
            Rex::Logger::info("($k)--删除原有本地程序目录: $localdir");
            rmdir("$localdir");
        }
        if ( "$senv" eq "" ) {
            if (  is_dir("$local_config_dir") ) {
                Rex::Logger::info("($k)--删除原有本地配置目录: $local_config_dir");
                rmdir("$local_config_dir");
            }
        }    

    }




    if ( !is_dir($localdir) ) {
        run "mkdir -p $localdir";
    }
    if ( !is_dir($local_config_dir) ) {
        run "mkdir -p $local_config_dir";
    } 

    if ( $download_all eq "true" ) {

        #启动脚本
        my $local_pro_init = $localdir . "pro_init";
        mkdir($local_pro_init);

        #容器目录
        my $local_container_dir = $localdir . "container_dir";
        mkdir($local_container_dir);
        my $pro_init      = $config->{'pro_init'};
        my $container_dir = $config->{'container_dir'};
        if ( $pro_init ne "" and $pro_init ne "Null" ) {
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir1 => "$pro_init", dir2 => "$local_pro_init" };
            my $size3 = run "du -sh $local_pro_init |awk '{print \$1}'";
            Rex::Logger::info(
                "($k)--$pro_init => $local_pro_init:$size3 完成.");
        }
        if ( $container_dir ne "" and $pro_init ne "Null" ) {
            run_task "Common:Use:download",
              on => "$network_ip",
              params =>
              { dir1 => "$container_dir", dir2 => "$local_container_dir" };
            my $size4 = run "du -sh $local_container_dir |awk '{print \$1}'";
            Rex::Logger::info(
                "($k)--$container_dir => $local_container_dir:$size4 完成.");
        }

    }    #download_all-end

    Rex::Logger::info("($k)--开始传输程序和配置目录到本地.");
    $start_time = time();

# run_task "Deploy:Core:download",on=>"$network_ip",params => {dir2=>"$localdir",dir1=>"$remotedir",dir4=>"$local_config_dir",dir3=>"$remote_confir_dir",k=>"$k"};
    if ( "$senv" ne "") {
        if ( $type eq "pro"  ) {
            Rex::Logger::info("($senv:$srck)--开始传输 ##### $senv 环境 ###### 程序目录到本地.");
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir2 => "$localdir", dir1 => "$remotedir" };
        }elsif($type eq "conf" ){
            Rex::Logger::info("($senv:$srck)--开始传输 ##### $senv 环境 ###### 配置目录到本地.");
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir2 => "$local_config_dir", dir1 => "$remote_confir_dir" };    
        }elsif($type eq "all"){
            Rex::Logger::info("($senv:$srck)--开始传输 ##### $senv 环境 ###### 程序和配置目录到本地.");
            run_task "Common:Use:download",
                  on     => "$network_ip",
                  params => { dir2 => "$localdir", dir1 => "$remotedir" };
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir2 => "$local_config_dir", dir1 => "$remote_confir_dir" };  
        }else{
            Rex::Logger::info("($senv:$srck)--开始传输 ##### $senv 环境 ###### 程序目录到本地.");
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir2 => "$localdir", dir1 => "$remotedir" };
        }


    }else{
   

        if ( $usetype eq "pro"  ) {
            run_task "Common:Use:download",
                  on     => "$network_ip",
                  params => { dir2 => "$localdir", dir1 => "$remotedir" };
        }elsif($usetype  eq "conf" ){
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir2 => "$local_config_dir", dir1 => "$remote_confir_dir" };   
        }elsif($usetype  eq "all"){
            run_task "Common:Use:download",
                  on     => "$network_ip",
                  params => { dir2 => "$localdir", dir1 => "$remotedir" };
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir2 => "$local_config_dir", dir1 => "$remote_confir_dir" }; 
        }else{
            run_task "Common:Use:download",
                  on     => "$network_ip",
                  params => { dir2 => "$localdir", dir1 => "$remotedir" };
            run_task "Common:Use:download",
              on     => "$network_ip",
              params => { dir2 => "$local_config_dir", dir1 => "$remote_confir_dir" };  
        }




    }


    my $size1 = run "du -sh $localdir |awk '{print \$1}'";
    my $size2 = run "du -sh $local_config_dir |awk '{print \$1}'";
    Rex::Logger::info(
"($k)--传输程序和配置目录到本地完成:$localdir:$size1 || $local_config_dir:$size2"
    );
    if ( "$update" eq "1") {
        Rex::Logger::info("");
        Rex::Logger::info("($k)--开始拷贝本地程序和配置目录到更新目录.");
        $update_local_prodir =~ s/\/$//;
        $update_local_confdir =~ s/\/$//;
        my $localdir_remote = $localdir ;
        my $local_config_dir_remote = $local_config_dir ;
        $localdir_remote =~ s/\/$//; 
        $local_config_dir_remote =~ s/\/$//; 
        # if ( ! is_dir($update_local_prodir)) {
        #     mkdir("$update_local_prodir");
        # }
        # if ( ! is_dir($update_local_confdir)) {
        #     mkdir("$update_local_confdir");
        # }
        eval {

            if(grep /^$local_name$/, @pro_key_array ){  
                my $update_pro_dir = $update_local_prodir."/".$relocal_name ;
                if ( is_dir("$update_pro_dir") ) {
                    rmdir("$update_pro_dir");
                    Rex::Logger::info("删除更新程序目录完成: rmdir $update_pro_dir.");
                }
                cp("$localdir_remote", "$update_pro_dir");         
                Rex::Logger::info("($k)--拷贝本地程序到更新目录完成  $localdir_remote => $update_pro_dir.");             
            }
            my $update_local_confdir = $update_local_confdir."/".$relocal_name;
            if ( ! is_dir( $update_local_confdir) ) {
                mkdir($update_local_confdir);
            }
            cp("$local_config_dir_remote", "$update_local_confdir");
            Rex::Logger::info("($k)--拷贝本地配置到更新目录完成  $local_config_dir_remote => $update_local_confdir.");
        };
        if ($@) {
        Rex::Logger::info("($k)--拷贝本地程序和配置目录到本地更新目录异常:$@","error");
        }
        Rex::Logger::info("($k)--拷贝本地程序和配置目录到本地更新目录完成"); 

    }
    $end_time = time();
    my $take = $end_time - $start_time;
    my $standtime = run "date '+%Y-%m-%d %H:%M:%S'";
    run
"echo '['$standtime'] 下载$k: $remotedir => $localdir $size1  花费时间:$take秒' >> $download_record_log";
    run
"echo '['$standtime'] 下载$k: $remote_confir_dir => $local_config_dir $size2 花费时间:$take秒' >> $download_record_log";
    Rex::Logger::info(
        "($k)--更新下载记录到日志:$download_record_log完成.");
};

desc "更改软链接,重启应用";
task linkrestart => sub {
    my $self             = shift;
    my $k                = $self->{k};
    my $config           = $self->{config};
    my $FistSerInfo      = $self->{FistSerInfo};
    my $dir              = $self->{dir};
    my $myAppStatus      = $self->{myAppStatus};
    my $network_ip       = $config->{network_ip};
    my $ps_num           = $FistSerInfo->{'ps_num'};
    my $pro_key          = $config->{pro_key};
    my $pro_init         = $config->{pro_init};
    my $remote_prodir    = $dir->{remote_prodir};
    my $remote_configdir = $dir->{remote_configdir};
    my $pro_dir          = $config->{pro_dir};
    my $config_dir       = $config->{config_dir};
    my $is_deloy_dir     = $config->{is_deloy_dir};
    my $localdir         = $dir->{localdir};
    my $local_config_dir = $dir->{local_config_dir};
    our $backupdir_same_level = $config->{backupdir_same_level};
    our $deploydir_same_level = $config->{deploydir_same_level};

    #去掉软链接最后的/
    $pro_dir =~ s/\/$//;
    $config_dir =~ s/\/$//;
    $local_config_dir =~ s/\/$//;

    #特殊应用处理
    run_task "Deploy:other:expother",
      on     => "$network_ip",
      params => {
        k                => "$k",
        remote_prodir    => "$remote_prodir",
        remote_configdir => "$remote_configdir",
        pro_dir          => "$pro_dir",
        config_dir       => "$config_dir",
        localdir         => "$localdir",
        local_config_dir => "$local_config_dir"
      };

    #获取更换软链接的状态,目前只支持1个和2个目录的同步
    if ( $is_deloy_dir == 1 ) {
        my $pro_desc_be = run
"ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'";
        if ( !is_dir($pro_dir) ) {
            Rex::Logger::info("($k)--: $pro_dir目录不存在");
        }
        else {
            my $link_status = run "ls $pro_dir -ld |grep '^l' |wc -l";
            if ( $link_status == 0 ) {
                my $pre_des_before = $pro_dir;
                Deploy::Db::updateTimes( $myAppStatus, "pre_des_real_before",
                    $pre_des_before );
                Rex::Logger::info(
"($k)--发布前详情(无软链接,存在目录):$pro_dir --> only"
                );
                deal_webapp( $k, $pro_dir, $myAppStatus,
                    $backupdir_same_level );
            }
            else {
                my $pre_des_before = run
"ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'";
                Deploy::Db::updateTimes( $myAppStatus, "pre_des_real_before",
                    $pre_des_before );
                Rex::Logger::info(
                    "($k)--发布前软链接详情: $pro_desc_be --> only");
                deal_webapp( $k, $pro_dir, $myAppStatus,
                    $backupdir_same_level );
            }
        }

    }
    else {
        if ( !is_dir($pro_dir) ) {
            Rex::Logger::info("($k)-- $pro_dir目录不存在");
        }
        if ( !is_dir($config_dir) ) {
            Rex::Logger::info("($k)--: $config_dir目录不存在");
        }
        my $pro_desc_be = run
"ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'";
        my $conf_desc_be = run
"ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'";
        my $pro_desc_be_before = run
"ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'";
        my $conf_desc_be_before = run
"ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'";
        if ( $pro_desc_be_before == "" ) {
            my $pro_desc_be =
              "mv ${pro_dir} --> ${pro_dir}_nolinkbak_$datetime ";
            my $pro_desc_be_before = "${pro_dir}_nolinkbak_$datetime";
        }
        if ( $conf_desc_be_before == "" ) {
            my $conf_desc_be =
              "mv $config_dir --> ${config_dir}_nolinkbak_${datetime}";
            my $conf_desc_be_before = "${config_dir}_nolinkbak_${datetime}";

        }
        Deploy::Db::updateTimes(
            $myAppStatus,        "pre_des_before_before",
            $pro_desc_be_before, $conf_desc_be_before
        );
        Rex::Logger::info(
            "($k)--发布前软链接详情: $pro_desc_be || $conf_desc_be");
    }

    #重启,更改软链接
    if ( $ps_num == 0 ) {

        link_start(
            $k,                $pro_dir,       $config_dir,
            $remote_configdir, $remote_prodir, $pro_key,
            $pro_init,         $is_deloy_dir,  $myAppStatus,$network_ip
        );

    }    #ps_num结束
    else {
        Rex::Logger::info(
"($k)--进程数为$ps_num,开始关闭应用->更改程序配置软链接->启动."
        );
        # run "nohup /bin/bash $pro_init stop > /dev/null & ";
        service "newservice",
           before_action=> "source /etc/profile",
           ensure  => "stopped",
           start   => "$pro_init start",
           stop    => "$pro_init stop",
           status  => "ps -efww | grep $pro_key",
           restart => "$pro_init stop && $pro_init start",
           reload  => "$pro_init stop && $pro_init start";

        run "sleep 2";
        my $ps_stop_num =
          run "ps aux |grep -v grep |grep -v sudo |grep '$pro_key' |wc -l";
        if ( $ps_stop_num == 0 ) {
            Rex::Logger::info("($k)--进程数为$ps_stop_num,关闭成功.");

            link_start(
                $k,                $pro_dir,       $config_dir,
                $remote_configdir, $remote_prodir, $pro_key,
                $pro_init,         $is_deloy_dir,  $myAppStatus,$network_ip
            );

        }
        else {
            Rex::Logger::info(
                "($k)--进程数为$ps_stop_num,关闭失败->kill应用.",
                "warn" );

            #my @apps = grep { $_->{"command"} =~ m/$pro_key/ } ps();
            my $ppids = run
              "ps aux |grep '$pro_key' |grep -v grep |awk '{print \$2}'|xargs";
            my @apps = split( '/ /', $ppids );
            Rex::Logger::info(
"($k)--进程数为$ps_stop_num,过滤进程key:$pro_key,进程ID为:$ppids."
            );
            for my $pid (@apps) {
                run "kill -9 $pid";
            }
            my $ps_stop_num2 =
              run "ps aux |grep -v grep |grep -v sudo |grep '$pro_key' |wc -l";
            if ( $ps_stop_num2 == 0 ) {
                Rex::Logger::info("($k)--kill应用-成功.");
            }
            else {
                Rex::Logger::info(
                    "($k)--kill应用-失败->略过此系统的发布.",
                    "error" );
                exit;
            }

            #更改软链接->重启-start
            link_start(
                $k,                $pro_dir,       $config_dir,
                $remote_configdir, $remote_prodir, $pro_key,
                $pro_init,         $is_deloy_dir,  $myAppStatus,$network_ip
            );

            #更改软链接->重启-end
        }

    } #ps_num else结束
      #更改软链接->重启-start,更改前程序已经处于停止的状态.

    sub link_start {
        my (
            $k,                $pro_dir,       $config_dir,
            $remote_configdir, $remote_prodir, $pro_key,
            $pro_init,         $is_deloy_dir,  $myAppStatus,
            $network_ip
        ) = @_;
        # my $args = Dumper(@_);
        # Rex::Logger::info("更改软链接->重启-start,参数: $args");
        $remote_prodir =~ s/\/$//;
        if ( $is_deloy_dir == 1 ) {
            Rex::Logger::info(
                "($k)--进程数为0,开始更改程序软链接.");

            #start-program
            my $last_remote_name =
              run "echo $remote_prodir |awk -F'/' '{print \$NF}' ";
            my $last_remote_dir;
            if ( $deploydir_same_level == 0 ) {
                Rex::Logger::info("($k)--deploydir_same_level=0,待发布同级状态为假,待发布目录不能和发布目录同层级.");
                run "mv $remote_prodir $baseapp_dir ";
                Rex::Logger::info("mv $remote_prodir $baseapp_dir ");
                my $last_remote_dir = "$baseapp_dir/$last_remote_name";
                if ( !is_dir($pro_dir) ) {
                    run "ln -s $last_remote_dir $pro_dir";
                    run "chown www.www   $last_remote_dir $pro_dir -R";
                }
                else {
                    Rex::Logger::info(
"($k)--移除并备份工程失败,跳过重建工程软链接,发布前目录依旧存在",
                        "error"
                    );
                }
            }
            else {
                if ( !is_dir($pro_dir) ) {
                    run "ln -s $remote_prodir $pro_dir";
                    run "chown www.www   $remote_prodir $pro_dir -R";
                }
                else {
                    Rex::Logger::info(
"($k)--移除并备份工程失败,跳过重建工程软链接,发布前目录依旧存在",
                        "error"
                    );
                }
            }

            #end-program
            my $pro_desc = run
              "ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'";
            my $pre_des_after = run
"ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'";
            my $size = run "du -sh $pre_des_after |xargs ";
            Deploy::Db::updateTimes( $myAppStatus, "pre_des_after",
                "$pre_des_after", "$size" );
            Rex::Logger::info(
                "($k)--进程数为0,发布后软链接详情: $pro_desc ");
            Rex::Logger::info(
                "($k)--进程数为0,重建软链接,&更改权限完成.");
            if ( !is_dir($pro_dir) ) {
                Rex::Logger::info(
                    "($k)--进程数为0,修改软链接失败:$pro_dir.",
                    'error' );
            }
        }
        elsif ( $is_deloy_dir == 2 ) {    #else开始

            #$pro_dir--start
            if ( !is_dir($pro_dir) ) {
                run "ln -s $remote_prodir $pro_dir";
            }
            else {
                my $link_status = run "ls $pro_dir -ld |grep '^l' |wc -l";
                if ( $link_status == 0 ) {
                    run
"mv $pro_dir ${pro_dir}_nolinkbak_$datetime ;ln -s $remote_prodir $pro_dir";
                    Rex::Logger::info(
"($k)--程序目录不为软链接: mv $pro_dir ${pro_dir}_nolinkbak_$datetime; ln -s $remote_prodir $pro_dir"
                    );
                }
                else {
                    run "unlink $pro_dir;ln -s $remote_prodir $pro_dir";
                }
            }

            #$pro_dir--end

            #$config_dir-start
            if ( !is_dir($config_dir) ) {
                run "ln -s $remote_configdir $config_dir";
            }
            else {
                my $linkc_status = run "ls $config_dir -ld |grep '^l' |wc -l";
                if ( $linkc_status == 0 ) {
                    run
"mv $config_dir ${config_dir}_nolinkbak_$datetime;ln -s $remote_configdir $config_dir ;chown www.www $remote_configdir $config_dir $remote_prodir $pro_dir -R ";
                    Rex::Logger::info(
"($k)--配置目录不为软链接: mv $config_dir  ${config_dir}_nolinkbak_$datetime"
                    );
                }
                else {
                    run
                      "unlink $config_dir;ln -s $remote_configdir $config_dir";
                    run
"chown www.www $remote_configdir $config_dir $remote_prodir $pro_dir -R ;";
                }
            }

            #$config_dir-end
            my $pro_desc = run
              "ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'";
            my $conf_desc = run
"ls $config_dir -ld |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'";
            my $pro_desc_after = run
"ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'";
            my $conf_desc_after = run
"ls $config_dir -ld |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'";
            my $size = run "du -sh $pro_desc_after $conf_desc_after |xargs ";
            Deploy::Db::updateTimes( $myAppStatus, "pre_des_after_after",
                "$pro_desc_after", "$conf_desc_after", "$size" );
            Rex::Logger::info(
"($k)--进程数为0,发布后软链接详情: $pro_desc || $conf_desc"
            );
            Rex::Logger::info(
"($k)--进程数为0,更改程序&配置软链接&更改权限完成."
            );

            if ( !is_dir($pro_dir) ) {
                Rex::Logger::info(
                    "($k)--进程数为0,修改软链接失败:$pro_dir.",
                    'error' );
            }
            if ( !is_dir($config_dir) ) {
                Rex::Logger::info(
                    "($k)--进程数为0,修改软链接失败:$config_dir.",
                    'error' );
            }
        }    #else结束
        Rex::Logger::info("($k)--进程数为0,开始启动应用.");
        my $servername = $pro_init;
        $servername =~ s /\/etc\/init.d\///g;
        Deploy::Db::updateTimes( $myAppStatus, "app_start_time" );
        my %service;
        $service->{'action'}   = "start";
        $service->{'pro_key'}  = "$pro_key";
        $service->{'pro_init'} = "$pro_init";
        run_task "Deploy:FirstConnect:services",
          on=>"$network_ip",
          params => { config => $service };
        my $ps_start_num =
          run "ps aux |grep -v grep |grep -v sudo |grep '$pro_key' |wc -l";
        Deploy::Db::updateTimes( $myAppStatus, "deploy_end", "$ps_start_num" );

        if ( $ps_start_num == 0 ) {
            Rex::Logger::info(
                "($k)--进程数为0,启动失败.($pro_init start)", "error" );
        }
        else {
            Rex::Logger::info("($k)--进程数为$ps_start_num,启动成功.");
        }
        Deploy::Db::updateTimes( $myAppStatus, "deploy_finish", "$k" );
    }

    #备份原有工程
    sub deal_webapp {
        my ( $k, $pro_dir, $myAppStatus, $backupdir_same_level ) = @_;
        $pro_dir =~ s/\/$//;
        my $root_name = run "echo $pro_dir |awk -F'/' '{print \$NF}' ";
        if ( $backupdir_same_level == 0 ) {
            if ( is_dir($pro_dir) ) {
                my $backup = "$backup_dir/$root_name/$datetime";
                if ( !is_dir($backup) ) {
                    run "mkdir $backup -p";
                }
                my $link_status = run "ls $pro_dir -ld |grep '^l' |wc -l";
                if ( $link_status == 0 ) {
                    run "mv $pro_dir   $backup";
                    my $last_name =
                      run "echo $pro_dir |awk -F'/' '{print \$NF}' ";
                    my $pre_des_before = "$backup/$last_name";
                    Deploy::Db::updateTimes( $myAppStatus, "pre_des_before",
                        $pre_des_before );
                    Rex::Logger::info(
                        "($k)--移除并备份工程: mv $pro_dir $backup");
                }
                else {
                    my $pro_dir_real = run
"ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'";
                    $pro_dir_real =~ s/\/$//;
                    my $last_name =
                      run "echo $pro_dir_real |awk -F'/' '{print \$NF}' ";
                    my $pre_des_before = "$backup/$last_name";
                    run "unlink $pro_dir; mv $pro_dir_real $backup";
                    Deploy::Db::updateTimes( $myAppStatus, "pre_des_before",
                        $pre_des_before );
                    Rex::Logger::info(
                        "($k)--移除并备份工程: mv $pro_dir_real $backup"
                    );
                }

            }
        }
        else {
            if ( is_dir($pro_dir) ) {
                my $link_status = run "ls $pro_dir -ld |grep '^l' |wc -l";
                if ( $link_status == 0 ) {
                    my $pre_des_before = "${pro_dir}_bak_$datetime";
                    run "mv $pro_dir $pre_des_before";
                    Deploy::Db::updateTimes( $myAppStatus, "pre_des_before",
                        $pre_des_before );
                    Rex::Logger::info(
                        "($k)--备份工程: mv $pro_dir $pre_des_before");
                }
                else {
                    my $pro_dir_real = run
"ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'";
                    $pro_dir_real =~ s/\/$//;
                    my $pre_des_before = "${pro_dir}_bak_$datetime";
                    run "unlink $pro_dir; mv $pro_dir_real $pre_des_before";
                    Deploy::Db::updateTimes( $myAppStatus, "pre_des_before",
                        $pre_des_before );
                    Rex::Logger::info(
                        "($k)--备份工程: mv $pro_dir $pre_des_before");
                }

            }

        }

    }

};

#处理的特殊单一的应用
task "execSpecial", sub {
    my $out = shell_block template('/data/RexDeploy/scripts/speicial.sh');
    say "$out";

    #Rex::Logger::info("$out");
};

desc
"同步本地(远程download)的程序和配置=>待发布目录: rex  Deploy:Core:syncpro --k='server1 server2 ../all' [--update='1']";
task "syncpro", sub {
    my $self       = shift;
    my $k          = $self->{k};
    my $update          = $self->{update};
    my $localnames = run_task "Deploy:Db:getlocalname";
    my @base       = split( /,/, $localnames );
    my @keys;
    my @errData;
    my @errpro;
    my @errconf;
    push @errData,1;
    if ( "$update" eq "1") {
        $update_local_prodir =~ s/\/$//;
        $update_local_confdir =~ s/\/$//;
        $local_prodir = $update_local_prodir;
        $local_confdir = $update_local_confdir;
    }
    $softdir =~ s/\/$//;
    $configuredir =~ s/\/$//;
    for my $item (@base) {
        my @list       = split( / /, $item );
        my $local_name = $list[0];
        my $app_key    = $list[1];
        push @keys, $app_key;
    }
    if ( $k eq "" ) {
        Rex::Logger::info("关键字(--k='')不能为空");
        $errData[0] = 0;
    }
    my @ks = split( / /, $k );
    my %vars = map { $_ => 1 } @keys;
    my @real_keys;
    foreach my $key (@ks) {
        if ( $key ne "" ) {
            if ( exists( $vars{$key} ) ) {
                push @real_keys, $key;
            }
            else {
                if ( $key ne "all" ) {
                    $errData[0] = 0;
                    Rex::Logger::info( "关键字($key)不存在", "error" );
                }
            }
        }
    }
    for my $item (@base) {
        my @list       = split( / /, $item );
        my $local_name = $list[0];
        my $app_key    = $list[1];
        if ( grep { $app_key eq $_ } @real_keys ) {
            Rex::Logger::info(
                "开启同步($app_key)目录到待发布目录.");
            my $deploy_prodir  = "$softdir/$local_name";
            my $deploy_confdir = "$configuredir/$local_name/$app_key";
            my $down_prodir    = "$local_prodir/$app_key";
            my $down_confdir   = "$local_confdir/$app_key";
            if ( "$update" eq "1") {
                $down_prodir = "$local_prodir/$local_name";
            }

    # say "mv $down_prodir --> $deploy_prodir ;mv $down_confdir $deploy_confdir";
    # exit;
    #处理程序目录
            if ( is_dir($down_prodir) ) {
                if ( is_dir($deploy_prodir) ) {
                    eval {
                        rmdir("$deploy_prodir");
                    };
                    if ($@) {
                        $errData[0] = 0;
                        Rex::Logger::info("删除发布程序目录异常: $@","error");
                        return \@errData;
                    }
                    # rmdir($deploy_prodir);
                    Rex::Logger::info(
                        "删除发布程序目录完成: rmdir $deploy_prodir."
                    );
                }
                cp( $down_prodir, $deploy_prodir );         
                Rex::Logger::info(
                    "cp程序目录完成: cp($down_prodir,$deploy_prodir).");
            }
            else {
                $errData[0] = 0;
                push @errpro,$down_prodir;
                Rex::Logger::info(
                    "待上传程序目录不存在:  $down_prodir.", "warn" );
            }

            #处理配置目录
            if ( "$update" eq "1") {
                $down_confdir = $local_confdir."/".$local_name."/".$app_key;
            }

            if ( is_dir($down_confdir) ) {
                if ( is_dir($deploy_confdir) ) {
                    rmdir($deploy_confdir);
                    Rex::Logger::info(
                        "删除发布配置目录完成: rmdir $deploy_confdir."
                    );
                }
                if ( !is_dir("$configuredir/$local_name") ) {
                    mkdir("$configuredir/$local_name");
                }
                my $configure_group_result = run_task "Deploy:Db:configure_group", params => { app_key => "$app_key" };
                if ( $configure_group_result eq '0' ) {
                    cp( $down_confdir, $deploy_confdir ); 

                    
                    Rex::Logger::info(
                        "cp配置目录完成: cp($down_confdir,$deploy_confdir).");
                }else{
                    my @configure_group_list = split( /,/, $configure_group_result );
                    foreach my $file (@configure_group_list) {
                        my @extent_dir = split( /\//, $file);
                        my $length = @extent_dir;
                        my @last_dir = split( /$extent_dir[$length-1]/, $file );
                        my $lastdir = "$deploy_confdir/$last_dir[0]";
                        if ( !is_dir($lastdir) ) {
                            run "mkdir -p $lastdir";
                        }
                         cp("$down_confdir/$file", "$lastdir");
                    Rex::Logger::info("拷贝配置文件: copy $down_confdir/$file => $lastdir");
                    }

                }
     
                
            }
            else {
                $errData[0] = 0;
                push @errconf,$down_confdir;
                Rex::Logger::info(
                    "待上传配置目录不存在:  $down_confdir.", "error" );
            }
            Rex::Logger::info(
                "同步($app_key)目录到待发布目录完成.");

        }
    }

    if ( $k eq 'all' ) {
        Rex::Logger::info("开启同步本地所有目录到待发布目录.");
        for my $item (@base) {
            my @list           = split( / /, $item );
            my $local_name     = $list[0];
            my $app_key        = $list[1];
            my $deploy_prodir  = "$softdir/$local_name";
            my $deploy_confdir = "$configuredir/$local_name/$app_key";
            my $down_prodir    = "$local_prodir/$app_key";
            my $down_confdir   = "$local_confdir/$app_key";


    #say "mv $down_prodir --> $deploy_prodir ;mv $down_confdir $deploy_confdir";
    #处理程序目录
            if ( is_dir($down_prodir) ) {
                if ( is_dir($deploy_prodir) ) {
                    rmdir($deploy_prodir);
                    Rex::Logger::info(
                        "删除发布程序目录完成: rmdir $deploy_prodir."
                    );
                }
                mv( $down_prodir, $deploy_prodir );
                Rex::Logger::info(
                    "mv程序目录完成: mv($down_prodir,$deploy_prodir).");
            }
            else {
                $errData[0] = 0;
                push @errpro,$down_prodir;
                Rex::Logger::info(
                    "待上传程序目录不存在:  $down_prodir.", "warn" );
            }

            #处理配置目录
            if ( "$update" eq "1") {
                $down_confdir = $local_confdir."/".$local_name."/".$app_key;
            }

            if ( is_dir($down_confdir) ) {
                if ( is_dir($deploy_confdir) ) {
                    rmdir($deploy_confdir);
                    Rex::Logger::info(
                        "删除发布配置目录完成: rmdir $deploy_confdir."
                    );
                }
                if ( !is_dir("$configuredir/$local_name") ) {
                    mkdir("$configuredir/$local_name");
                }
                # mv( $down_confdir, $deploy_confdir );
                # Rex::Logger::info(
                #     "mv配置目录完成: mv($down_confdir,$deploy_confdir).");

                my $configure_group_result = run_task "Deploy:Db:configure_group", params => { app_key => "$app_key" };
                if ( $configure_group_result eq '0' ) {
                    mv( $down_confdir, $deploy_confdir );
                    Rex::Logger::info(
                        "mv配置目录完成: mv($down_confdir,$deploy_confdir).");
                }else{
                    my @configure_group_list = split( /,/, $configure_group_result );
                    foreach my $file (@configure_group_list) {
                        my @extent_dir = split( /\//, $file);
                        my $length = @extent_dir;
                        my @last_dir = split( /$extent_dir[$length-1]/, $file );
                        my $lastdir = "$deploy_confdir/$last_dir[0]";
                        if ( !is_dir($lastdir) ) {
                            run "mkdir -p $lastdir";
                        }
                         cp("$down_confdir/$file", "$lastdir");
                    Rex::Logger::info("拷贝配置文件: copy $down_confdir/$file => $lastdir");
                    }

                }


            }
            else {
                $errData[0] = 0;
                push @errconf,$down_confdir;
                Rex::Logger::info(
                    "待上传配置目录不存在:  $down_confdir.", "error" );
            }

        }
        Rex::Logger::info("同步本地所有目录到待发布目录完成.");
    }
    push @errData,join(",",@errpro);
    push @errData,join(",",@errconf);
    return \@errData;
};



desc
"校验下载目录程序和配置和待发布目录差异: rex  Deploy:Core:diff --k='server1 server2 '";
task "diff", sub {
    my $self       = shift;
    my $k          = $self->{k};
    my $w          = $self->{w};
    my $localnames = run_task "Deploy:Db:getlocalname";
    my @base       = split( /,/, $localnames );
    my @keys;
    my %hash ;
    my @errDownloadpro;
    my @errDownloadconf;
    my @errpro;
    my @errconf;
    my @proChange;
    my @enproChange;
    my @confChange;
    my @enconfChange;
    my @differcountArray;
    $hash{"code"} = 1;
    # $softdir =~ s/\/$//;
    # $configuredir =~ s/\/$//;

    Rex::Config->register_config_handler(
        "$env",
        sub {
            my ($param) = @_;
            $table_string        = $param->{table_string};
            @string              = split( /,/, $table_string );
            $softdir             = $param->{softdir};
            $configuredir        = $param->{configuredir};
            $local_prodir        = $param->{local_prodir};
            $local_confdir       = $param->{local_confdir};
            $backup_dir          = $param->{backup_dir};
            $baseapp_dir         = $param->{baseapp_dir};
            $temp                = $param->{temp};
            $is_link             = $param->{is_link};
            $is_stop             = $param->{is_stop};
            $is_start            = $param->{is_start};
            $download_record_log = $param->{download_record_log};
            $download_all        = $param->{download_all};
            $update_local_prodir        = $param->{update_local_prodir};
            $update_local_confdir        = $param->{update_local_confdir};
        }
    );

    for my $item (@base) {
        my @list       = split( / /, $item );
        my $local_name = $list[0];
        my $app_key    = $list[1];
        push @keys, $app_key;
    }
    if ( $k eq "" ) {
        $hash{"code"} = 0;
        $hash{"msg"} = "关键字(--k='')不能为空";
        Rex::Logger::info("关键字(--k='')不能为空");
    }
    my @ks = split( / /, $k );
    my %vars = map { $_ => 1 } @keys;
    my @real_keys;
    foreach my $key (@ks) {
        if ( $key ne "" ) {
            if ( exists( $vars{$key} ) ) {
                push @real_keys, $key;
            }
            else {
                if ( $key ne "all" ) {
                    $hash{"code"} = 0;
                    $hash{"msg"} = "关键字(--k='')不存在";
                    Rex::Logger::info( "关键字($key)不存在", "error" );
                }
            }
        }
    }
    for my $item (@base) {
        my @list       = split( / /, $item );
        my $local_name = $list[0];
        my $app_key    = $list[1];
        if ( grep { $app_key eq $_ } @real_keys ) {
            Rex::Logger::info(
                "开启校验对比($app_key)下载目录到待发布目录差异.");
            my $deploy_prodir  = "$softdir/$local_name";
            my $deploy_confdir = "$configuredir/$local_name/$app_key";
            my $down_prodir    = "$local_prodir/$app_key";
            my $down_confdir   = "$local_confdir/$app_key";
            my $deploy_single_confdir = "$configuredir/diffconf/$local_name/$app_key";



            #处理程序目录
            Rex::Logger::info("开始校验程序目录: diff -rbq $down_prodir $deploy_prodir ");
            if (!  is_dir($down_prodir) ) {
                $hash{"code"} = 0;
                push @errDownloadpro,$down_prodir;
                Rex::Logger::info("下载程序目录不存在:  $down_prodir.", "error" ); 
                next; 
            }
            if (!  is_dir($deploy_prodir) ) {
                $hash{"code"} = 0;
                push @errpro,$deploy_prodir;
                Rex::Logger::info("待发布程序目录不存在:  $deploy_prodir.", "error" ); 
                next; 
            }
            my $randomfile = "/tmp/differ" . get_random( 8, 'a' .. 'z' ) . time().".txt";
            my $proDiffer = run "diff -rbq $down_prodir $deploy_prodir > $randomfile";
            #Rex::Logger::info("开始解析differ文件: $randomfile");

            my $i = 0 ;
            my $c = 0 ;
            my $a = 0 ;
            my $d = 0 ;
            my @data ;
            open(DATA, "<$randomfile") or  Rex::Logger::info("$randomfile 文件无法打开, $!","error");        
            while(<DATA>){
               #Rex::Logger::info("$_"); 
               if ( $_ =~ m/differ$/ ) {
                 $c = $c + 1 ;
               }
               if ( $_ =~ m/^Only/  && $_ =~ m/$deploy_prodir/ ) {
                 $a = $a + 1 ;
               }
               if ( $_ =~ m/^Only/  &&  $_ =~ m/$down_prodir/) {
                 $d = $d + 1 ;
               }
               $i = $i + 1 ;
            }
            close(DATA) || die Rex::Logger::info("$randomfile 文件无法关闭","error");
            if (is_file($randomfile)) {
                unlink($randomfile);
            }
            my $prodiffercount;
            my $confdiffercount;
            Rex::Logger::info("$app_key 程序目录: 合计变化的文件数: $i 变化的文件数:$c 删除的文件数:$d 新增文件数:$a");
            $prodiffercount = "$i,$c,$d,$a";
            #push @proChange,"$app_key程序 校验统计 合计:$i 变化:$c 删除:$d 新增:$a";
            # push @proChange,"[$app_key程序 合计:$i {c:$c,d:$d,a:$a}]";
            push @proChange,"[$app_key程序:$i]";
            push @enproChange,"[$app_key pro:$i]";

            #处理配置目录
            if ( is_dir($down_confdir) ) {
                if ( ! is_dir($deploy_confdir) ) {
                    $hash{"code"} = 0;
                    push @errconf,$deploy_confdir;
                    Rex::Logger::info(
                        "待发布配置目录不存在: $deploy_confdir.","error"
                    );
                    next;
                }
                my $configure_group_result = run_task "Deploy:Db:configure_group", params => { app_key => "$app_key" };
                if ( $configure_group_result eq '0' ) {

                    my $randomfile = "/tmp/differconfig" . get_random( 8, 'a' .. 'z' ) . time().".txt";
                    my $proDiffer = run "diff -rbq $down_confdir $deploy_confdir > $randomfile";
                    #Rex::Logger::info("开始解析配置differ文件: $randomfile");
                    my $i = 0 ;
                    my $c = 0 ;
                    my $a = 0 ;
                    my $d = 0 ;
                    my @data ;
                    open(DATA, "<$randomfile") or  Rex::Logger::info("$randomfile 文件无法打开, $!","error");        
                    while(<DATA>){
                       #Rex::Logger::info("$_"); 
                       if ( $_ =~ m/differ$/ ) {
                         $c = $c + 1 ;
                       }
                       if ( $_ =~ m/^Only/  && $_ =~ m/$deploy_confdir/ ) {
                         $a = $a + 1 ;
                       }
                       if ( $_ =~ m/^Only/  &&  $_ =~ m/$down_confdir/) {
                         $d = $d + 1 ;
                       }
                       $i = $i + 1 ;
                    }
                    close(DATA) || die Rex::Logger::info("$randomfile 文件无法关闭","error");
                    # if (is_file($randomfile)) {
                    #     unlink($randomfile);
                    # }
                    Rex::Logger::info("$app_key 配置目录: 合计变化的文件数: $i 变化的文件数:$c 删除的文件数:$d 新增文件数:$a");
                    Rex::Logger::info("校验配置目录: diff -rbq $down_confdir $deploy_confdir ");
                    $confdiffercount = "$i,$c,$d,$a";
                    # push @confChange,"$app_key配置 校验统计 合计:$i 变化:$c 删除:$d 新增:$a";
                    # push @confChange,"[$app_key配置 合计:$i {c:$c d:$d a:$a}]";
                    push @confChange,"[$app_key配置:$i]";
                    push @enconfChange,"[$app_key conf:$i]";

                }else{
                    my @configure_group_list = split( /,/, $configure_group_result );
                    my $lastdir;
                    foreach my $file (@configure_group_list) {
                        my @extent_dir = split( /\//, $file);
                        my $length = @extent_dir;
                        my @last_dir = split( /$extent_dir[$length-1]/, $file );
                        $lastdir = "$deploy_single_confdir/$last_dir[0]";
                        if ( !is_dir($lastdir) ) {
                            run "mkdir -p $lastdir";
                        }
                        cp("$down_confdir/$file", "$lastdir");
                        # Rex::Logger::info("拷贝配置文件: copy $down_confdir/$file => $lastdir");
                    }
                    $lastdir=~ s/\/$//;
                    my $down_confdir = $lastdir ;
                    my $randomfile = "/tmp/differsingleconfig" . get_random( 8, 'a' .. 'z' ) . time().".txt";
                    my $proDiffer = run "diff -rbq $down_confdir $deploy_confdir > $randomfile";
                    #Rex::Logger::info("开始解析配置differ文件: $randomfile");
                    my $i = 0 ;
                    my $c = 0 ;
                    my $a = 0 ;
                    my $d = 0 ;
                    my @data ;
                    open(DATA, "<$randomfile") or  Rex::Logger::info("$randomfile 文件无法打开, $!","error");        
                    while(<DATA>){
                       #Rex::Logger::info("$_"); 
                       if ( $_ =~ m/differ$/ ) {
                         $c = $c + 1 ;
                       }
                       if ( $_ =~ m/^Only/  && $_ =~ m/$deploy_confdir/ ) {
                         $a = $a + 1 ;
                       }
                       if ( $_ =~ m/^Only/  &&  $_ =~ m/$down_confdir/) {
                         $d = $d + 1 ;
                       }
                       $i = $i + 1 ;
                    }
                    close(DATA) || die Rex::Logger::info("$randomfile 文件无法关闭","error");
                    # if (is_file($randomfile)) {
                    #     unlink($randomfile);
                    # }
                    Rex::Logger::info("$app_key 配置目录: 合计变化的文件数: $i 变化的文件数:$c 删除的文件数:$d 新增文件数:$a");
                    Rex::Logger::info("校验配置目录: diff -rbq $down_confdir $deploy_confdir ");
                    $confdiffercount = "$i,$c,$d,$a";
                    # push @confChange,"$app_key配置 校验统计 合计:$i 变化:$c 删除:$d 新增:$a";
                    # push @confChange,"[$app_key配置 合计:$i {c:$c d:$d a:$a}]";
                    push @confChange,"[$app_key配置:$i]";
                    push @enconfChange,"[$app_key conf:$i]";

                }
     
                
            }
            else {
                $hash{"code"} = 0;
                push @errDownloadconf,$down_confdir;
                Rex::Logger::info(
                    "下载配置目录不存在:  $down_confdir.", "error" );
                     next;
            }
            my $differcount = "{\"app_key\":\"$app_key\",\"prodiffercount\":\"$prodiffercount\",\"confdiffercount\":\"$confdiffercount\"}";
            run_task "Deploy:Db:update_differcount", params => { app_key => "$app_key" ,differcount=>"$differcount"};
            push @differcountArray,$differcount;
            Rex::Logger::info(
                "校验对比($app_key)下载目录到待发布目录差异完成.");
            Rex::Logger::info("");

        }
    }
    my $errDownloadproStr = join(",",@errDownloadpro);
    my $errDownloadconfStr = join(",",@errDownloadconf);
    $hash{"errDownloadpro"} = $errDownloadproStr;
    $hash{"errDownloadconf"} = $errDownloadconfStr;
    my $errproStr = join(",",@errpro);
    my $errconfStr = join(",",@errconf);
    $hash{"errpro"} = $errproStr;
    $hash{"errconf"} = $errconfStr;
    my $confChangeStr = join(",",@confChange);
    my $enconfChangeStr = join(",",@enconfChange);
    my $proChangeStr = join(",",@proChange);
    my $enproChangeStr = join(",",@enproChange);
    $hash{"confChange"} = $confChangeStr;
    $hash{"enconfChange"} = $enconfChangeStr;
    $hash{"proChange"} = $proChangeStr;
    $hash{"enproChange"} = $enproChangeStr;
    $hash{"differcount"} = [\@differcountArray];
    Common::Use::json($w,"0","成功",[\%hash]);
    return \%hash;

};



1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Deploy::Core/;

 task yourtask => sub {
    Deploy::Core::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
