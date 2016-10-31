package Deploy::Configure;

use Rex -base;
use Deploy::Db;
use DBI;
use Data::Dumper;

task example => sub {
	# file "/data/www/ins_share/cm/config/config.properties",
	# content   => template("file/data/www/ins_share/cm/config/config.properties", mysql_server => $mysql_server),
	# on_change => sub {
	# 	print "have changed!";
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
	#         	$local_name = $record->{$field};
	#         }	       
	#          if($field eq "env"){
	#         	$env = $record->{$field};
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
