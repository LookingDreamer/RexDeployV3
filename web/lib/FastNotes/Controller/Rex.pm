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
use List::MoreUtils qw(uniq);
use Encode qw(encode_utf8);

my $log = Mojo::Log->new;


#查询rex模块列表
sub index {
    my ($self) = @_;
    my $cmd ;
    my $result;
    my %result;
    my $pwd;
    my $rex;
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
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

sub directruncmd {
    my ($self) = @_;
    my ($pwd,$rex,$cmd,$precmd,$requestCmd,$yaml,$stdout,$respon,$result,%result,@cmdArray);
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $pwd = $self->param('pwd');
    $rex = $self->param('rex');
    $precmd = $self->param('precmd');
    $requestCmd = $self->param('cmd');
    my $start = time();
    if (defined $pwd && defined $rex) {
        $log->info("传参 pwd:" . $pwd . " rex:".$rex);
    }else{
        $rex =  $self->app->defaults->{"config"}->{"rex"};
        $pwd =  $self->app->defaults->{"config"}->{"pwd"};        
    }
    if ( ! defined $precmd ){
        $precmd = " -qF ";
    }else{
        $precmd =~ s/,/ /i; 
        $precmd = " -qF ".$precmd;
    }
    if ( ! defined $requestCmd || "$requestCmd" eq "" ){
        $result{"code"} = 3 ;
        $result{"msg"} = "cmd参数没有传递" ;
        $log->error("cmd参数没有传递");
    }else{
        @cmdArray = split(",",$requestCmd);
        $cmd = join(" ",@cmdArray);
        $cmd = $rex." ".$precmd." ".$cmd;
        eval {
            $respon = run($cmd,$pwd);
        };
        if ($@) {
            $result{"code"} = 2 ;
            $result{"msg"} = "执行异常: $@" ;
            $log->error("执行异常: $@");
        }   
        $log->info("返回结果:".Dumper($respon));
        $stdout = $respon->{"stdout"};
        my $decoded_json ;
        if ( $stdout ne "" ) {
            $stdout = $respon->{"stdout"};
            eval {
                my $data_json = qq( $stdout );
                $decoded_json = decode_json(encode_utf8($data_json));
                # $decoded_json = decode_json($stdout);
            };
            if ($@) {
                $result{"code"} = -1 ;
                $result{"msg"} = "解析返回JSON异常 $@" ;
                $log->error("解析返回JSON异常: $@");
            }  
        }

        $result{"data"} = $decoded_json;   
        # $yaml = Load($stdout);  
        # $result{"data"} = $yaml;   
        $result{"respon"} = $respon;   
    }

    my $end = time();
    my $take = $end - $start;
    # say Dumper(ref $result);
    $result{"take"} = $take;
    $result{"code"} = 0 ;
    $self->render(json => \%result);
}

#执行命令模块
sub runcmd {
    my ($self) = @_;
    my ($pwd,$rex,$cmd,$precmd,$requestCmd,$yaml,$stdout,$respon,$result,$is_direct_run_status,$decoded_json,%result,@cmdArray);
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $pwd = $self->param('pwd');
    $rex = $self->param('rex');
    my $print = $self->param('sprint');
    my $debug = $self->param('debug');
    my @all_param_names = @{$self->req->params->names};
    my $param = $self->req->params->to_hash;
    $log->info("获取post参数".encode_json($param));
    $result{"param"} = $param ;
    my $allow =  $self->app->defaults->{"config"}->{"allow"}; 
    my $print_stdout =  $self->app->defaults->{"config"}->{"print_stdout"}; 
    my $precmdAllow =  $self->app->defaults->{"config"}->{"precmdAllow"}; 
    my $parseparameters = parseparameters($param,$allow,$precmdAllow,\@all_param_names);
    $result{"parseparameters"} = $parseparameters ;
    $precmd = $parseparameters->{precmd};
    $requestCmd = $parseparameters->{requestCmd};
    $result{"code"} = 0 ;
    $result{"print_stdout"} = $print_stdout ;
    my $start = time();
    if (defined $pwd && defined $rex) {
        $log->info("pwd:" . $pwd . " rex:".$rex);
    }else{
        $rex =  $self->app->defaults->{"config"}->{"rex"};
        $pwd =  $self->app->defaults->{"config"}->{"pwd"};  
        $log->info("pwd:" . $pwd . " rex:".$rex);      
    }

    if ( ! defined $precmd ||  $precmd eq ""){
        if ( $debug ) {
            $precmd = " -F ";
        }else{
            $precmd = " -qF ";
        }
        
    }else{
        if ($debug) {
            $precmd =~ s/,/ /i; 
            $precmd = " -F ".$precmd;
        }else{
            $precmd =~ s/,/ /i; 
            $precmd = " -qF ".$precmd;            
        }

    }

    if($parseparameters->{code} !=  0 ){
        $log->error("校验和解析参数失败: " .$parseparameters->{msg});
        $result{"code"} = -1 ;
        $result{"msg"} = "校验和解析参数失败: " .$parseparameters->{msg};
    }

    eval {
        if ( $result{"code"} == 0 ) {
            if(! defined $requestCmd || "$requestCmd" eq "" ){
                $result{"code"} = -3 ;
                $result{"msg"} = "解析后cmd参数为空" ;
                $log->error("解析后cmd参数为空");
            }else{
                @cmdArray = split(",",$requestCmd);
                $cmd = join(" ",@cmdArray);
                $cmd = $rex." ".$precmd." ".$cmd;
                $log->info("cmd: $cmd");            
                $respon = run($cmd,$pwd);        
            }

        }       
    };
    if ($@) {
        $result{"code"} = 2 ;
        $result{"msg"} = "执行异常: $@" ;
        $log->error("执行异常: $@");
    }   
    $log->info("返回结果:".Dumper($respon));
    
    if ( $respon ) {
        my $stdout;
        $stdout = $respon->{"stdout"};
        if ( $stdout ne "" ) {    
            eval {
                $decoded_json = decode_json($stdout);
            };
            if ($@) {
                $result{"code"} = -1 ;
                $result{"msg"} = "解析返回JSON异常 $@" ;
                $log->error("解析返回JSON异常: $@");
            }  
        }          
    } 

    $result{"data"} = $decoded_json;     
    $result{"respon"} = $respon;   
    my $end = time();
    my $take = $end - $start;
    $result{"take"} = $take;
    if ( ! defined $print ||  $print eq ""){
        if ( $print_stdout ==  0 ) {
            $result{"respon"}{"stdout"} = "" ;
        }        
    }

    $self->render(json => \%result);
}


sub  parseparameters{
    my ($paramsHash,$allow,$precmdAllow,$paramsArray) = @_;
    my (%reshash,@paramsArray,$count,$action,$requestCmd,$precmd,@requestCmd,@precmd);
    @paramsArray = @$paramsArray;
    $count =  @paramsArray;
    my @precmdAllow = @$precmdAllow;
    if ( $count ==  0 ) {
        $reshash{"code"} = -1 ;
        $reshash{"msg"} = "post参数为空" ;
        return \%reshash;
    }
    if( ! grep { $_ eq "action" } @paramsArray){  
        $log->error("action参数不能为空");
        $reshash{"code"} = -1 ;
        $reshash{"msg"} = "action参数不能为空" ;
        return \%reshash;
    }  
    my $action;
    $action = $paramsHash->{action};
    $log->info("action: $action");
    $log->info("转换POST参数: @paramsArray");

    my @allow = @$allow;
    my $action_status = 0 ;
    my $mustParams_status = 0 ;
    my $mustOneParams_status = 0 ;
    for my $allowData (@allow){
        my $allowaction = $allowData->{action};
        my $mustParams = $allowData->{mustParams};
        my $mustOneParams = $allowData->{mustOneParams};
        $allowaction =~ s/ //g;  
        $mustParams =~ s/ //g;  
        $mustOneParams =~ s/ //g;  
        if ( "$allowaction" eq "$action" ) {
            $action_status = $action_status + 1 ;
            if ( "$mustParams" ne "" ) {
               my @mustParamsArray = split(",",$mustParams); 
               push @mustParamsArray,"action";
               my $number = uniq @paramsArray,@mustParamsArray;
               if ( $number != uniq(@paramsArray) ) {
                    $log->error("当执行 $action 模块时,post参数为空,必须传参: $mustParams");
                    $reshash{"code"} = -1 ;
                    $reshash{"msg"} = "当执行 $action 模块时,post参数为空,必须传参: $mustParams" ;
                    return \%reshash;
               }
            }else{
                $mustParams_status = $mustParams_status + 1 ;  
            }

            if ( "$mustOneParams" ne "" ) {
                my @mustOneParamsArray = @$mustOneParams ; 
                for my $mustOne (@mustOneParamsArray){
                     my @mustArray = @$mustOne;
                     my $muststr = join(",",@mustArray);
                     my $must = 0 ;
                     my $mustCount = @mustArray ;
                     for my $one (@mustArray){
                        if(  grep { $_ eq "$one" } @paramsArray){
                            $must = $must + 1;  
                        }  
                     }
                     if ( $mustCount > 0  ) {
                        if ( $must != 1  ) {
                            $log->error("当执行 $action 模块时,post前置参数为空,必须传单个参: $muststr");
                            $reshash{"code"} = -1 ;
                            $reshash{"msg"} = "当执行 $action 模块时,post前置参数为空,必须传单个参: $muststr" ;
                            return \%reshash;
                        }
                     }  
                }
            }else{
                $mustOneParams_status = $mustOneParams_status + 1 ;  
            }

        }

    }

    if( $action_status == 0 ){
        $log->error("不支持的action参数: $action");
        $reshash{"code"} = -1 ;
        $reshash{"msg"} = "不支持的action参数: $action";
        return \%reshash;
    }
    #重新组合cmd
    push @requestCmd,$paramsHash->{action} ;
    my $precmdVar;
    for my $param (@paramsArray){
        $param =~ s/ //g; 
        if(grep { $_ eq "$param" } @precmdAllow){
            my $preParam ;
            if ( $paramsHash->{$param} eq "" ) {
                $preParam = "-".$param  ;
            }else{
                $preParam = "-".$param ." \"".$paramsHash->{$param}."\"" ;
            }
            
            push @precmd,$preParam ;
        }else{
            if ( "$param" ne "action") {
                my $singeParam = "--".$param ."=\"".$paramsHash->{$param}."\"";
                push @requestCmd,$singeParam;
            }
        }

    }
    push @requestCmd,"--w=\"1\"" ;
    my  $requestCmdVar = join(",",@requestCmd);
    my  $precmdVar = join(",",@precmd);
    $log->info("重新组合cmd: $requestCmdVar");
    $log->info("重新组合precmd: $precmdVar");
    $reshash{"requestCmd"} = $requestCmdVar;
    $reshash{"precmd"} = $precmdVar ;
    $reshash{"code"} = 0 ;
    $reshash{"msg"} = "校验和解析参数成功" ;
    return \%reshash;
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
    if ( ! -e  "$chdir"  ) {
        $log->error("执行目录: $chdir 不存在");
        $data{"code"} = 0;
        $data{"msg"} = "执行目录: $chdir 不存在";          
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
