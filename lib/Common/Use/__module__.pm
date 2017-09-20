package Common::Use;

use Rex -base;
use Rex::Commands::Rsync;
use Deploy::Db;
use threads;
use POSIX;
use File::Basename;

desc "批量命令模块: rex [-H 'x.x.x.x x.x.x.x']/[-G  jry-com] run --cmd='uptime'";
task run =>,sub {

my $self = shift;
my $cmd = $self->{cmd};

run $cmd, sub {
     my ($stdout, $stderr) = @_;
     my $server = Rex::get_current_connection()->{server};
     my $names ;
     eval{ $names = Deploy::Db::showname($server);};
     if($@){
        Rex::Logger::warn("根据IP在数据库中查询主机信息超时或异常(不影响后续执行)");
     }
     if($names eq "none"){
        say "[$server] $stdout";
        say "" ;
     }elsif($names eq "null"){
        say "[$server] $stdout";
        say "" ;
     }else{
        say "[$server]-[$names] $stdout";
        say "" ;
     }

    };
};

desc "文件下载模块 远程->本地:rex [-H 'x.x.x.x']/[-G  jry-com] Common:Use:download --dir1='/tmp/1.txt' --dir2='/tmp/'";
task "download", sub {
   my $self = shift;
   my $dir1 = $self->{dir1};
   my $dir2 = $self->{dir2};
   my %hash_pids;
   my $server = Rex::get_current_connection()->{server};
   my %hash;
   my $sufer_dir2_status;
   my $sufer_dir1_status;
   my $du_dir;
   my $basename;
   if(  $dir2  =~m/\/$/ ) { 
     $sufer_dir2_status = "true";
   }else{
     $sufer_dir2_status = "false";
   }

   if(  $dir1  =~m/\/$/ ) { 
     $sufer_dir1_status = "true";
   }else{
     $sufer_dir1_status = "false";
   }
   # my $thread_1_01 = threads->create('download_thread','Download_Thread_1');
   # my $thread_2_01 = threads->create('download_thread',$dir1,$dir2);
   # $thread_2_01->join();
   if (  ! is_dir($dir1) &&  ! is_file($dir1) ) {
     Rex::Logger::info("[文件传输] [$server] $dir1 远程目录或文件不存在.");
     exit;
   }
   LOCAL{
    if ( !is_dir($dir2) ) {
      mkdir($dir2);
    }
   };

    #判断是带目录传输还是直接传输子目录或文件
  if ( $sufer_dir1_status eq "true" &&  $sufer_dir2_status eq "true" ) {
     $du_dir = $dir2;
   } elsif ( $sufer_dir1_status eq "true" &&  $sufer_dir2_status eq "false" ) {
     $du_dir = $dir2;
   } elsif ( $sufer_dir1_status eq "false" &&  $sufer_dir2_status eq "true" ) {
     $basename = basename $dir1;
     $du_dir = "$dir2/$basename";
   } else {
     $basename = basename $dir1;
     $du_dir = "$dir2/$basename";
   }
     
   #判断是否开启了sudo,如果开启了则查看修改/etc/sudoers
  my $env;
  my $key_auth;
  my $username;
  Rex::Config->register_config_handler("env", sub {
    my ($param) = @_;
    $env = $param->{key} ;
  });
  Rex::Config->register_config_handler("$env", sub {
    my ($param) = @_;
    $key_auth = $param->{key_auth} ;
    $username = $param->{user} ;
  });
  if (Rex::is_sudo) {
    if ( $key_auth eq "true" ) {
        my $sudo_config_status = run "grep 'Defaults:$username !requiretty' /etc/sudoers |wc -l";
       if (  $sudo_config_status eq '0') {
         run "echo 'Defaults:$username !requiretty' >> /etc/sudoers ";
         Rex::Logger::info("[文件传输] echo 'Defaults:$username !requiretty' >> /etc/sudoers ");
       }else{
         Rex::Logger::info("[文件传输] sudo tty终端已经关闭.");
       }
    }
  };

   my $real_size = run " du -sh $dir1 | awk '{print \$1}'";
   my $size = run " du -s $dir1 | awk '{print \$1}'";
   Rex::Logger::info("[文件传输] [$server]  $dir1-->$dir2大小: $real_size .");
   my $time_start=time();
   if( 2 > 1){
    download_thread($dir1,$dir2);
   }else{
   my $child=fork();
   die Rex::Logger::info("[文件传输] 创建进程失败.",'error') if not defined $child;
   if($child){   # child >; 0, so we're the parent 
    $hash_pids{$child} = $child; 
    Rex::Logger::info("[文件传输] 多进程文件传输: 父进程PID:$$ 子进程PID:$child");
    $hash{$child} = $child; #将子进程PID保存到hash,方便下面回收
   }else{
    download_thread($dir1,$dir2);        # child handles  
    exit 0;                              # child is done 
   }
   
    local $| = 1;
    my @progress_symbol = ('-','\\','|','/');
    my $i = 1;
    my $n = 0;
    while (scalar keys %hash) { #一直判断hash中是否含有pid值,直到退出.
        my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
        if ($kid and exists $hash{$kid}) {
            delete $hash{$kid};  #如果回收的子进程存在于hash中,那么删除它.
        }
        select(undef, undef, undef, 0.5);
        LOCAL {
          my @result;
          # if ( $sufer_dir_status  eq 'true' ) {
          #        @result = readpipe "du -s $dir2  | awk '{print \$1}'";
          # }else{
          #       my $basename = basename $dir1;
          #       # print "du -s $dir2/$basename  | awk '{print \$1}'";
          #       my $file_name = "$dir2/$basename";
          #       if (  ! is_dir($file_name) &&  ! is_file($file_name) ) {
          #         my $pre_hosts = run "ifconfig  |grep inet |awk '{print \$2}' |xargs";
          #         Rex::Logger::info("[文件传输] $file_name 目录或文件不存在,退出进度条显示,后台传输文件。");
          #         Rex::Logger::info("[文件传输] 当前执行命令主机: $pre_hosts ");
          #         exit;
          #       }
          #       @result = readpipe "du -s $dir2/$basename  | awk '{print \$1}'";
          # }
      
          my $file_name = "$du_dir";
          if (  ! is_dir($file_name) &&  ! is_file($file_name) ) {
            my $pre_hosts = run "ifconfig  |grep inet |awk '{print \$2}' |xargs";
            Rex::Logger::info("[文件传输] $file_name 目录或文件不存在,退出进度条显示,后台传输文件。");
            Rex::Logger::info("[文件传输] 当前执行命令主机: $pre_hosts ");
            exit;
          }
          @result = readpipe "du -s $du_dir  | awk '{print \$1}'";

          my $percent = $result[0] / $size ;
          my $percent = sprintf("%.2f",$percent);
          my $percent = $percent * 100;
          if ( $percent >= 100 ) {
            print "\r $progress_symbol[$n] 100%"; 
          } else {
            print "\r $progress_symbol[$n] $percent%";  
          }

          # print "\r $progress_symbol[$n] $percent%";
        };
        
        $i = $i + 1;
        $n = ($n>=3)? 0:$n+1;
    }

    }
    print "\n";
    local $| = 0;
    my $time_end=time();
    my $time =$time_end-$time_start; 
    Rex::Logger::info("[文件传输] 传输完成,耗时: $time秒");

   sub download_thread{
     my ($dir1,$dir2) = @_;
     sync $dir1,$dir2, {
     download => 1,
     parameters => '--backup --progress',
     };
   }
 };

desc "文件上传模块 本地->远程:rex [-H 'x.x.x.x']/[-G  jry-com] Common:Use:upload --dir1='/tmp/1.txt' --dir2='/tmp/'";
task "upload", sub {
    my $self = shift;
    my $dir1 = $self->{dir1};
    my $dir2 = $self->{dir2};
   my %hash_pids;
   my $server = Rex::get_current_connection()->{server};
   my %hash;
   my @sizearr;
   my $sufer_dir2_status;
   my $sufer_dir1_status;
   my $du_dir;
   my $basename;
   my $time_start;
   if(  $dir2  =~m/\/$/ ) { 
     $sufer_dir2_status = "true";
   }else{
     $sufer_dir2_status = "false";
   }

   if(  $dir1  =~m/\/$/ ) { 
     $sufer_dir1_status = "true";
   }else{
     $sufer_dir1_status = "false";
   }

   if( 2 > 1 ){
    $time_start=time();
    upload_thread($dir1,$dir2);
   }else{

   LOCAL{

        if ( !is_dir($dir1) ) {
          Rex::Logger::info("[文件传输] [local]: $dir1 目录或文件不存在.");
          exit;
        }
        my $real_size = run " du -sh $dir1 | awk '{print \$1}'";
        @sizearr = readpipe " du -s $dir1 | awk '{print \$1}'";
        Rex::Logger::info("[文件传输] [local]: $dir1-->$dir2大小: $real_size .");
   };

  #判断是带目录传输还是直接传输子目录或文件
  if ( $sufer_dir1_status eq "true" &&  $sufer_dir2_status eq "true" ) {
     $du_dir = $dir2;
   } elsif ( $sufer_dir1_status eq "true" &&  $sufer_dir2_status eq "false" ) {
     $du_dir = $dir2;
   } elsif ( $sufer_dir1_status eq "false" &&  $sufer_dir2_status eq "true" ) {
     $basename = basename $dir1;
     $du_dir = "$dir2/$basename";
   } else {
     $basename = basename $dir1;
     $du_dir = "$dir2/$basename";
   }

  #判断是否开启了sudo,如果开启了则查看修改/etc/sudoers
  my $env;
  my $key_auth;
  my $username;
  Rex::Config->register_config_handler("env", sub {
    my ($param) = @_;
    $env = $param->{key} ;
  });
  Rex::Config->register_config_handler("$env", sub {
    my ($param) = @_;
    $key_auth = $param->{key_auth} ;
    $username = $param->{user} ;
  });
  Rex::Logger::info("---------aaa---");
  if (Rex::is_sudo) {
    Rex::Logger::info("------------");	
    if ( $key_auth eq "true" ) {
        my $sudo_config_status = run "grep 'Defaults:$username !requiretty' /etc/sudoers |wc -l";
       if (  $sudo_config_status eq '0') {
         run "echo 'Defaults:$username !requiretty' >> /etc/sudoers ";
         Rex::Logger::info("[文件传输] echo 'Defaults:$username !requiretty' >> /etc/sudoers ");
       }else{
         Rex::Logger::info("[文件传输] sudo tty终端已经关闭.");
       }
    }
  };

   my $size = $sizearr[0];
   my $time_start=time();
   my $child=fork();
   die Rex::Logger::info("[文件传输] 创建进程失败.",'error') if not defined $child;
   if($child){   # child >; 0, so we're the parent 
    $hash_pids{$child} = $child; 
    Rex::Logger::info("[文件传输] 多进程文件传输: 父进程PID:$$ 子进程PID:$child");
    $hash{$child} = $child; #将子进程PID保存到hash,方便下面回收
   }else{
    upload_thread($dir1,$dir2);        # child handles  
    exit 0;                              # child is done 
   }
   
    local $| = 1;
    my @progress_symbol = ('-','\\','|','/');
    my $i = 1;
    my $n = 0;
    while (scalar keys %hash) { #一直判断hash中是否含有pid值,直到退出.
        my $kid = waitpid(-1, WNOHANG); #无阻塞模式收割
        if ($kid and exists $hash{$kid}) {
            delete $hash{$kid};  #如果回收的子进程存在于hash中,那么删除它.
        }
        select(undef, undef, undef, 0.5);
        # my @result;
        my $cmd_result;
        # if ( $sufer_dir_status  eq 'true' ) {
        #        # @result = readpipe "du -s $dir2  | awk '{print \$1}'";
        #        $cmd_result = run "du -s $du_dir   | awk '{print \$1}'";
        # }else{
        #       # my $basename = basename $dir1;
        #       # print "du -s $dir2/$basename  | awk '{print \$1}'";
        #       # my $file_name = "$dir2/$basename";
              if (  ! is_dir($du_dir) &&  ! is_file($du_dir) ) {
                my $pre_hosts = run "ifconfig  |grep inet |awk '{print \$2}' |xargs";
                Rex::Logger::info("[文件传输] $du_dir 目录或文件不存在,退出进度条显示,后台传输文件。");
                Rex::Logger::info("[文件传输] 当前执行命令主机: $pre_hosts ");
                exit;
              }
              # @result = readpipe "du -s $dir2/$basename  | awk '{print \$1}'";
              $cmd_result = run "du -s $du_dir   | awk '{print \$1}'";
        # };

        # my $cmd_result = run "du -s $dir2/$basename  | awk '{print \$1}'";
        my $percent = $cmd_result / $size ;
        my $percent = sprintf("%.2f",$percent);
        my $percent = $percent * 100;
 
        if ( $percent >= 100 ) {
          print "\r $progress_symbol[$n] 100%"; 
        } else {
          print "\r $progress_symbol[$n] $percent%";  
        }
              
        # print "\r $cmd_result / $size";        
        $i = $i + 1;
        $n = ($n>=3)? 0:$n+1;
    }
    local $| = 0;
    }
    my $time_end=time();
    my $time =$time_end-$time_start; 
    #my $result = run "du -sh $dir2 ";
    Rex::Logger::info("[文件传输] 传输完成,耗时: $time秒");

   sub upload_thread{
    my ($dir1,$dir2) = @_;

    LOCAL{
        if ( !is_dir($dir1) && ! is_file($dir1) ) {
          Rex::Logger::info("[文件传输] [local]: $dir1 目录或文件不存在.");
          exit;
        }
        my $real_size = run " du -sh $dir1 | awk '{print \$1}'";
        @sizearr = readpipe " du -s $dir1 | awk '{print \$1}'";
        Rex::Logger::info("[文件传输] [local]: $dir1-->$dir2大小: $real_size .");
      };


      #判断是否开启了sudo,如果开启了则查看修改/etc/sudoers
      my $env;
      my $key_auth;
      my $username;
      Rex::Config->register_config_handler("env", sub {
        my ($param) = @_;
        $env = $param->{key} ;
      });
      Rex::Config->register_config_handler("$env", sub {
        my ($param) = @_;
        $key_auth = $param->{key_auth} ;
        $username = $param->{user} ;
      });
      if (Rex::is_sudo) {
        if ( $key_auth eq "true" ) {
            my $sudo_config_status = run "grep 'Defaults:$username !requiretty' /etc/sudoers |wc -l";
           if (  $sudo_config_status eq '0') {
             run "echo 'Defaults:$username !requiretty' >> /etc/sudoers ";
             Rex::Logger::info("[文件传输] echo 'Defaults:$username !requiretty' >> /etc/sudoers ");
           }else{
             Rex::Logger::info("[文件传输] sudo tty终端已经关闭.");
           }
        }
      };

      
      sync $dir1,$dir2, {
      exclude => ["*.sw*", "*.tmp"],
      parameters => '--backup --delete --progress',
      };
   }
 };


desc "内部命令调用模块: rex [-H 'x.x.x.x x.x.x.x']/[-G  jry-com] run --cmd='uptime'";
task apirun =>,sub {

my $self = shift;
my $cmd = $self->{cmd};
my $result = run "$cmd";
return $result;
 
};


=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Common::Use/;

 task yourtask => sub {
    Common::Use::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
