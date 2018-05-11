package Predeploy::Judge;

use Rex -base;
use Deploy::Core;
use Rex -base;
use Deploy::Db;
use Rex::Commands;
use Rex::Commands::MD5;
use POSIX qw(strftime);
use feature qw(say);
use JSON;
use Data::Dumper;

desc "校验访问日志 \nrex  Predeploy:Judge:accesslog  --k='server1 server2 ..'";
task accesslog => sub {
    my $self = shift;
    my $k=$self->{k};
    my $log=$self->{log};
    my $keys=Deploy::Db::getallkey();
    my @keys=split(/,/, $keys);
    my %vars = map { $_ => 1 } @keys;
    my $lastnum=$keys[-1] - 1;
    if( $k eq ""  ){
        Rex::Logger::info("关键字(--k='')不能为空","error");
        exit;
    }
    my @ks = split(/ /, $k);
    my @md5Array;
    for my $kv (@ks) {
        if ( $kv ne "" ){
            if (exists($vars{$kv})){
                my %hash ; 
                my $config=Deploy::Core::init("$kv");
                my $logpath = $config->{"log_dir"};
                my $network_ip = $config->{"network_ip"};
                my $acc_log = $config->{"access_log"};
                my $config_dir = $config->{"config_dir"};
                my $server = Rex->get_current_connection()->{'server'};
                my $acc_log = tran_log($acc_log);
                $acc_log =~ s/ //;
                $acc_log =~ s/\n//;
                $hash{"k"} = $kv ;
                $hash{"network_ip"} = $network_ip ;

                if ( "$log"  ne "" ) {
                    $acc_log = $log ;
                }  
                if ( $acc_log eq "" ) {
                  $hash{"code"} = -1 ;
                  $hash{"msg"} = "accesslog is null" ;                  
                  Rex::Logger::info("($kv) 获取日志文件为空,请确认access_log是否正确配置","error");
                  push @md5Array,\%hash;
                  next;
                }
                Rex::Logger::info("($kv) 校验日志文件: $acc_log 地址: $network_ip ");
                my $consequence = run_task "Predeploy:Judge:FileMd5",on=>$network_ip,params=>{ acclog => $acc_log };
                if ( $consequence == -1 ) {
                  $hash{"code"} = -1 ;
                  $hash{"msg"} = "accesslog not exist" ;                    
                  Rex::Logger::info("($kv) 日志文件不存在: $acc_log","error");
                  push @md5Array,\%hash;
                  next;
                }

                my $md5 = run "echo $consequence|awk '{print \$1}'";
                Rex::Logger::info("($kv) 校验日志文件: $acc_log 地址: $network_ip  返回MD5: $md5 ");
                
                
                $hash{"accesslog"} = $acc_log  ;
                $hash{"md5"} = $md5 ;
                if ( "$md5"  eq "") {
                  $hash{"code"} = -1 ;
                  $hash{"msg"} = "get md5 faild" ;
                }else{
                  $hash{"code"} = 0 ;
                  $hash{"msg"} = "get md5 success" ;
                }
                push @md5Array,\%hash;
                # my ($md5judge,$msg) = tran_json($kv,$md5);
                # my $json = JSON->new;#->utf8;
                # my @hash = ();		  
                # push @hash ,{code=>$md5judge};
                # push @hash ,{msg=>$msg};
                # push @hash ,{data=>$kv};
                # print $json->encode(\@hash),"\n";  
            }else{
                Rex::Logger::info("关键字($kv)不存在","error");
            }
        }
    }
    say Dumper(@md5Array);
    return \@md5Array;


};

#校验返回md5
task "FileMd5", sub {
    my $self = shift;
    my $file = $self->{acclog};
    if ( ! is_file($file) ) {
      return -1;
    }
    my $logmd5 = run "md5sum $file";
    return $logmd5;
};


sub tran_log{
    my ($queryLogFile) = @_;
    my $log;
    if ( $queryLogFile =~ /#/ ) {
        my @queryLogFileList=split(/#/, $queryLogFile);
        my $today=strftime($queryLogFileList[1], localtime(time));
        my $LogFile="$queryLogFileList[0]$today$queryLogFileList[2]";
        $log="$LogFile";
    }else{
        $log="$queryLogFile";
    }
    return "$log\n";
};


sub tran_json{
    my ($kv,$md5) = @_;
    my $value = 1;
    my $msg;

    open d,">>logs/md5${kv}.txt";  # 文件不存在创建
    print d "$md5\n";
    close d; 
    # 1:不变为真，0:变为假
    my $md5judge = `[[ \$(cat logs/md5${kv}.txt|tail -2|head -1) == \$(cat logs/md5${kv}.txt|tail -1) ]] && echo -n 1 || echo -n 0`;
    if ($md5judge == 1){
        $msg = "访问日志md5值没有变化";
    }else {
        $msg = "访问日志md5值在变化";
    }
    return($md5judge,$msg);
};



1;




=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Predeploy::Judge/;

 task yourtask => sub {
    Predeploy::Judge::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
