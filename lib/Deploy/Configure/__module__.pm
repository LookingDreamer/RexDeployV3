package Deploy::Configure;

use Rex -base;
use Deploy::Db;
use DBI;
use Data::Dumper;

my $env;
my $softdir;
my $configuredir;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key} ;
 });
Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 our $user = $param->{user} ;
     $softdir  = $param->{softdir};
     $configuredir  = $param->{softdir};
 });


desc "配置文件初始化";
task config => sub {
    my $self = shift;
    my $k=$self->{k};
    my $w=$self->{w};
    my %reshash ;
    if( $k eq ""  ){
	    Rex::Logger::info("关键字(--k='')不能为空");
	    Common::Use::json($w,"","关键字(--k='')不能为空","");
	    exit;
    }
    my $diff_pro = Deploy::Db::query_local_pro_cmd($k);
    my @diff_pro_array = @$diff_pro;
    my $diff_pro_count = @diff_pro_array;
    my $run_pro_cmd ;
    if ( $diff_pro_count > 0 ) {
    	Rex::Logger::info("$k 存在工程路径自定义命令执行");
    	$run_pro_cmd = run_pro_cmd($diff_pro);
    	if ( $run_pro_cmd->{code} != 0 ) {
    		Rex::Logger::info("$k 执行程序初始化命令失败","error");
    		return ;
    	}
    }else{
    	Rex::Logger::info("$k 不存在工程路径自定义命令执行");
    }



};

sub run_pro_cmd {
	my ($diff_pro)= @_;
    my @diff_pro_array = @$diff_pro;
    my %reshash ; 
    my @data ; 
    for my $pro (@diff_pro_array){
    	my %singleData ; 
    	my $local_name = $pro->{"local_name"};
    	my $pro_cmd = $pro->{"local_pro_cmd"};
    	my $run_dir = $softdir."/".$local_name ; 
    	Rex::Logger::info("$local_name 执行路径: $run_dir 执行命令: $pro_cmd");
    	$singleData{"local_name"} = $local_name;
    	$singleData{"pro_cmd"} = $pro_cmd;
    	$singleData{"run_dir"} = $run_dir;
    	my $runres;
    	eval {
    		$runres = run " cd $run_dir && $pro_cmd";
    		if ( $? != 0 ) {
    			Rex::Logger::info("$local_name 执行路径: $run_dir 执行命令: $pro_cmd 执行失败: $runres","error");
	    		$reshash{"code"} = -1 ;
	    		$reshash{"msg"} = "run cmd faild: $runres" ;
	    		return \%reshash;
    		}else{
    			Rex::Logger::info("$local_name 执行路径: $run_dir 执行命令: $pro_cmd 执行成功");
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
	$reshash{"code"} = 0 ;
	$reshash{"msg"} = "run cmd success" ;
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
