package Deploy::FirstConnect;

use Rex::Hardware;
use Rex -base;
use Data::Dumper;
use Mojo::JSON;
use Rex::Commands::Network;
use Rex::Commands::Service;
use File::Basename;

desc "获取远程服务器信息";
task getserinfo => sub {
    my $self = shift;
    my $pro_key = $self->{pro_key};
    my $pro_init = $self->{pro_init};
    my $pro_dir = $self->{pro_dir};
    my $config_dir = $self->{config_dir};
    my %myserinfo=();
    my $myserinfo ;
#   my $init_file= run_task "Deploy:Ps:isfile",params => { file => "$pro_init"};
    #进程 
    my $ps_num = run "ps aux |grep -v grep |grep -v sudo | grep '$pro_key' |wc -l" ; 
#   my $init_file = run "if [[ -f $pro_init ]];then echo 'exist-01';else echo 'no-01' ; fi";	
    $myserinfo{ps_num}=$ps_num;
    #启动文件
    if( is_file("$pro_init") ) {
    $myserinfo{pro_init}=1;
     }
     else {
    $myserinfo{pro_init}=0;
    }
    #应用程序和配置目录
    if( is_dir("$pro_dir") ){
    $myserinfo{pro_dir}=1;
    }else{
    $myserinfo{pro_dir}=0;
    }
    if( is_dir("$config_dir") ){
    $myserinfo{config_dir}=1;
    }else{
    $myserinfo{config_dir}=0;
    }
    

    return \%myserinfo;
};


desc "服务的控制";
task "services"=>sub{
    my $self = shift;
    my $config=$self->{config};
    my $pro_init=$config->{"pro_init"};    
    my $k=$config->{"app_key"};
    my $action=$config->{"action"};
    my $pro_key=$config->{"pro_key"};
    my $jsonfile=$config->{"jsonfile"};
    my $services_file=$config->{"services_file"};
    my $app_define_key=$config->{"app_define_key"};
    my $key=$config->{"key"};
    my $env;
    my $service_start_retry;
    Rex::Config->register_config_handler("env", sub {
       my ($param) = @_;
       $env = $param->{key} ;
       });
    Rex::Config->register_config_handler("$env", sub {
       my ($param) = @_;
       $service_start_retry = $param->{service_start_retry} ;
       });

    if($services_file ne ""){
       $pro_init = $services_file;
    }    
    if($key ne ""){
       $pro_key = $key;
    }
    if($services_file ne ""){
       if($key eq ""){
        Rex::Logger::info("自定义启动文件时,关键词不能为空:--key=''","error");
        return;
    }
    }
    $pro_init =~s/^ +//;
    $pro_init =~s/ +$//;
    if(!is_file($pro_init)){
        Rex::Logger::info("启动文件不存在:--f='$pro_init'","error");
        return;
    }
    if($action eq ""){
        Rex::Logger::info("启动方法为空:--a=''","error");
        return;
    }
    if($pro_key eq ""){
        Rex::Logger::info("进程关键词为空:--key=''","error");
        return;
    }

    my $processNumber=run "ps aux |grep '$pro_key' |grep -v grep |grep -v sudo |wc -l";
    if($action eq 'start'){
        if($processNumber == 0 ){
            my $result_start = start($pro_init,$pro_key,$service_start_retry);
            if($result_start eq '1'){
                Rex::Logger::info("应用启动成功.");
            }elsif($result_start eq  '2'){
                Rex::Logger::info("应用启动失败.","error");
            }elsif($result_start eq  '0'){
                Rex::Logger::info("进程已经处于启动的状态.","warn");
            }
        }else{
            Rex::Logger::info("进程已经处于启动的状态.","warn");
        }
    }
    if($action eq 'stop'){
        if($processNumber != 0 ){
            my $result_stop = stop($pro_init,$pro_key,$service_start_retry);
            if($result_stop eq '1'){
                Rex::Logger::info("应用关闭失败.","error");
            }elsif($result_stop eq  '2'){
                Rex::Logger::info("应用关闭成功.");
            }elsif($result_stop eq  '0'){
                Rex::Logger::info("进程已经处于关闭的状态.","warn");
            }
        }else{
            Rex::Logger::info("进程已经处于关闭的状态.","warn");
        }
    }
    if($action eq 'restart'){
       if($processNumber != 0 ){
            my $result_stop = stop($pro_init,$pro_key,$service_start_retry);
            if($result_stop eq '1'){
                Rex::Logger::info("应用关闭失败.","error");
            }elsif($result_stop eq  '2'){
                Rex::Logger::info("应用关闭成功.");
            }elsif($result_stop eq  '0'){
                Rex::Logger::info("进程已经处于关闭的状态.","warn");
            }
        }else{
            Rex::Logger::info("进程已经处于关闭的状态.","warn");
        }
        my $processNumber=run "ps aux |grep '$pro_key' |grep -v grep |grep -v sudo |wc -l";
        if($processNumber == 0 ){
            my $result_start = start($pro_init,$pro_key,$service_start_retry);
            if($result_start eq '1'){
                Rex::Logger::info("应用启动成功.");
            }elsif($result_start eq  '2'){
                Rex::Logger::info("应用启动失败.","error");
            }elsif($result_start eq  '0'){
                Rex::Logger::info("进程已经处于启动的状态.","warn");
            }
        }else{
            Rex::Logger::info("进程关闭失败,跳过启动.","error");
        } 

    }
    sub start{
       my ($pro_init,$pro_key,$service_start_retry) = @_;
       foreach my $i(1..$service_start_retry){
           my $processNumber=run "ps aux |grep $pro_key |grep -v grep |grep -v sudo |wc -l";
           if($processNumber ne '0' ){
                Rex::Logger::info("进程已存在:$processNumber","error");
                return '0';
                last;
           }else{
                # Rex::Logger::info("cmd($i): source /etc/profile ;  nohup /bin/bash $pro_init start  & > /dev/null");
                Rex::Logger::info("service($i): 开始启动应用....");
                #run "source /etc/profile ;  /bin/bash $pro_init start ";
                service "newservice",
                   ensure  => "started",
                   start   => "$pro_init start",
                   stop    => "killall $pro_key",
                   status  => "ps -efww | grep $pro_key",
                   restart => "killall $pro_key && $pro_init start",
                   reload  => "killall $pro_key && $pro_init start";
           }
           select(undef, undef, undef, 0.25);
           my $resultProcessNumber=run "ps aux |grep $pro_key |grep -v grep |grep -v sudo |wc -l";
           if($resultProcessNumber ne '0' ){
               return '1';
               last;
           }else{
               select(undef, undef, undef, 0.5);
               next; 
           }
       }
       return '2'; 
    }     
    sub stop{
       my ($pro_init,$pro_key,$service_start_retry) = @_;
       my $processNumber=run "ps aux |grep $pro_key |grep -v grep |grep -v sudo |wc -l";
       my $process=run "ps aux |grep $pro_key |grep -v grep |grep -v sudo |awk '{print \$2}' |xargs ";
       if($processNumber eq 0 ){
            Rex::Logger::info("进程已经停止","warn");
            return '0';
       }else{
            my  @process_list = split(' ',$process);
            foreach my $number(@process_list){
                run "kill -9 $number";
            }
       }
       select(undef, undef, undef, 0.25);
       my $resultProcessNumber=run "ps aux |grep $pro_key |grep -v grep |grep -v sudo |wc -l";
       if($resultProcessNumber ne '0' ){
           return '1';
       }else{
           return '2'; 
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

 include qw/Deploy::FirstConnect/;

 task yourtask => sub {
    Deploy::FirstConnect::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
