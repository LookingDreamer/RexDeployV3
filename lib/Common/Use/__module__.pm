package Common::Use;

use Rex -base;
use Rex::Commands::Rsync;
use Deploy::Db;
use threads;
use POSIX;
use Term::ProgressBar 2.00;
use File::Basename;

desc "批量命令模块: rex [-H 'x.x.x.x x.x.x.x']/[-G  jry-com] run --cmd='uptime'";
task run =>,sub {

my $self = shift;
my $cmd = $self->{cmd};

run $cmd, sub {
     my ($stdout, $stderr) = @_;
     my $server = Rex::get_current_connection()->{server};
     my $names = Deploy::Db::showname($server);
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
   # my $thread_1_01 = threads->create('download_thread','Download_Thread_1');
   # my $thread_2_01 = threads->create('download_thread',$dir1,$dir2);
   # $thread_2_01->join();
   if (  ! is_dir($dir1) &&  ! is_file($dir1) ) {
     Rex::Logger::info("[$server] $dir1 远程目录或文件不存在.");
     exit;
   }
   LOCAL{
    if ( !is_dir($dir2) ) {
      mkdir($dir2);
    }
   };

   my $real_size = run " du -sh $dir1 | awk '{print \$1}'";
   my $size = run " du -s $dir1 | awk '{print \$1}'";
   Rex::Logger::info("[$server]  $dir1-->大小: $real_size .");
   my $time_start=time();
   my $child=fork();
   die Rex::Logger::info("创建进程失败.",'error') if not defined $child;
   if($child){   # child >; 0, so we're the parent 
    $hash_pids{$child} = $child; 
    Rex::Logger::info("多进程文件传输: 父进程PID:$$ 子进程PID:$child");
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
          my $basename = basename $dir1;
          # print "du -s $dir2/$basename  | awk '{print \$1}'";
          my @result = readpipe "du -s $dir2/$basename  | awk '{print \$1}'";
          my $percent = $result[0] / $size ;
          my $percent = sprintf("%.2f",$percent);
          my $percent = $percent * 100;
          if ( $percent >= 100 ) {
            print "\r $progress_symbol[$n] 100%"; 
          } else {
            print "\r $progress_symbol[$n] $percent%";  
          }

          print "\r $progress_symbol[$n] $percent%";
        };
        
        $i = $i + 1;
        $n = ($n>=3)? 0:$n+1;
    }
    local $| = 0;
    my $time_end=time();
    my $time =$time_end-$time_start; 
    Rex::Logger::info("传输完成,耗时: $time秒");

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
   # my $thread_1_01 = threads->create('download_thread','Download_Thread_1');
   # my $thread_2_01 = threads->create('download_thread',$dir1,$dir2);
   # $thread_2_01->join();
   # if (  ! is_dir($dir1) &&  ! is_file($dir1) ) {
   #   Rex::Logger::info("[$server] $dir1 目录或文件不存在.");
   #   exit;
   # }

   LOCAL{

        if ( !is_dir($dir1) ) {
          Rex::Logger::info("[local]: $dir1 目录或文件不存在.");
          exit;
        }
        my $real_size = run " du -sh $dir1 | awk '{print \$1}'";
        @sizearr = readpipe " du -s $dir1 | awk '{print \$1}'";
        Rex::Logger::info("[local]: $dir1-->大小: $real_size .");
   };
   my $size = $sizearr[0];
   my $time_start=time();
   my $child=fork();
   die Rex::Logger::info("创建进程失败.",'error') if not defined $child;
   if($child){   # child >; 0, so we're the parent 
    $hash_pids{$child} = $child; 
    Rex::Logger::info("多进程文件传输: 父进程PID:$$ 子进程PID:$child");
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
        my $basename = basename $dir1;
        # print "\ndu -s $dir2/$basename  | awk '{print \$1}'\n";
        my $cmd_result = run "du -s $dir2/$basename  | awk '{print \$1}'";
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
    my $time_end=time();
    my $time =$time_end-$time_start; 
    Rex::Logger::info("传输完成,耗时: $time秒");

   sub upload_thread{
      my ($dir1,$dir2) = @_;
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
my $result = run "w";
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
