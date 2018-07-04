package Common::mysql;

use Rex -base;
use Deploy::Db;
use DBI;
use Data::Dumper;

my $localenv;
my $table;
my $deploy_table;
my $deploy_status_table;
my $external_status;
my $external_deploy_config_table;
my $table_load_key;
my $allow_env;
my $default_download_env;
Rex::Config->register_config_handler("env", sub {
        my ($param) = @_;        
        $localenv = $param->{key} ;
        $localenv = Rex::Config->get_envName; if ( $envName );
});
Rex::Config->register_config_handler("$localenv", sub {
        my ($param) = @_;
        $external_status = $param->{external_status} ;
        if($external_status eq "true"){
        $table = $param->{external_deploy_config_table};
        }else{
        $table = $param->{deploy_config_table} ;
        }
        $deploy_table = $param->{deploy_record_table} ;
        $deploy_status_table = $param->{deploy_status_table} ;
        $table_load_key = $param->{table_load_key} ;
        $allow_env = $param->{allow_env} ;
        $default_download_env = $param->{default_download_env} ;
});

#获取其他环境配置
sub getEnvConfig{
    my ($local_name,$env) = @_;
    if ( "$env" eq "" ) {
        $env = $default_download_env;
    }
    my $args = checkArgs($env,$local_name);
    if ( $args->{code} != 0 ) {
        Rex::Logger::info("环境变量env不正确或者local_name为空: ".$args->{msg},"error");
        return $args;
    }
    my @local_name_array = split(" ",$local_name);
    my $local_name = join(" ",@local_name_array);
    $local_name =~ s/ /','/g;
    $local_name = "'".$local_name."'";    
    my $sql = "select * from $table where local_name in ($local_name) group by local_name;";
    my @data = query($env,$sql);
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
        $config{loadBalancerId}=$list->{'loadBalancerId'};
        $config{url}=$list->{'url'};
        $config{header}=$list->{'header'};
        $config{params}=$list->{'params'};
        $config{require}=$list->{'require'};
        $config{requirecode}=$list->{'requirecode'};
        $config{config_dir}=~ s/ //g;
        $config{pro_dir}=~ s/ //g;
        $config{pro_init}=~ s/ //g;   
        $config{network_ip}=~ s/\s+$//;
        $config{network_ip}=~ s/^\s+//;
        $config{app_key}=~ s/ //g;   
        $config{local_name}=~ s/ //g;   
        $config{container_dir}=~ s/ //g;
        $config{loadBalancerId}=~ s/ //g;
    }
    my $len=@ids;
    if($len == 0 ){
        return 1;
    }
    if($len != 1){
        return 2;       
        exit
    }
    return \%config;

};

#参数校验
sub checkArgs{
    my ($env,$local_name) = @_;
    my %args;
    if ( "$env" eq "") {
        $args{"code"} = 1;
        $args{"msg"} = "env is must be not null";
        return \%args;
    }     
    if ( "$local_name" eq "") {
        $args{"code"} = 2;
        $args{"msg"} = "local_name is must be not null";
        return \%args;
    }  
    my @allow_env_array = split(",",$allow_env);
    if ( ! grep /^$env$/, @allow_env_array) {
        $args{"code"} = 3;
        $args{"msg"} = "env:$env must in ($allow_env)";
        return \%args;
    }
    $args{"code"} = 0;
    $args{"msg"} = "success";
    return  \%args;
}

#查询
sub query {
    my ($env,$sql) = @_;
    if ( "$sql" eq "" ) {
        Rex::Logger::info("SQL不能为空","error");
        return;
    }
    my $dbh = init($env);
    $dbh->do('set SESSION wait_timeout=72000');
    $dbh->do('set SESSION interactive_timeout=72000');
    $dbh->do("SET NAMES utf8"); 
    my $sth = $dbh->prepare($sql);
    $sth->execute() or die( $sth->errstr );
    my @return;
    while ( my $row = $sth->fetchrow_hashref ) {
      push @return, $row;
    }    
    $sth->finish();
    $dbh->disconnect();
    return @return;
};

#初始数据库
sub init{
    my $env = $_[0]; 
    my $dbname;
    my $dbhost;
    my $dbuser;
    my $dbpassword;
    my $dbport;   

    Rex::Config->register_config_handler("$env", sub {
     my ($param) = @_;
      $dbname = $param->{dbname} ;
      $dbhost = $param->{dbhost} ;
      $dbuser = $param->{dbuser} ;
      $dbpassword = $param->{dbpassword} ;
      $dbport = $param->{dbport} ;
    });
    Rex::Logger::info("初始化$env环境数据库 host: $dbhost dbname: $dbname");
    my $dbh = DBI->connect("DBI:mysql:database=$dbname;host=$dbhost;port=$dbport",
                       "$dbuser", "$dbpassword",
                       {'RaiseError' => 1, 'AutoCommit' => 1 ,'mysql_auto_reconnect'=>1});
    return $dbh;
}


1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Common::mysql/;

 task yourtask => sub {
    Common::mysql::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
