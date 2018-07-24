package User::main;

use Rex -base;
use Rex::Commands::User;

my $env;
my $common_public_key;
Rex::Config->register_config_handler("env", sub {
 my ($param) = @_;
 $env = $param->{key};
 my $envName = Rex::Config->get_envName;
 $env = $envName if ( $envName ) ;
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
3.3 创建秘钥用户(随机秘钥,无密码) rex User:main:route --action='create' --user='test' --level='2'
3.4 创建秘钥用户(随机秘钥,有密码) rex User:main:route --action='create' --user='test' --level='3' --pass='testabc123456'
3.5 通用参数 --sudo=1 开启sudo 加入wheel组
3.6 通用参数 --allow=1 加入ssh allow,允许登陆
3.7 仅支持'level=1,action=create'时 --dir='目录' dir为指定当前服务器秘钥目录
4.0 删除用户 rex User:main:route --action='delete' --user='test'
5.0 锁定用户 rex User:main:route --action='lock' --user='test'
6.0 生成秘钥 rex User:main:route --action='createkey' --user='test' --pass='testabc123456'
7.0 批量查询/删除/锁定/创建用户 rex User:main:route --action='query/delete/lock/createkey/create' --user='testa,testb' --batch='1' --level='1'
";
task "route", sub {
	my $self = shift;
	my $user=$self->{user};
	my $action=$self->{action};
	my $function=$self->{function};
	my $level=$self->{level};
	my $sudo=$self->{sudo};
	my $pass=$self->{pass};
	my $allow=$self->{allow};
	my $dir=$self->{dir};
	my $batch=$self->{batch};
	my $w=$self->{w};
	my $random=$self->{random};
	my %reshash ;
	if( $function  ne ""){
		$action = $function;
	}
	$reshash{"params"} = {
		user=>$user,
		action=>$action,
		level=>$level,
		sudo=>$sudo,
		pass=>$pass,
		allow=>$allow,
		dir=>$dir,
		batch=>$batch,
		w=>$w
	};
	Rex::Logger::info("user参数: $user action参数: $action");
	if ( $action ne 'list' ) {
		if ( $batch ne "" ) {
			if ($user eq "" or $action eq "" ) {
				Rex::Logger::info("用户名或动作不能为空","error");
				Common::Use::json($w,"","用户名或动作不能为空","");
				$reshash{"code"} = -1 ;
				$reshash{"msg"} = "action or user is null" ;
				return \%reshash;
			}
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
	if ($dir eq "") {
		$dir = 0;
	}	
	if ($batch eq "") {
		$batch = 0;
	}	
	Rex::Logger::info("level参数: $level sudo参数: $sudo pass参数:$pass allow参数: $allow dir参数:$dir batch参数:$batch");
	my $server = Rex->get_current_connection()->{'server'};
	Rex::Logger::info("服务器: $server");
	$reshash{"server"} = "$server";
	my @action_list = ('query' ,'create' ,'delete','lock','list','createkey');
	my $action_status = 0 ;
	for my $kv (@action_list) {
		if ( $kv eq "$action") {
			$action_status = 1 ;
		}
	}
	my $action_string = join( ",", @action_list); 
	if ($action_status eq "0"){
		Rex::Logger::info("action参数仅支持$action_string","error");
		Common::Use::json($w,"","action参数仅支持$action_string","");
		$reshash{"code"} = -1 ;
		$reshash{"msg"} = "action must in $action_string" ;
		return \%reshash;
	}

	if ( $level eq "1" and $action eq "create" and $dir ne "0" and $batch eq "0") {
		LOCAL{
				if( ! is_dir("$dir") ){
					Rex::Logger::info("秘钥目录不存在:$dir","error");
					Common::Use::json($w,"","秘钥目录不存在:$dir","");
					$reshash{"code"} = -1 ;
					$reshash{"msg"} = "private key dir $dir not exist" ;
					return \%reshash;
				}
				if ( ! is_file("$dir/$user\.pub") ) {
					Rex::Logger::info("公钥文件不存在:$dir/$user\.pub","error");
					Common::Use::json($w,"","公钥文件不存在:$dir/$user\.pub","");
					$reshash{"code"} = -1 ;
					$reshash{"msg"} = "public file: $dir/$user\.pub is not exist" ;
					return \%reshash;
				}
			}
	}elsif($level eq "1" and $action eq "create" and $dir ne "0" and $batch ne "0"){
		my @userlist=split(/,/,$user);
		for my $user (@userlist) {
			LOCAL{
					if( ! is_dir("$dir") ){
						Rex::Logger::info("秘钥目录不存在:$dir","error");
						Common::Use::json($w,"","秘钥目录不存在:$dir","");
						$reshash{"code"} = -1 ;
						$reshash{"msg"} = "private key dir $dir not exist" ;
						return \%reshash;
					}
					if ( ! is_file("$dir/$user\.pub") ) {
						Rex::Logger::info("公钥文件不存在:$dir/$user\.pub","error");
						Common::Use::json($w,"","公钥文件不存在:$dir/$user\.pub","");
						$reshash{"code"} = -1 ;
						$reshash{"msg"} = "public file: $dir/$user\.pub is not exist" ;
						return \%reshash;
					}
				}				
		}
	}

	
	if ($batch eq 0) {
		if ( $action eq "query") {
			my $query = queryUser($user);
			$reshash{"query"} = ["$query"];
		}elsif($action eq "create"){
			my $query = queryUser($user); 
			my $createUser = createUser($user,$level,$query,$sudo,$pass,$allow,$dir);
			$reshash{"query"} = [$query];
			$reshash{"createUser"} = [$createUser];
		}elsif($action eq "delete"){
			my $deleteUser = deleteUser($user);
			$reshash{"deleteUser"} = [$deleteUser];
		}elsif($action eq "lock"){
			my $forbitUser = forbitUser($user);
			$reshash{"forbitUser"} = [$forbitUser];
		}elsif($action eq "list"){
			my $list = listUser();
			$reshash{"listUser"} = $list ;
		}elsif($action eq "createkey"){
			my $key = general_key($user,$pass);
			$reshash{"general_key"} = [$key] ;
		}else{
			Rex::Logger::info("不支持的action","error");
			Common::Use::json($w,"","不支持的action","");
			$reshash{"code"} = -1 ;
			$reshash{"msg"} = "unsupport action" ;
			return \%reshash;	
		}

	}else{
		my @queryArray;
		my @createUserArray;
		my @deleteUserArray;
		my @forbitUserArray;
		my @general_keyArray;
		my @userlist=split(/,/,$user);
		for my $user (@userlist) {
	
			if ( $action eq "query") {
				my $query = queryUser($user);
				push @queryArray,$query;
			}elsif($action eq "create"){
				my $query = queryUser($user); 
				my $createUser = createUser($user,$level,$query,$sudo,$pass,$allow,$dir);
				push @queryArray,$query;
				push @createUserArray,$createUser;
			}elsif($action eq "delete"){
				my $deleteUser = deleteUser($user);
				push @deleteUserArray,$deleteUser;
			}elsif($action eq "lock"){
				my $forbitUser = forbitUser($user);
				push @forbitUserArray,$forbitUser;
			}elsif($action eq "createkey"){
				my $key = general_key($user,$pass,$batch);
				push @general_keyArray,$key;
			}
		};
		$reshash{"query"} = \@queryArray;
		$reshash{"createUser"} = \@createUserArray;
		$reshash{"deleteUser"} = \@deleteUserArray;
		$reshash{"forbitUser"} = \@forbitUserArray;
		$reshash{"general_key"} = \@general_keyArray;				
	}
	Common::Use::json($w,"0","成功",[\%reshash],$random);
	return \%reshash;

	
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
	my $dir = @_[6];
	my %hash ; 
	my $create ; 
	my $append_allow ; 
	my $create_sudo ; 
	my $create_authorized_keys ; 
	$hash{"createUserParams"} = {user=>$user,level=>$level,query=>$query,sudo=>$sudo,pass=>$pass,allow=>$allow,dir=>$dir};
	if ( $query eq "0" ) {
		if ( $level eq "0") {
			$create = create($user,$pass);
			$hash{"create"} = $create;
			if ( ! $create ) {
				Rex::Logger::info("创建普通用户:$user失败","error");
				$hash{"code"} = -1 ;
				$hash{"msg"} = "create user:$user faild" ;
				return \%hash;				
			}
			if ($allow eq "1") {
				$append_allow = append_allow($user);
				$hash{"append_allow"} = $append_allow;
				if ( ! $append_allow ) {
					Rex::Logger::info("添加sshd_config allow 失败","error");
					$hash{"code"} = -1 ;
					$hash{"msg"} = "append sshd_config allow $user faild" ;
					return \%hash;				
				}				
			}
			if ($sudo eq "1") {
				$create_sudo = create_sudo($user);
				$hash{"create_sudo"} = $create_sudo;				
				if ( ! $create_sudo ) {
					Rex::Logger::info("添加sudo wheel组失败","error");
					$hash{"code"} = -1 ;
					$hash{"msg"} = "append sudo wheel faild" ;
					return \%hash;				
				}					
			}
		}elsif($level eq "1" or $level eq "2" or $level eq "3"){
			my $res = create($user,$pass);
			$hash{"create"} = $res;
			if ( $res eq "0") {
				$hash{"code"} = -1 ;
				$hash{"msg"} = "create user faild." ;
				return \%hash;
			}
			$create_authorized_keys = create_authorized_keys($user,$level,$pass,$dir);
			$hash{"authorized_keys"} = $create_authorized_keys;
			if ( ! $create_authorized_keys ) {
				Rex::Logger::info("创建秘钥失败","error");
				$hash{"code"} = -1 ;
				$hash{"msg"} = "create private key faild" ;
				return \%hash;				
			}				
			if ($sudo eq "1") {
				$create_sudo = create_sudo($user);
				$hash{"create_sudo"} = $create_sudo;
				if ( ! $create_sudo ) {
					Rex::Logger::info("添加sudo wheel组失败","error");
					$hash{"code"} = -1 ;
					$hash{"msg"} = "append sudo wheel faild" ;
					return \%hash;				
				}				
			}
			if ($allow eq "1") {
				$append_allow  = append_allow($user);
				$hash{"append_allow"} = $append_allow;
				if ( ! $append_allow ) {
					Rex::Logger::info("添加sshd_config allow 失败","error");
					$hash{"code"} = -1 ;
					$hash{"msg"} = "append sshd_config allow $user faild" ;
					return \%hash;				
				}	

			}			
		}else{
			Rex::Logger::info("level参数仅支持0,1,2,3","error");
			$hash{"code"} = -1 ;
			$hash{"msg"} = "level must in 0,1,2,3" ;
			return \%hash;
		}
		
	}else{
		Rex::Logger::info("用户已经存在");
		$hash{"code"} = -1 ;
		$hash{"msg"} = "user already exist" ;
		return \%hash;		
	}	
	$hash{"code"} = 1 ;
	$hash{"msg"} = "success" ;
	return \%hash;

};

sub create{
	my $user = @_[0];
	my $pass = @_[1];
	my $cmd;
	my $group_cmd = "egrep '\^$user\:' /etc/group &&  result=\$? ;echo status=\$result";
	Rex::Logger::info("__SUB__:开始创建普通用户"); 
	Rex::Logger::info("cmd:$group_cmd");
	my $group = run "$group_cmd";
	Rex::Logger::info("cmd用户组判断:$group"); 
	if ( $group =~ /status=0/ ) {
		 if ( $pass eq "0" ) {
		 	$cmd = "useradd $user -g $user && echo $user | passwd --stdin $user &&  result=\$? ;echo status=\$result" ;
		 }else{
		 	$cmd = "useradd $user -g $user && echo $pass | passwd --stdin $user &&  result=\$? ;echo status=\$result" ;
		 }
	}else{
		 if ( $pass eq "0" ) {
		 	$cmd = "useradd $user  && echo $user | passwd --stdin $user &&  result=\$? ;echo status=\$result" ;
		 	}else{
		 	$cmd = "useradd $user  && echo $pass | passwd --stdin $user &&  result=\$? ;echo status=\$result" ;

		 	}

	}
	Rex::Logger::info("开始创建普通用户:$user");
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
	my $batch = @_[2];
	my $cmd;
	my $base_dir ;
	if ($batch eq 0 ) {
		$base_dir = "/tmp/$user/$random";
	}else{
		$base_dir = "/tmp/$random";
	}
	Rex::Logger::info("__SUB__:开始生成秘钥文件"); 
	if ( $pass eq "0") {
		$cmd = "mkdir -p $base_dir ; ssh-keygen -t rsa -f $base_dir/$user  -P '' &&  result=\$? ;echo status=\$result" ;
	}else{
		Rex::Logger::info("秘钥密码:$pass");
		$cmd = "mkdir -p $base_dir ; ssh-keygen -t rsa -f $base_dir/$user  -P '$pass' &&  result=\$? ;echo status=\$result" ;
	}
	Rex::Logger::info("开始生成秘钥");
	Rex::Logger::info("cmd:$cmd");
	my $res = run "$cmd";
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("秘钥路径: $base_dir");
		Rex::Logger::info("生成秘钥成功");
		return $base_dir;
	}else{
		Rex::Logger::info("生成秘钥失败","error");
		return 0;
	}

}


sub append_allow{
	my $user = @_[0];
	my $cmd ;
	my $cmd1 ;
	my $cmd2 ;
	$cmd1 = "cat /etc/ssh/sshd_config |grep AllowUsers |grep ' $user ' &&  result=\$? ;echo status=\$result" ;
	$cmd2 = "cat /etc/ssh/sshd_config |grep AllowUsers |grep ' $user\$' &&  result=\$? ;echo status=\$result" ;
	$cmd = "sed -i 's/AllowUsers/AllowUsers $user /g' /etc/ssh/sshd_config &&  result=\$? ;echo status=\$result" ;
	Rex::Logger::info("__SUB__:开始添加allow至sshd配置文件"); 
	Rex::Logger::info("开始把用户 $user 添加至allow");
	Rex::Logger::info("cmd:$cmd");
	my $res1 = run "$cmd1";
	my $res2 = run "$cmd2";
	if ( $res1 =~ /status=0/ or $res2 =~ /status=0/ ) {
		Rex::Logger::info("cmd1:$cmd1");
		Rex::Logger::info("cmd2:$cmd2");
		Rex::Logger::info("该用户已经添加,无需重复添加.");
		return 0;
	}else{
		my $res = run "$cmd";	
		if ( $res =~ /status=0/ ) {
			Rex::Logger::info("添加成功");
			run "service sshd restart";
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
	my $dir = @_[3];
	my $cmd;
	my $common_public_key;
	my $common_private_key;
	Rex::Logger::info("__SUB__:开始创建秘钥并写入用户ssh主目录"); 
	if ( $level eq "1") {
		if ( $dir  ne  "0") {
			LOCAL{
				my $publick_key = run "cat $dir/$user\.pub ";
				$cmd = "mkdir /home/$user/.ssh ;echo $publick_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;
			}
		}else{
			$cmd = "mkdir /home/$user/.ssh ;echo $common_public_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;
		}
		
	}elsif($level eq "2"){
		my $key = general_key($user,$pass);
		# $common_public_key = run "cat /tmp/$user/$random/$user\.pub" ;
		# $common_private_key = run "cat /tmp/$user/$random/$user" ;
		$common_public_key = run "cat /tmp/$random/$user\.pub" ;
		$common_private_key = run "cat /tmp/$random/$user" ;
		$cmd = "mkdir /home/$user/.ssh ;echo $common_public_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;
	}elsif($level eq "3"){
		my $key = general_key($user,$pass);
		$common_public_key = run "cat /tmp/$user/$random/$user\.pub" ;
		$common_private_key = run "cat /tmp/$user/$random/$user" ;	
		if ( $pass ne 0) {
			if ( length($pass) < 8 ) {
				Rex::Logger::info("密码为真时必须大于8个长度","error");
				return 0;
			}
		}
		$cmd = "mkdir /home/$user/.ssh ;echo $common_public_key > /home/$user/.ssh/authorized_keys ;chown $user:$user  /home/$user -R &&  result=\$? ;echo status=\$result" ;	

	}
	
	Rex::Logger::info("开始创建秘钥");
	Rex::Logger::info("cmd:$cmd");
	my $res = run "$cmd";
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("创建秘钥成功");
		if( $common_public_key ne "" and $common_private_key ne "" ){
			if ( is_dir("/tmp/$user/$random") ) {
				run "rm -rf /tmp/$user/$random ";
			}
			LOCAL{
				my $cmd1 = "mkdir -p /tmp/$user/$random && echo '$common_public_key' > /tmp/$user/$random/$user\.pub  && echo '$common_private_key' > /tmp/$user/$random/$user &&  result=\$? ;echo status=\$result ";
				my $res1 = run "$cmd1";
				Rex::Logger::info("保存秘钥到本地 res: $res1 ");
				if ( $res =~ /status=0/ ) {
					Rex::Logger::info("保存秘钥到本地成功: /tmp/$user/$random");
				}else{
					Rex::Logger::info("保存秘钥到本地失败: /tmp/$user/$random","error");
					return 0;
				}
			}
		}
		return "/tmp/$user/$random";
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
	my $res =  run "id $user > /dev/null 2>&1 && result=\$? ;echo status=\$result";
	Rex::Logger::info("__SUB__:开始查询用户"); 
	Rex::Logger::info("当前服务器: $server");
	Rex::Logger::info("返回命令结果: $res");
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("$user 用户存在");
		my $res =  run "id $user";
		return $res;
	}else{
		Rex::Logger::info("$user 用户不存在","warn");
		return 0;
	}

};

# "删除用户";
sub deleteUser{
	my $user = @_[0];
	my $server = Rex->get_current_connection()->{'server'};
	my $res =  run "userdel -rf $user > /dev/null 2>&1 && result=\$? ;echo status=\$result";
	Rex::Logger::info("__SUB__:开始删除用户"); 
	Rex::Logger::info("当前服务器: $server");
	Rex::Logger::info("返回命令结果: $res");
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("删除用户$user成功");
		return $user;
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
		return $user;
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
	my $result = run "cat /etc/passwd |awk -F':' '\$3>=500' |awk -F: '{print \$1,\$NF}' ";
	my @resultArray = split("\n",$result);
	if ( $res =~ /status=0/ ) {
		Rex::Logger::info("查询用户列表成功");
		return \@resultArray;
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
