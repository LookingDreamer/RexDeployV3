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

desc "用户管理路由
1.0 查询列表 rex User:main:route --action='list'
2.0 查询用户 rex User:main:route --action='query' --user='test'
3.1 创建普通用户 rex User:main:route --action='create' --user='test' 
3.2 创建秘钥用户(固定秘钥,无密码) rex User:main:route --action='create' --user='test' --level='1'
3.3 创建普通用户(随机秘钥,无密码) rex User:main:route --action='create' --user='test' --level='2'
3.4 创建普通用户(随机秘钥,有密码) rex User:main:route --action='create' --user='test' --level='3' --pass='testabc123456'
3.5 通用参数 --sudo=1 开启sudo 加入wheel组
3.6 通用参数 --allow=1 加入ssh allow,允许登陆
4.0 删除用户 rex User:main:route --action='delete' --user='test'
5.0 锁定用户 rex User:main:route --action='lock' --user='test'
";
task "route", sub {
	my $self = shift;
	my $user=$self->{user};
	my $action=$self->{action};
	my $level=$self->{level};
	my $sudo=$self->{sudo};
	my $pass=$self->{pass};
	my $allow=$self->{allow};
	Rex::Logger::info("user参数: $user action参数: $action");
	if ( $action ne 'list' ) {
		if ($user eq "" or $action eq "" ) {
			Rex::Logger::info("用户名或动作不能为空","error");
			exit;
		}
	}

	if ($level eq "") {
		$level = 0;
	}
	if ($sudo eq "") {
		$sudo = 0;
	}	
	if ($pass eq "") {
		$pass = 0;
	}
	if ($allow eq "") {
		$allow = 0;
	}	
	Rex::Logger::info("level参数: $level sudo参数: $sudo pass参数:$pass");
	my @action_list = ('query' ,'create' ,'delete','lock','list');
	my $action_status = 0 ;
	for my $kv (@action_list) {
		if ( $kv eq "$action") {
			$action_status = 1 ;
		}
	}
	my $action_string = join( ",", @action_list); 
	if ($action_status eq "0"){
		Rex::Logger::info("action参数仅支持$action_string","error");
		exit;
	}
	if ( $action eq "query") {
		queryUser($user);
	}elsif($action eq "create"){
		my $query = queryUser($user); 
		createUser($user,$level,$query,$sudo,$pass,$allow);
	}elsif($action eq "delete"){
		deleteUser($user);
	}elsif($action eq "lock"){
		forbitUser($user);
	}elsif($action eq "list"){
		listUser();
	}else{
		Rex::Logger::info("不支持的action","error");
		exit;		
	}
	
};

#level参数,密码认证:0代表普通用户密码为用户名+2017654321
#level参数,秘钥认证:1有秘钥,秘钥是无密码的 sudo为1时,加入sudo 秘钥为默认的固定秘钥
#level参数,秘钥认证:2有秘钥,秘钥是无密码的 sudo为1时,加入sudo 秘钥为随机生成rsa秘钥
#level参数,秘钥认证:3有秘钥,秘钥是有密码的 sudo为1时,加入sudo 秘钥为随机生成rsa秘钥，且有密码
# "创建用户";
sub createUser{
	my $user = @_[0];	
	my $level = @_[1];	
	my $query = @_[2];
	my $sudo = @_[3];
	my $pass = @_[4];
	my $allow = @_[5];
	if ( $query eq "0" ) {
		if ( $level eq "0") {
			create($user);
			if ($allow eq "1") {
				append_allow($user);
			}
		}elsif($level eq "1" or $level eq "2" or $level eq "3"){
			my $res = create($user);
			if ( $res eq "0") {
				exit;
			}
			create_authorized_keys($user,$level,$pass);
			if ($sudo eq "1") {
				create_sudo($user);
			}
			if ($allow eq "1") {
				append_allow($user);
			}			
		}else{
			Rex::Logger::info("level参数仅支持0,1,2,3","error");
			exit;
		}
		
	}else{
		Rex::Logger::info("用户已经存在");
	}	

};

sub create{
	my $user = @_[0];
	my $cmd;
	my $group_cmd = "egrep '\^$user\:' /etc/group &&  result=\$? ;echo status=\$result";
	Rex::Logger::info("__SUB__:开始创建普通用户"); 
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

sub general_key{
	my $user = @_[0];
	my $pass = @_[1];
	my $cmd;
	Rex::Logger::info("__SUB__:开始生成秘钥文件"); 
	if ( $pass eq "0") {
		$cmd = "mkdir -p /tmp/$user/$random ; ssh-keygen -t rsa -f /tmp/$user/$random/$user  -P '' &&  result=\$? ;echo status=\$result" ;
	}else{
		Rex::Logger::info("秘钥密码:$pass");
		$cmd = "mkdir -p /tmp/$user/$random ; ssh-keygen -t rsa -f /tmp/$user/$random/$user  -P '$pass' &&  result=\$? ;echo status=\$result" ;
	}
	Rex::Logger::info("开始生成秘钥");
	Rex::Logger::info("cmd:$cmd");
	my $res = run "$cmd";
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("秘钥路径: /tmp/$user/$random/");
		Rex::Logger::info("生成秘钥成功");
		return 1;
	}else{
		Rex::Logger::info("生成秘钥失败","error");
		exit;
	}

}


sub append_allow{
	my $user = @_[0];
	my $cmd ;
	my $cmd1 ;
	my $cmd2 ;
	$cmd1 = "cat /etc/ssh/sshd_config |grep AllowUsers |grep ' $user' &&  result=\$? ;echo status=\$result" ;
	$cmd2 = "cat /etc/ssh/sshd_config |grep AllowUsers |grep ' $user\$' &&  result=\$? ;echo status=\$result" ;
	$cmd = "sed -i 's/AllowUsers/AllowUsers $user /g' /etc/ssh/sshd_config" ;
	Rex::Logger::info("__SUB__:开始添加allow至sshd配置文件"); 
	Rex::Logger::info("开始把用户 $user 添加至allow");
	Rex::Logger::info("cmd:$cmd");
	my $res1 = run "$cmd1";
	my $res2 = run "$cmd2";
	if ( $res1 =~ /status=0/ or $res2 =~ /status=0/ ) {
		Rex::Logger::info("该用户已经添加,无需重复添加.");
		return 0;
	}else{
		my $res = run "$cmd";
		if ( $res =~ /status=0/ ) {
			Rex::Logger::info("添加成功");
			return 1;
		}else{
			Rex::Logger::info("添加失败","error");
			return 0;
		}
		
	}		
}


sub create_authorized_keys{
	my $user = @_[0];
	my $level = @_[1];
	my $pass = @_[2];
	my $cmd;
	Rex::Logger::info("__SUB__:开始创建秘钥并写入用户ssh主目录"); 
	if ( $level eq "1") {
		$cmd = "mkdir /home/$user/.ssh ;echo $common_public_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;
	}elsif($level eq "2"){
		my $key = general_key($user);
		my $common_public_key = run "cat /tmp/$user/$random/$user\.pub" ;
		$cmd = "mkdir /home/$user/.ssh ;echo $common_public_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;
	}elsif($level eq "3"){
		my $key = general_key($user,$pass);
		my $common_public_key = run "cat /tmp/$user/$random/$user\.pub" ;	
		if ( $pass ne 0) {
			if ( length($pass) < 8 ) {
				Rex::Logger::info("密码为真时必须大于8个长度","error");
				exit;
			}
		}
		$cmd = "mkdir /home/$user/.ssh ;echo $common_public_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;	

	}
	
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
	my $cmd = "usermod -g 10 $user &&  result=\$? ;echo status=\$result" ;
	Rex::Logger::info("__SUB__:开始添加sudo权限"); 
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
	Rex::Logger::info("__SUB__:开始查询用户"); 
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
	my $user = @_[0];
	my $server = Rex->get_current_connection()->{'server'};
	my $res =  run "userdel -rf $user && result=\$? ;echo status=\$result";
	Rex::Logger::info("__SUB__:开始删除用户"); 
	Rex::Logger::info("当前服务器: $server");
	Rex::Logger::info("返回命令结果: $res");
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("删除用户$user成功");
		return 1;
	}else{
		Rex::Logger::info("删除用户$user失败","warn");
		return 0;
	}
};

# "禁用用户";
sub forbitUser {
	my $user = @_[0];
	my $server = Rex->get_current_connection()->{'server'};
	my $cmd = "usermod -s /sbin/nologin $user && result=\$? ;echo status=\$result";
	my $res =  run "$cmd";
	Rex::Logger::info("__SUB__:开始锁定用户"); 
	Rex::Logger::info("当前服务器: $server");
	Rex::Logger::info("当前命令: $cmd ");
	Rex::Logger::info("返回命令结果: $res");
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("锁定用户$user成功");
		return 1;
	}else{
		Rex::Logger::info("锁定用户$user失败","warn");
		return 0;
	}
};

# "查询用户列表";
sub listUser {
	my $server = Rex->get_current_connection()->{'server'};
	my $cmd = "cat /etc/passwd |awk -F':' '\$3>=500' |awk -F: '{print \$1,\$NF}'  |column -t  && result=\$? ;echo status=\$result";
	my $res =  run "$cmd";
	Rex::Logger::info("__SUB__:开始查询用户列表"); 
	Rex::Logger::info("当前服务器: $server");
	Rex::Logger::info("当前命令: $cmd ");
	Rex::Logger::info("返回命令结果: \n$res");
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("查询用户列表成功");
		return 1;
	}else{
		Rex::Logger::info("查询用户列表失败","warn");
		return 0;
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