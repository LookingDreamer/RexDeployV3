package Cos::Upload;

use Rex -base;

desc "腾讯云cos
1.上传cos   rex  Cos:Upload:txy --option='upload' --env='app' --pkgpath='/tmp/zhangZhongBao-uat.zip' [--backup='1']
  测试上传  rex  Cos:Upload:txy --option='upload' --env='test' --pkgpath='/tmp/zhangZhongBao-uat.zip'
2.增加cos上传管理文件 rex  Cos:Upload:txy --option='add_cos' --env='app'
3.查询已有cos文件     rex Cos:Upload:query
";


task txy => sub {
   my $self = shift;
   my $k=$self->{env};
   my $pkg=$self->{pkgpath};
   my $func=$self->{option};
   my $is_bak=$self->{backup};

   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;

   }
   my @ks = split(/ /, $k);

   for my $kv (@ks) {
       if ( $kv ne "" ){
       		if( $is_bak eq "1" ){
       			Rex::Logger::info("开始备份……");
       			run_task "Cos:Upload:backup",params=>{ env => $k };
       		}

	        my $cmd = `/bin/bash scripts/cos_upload.sh ${func} ${kv} ${pkg}`;
	        print $cmd;

       }else{
       	Rex::Logger::info("关键字($kv)不存在","error");
       }

   }

};



# scripts 目录下创建env目录

task query => sub{
	my $scripts_dir="/data/scripts";
	my $enviroment=`grep "^Env" scripts/cos_upload.sh|awk '{print \$1}'|awk -F= '{print \$2}'`;

	my $Cos_dir="cos_for_$enviroment";
	my $env_cos_dir="${scripts_dir}/${Cos_dir}";

	my @array = `ls $env_cos_dir`;
    my $num;foreach $num(@array){

        if( $num =~ m/cos/i ) {
			$num =~ s/cos_//;
			print "$num";
        }
    }

};


sub mkbak {
	my ($aplct) = @_;
	Rex::Logger::info("备份${aplct} cos文件");

	my $enviroment=`grep "^Env" scripts/cos_upload.sh|awk '{print \$1}'|awk -F= '{print \$2}'`;
	$enviroment =~ s/\n//i;
	$enviroment =~ s/ //i;

	my $backup_dir="/data/backup";
	my $env_bak_dir="$backup_dir/cos_bak_${enviroment}/${aplct}";

	use POSIX qw(strftime);
	my $datestring = strftime "%Y_%m%d_%H%M", localtime;


	system "mkdir -p $env_bak_dir/$datestring";
	if ( !is_dir("$env_bak_dir/$datestring") ) {
		Rex::Logger::info("创建文件失败");
		exit;
	}else{
		Rex::Logger::info("备份目录：$env_bak_dir/$datestring");
	}
	return ("$env_bak_dir/$datestring","$enviroment");

}



# coscmd 备份
task backup => sub{
	my $scripts_dir="/data/scripts";

	my $self = shift;
	my $aplct = $self->{env};
	my ($bak_dir,$enviroment) = mkbak($aplct);


	my $Scripts_dir="/data/scripts";
	my $Cos_path="$Scripts_dir/cos_for_${enviroment}/cos_${aplct}";
	my $txy_cos_path=`grep cos_path $Cos_path/cos_sync/conf/config.json |awk -F'"' '{print \$4}'`;
	$txy_cos_path =~ s/\n//i;
	$txy_cos_path =~ s/ //i;

    my $cmd=` coscmd download -r $txy_cos_path/ /$bak_dir `


};




1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Cos::Upload/;

 task yourtask => sub {
    Cos::Upload::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
