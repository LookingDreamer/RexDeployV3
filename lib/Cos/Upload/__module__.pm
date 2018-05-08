package Cos::Upload;

use Rex -base;

desc "腾讯云cos \n1.上传cos  rex  Cos:Upload:txy --option='upload' --env='app fm' --pkgpath='/tmp/zhangZhongBao-1525341589008-201805031800-uat.zip' \n2.增加cos上传管理文件  rex  Cos:Upload:txy --option='add_cos' --env='app fm'";


task txy => sub {
   my $self = shift;
   my $k=$self->{env};
   my $pkg=$self->{pkgpath};
   my $func=$self->{option};

   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;

   }
   my @ks = split(/ /, $k);

   for my $kv (@ks) {
       if ( $kv ne "" ){

	        print "$kv\n";
	        print "$pkg\n";

	        my $cmd = `/bin/bash /data/scripts/cos_upload.sh ${func} ${kv} ${pkg}`;
	        print $cmd;


       }else{
       	Rex::Logger::info("关键字($kv)不存在","error");
       }

   }

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
