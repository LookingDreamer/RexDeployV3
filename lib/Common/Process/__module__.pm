package Common::Process;

use Rex -base;
use Data::Dumper;
use IPC::Shareable;
use POSIX;


my $env;
my $parallelism;
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
        $parallelism = $param->{parallelism};
    }
);


desc "多进程执行模块";
task main => sub {
    my $w = 0 ;
    my $params = { cmd=>"uptime" ,w=>$w};
    #my $result = moreProcess("server1 server2",$w,"批量命令模块","Common:Use:run",$params) ;
    # my $result = moreProcess("all",$w,"批量命令模块","Common:Use:run",$params) ;
    # my $result = moreProcess("server flow",$w,"批量命令模块","Common:Use:run",$params) ;
    say Dumper($result);
};


#多线程通用模块
sub moreProcess{
   my ($k,$w,$desc,$module,$params) = @_;
   my $data ;
   if ( $k eq "all" ){
      my $keys=Deploy::Db::getallkey();
      my @keysArray=split(/,/, $keys);
      pop @keysArray;
      my $k = join(" ",@keysArray);
      $data = appProcess($k,$w,$desc,$module,$params);  
   }else{
      my $query_local_prodir_key = Deploy::Db::query_local_app_key($k);
      my @query_local_prodir_key = @$query_local_prodir_key ;
      my @app_key_array;
      for my $prolocal (@query_local_prodir_key){
          my $app_key = $prolocal->{"app_key"};
          push @app_key_array,$app_key;
      }
      my $app_key_count = @app_key_array;
      my $app_key_str = join(" ",@app_key_array);
      if ( $app_key_count > 0 ) {
        Rex::Logger::info("开始多进程操作:  $app_key_str 名字数量: $app_key_count");
        eval {
          $data = appProcess($app_key_str,$w,$desc,$module,$params); 
        };
        if ($@) {
          Rex::Logger::info("执行多进程异常: $@","error");
          Common::Use::json($w,"","执行多进程异常: $@",[]);
          exit;
        }
        
      }else{
        Rex::Logger::info("查询到数据为空，请确认是否正确的录入数据: $k","error");
        Common::Use::json($w,"","查询到数据为空，请确认是否正确的录入数据: $k",[]);
        exit;
      }
 
   }
   return $data;

};

#根据app_key执行多线程
sub appProcess{
    my ($k,$w,$desc,$module,$params) = @_;
    my $i;
    my $start = time;
    my $data = [];
    my @shared;

    if( $k eq ""  ){
     Rex::Logger::info("关键字(--k='')不能为空");
     Common::Use::json($w,"","关键字(--k='')不能为空",$data);
     exit;
    }
    my $ipch = tie @shared,   'IPC::Shareable',
                           "foco",
                           {  create    => 1,
                              exclusive => 'no',
                              mode      => 0666,
                              size      => 1024*512
                           };

    my $keys=Deploy::Db::getallkey();
    my @keys=split(/,/, $keys);
    my %vars = map { $_ => 1 } @keys;
    my $lastnum=$keys[-1] - 1;
    my @ks = split(/ /, $k);

     Rex::Logger::info("");
     Rex::Logger::info("开始执行".$desc);
     Rex::Logger::info("并发数量: $parallelism");
     my $maxchild = $parallelism ;
     my $max = @ks;
     my $s;
     my %hash_pids;
     for(my $g=0; $g < $max ;){
       $g = $g+$maxchild;
       $s = $g-$maxchild ;
       my $currentMax = $g;
       if( $g > $max ){
         my $currentMax = $max;
         Rex::Logger::info("并发控制:($s - $max)");
       }else{
         Rex::Logger::info("并发控制:($s - $g)");
       }
       
       for($i=$g-$maxchild;$i<$currentMax;$i++){
          select(undef, undef, undef, 0.25);
          my $kv = $ks[$i];
          my $child=fork(); #派生一个子进程
          if($child){   # child >; 0, so we're the parent 
              $hash_pids{$child} = $child;  
              Rex::Logger::info("父进程PID:$$ 子进程PID:$child");
          }else{ 
            # 在子进程中执行相关动作
            Rex::Logger::info("执行子进程,进程序号:$i");
            if ( $kv ne "" ){
              if (exists($vars{$kv})){
                Rex::Logger::info("");
                Rex::Logger::info("##############($kv)###############");
                my $config=Deploy::Core::init("$kv");
                my $runres = run_task "$module",on=>$config->{'network_ip'},params=>$params;
                if ( ref $runres eq "HASH"  ) {
                    $runres->{"app_key"} = $kv;
                }elsif( ref $runres eq "ARRAY"  ){
                    push   $runres,$kv;   
                }                
                $ipch->shlock;
                push @shared, $runres;
                $ipch->shunlock;

              }else{
              Rex::Logger::info("关键字($kv)不存在","error");
              }
            }
            exit 0;             # child is done 

         } 
        }
        #收割并等待子进程完成
        while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
          my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
          if ($kid and exists $hash_pids{$kid}) {
            delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
          }
        }
    }

    #收割并等待子进程完成
    while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
       my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
       if ($kid and exists $hash_pids{$kid}) {
         delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
       }
    }
    Rex::Logger::info("执行".$desc."完成.");
    my $take_time = time - $start;
    Rex::Logger::info("总共花费时间:$take_time秒.");
    Common::Use::json($w,"0","成功",\@shared);
    my $sharedCount = @shared;
    my %result = (
       msg => "success",
       code  => 0,
       count  => $sharedCount,
       data => [@shared]
    );
    (tied @shared)->remove;
    IPC::Shareable->clean_up;
    IPC::Shareable->clean_up_all;
    return \%result;
    exit; #全部结束
}


1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Common::Process/;

 task yourtask => sub {
    Common::Process::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
