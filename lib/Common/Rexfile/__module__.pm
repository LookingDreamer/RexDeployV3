package Common::Rexfile;

use Rex -base;
use Data::Dumper;
use IPC::Shareable;
use POSIX;

#desc "检查服务器信息: rex check   --k='server1 server2 ../all'";
sub check{
	my ($k,$w,$username) = @_;	 
	my $keys=Deploy::Db::getallkey();
	my @keys=split(/,/, $keys);
	my %vars = map { $_ => 1 } @keys; 
	my $lastnum=$keys[-1] - 1;
	my $data = [];
	if( $k eq ""  ){
		 Rex::Logger::info("关键字(--k='')不能为空");
		 Common::Use::json($w,"","关键字(--k='')不能为空",""); 
		 exit;	
	}

	if( $username eq ""  ){
		Rex::Logger::info("用户名(--u='')不能为空");
		Common::Use::json($w,"","用户名(--u='')不能为空","");
		exit;
	}

	Rex::Logger::info("Starting ...... 操作人: $username");

	my @ks = split(/ /, $k);
	if ( $k eq "all" ){
		Rex::Logger::info("");
		Rex::Logger::info("开始检查 发布系统 服务器以及数据库配置---$keys[-1] 个.");
		for my $num (0..$lastnum) {
			Rex::Logger::info("");
			Rex::Logger::info("##############($keys[$num])###############");
			#初始化数据库信息
			my $config=Deploy::Core::init("$keys[$num]");
			#say $keys[$num];     
			#第一次连接获取远程服务器信息
			my $FistSerInfo=Deploy::Core::prepare($keys[$num],$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'},$w);
			push $data, $FistSerInfo;
		}
		Rex::Logger::info("检查 发布系统 服务器以及数据库配置完成---$keys[-1] 个.");
	}else{   
		Rex::Logger::info("");
		Rex::Logger::info("开始检查 发布系统 服务器以及数据库配置.");    
		for my $kv (@ks) {
			if ( $kv ne "" ){
				if (exists($vars{$kv})){	   
					Rex::Logger::info("");
					Rex::Logger::info("##############($kv)###############");
					#初始化数据库信息
					my $config=Deploy::Core::init("$kv");
					#第一次连接获取远程服务器信息
					my $FistSerInfo=Deploy::Core::prepare($kv,$config->{'network_ip'},$config->{'pro_init'},$config->{'pro_key'},$config->{'pro_dir'},$config->{'config_dir'});  
					push $data, $FistSerInfo;
				}else{
					Rex::Logger::info("关键字($kv)不存在","error");
				}
			}
		}
		Rex::Logger::info("检查 发布系统 服务器以及数据库配置完成.");
		Common::Use::json($w,"0","成功",$data);
	}

}

#desc "批量执行命令行: rex run  --k='server1 server2 ../all' --cmd='ls'";
sub batchrun{
   my ($k,$w,$cmd,$username) = @_;
   my $i;
   my $start = time;
   my $data = [];
   my @shared;
   if( $k eq ""  ){
     Rex::Logger::info("关键字(--k='')不能为空");
     Common::Use::json($w,"","关键字(--k='')不能为空",$data);
     exit;
   }
   if ( $cmd eq "" ){
     Rex::Logger::info("cmd命令不能为空.");
     Common::Use::json($w,"","cmd命令不能为空.",$data);
     exit;
   }
   if( $username eq ""  ){
     Rex::Logger::info("用户名(--u='')不能为空");
     Common::Use::json($w,"","用户名(--u='')不能为空",$data);
     exit;
   }
   my $ipch = tie @shared,   'IPC::Shareable',
                           "foco",
                           {  create    => 1,
                              exclusive => 'no',
                              mode      => 0666,
                              size      => 1024*512
                           };
   
   Rex::Logger::info("Starting ...... 操作人: $username");


   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   my @ks = split(/ /, $k);
   if ( $k eq "all" ){
     Rex::Logger::info("");
     Rex::Logger::info("开始执行命令模板---$keys[-1] 个.");
     my $maxchild = 5 ;
     my $max = @keys;
     my $s;
     my %hash_pids;
     for(my $g=0; $g < $max ;){
       $g = $g+$maxchild;
       $s = $g-$maxchild ;
       if( $g > $max ){
         Rex::Logger::info("并发控制:($s - $max)");
       }else{
         Rex::Logger::info("并发控制:($s - $g)");
       }

       for($i=$g-$maxchild;$i<$g;$i++){
          if( $i == $max  ){
             #最后一次收割并等待子进程完成
             while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
               my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
               if ($kid and exists $hash_pids{$kid}) {
                 delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
               }
             }
            Rex::Logger::info("执行命令模板完成.");
            my $take_time = time - $start;
            Rex::Logger::info("总共花费时间:$take_time秒.");
            Common::Use::json($w,"0","成功",\@shared);
            (tied @shared)->remove;
            IPC::Shareable->clean_up;
            IPC::Shareable->clean_up_all;
            exit; #全部结束
          }
          select(undef, undef, undef, 0.25);
          my $kv = $keys[$i];
          my $child=fork(); #派生一个子进程
          if($child){   # child >; 0, so we're the parent 
            $hash_pids{$child} = $child;  
            Rex::Logger::info("父进程PID:$$ 子进程PID:$child");
          }else{ 
            # 在子进程中执行相关动作
            Rex::Logger::info("执行子进程,进程序号:$i");
            if (  $kv =~ /^\d+$/ ){
	    }else{	
                Rex::Logger::info("");
                Rex::Logger::info("##############($kv)###############");
                my $config=Deploy::Core::init("$kv");
                my $runres = run_task "Common:Use:run",on=>$config->{'network_ip'},params=>{ cmd=>"$cmd",w=>"$w" };
                $runres->{"app_key"} = $kv;
                $ipch->shlock;
                push @shared, $runres;
                $ipch->shunlock;
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

     #Rex::Logger::info("执行命令模板完成---$keys[-1] 个.");
   }else{
     Rex::Logger::info("");
     Rex::Logger::info("开始执行命令模板.");
     my $maxchild = 5 ;
     my $max = @ks;
     my $s;
     my %hash_pids;
     for(my $g=0; $g < $max ;){
       $g = $g+$maxchild;
       $s = $g-$maxchild ;
       if( $g > $max ){
         Rex::Logger::info("并发控制:($s - $max)");
       }else{
         Rex::Logger::info("并发控制:($s - $g)");
       }

       for($i=$g-$maxchild;$i<$g;$i++){
          if( $i == $max  ){
             #最后一次收割并等待子进程完成
             while (scalar keys %hash_pids) { #一直判断hash中是否含有pid值,直到退出.
               my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
               if ($kid and exists $hash_pids{$kid}) {
                 delete $hash_pids{$kid};  #如果回收的子进程存在于hash中,那么删除它.
               }
             }
            Rex::Logger::info("执行命令模板完成.");
            my $take_time = time - $start;
            Rex::Logger::info("总共花费时间:$take_time秒.");
            Common::Use::json($w,"0","成功",\@shared);
            (tied @shared)->remove;
            IPC::Shareable->clean_up;
            IPC::Shareable->clean_up_all;
            exit; #全部结束
          }
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
                my $runres = run_task "Common:Use:run",on=>$config->{'network_ip'},params=>{ cmd=>"$cmd" ,w=>"$w"};
                $runres->{"app_key"} = $kv;
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

 include qw/Common::Rexfile/;

 task yourtask => sub {
    Common::Rexfile::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
