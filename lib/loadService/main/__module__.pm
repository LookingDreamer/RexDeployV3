package loadService::main;

use Rex -base;
use Data::Dumper;
use JSON qw( decode_json );
use Encode;
use URI::Escape;
use Rex::Commands::File;

my $env;
my $is_weight_allow;
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
        $is_weight_allow = $param->{is_weight_allow};
    }
);

desc "负载均衡查询 rex  loadService:main:query  --loadBalancerId='[负载均衡ID]'";
task query => sub {
   my $self = shift; 
   my $loadBalancerId = $self->{loadBalancerId}; 
   my $w = $self->{w}; 
   if( $loadBalancerId eq ""  ){
     Rex::Logger::info("关键字(--loadBalancerId='')不能为空");
     exit;
   }
   Rex::Logger::info("");
   Rex::Logger::info("开始查询负载均衡($loadBalancerId)列表状态,返回格式HASH对象");
   my $cmd = "qcloudcli lb DescribeLoadBalancerBackends --loadBalancerId \"$loadBalancerId\"";   
   my $output = run "$cmd";
   my $ret = decode_json($output);
   
   #Rex::Logger::info( Dumper($ret)) ;
   if($ret->{"code"} eq "4000"){
        Rex::Logger::info("查询负载均衡失败: ".$ret->{"codeDesc"}."\n".Dumper($ret),"error");
        return undef;
   }
   my @backendSet ;
   my $backendSetLen;
   eval {
        @backendSet = @{ $ret->{'backendSet'} };
        $backendSetLen = @backendSet;
   };
   if ($@) {
        Rex::Logger::info("解析子节点异常: $@","error");
        exit;
   }

   # Rex::Logger::info("实例数量: $backendSetLen");
   if( $backendSetLen == 0 ){
        Rex::Logger::info("查询负载均衡失败,返回实例数量为空","error");
        return undef;
   }
   return $ret;
};

desc "负载均衡查询 rex  loadService:main:queryk  --k='server1 server2 ..' --file='/tmp/save.txt'";
task queryk => sub {
   my $self = shift;
   my $k=$self->{k};
   my $file=$self->{file};
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;
   }
   if ( "$file" ne "" ) {
       if ( ! is_file($file) ) {
           my $fh;
           eval {
                $fh = file_append "$file";
            };
            if ($@) {
                Rex::Logger::info("写入文件:$file 异常:$@","error");
                exit;
            } 
           
           $fh->write("");
           $fh->close;
       }
   }
   my @ks = split(/ /, $k);
   Rex::Logger::info("");
   Rex::Logger::info("开始负载均衡查询模块.");
   for my $kv (@ks) {
       if ( $kv ne "" ){
           if (exists($vars{$kv})){
           Rex::Logger::info("");
           Rex::Logger::info("##############($kv)-(start)###############");

           my $config=Deploy::Core::init("$kv");
           my $loadBalancerId = $config->{"loadBalancerId"};
           my $network_ip = $config->{"network_ip"};
           my $network_ip = $config->{"network_ip"};
           Rex::Logger::info("获取到负载均衡ID: $loadBalancerId");
           #say Dumper($config);
           my @loadBalancerIdArray = split(/,/, $loadBalancerId);
           my $loadBalancerIdLength = @loadBalancerIdArray;
           Rex::Logger::info("该应用绑定了 ".$loadBalancerIdLength." 个负载均衡");
           my $i = 0 ;
           my @weightArray ;
           for my $loadBalance (@loadBalancerIdArray){
             my $loadInfo=run_task "loadService:main:query",params => { loadBalancerId => $loadBalance};
             my @backendSet ;
             my @backendSet = @{ $loadInfo->{'backendSet'} };
             my $backendSetLen = @backendSet;
             Rex::Logger::info("负载ID($loadBalance) 实例数量: $backendSetLen");
             foreach my $back ( @backendSet ) {
                 my $instanceName = $back->{"instanceName"};
                 my @wanIpSet = @{ $back->{"wanIpSet"} };
                 my $lanIp = $back->{"lanIp"};
                 my $weight = $back->{"weight"};
                 my $instanceId = $back->{"instanceId"};
                 utf8::encode($instanceName);  
                 if( "$lanIp"  eq "$network_ip" ){
                     $i = $i + 1;
                     Rex::Logger::info("第($i)个 实例名: $instanceName 外网IP: $wanIpSet[0] 内网IP: $lanIp 当前权重: $weight");
                     push @weightArray,$weight;
                     if ( "$file" ne "" ) {
                       my $fh;
                       eval {
                            $fh = file_append "$file";
                        };
                        if ($@) {
                            Rex::Logger::info("写入文件:$file 异常:$@","error");
                            exit;
                        } 
                       
                       $fh->write("$kv:$loadBalance:$network_ip:$weight\n");
                       $fh->close;

                     }
                 }
             }
           }
           my $weightString = join(",",@weightArray);;
           run_task "Deploy:Db:update_weight", params => { app_key => "$kv" ,weight=>"$weightString"};
           Rex::Logger::info("");        
           Rex::Logger::info("##############($kv)-(end)###############");
           Rex::Logger::info("");
           }else{
            Rex::Logger::info("关键字($kv)不存在","error");
           }
       }
   }
   Rex::Logger::info("");
   Rex::Logger::info("负载均衡查询模块完成.");
};


desc "负载均衡修改 rex  loadService:main:update  --k='server1 server2 ..' --w='[0-10]'";
task update => sub {
   my $self = shift;
   my $k=$self->{k};
   my $w=$self->{w};
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;
   }
   if( $w eq ""  ){
   Rex::Logger::info("关键字(--w='')不能为空","error");
   exit;
   } 
   my @ks = split(/ /, $k);
   Rex::Logger::info("");
   Rex::Logger::info("开始负载均衡修改模块.");
   for my $kv (@ks) {
       if ( $kv ne "" ){
           if (exists($vars{$kv})){
           Rex::Logger::info("");
           Rex::Logger::info("##############($kv)-(start)###############");

           my $config=Deploy::Core::init("$kv");
           my $loadBalancerId = $config->{"loadBalancerId"};
           my $network_ip = $config->{"network_ip"};
           Rex::Logger::info("获取到负载均衡ID: $loadBalancerId");
           #say Dumper($config);
           my @loadBalancerIdArray = split(/,/, $loadBalancerId);
           my $loadBalancerIdLength = @loadBalancerIdArray;
           Rex::Logger::info("该应用绑定了 ".$loadBalancerIdLength." 个负载均衡");
           my $i = 0 ;
           for my $loadBalance (@loadBalancerIdArray){
             my $loadInfo=run_task "loadService:main:query",params => { loadBalancerId => $loadBalance};
             my @backendSet ;
             my @backendSet = @{ $loadInfo->{'backendSet'} };
             my $backendSetLen = @backendSet;
             Rex::Logger::info("负载ID($loadBalance) 实例数量: $backendSetLen");
             #判断负载正在使用的子节点数量
             my @lanIpArray ;
             foreach my $back ( @backendSet ) {
               my $weight = $back->{"weight"};
               my $lanIp = $back->{"lanIp"};
               if( "$weight" ne "0"){
                  push @lanIpArray, $lanIp;
               }
             }
             my $lanIpLength = @lanIpArray;
             if ( "$lanIpLength" eq "1" && "$is_weight_allow" eq "1") {
                 if ( "$lanIpArray[0]" == "$network_ip" && "$w" eq "0") {
                     Rex::Logger::info("不允许摘掉最后1个节点,否则负载无法正常运转","error");
                     next;
                 }
             }

             foreach my $back ( @backendSet ) {
                 my $instanceName = $back->{"instanceName"};
                 my @wanIpSet = @{ $back->{"wanIpSet"} };
                 my $lanIp = $back->{"lanIp"};
                 my $weight = $back->{"weight"};
                 my $instanceId = $back->{"instanceId"};
                 utf8::encode($instanceName);  
                 if( "$lanIp"  eq "$network_ip" ){
                     Rex::Logger::info("实例名: $instanceName 外网IP: $wanIpSet[0] 内网IP: $lanIp 当前权重: $weight");
                     $i = $i + 1;
                     Rex::Logger::info("第$i个 负载ID($loadBalance) 匹配到内网IP($network_ip) 开始修改权重...");
                     loadEdit($loadBalance,$instanceId,$w);
                 }
             }

             select(undef, undef, undef, 0.25);
           }
           Rex::Logger::info("");        
           Rex::Logger::info("##############($kv)-(end)###############");
           Rex::Logger::info("");
           }else{
            Rex::Logger::info("关键字($kv)不存在","error");
           }
       }
   }
   Rex::Logger::info("");
   Rex::Logger::info("负载均衡修改模块完成.");
};



desc "校验url rex  loadService:main:check  --k='server1 server2 ..'";
task check => sub {
   my $self = shift;
   my $k=$self->{k};
   my $keys=Deploy::Db::getallkey();
   my @keys=split(/,/, $keys);
   my %vars = map { $_ => 1 } @keys;
   my $lastnum=$keys[-1] - 1;
   if( $k eq ""  ){
   Rex::Logger::info("关键字(--k='')不能为空","error");
   exit;
   } 
   my @ks = split(/ /, $k);
   Rex::Logger::info("");
   Rex::Logger::info("开始校验url模块.");
   for my $kv (@ks) {
       if ( $kv ne "" ){
           if (exists($vars{$kv})){
           Rex::Logger::info("");
           Rex::Logger::info("##############($kv)-(start)###############");

           my $config=Deploy::Core::init("$kv");
           my $network_ip = $config->{"network_ip"};
           my $url = $config->{"url"};
           my $header = $config->{"header"};
           my $params = $config->{"params"};
           my $require = $config->{"require"};
           my $requirecode = $config->{"requirecode"};
           #处理逻辑
           if ( "$url" eq "" ) {
               Rex::Logger::info("校验url不能为空","error");
               next;
           }
           my $res;
           if ( "$params" eq "" ) {
               $res=run_task "Common:Use:get",params => { url => $url,header=>$header};
           }else{
               $res=run_task "Common:Use:post",params => { url => $url,header=>$header,param=>$params};  
           }
           my @res = @$res; 
           my $code = $res[0];
           my $message = $res[1];
           Rex::Logger::info("校验返回码: $requirecode 校验返回内容: $require");
           if ( "$requirecode" ne "" ) {
               if ( "$code"  eq "$requirecode" ) {
                   Rex::Logger::info("校验返回码成功");
               }else{
                   run_task "Deploy:Db:update_checkurl_status", params => { app_key => "$kv" ,checkurl_status=>0};
                   Rex::Logger::info("校验返回码失败","error"); 
               }
           }
           if ( "$require" ne "" ) {
               if (  $message =~ m/$require/ ) {
                   Rex::Logger::info("校验返回内容成功");
               }else{
                   run_task "Deploy:Db:update_checkurl_status", params => { app_key => "$kv" ,checkurl_status=>0};
                   Rex::Logger::info("校验返回内容失败","error"); 
               }
           }

           Rex::Logger::info("");        
           Rex::Logger::info("##############($kv)-(end)###############");
           Rex::Logger::info("");
           }else{
            Rex::Logger::info("关键字($kv)不存在","error");
           }
       }
   }
   Rex::Logger::info("");
   Rex::Logger::info("校验url模块完成.");
};


sub loadEdit {
    my ($loadBalancerId,$instanceId,$weight) = @_;
    if( $loadBalancerId eq ""  ){
        Rex::Logger::info("修改权重时: loadBalancerId不能为空","error");
        exit;
    }  
    if( $instanceId eq ""  ){
        Rex::Logger::info("修改权重时: instanceId","error");
        exit;
    }  
    if( $weight eq ""  ){
        Rex::Logger::info("修改权重时: weight不能为空","error");
        exit;
    }    

    Rex::Logger::info("开始修改负载均衡:$loadBalancerId 实例ID:$instanceId 修改权重:$weight");
    my $cmd = "qcloudcli lb ModifyLoadBalancerBackends --loadBalancerId \"$loadBalancerId\" --backends '[{\"instanceId\":\"$instanceId\",\"weight\":\"$weight\"}]' ";
    my $output = run "$cmd";
    my $ret = decode_json($output);

    # Rex::Logger::info( Dumper($output)) ;
    # Rex::Logger::info( Dumper($ret)) ;
    if($ret->{"code"} eq "4000"){
        Rex::Logger::info("修改负载均衡失败: ".$ret->{"codeDesc"}."\n".Dumper($ret),"error");
        return undef;
    }elsif ($ret->{"code"} eq "0"){
        Rex::Logger::info("修改负载均衡权重成功");
    }
    Rex::Logger::info("修改负载均衡权重完成.");
    return $ret;
}

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/loadService::main/;

 task yourtask => sub {
    loadService::main::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
