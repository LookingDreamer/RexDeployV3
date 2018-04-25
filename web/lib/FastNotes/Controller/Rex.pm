package FastNotes::Controller::Rex;

use strict;
use warnings;
use v5.10;
use utf8;
use base 'Mojolicious::Controller';
use Data::Dumper;
use Mojo::Log;
use IPC::System::Options qw(system readpipe run);
use Data::Dumper;
use Mojo::Base 'Mojolicious::Plugin';
use YAML;
use Mojo::JSON qw(decode_json encode_json);

my $log = Mojo::Log->new;


#查询rex模块列表
sub index {
    my ($self) = @_;
    my $cmd ;
    my $result;
    my %result;
    my $pwd;
    my $rex;
    $pwd = $self->param('pwd');
    $rex = $self->param('rex');
    my $start = time();
    if (defined $pwd && defined $rex) {
        $log->info("传参 pwd:" . $pwd . " rex:".$rex);
    }else{
        $rex =  $self->app->defaults->{"config"}->{"rex"};
        $pwd =  $self->app->defaults->{"config"}->{"pwd"};        
    }

    $cmd = $rex." "."-FTy";
    
    eval {
        $result = run($cmd,$pwd);
    };
    if ($@) {
        $result{"code"} = 2 ;
        $result{"msg"} = "执行异常: $@" ;
        $log->error("执行异常: $@");
        $self->render(json => $result);
    }
    my $end = time();
    my $take = $end - $start;
    $log->info("返回结果:".Dumper($result));
    my $stdout = $result->{"stdout"};
    my $yaml = Load($stdout);
    $result->{"data"} = $yaml;
    # say Dumper($yaml);
    $result->{"take"} = $take;
    $self->render(json => $result);
}

#执行命令模块
sub runcmd {
    my ($self) = @_;
    my $cmd ;
    my $result;
    my %result;
    my $pwd;
    my $rex;
    my $cmd ;
    my $precmd;
    $pwd = $self->param('pwd');
    $rex = $self->param('rex');
    $precmd = $self->param('precmd');
    $cmd = $self->param('cmd');
    my $start = time();
    if (defined $pwd && defined $rex) {
        $log->info("传参 pwd:" . $pwd . " rex:".$rex);
    }else{
        $rex =  $self->app->defaults->{"config"}->{"rex"};
        $pwd =  $self->app->defaults->{"config"}->{"pwd"};        
    }
    if ( ! defined $precmd ){
        $precmd = " -q ";
    }
    if ( ! defined $cmd || "$cmd" eq "" ){
        $result{"code"} = 3 ;
        $result{"msg"} = "cmd参数没有传递" ;
        $log->error("cmd参数没有传递");
        return $self->render(json => $result);
        # return %result;
    }

    my @cmdArray = split(",",$cmd);
    $cmd = join(" ",@cmdArray);
    $cmd = $rex." ".$precmd." ".$cmd;
    
    eval {
        $result = run($cmd,$pwd);
    };
    if ($@) {
        $result{"code"} = 2 ;
        $result{"msg"} = "执行异常: $@" ;
        $log->error("执行异常: $@");
        $self->render(json => $result);
    }
    my $end = time();
    my $take = $end - $start;
    $log->info("返回结果:".Dumper($result));
    my $stdout = $result->{"stdout"};
    my $yaml = Load($stdout);
    $result->{"data"} = $yaml;
    # say Dumper($yaml);
    $result->{"take"} = $take;
    $self->render(json => $result);
}


#调用本地命令
sub run {
    my %data ;
    my ($cmd,$chdir) = @_;
    my $stdout;
    my $stderr;
    my $ret;
    $data{"cmd"} = $cmd;
    $data{"chdir"} = $chdir;
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
    $log->info("开始执行 $chdir=> $cmd");  
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
            $log->error("命令:$cmd 结果:失败 原因:$!");
        }elsif ($ret & 127) {
            $log->error("进程被终止 终止信号:",
                ($ret & 127),  ($ret & 128) ? 'with' : 'without');
        }else {
             $log->info("执行子进程退出值". $ret);
        }

    };
    $log->info("结束执行 $chdir=> $cmd");  
    if ($@) {
        $data{"code"} = 99;
        $data{"msg"} = "执行异常:$@";
        $log->error("执行异常:$@");
    }else{
        $data{"code"} = 1;
        $data{"msg"} = "执行完成";  
        $log->info("执行完成");    
    }

    $data{"ret"} = $ret;
    $data{"stdout"} = $stdout;
    $data{"stderr"} = $stderr;
    $data{"chdir"} = $chdir;
    return \%data;
}



1;
