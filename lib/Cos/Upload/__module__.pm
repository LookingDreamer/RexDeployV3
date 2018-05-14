package Cos::Upload;

use Rex -base;

my $env;
my $cos_upload_shell;
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
        $cos_upload_shell = $param->{cos_upload_shell};
    }
);


desc "腾讯云cos
1.上传cos  rex  Cos:Upload:txy --option='upload' --env='app' --pkgpath='/tmp/zhangZhongBao-uat.zip'
  测试上传  rex  Cos:Upload:txy --option='upload' --env='test' --pkgpath='/tmp/zhangZhongBao-uat.zip'

2.增加cos上传管理文件   rex  Cos:Upload:txy --option='add_cos' --env='app fm'
3.查询已有cos文件  rex Cos:Upload:query --option='query'
";

task txy => sub {
   my $self = shift;
   my $k=$self->{env};
   my $pkg=$self->{pkgpath};
   my $func=$self->{option};

   if( $k eq ""  ){
     Rex::Logger::info("关键字(--env='')不能为空","error");
     exit;
   }

   if ( $func ne "upload" &&  $func ne "add_cos" ) {
     Rex::Logger::info("option参数不正确,仅支持upload、add_cos","error");
     exit;
   }
   if( ! is_dir("/data/scripts") ){
      mkdir("/data/scripts");
   }

   my @ks = split(/ /, $k);

   for my $kv (@ks) {
       if ( $kv ne "" ){
          Rex::Logger::info("当前操作的关键词: $kv 操作的包: $pkg");
          Rex::Logger::info("执行脚本: /bin/bash scripts/cos_upload.sh ${func} ${kv} ${pkg}");
	        my $cmd = `/bin/bash scripts/cos_upload.sh ${func} ${kv} ${pkg}`;
	        print $cmd;
       }
   }

};

task query => sub{
  my $self = shift;
  my $func=$self->{option};
  my $scripts_dir="/data/scripts";

  my $cmd = `ls $scripts_dir/ |grep ^cos_.*_`;
  print $cmd;

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
