#!/usr/bin/env perl
use IPC::System::Options qw(system readpipe run);
use Data::Dumper;

sub run {
    my %data ;
    my $cmd = "df -h";
    my $chdir = "/tmp";
    my $stdout;
    my $stderr;
    my $ret;

    if ( "$cmd"  eq  "") {
        $data{"code"} = 0;
        $data{"msg"} = "cmd命令不能为空";          
        return \%data;
    }
    if ( "$chdir"  eq  "") {
        $data{"code"} = 0;
        $data{"msg"} = "执行路径不能为空";          
        return \%data;
    }    
    eval {
        system({
            chdir => "$chdir", 
            die => 0,
            capture_stdout => \$stdout, 
            capture_stderr => \$stderr,
            lang=>"en_US.UTF-8",
            },
            $cmd);
        $ret = $?;
        if ($ret == -1) {
            print "命令:$cmd 结果:失败 原因:$!\n";
        }elsif ($ret & 127) {
            printf "进程被终止 终止信号:%d, %s coredump\n",
                ($ret & 127),  ($ret & 128) ? 'with' : 'without';
        }else {
            printf "执行子进程退出值 %d\n", $ret >> 8;
        }

    };
    if ($@) {
        $data{"code"} = 99;
        $data{"msg"} = "执行异常:$@";
    }else{
        $data{"code"} = 1;
        $data{"msg"} = "执行完成";      
    }

    $data{"ret"} = $ret;
    $data{"stdout"} = $stdout;
    $data{"stderr"} = $stderr;
    $data{"chdir"} = $chdir;
    return \%data;

}

run();