package User::main;

use Rex -base;
use Rex::Commands::User;

my $env;
my $common_public_key;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key} ;
 });

Rex::Config->register_config_handler("$env", sub {
 my ($param) = @_;
 $common_public_key = $param->{common_public_key} ;
 });
my $random = get_random(10, 'a' .. 'z') ;

desc "用户管理路由";
task "route", sub {
	my $self = shift;
	my $user=$self->{user};
	my $action=$self->{action};
	my $level=$self->{level};
	my $sudo=$self->{sudo};
	Rex::Logger::info("user参数: $user action参数: $action");
	if ($user eq "" or $action eq "" ) {
		Rex::Logger::info("用户名或动作不能为空","error");
		exit;
	}
	if ($level eq "") {
		$level = 0;
	}
	if ($sudo eq "") {
		$sudo = 0;
	}	
	Rex::Logger::info("level参数: $level sudo参数: $sudo");
	my @action_list = ('query' ,'create' ,'delete','lock');
	my $action_status = $action ~~ @action_list;
	my $action_string = join( ",", @action_list); 
	if ($action_status eq ""){
		Rex::Logger::info("action参数仅支持$action_string","error");
		exit;
	}
	if ( $action eq "query") {
		queryUser($user);
	}elsif($action eq "create"){
		my $query = queryUser($user); 
		createUser($user,$level,$query,$sudo);
	}
	
};

#level参数,密码认证:0代表普通用户密码为用户名+2017654321
#level参数,秘钥认证:1有秘钥,秘钥是无密码的 sudo为1时,加入sudo
#level参数,秘钥认证:2有秘钥,秘钥密码为用户名+2017654321 sudo为1时,加入sudo
# "创建用户";
sub createUser{
	my $user = @_[0];	
	my $level = @_[1];	
	my $query = @_[2];
	if ( $query eq "0" ) {
		if ( $level eq "0") {
			create($user);
		}elsif($level eq "1"){
			my $res = create($user);
			if ( $res eq "0") {
				exit;
			}
			create_authorized_keys($user);
			if ($sudo eq "1") {
				create_sudo($user);
			}
		}
		
	}else{
		Rex::Logger::info("用户已经存在");
	}	

};

sub create{
	my $user = @_[0];
	my $cmd;
	my $group_cmd = "egrep '\^$user\:' /etc/group &&  result=\$? ;echo status=\$result";
	Rex::Logger::info("cmd:$group_cmd");
	my $group = run "$group_cmd";
	Rex::Logger::info("cmd用户组判断:$group"); 
	if ( $group =~ /status=0/ ) {
		 $cmd = "useradd $user -g $user && echo $random | passwd --stdin $user &&  result=\$? ;echo status=\$result" ;
	}else{
		 $cmd = "useradd $user  && echo $random | passwd --stdin $user &&  result=\$? ;echo status=\$result" ;

	}
	Rex::Logger::info("开始创建普通用户:$user 密码:$random");
	Rex::Logger::info("cmd:$cmd");
	my $res = run "$cmd";
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("创建普通用户成功");
		return 1;
	}else{
		Rex::Logger::info("创建普通用户失败","error");
		return 0;
	}	
}

sub create_authorized_keys{
	my $user = @_[0];
	my $cmd = "mkdir /home/$user/.ssh ;echo $common_public_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;
	Rex::Logger::info("开始创建秘钥");
	Rex::Logger::info("cmd:$cmd");
	my $res = run "$cmd";
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("创建秘钥成功");
		return 1;
	}else{
		Rex::Logger::info("创建秘钥失败","error");
		return 0;
	}		
}

sub create_sudo{
	my $user = @_[0];
	my $cmd = "usermod -g 10 $user" ;
	Rex::Logger::info("开始添加sudo/wheel");
	Rex::Logger::info("cmd:$cmd");
	my $res = run "$cmd";
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("添加sudo成功");
		return 1;
	}else{
		Rex::Logger::info("添加sudo失败","error");
		return 0;
	}		
}

# "查询用户";
sub queryUser{
	my $user = @_[0];
	my $server = Rex->get_current_connection()->{'server'};
	my $res =  run "id $user && result=\$? ;echo status=\$result";
	Rex::Logger::info("当前服务器: $server");
	Rex::Logger::info("返回命令结果: $res");
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("$user 用户存在");
		return 1;
	}else{
		Rex::Logger::info("$user 用户不存在","warn");
		return 0;
	}

};

# "删除用户";
sub deleteUser{

};

# "禁用用户";
sub forbitUser {

};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

include qw/User::main/;

task yourtask => sub {
	User::main::example();
};

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut