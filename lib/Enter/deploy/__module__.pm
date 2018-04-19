package Enter::deploy;

use Rex -base;
use Data::Dumper;
use JSON qw( decode_json );
use Encode;
use URI::Escape;
use POSIX qw(strftime); 

my $env;
my $is_weixin;
my $is_qq;
my $weixin_config;
my $qq_config;
my $finish_qq_config;
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
        $is_weixin = $param->{is_weixin};
        $is_qq = $param->{is_qq};
        $weixin_config = $param->{weixin_config};
        $qq_config = $param->{qq_config};
        $finish_qq_config = $param->{finish_qq_config};
    }
);

task main => sub {
	my $k = "server1";
	my $is_finish = 0;
	my $weigts;
	my $datetime = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
	my $subject = "灰度发布-滚动发布(1)";
	my $content = "开始时间: $datetime 发布系统: $k";
	sendMsg($subject,$content,$is_finish);
	#1.摘取节点
	eval {
		run_task "loadService:main:update",params => { k => $k,w => 0};
		run_task "loadService:main:queryk",params => { k => $k};
		$weigts = run_task "Deploy:Db:query_weight",params => { k => $k};
		say Dumper($weigts);
	};
	if ($@) {
		Rex::Logger::info("($k) 摘取并保存权重数据异常:$@","error");
		sendMsg($subject,"error: 摘取并保存权重数据异常",$is_finish);
		exit;
	}


};

sub sendMsg{
	my ($subject,$content,$is_finish) = @_;
	sendWeixin($is_weixin,$weixin_config,$subject,$content);
	sendQQ($is_qq,$qq_config,$finish_qq_config,$content,$is_finish);	
}

sub sendWeixin{
	my ($is_weixin,$weixin_config,$subject,$content) = @_;
	my $weixin_config_obj;
	my $ret ;
	if ( $is_weixin eq "1" && "$subject" ne "" && "$content" ne "") {
		Rex::Logger::info("开始发送微信消息,微信主题: $subject 微信内容: $content");
		eval {
			$weixin_config_obj = decode_json($weixin_config);
		};
		if ($@) {
			Rex::Logger::info("解析微信配置异常,请确认微信配置项(weixin_config)是否为正确的json格式","error");
			return ;
		}
		if( $weixin_config_obj->{"params"} eq "" ){
			$ret = run_task "Common:Use:get",params => { url => $weixin_config_obj->{"url"}."&subject=$subject&content=$content",header=>$weixin_config_obj->{"header"}};
		}else{
			$ret = run_task "Common:Use:post",params => { url => $weixin_config_obj->{"url"},header=>$weixin_config_obj->{"header"},param=>'{"subject":"$subject","content":"$content"}'};			
		}
		
		Rex::Logger::info("结束发送微信消息,微信主题: $subject 微信内容: $content");
	}

}

sub sendQQ{
	my ($is_qq,$qq_config,$finish_qq_config,$content,$is_finish) = @_;
	my $qq_config_obj;
	my $ret ;
	if ( $is_qq eq "1"  && "$content" ne "") {
		Rex::Logger::info("开始发送QQ消息, 消息内容: $content");
		eval {
			if ( "$is_finish" eq "0") {
				$qq_config_obj = decode_json($qq_config);
			}else{
				$qq_config_obj = decode_json($finish_qq_config);
			}
			
		};
		if ($@) {
			Rex::Logger::info("解析QQ配置异常,请确认QQ配置项(qq_config)是否为正确的json格式","error");
			return ;
		}
		if( $qq_config_obj->{"params"} eq "" ){
			$ret = run_task "Common:Use:get",params => { url => $qq_config_obj->{"url"}."&content=$content",header=>$qq_config_obj->{"header"}};
		}else{
			$ret = run_task "Common:Use:post",params => { url => $qq_config_obj->{"url"},header=>$qq_config_obj->{"header"},param=>'{"content":"$content"}'};			
		}
		
		Rex::Logger::info("结束开始发送QQ消息, 消息内容: $content");
	}

}


1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Enter::deploy/;

 task yourtask => sub {
    Enter::deploy::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
