package Deploy::rollBack;

use Rex -base;
use Data::Dumper;
use Deploy::FirstConnect;
use Deploy::Db;
use Rex::Commands::Rsync;
use Rex::Commands::Sync;
use Deploy::other;
use Rex::Misc::ShellBlock;

my $datetime = run "date '+%Y%m%d_%H%M%S'" ;
desc "回滚模块";
task linkrestart => sub {

   my $self = shift;
   my  $k  = $self->{k};
   my  $network_ip = $self->{network_ip};
   my  $ps_num = $self->{ps_num};
   my  $pro_key = $self->{pro_key};
   my  $pro_init = $self->{pro_init};
   my  $pro_dir = $self->{pro_dir};
   my  $config_dir = $self->{config_dir};
   my  $is_deloy_dir = $self->{is_deloy_dir};
   our $myAppStatus = $self->{myAppStatus};
   our $getLastDeloy = $self->{getLastDeloy};
   our $deloy_prodir_before =$getLastDeloy->{'deloy_prodir_before'} ;
   our $deloy_configdir_before =$getLastDeloy->{'deloy_configdir_before'} ;
   our $lastRandomStr =$getLastDeloy->{'randomStr'} ;
   our $rollstatus =$getLastDeloy->{'rollstatus'} ;
   #去掉软链接最后的/
   $pro_dir =~ s/\/$//;
   $config_dir =~ s/\/$//;
 

   #1.获取更换软链接前的状态,目前只支持1个和2个目录的同步
   ###只有一个工程目录的情况
   if($is_deloy_dir == 1 ){
           #查看目前工程的软链接的情况
           my $pro_desc_be=run "ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'" ;
           if( ! is_dir($pro_dir) ){
           Rex::Logger::info("($k)--$pro_dir目录不存在");
           }else{
           my $pre_des_before=run "ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'";
           Deploy::Db::updateTimes($myAppStatus,"pre_des_before",$pre_des_before);
           Rex::Logger::info("($k)--发布前软链接详情: $pro_desc_be --> only");
           }

   }else{
   ###两个工程目录的情况

           if( ! is_dir($pro_dir) ){ 
           Rex::Logger::info("($k)-- $pro_dir目录不存在");
           }
           if( ! is_dir($config_dir) ){
           Rex::Logger::info("($k)-- $config_dir目录不存在");
           }
           my $pro_desc_be=run "ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'" ;
           my $conf_desc_be=run "ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'";
           my $pro_desc_be_before=run "ls $pro_dir -ld |grep -v sudo |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'" ;
           my $conf_desc_be_before=run "ls $config_dir -ld |grep -v sudo |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'|awk '{print \$NF}'";
           Deploy::Db::updateTimes($myAppStatus,"pre_des_before_before",$pro_desc_be_before,$conf_desc_be_before);
           Rex::Logger::info("($k)--发布前软链接详情: $pro_desc_be || $conf_desc_be");
   }


   #2.重启,更改软链接
   ###进程为0的情况
   if ($ps_num == 0){
   
          link_start($k, $pro_dir,$config_dir,$deloy_configdir_before,$deloy_prodir_before,$pro_key,$pro_init,$is_deloy_dir);   

   }###进程不为0的情况
   else{
           Rex::Logger::info("($k)--进程数为$ps_num,开始关闭应用->更改程序配置软链接->启动.");
           # run "/bin/bash $pro_init stop;sleep 2";   
           service "newservice",
             before_action=> "source /etc/profile",
             ensure  => "stopped",
             start   => "$pro_init start",
             stop    => "$pro_init stop",
             status  => "ps -efww | grep $pro_key",
             restart => "$pro_init stop && $pro_init start",
             reload  => "$pro_init stop && $pro_init start";
           my $ps_stop_num = run "ps aux |grep -v grep |grep -v sudo |grep '$pro_key' |wc -l";
                   if( $ps_stop_num == 0  ){
                           Rex::Logger::info("($k)--进程数为$ps_stop_num,关闭成功.");

                           link_start($k, $pro_dir,$config_dir,$deloy_configdir_before,$deloy_prodir_before,$pro_key,$pro_init,$is_deloy_dir);   

                   }else{
                           Rex::Logger::info("($k)--进程数为$ps_stop_num,关闭失败->kill应用.","warn");
                           my @apps = grep { $_->{"command"} =~ m/$pro_key/ } ps();

                           for my $app (@apps) {
                           run  "kill -9  $app->{'pid'}";
                           }
                           my $ps_stop_num2 = run "ps aux |grep -v grep |grep -v sudo |grep '$pro_key' |wc -l";
                           if( $ps_stop_num2 == 0  ){Rex::Logger::info("($k)--kill应用-成功.");}else{Rex::Logger::info("($k)--kill应用-失败->略过此系统的发布.","error");return 0;}
                            
                           #更改软链接->重启-start  
                           link_start($k, $pro_dir,$config_dir,$deloy_configdir_before,$deloy_prodir_before,$pro_key,$pro_init,$is_deloy_dir);
                           #更改软链接->重启-end  
                   }
 
   }

   #更改软链接->重启-start,更改前程序已经处于停止的状态.
   sub link_start  {
   my ($k, $pro_dir,$config_dir,$remote_configdir,$remote_prodir,$pro_key,$pro_init,$is_deloy_dir) = @_;
   if($is_deloy_dir == 1){
   Rex::Logger::info("($k)--进程数为0,开始更改程序软链接.");
   #start-program
   my $link_status=run "ls $pro_dir -ld |grep '^l' |wc -l" ;
   if(! is_dir($pro_dir) ){
   run "ln -s $remote_prodir $pro_dir";
   run "chown www.www   $remote_prodir $pro_dir -R" ;
   }else{
   if ($link_status == 0) {
   run "mv $pro_dir ${pro_dir}_$datetime";
   Rex::Logger::info("($k)--程序目录不为软链接: mv $pro_dir ${pro_dir}_$datetime");
   }else{
   run "unlink $pro_dir;ln -s $remote_prodir $pro_dir";
   run "chown www.www   $remote_prodir $pro_dir -R" ;
   }
   }
   #end-program
   my $pro_desc=run "ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'" ;
   my $pre_des_after=run "ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'" ;
   my $size=run "du -sh $pre_des_after |xargs ";
   Deploy::Db::updateTimes($myAppStatus,"pre_des_after","$pre_des_after","$size");
   Rex::Logger::info("($k)--进程数为0,发布后软链接详情: $pro_desc ");
   Rex::Logger::info("($k)--进程数为0,更改程序&更改权限完成.");
   if ( !is_dir($pro_dir) ){
   Rex::Logger::info("($k)--进程数为0,修改软链接失败:$pro_dir.",'error');    
   }            
   }elsif($is_deloy_dir == 2){#else开始

   #$pro_dir--start
   if( ! is_dir($pro_dir) ){
   run "ln -s $remote_prodir $pro_dir"
   }else{
   my $link_status=run "ls $pro_dir -ld |grep '^l' |wc -l" ;
   if ($link_status == 0) {
   run "mv $pro_dir ${pro_dir}_$datetime";
   Rex::Logger::info("($k)--程序目录不为软链接: mv $pro_dir ${pro_dir}_$datetime");
   }else{
   run "unlink $pro_dir;ln -s $remote_prodir $pro_dir"
   }
   }
   #$pro_dir--end
   
   #$config_dir-start
   if( ! is_dir($config_dir) ){
   run "ln -s $remote_configdir $config_dir"
   }else{
   my $linkc_status=run "ls $config_dir -ld |grep '^l' |wc -l" ;
   if ($linkc_status == 0) {
   run "mv $config_dir ${pro_dir}_$datetime";
   Rex::Logger::info("($k)--配置目录不为软链接: mv $config_dir  ${pro_dir}_$datetime");
   }else{
   run "unlink $config_dir;ln -s $remote_configdir $config_dir";
   run "chown www.www $remote_configdir $config_dir $remote_prodir $pro_dir -R ;";
   }
   }
   #$config_dir-end
   my $pro_desc=run "ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}'" ;
   my $conf_desc=run "ls $config_dir -ld |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}'";
   my $pro_desc_after=run "ls $pro_dir -ld |grep '^l'|awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'" ;
   my $conf_desc_after=run "ls $config_dir -ld |grep '^l' |awk '{print \$(NF-2),\$(NF-1),\$NF}' |awk '{print \$NF}'";
   my $size=run "du -sh $pro_desc_after $conf_desc_after |xargs ";
   Deploy::Db::updateTimes($myAppStatus,"pre_des_after_after","$pro_desc_after","$conf_desc_after","$size");
   Rex::Logger::info("($k)--进程数为0,发布后软链接详情: $pro_desc || $conf_desc");
   Rex::Logger::info("($k)--进程数为0,更改程序&配置软链接&更改权限完成.");
   if ( !is_dir($pro_dir) ){
   Rex::Logger::info("($k)--进程数为0,修改软链接失败:$pro_dir.",'error');       
   }
   if ( !is_dir($config_dir) ){
   Rex::Logger::info("($k)--进程数为0,修改软链接失败:$config_dir.",'error');       
   }     
   }#else结束   
   Rex::Logger::info("($k)--进程数为0,开始启动应用.");
   my $servername=$pro_init;
   $servername=~s /\/etc\/init.d\///g;
   Deploy::Db::updateTimes($myAppStatus,"app_start_time");

   # run "nohup /bin/bash $pro_init start > /dev/null & ";

   service "newservice",
     before_action=> "source /etc/profile",
     ensure  => "started",
     start   => "$pro_init start",
     stop    => "$pro_init stop",
     status  => "ps -efww | grep $pro_key",
     restart => "$pro_init stop && $pro_init start",
     reload  => "$pro_init stop && $pro_init start";
   run "sleep 2"; 
   #run "source /etc/profile ;/bin/bash $pro_init start";
   my $ps_start_num = run "ps aux |grep -v grep |grep -v sudo |grep '$pro_key' |wc -l";
   Deploy::Db::updateTimes($myAppStatus,"deploy_end","$ps_start_num");
   if( $ps_start_num == 0  ){
   Rex::Logger::info("($k)--进程数为0,启动失败.($pro_init start)","error");
   }else{
   Rex::Logger::info("($k)--进程数为$ps_start_num,启动成功.");
   }
   Deploy::Db::updateTimes($myAppStatus,"deploy_roll_finish","$k","$lastRandomStr","$rollstatus");
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

 include qw/Deploy::rollBack/;

 task yourtask => sub {
    Deploy::rollBack::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
