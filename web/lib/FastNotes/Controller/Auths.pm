package FastNotes::Controller::Auths;

use strict;
use warnings;
use v5.10;
use utf8;
use Encode;
use POSIX qw(strftime); 

use base 'Mojolicious::Controller';


sub create {
    my ($self) = @_;

    my $login    = $self->param('login');
    my $password = $self->param('password');

    my $user = FastNotes::Model::User->select({login => $login, password=>$password})->hash();

    if ( $login  && $user->{user_id} ) {
        $self->session(
            user_id => $user->{user_id},
            login   => $user->{login}
        )->redirect_to('users_show');
    }
    else {
        $self->flash( error => 'Wrong password or user does not exist!' )->redirect_to('auths_create_form');
    }
}

sub delete {
    shift->session( user_id => '', login => '' )->redirect_to('auths_create_form');
}

sub check {
    shift->session('user_id') ? 1 : 0;
}

sub get_random {
  my $count = shift;
  my @chars = @_;

  srand();
  my $ret = "";
  for ( 1 .. $count ) {
    $ret .= $chars[ int( rand( scalar(@chars) - 1 ) ) ];
  }

  return $ret;
}


sub login {
    my ($self) = @_;
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    my $username = $self->param('username');
    my $password = $self->param('password');
    my %result ;
    my $start = time();
    $result{"params"} = {"username"=>"$username","password"=>"$password"};
    my $config =  $self->app->defaults->{"config"};
    if ( $config->{username} ne "$username") {
        $result{"msg"} = "用户名不正确";
        $result{"code"} = -1 ;
        return  $self->render(json => \%result);
    }   
    if ( $config->{password} ne "$password") {
        $result{"msg"} = "密码不正确";
        $result{"code"} = -1 ;
        return  $self->render(json => \%result);
    } 
    my $token = time().get_random( 32, 'a' .. 'z' );
    $result{"token"} =  $token;
    $result{"expire"} =  $config->{expire};
    $result{"code"} = 0 ;
    $result{"msg"} = "获取成功";
    my $end = time();
    my $endtime = strftime("%Y-%m-%d %H:%M:%S", localtime($end));
    $result{"time"} = {timestamp=>"$end",datetime=>"$endtime"};
    $result{"take"} = $end - $start;
    my $tokenRes = saveToken($token,$config->{expire},$end);
    $result{"saveToken"} = $tokenRes;
    $self->render(json => \%result);
}

sub token {
    my ($self) = @_;
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    my $token = $self->param('token');
    my %result ;
    my $config =  $self->app->defaults->{"config"};
    if ( ! defined $token || $token eq "" ) {
        $result{"msg"} = "token不能为空";
        $result{"code"} = -1 ;
        return  $self->render(json => \%result);
    }   
    $result{"timestamp"} =  time();
    $result{"token"} =  $token;
    $result{"expire"} =  $config->{expire};
    my $getToken = getToken($token);
    $result{"getToken"} = $getToken;
    $self->render(json => \%result);
}

sub getToken{
    my ($token) = @_;
    my %hash ;
    my $query_token = scalar FastNotes::Model::Token->select( { token => $token } )->hash ;
    $hash{"query"} = $query_token ;
    if( $query_token->{token} eq "") {
        $hash{"code"} = -1 ;
        $hash{"msg"} = "根据token查询数据为空" ; 
        return \%hash;      
    }
    my $timestamp = time();
    my $comptimestamp = $query_token->{timestamp} + $query_token->{expire} ;
    if ( $comptimestamp  <  $timestamp  ) {
        FastNotes::Model::Token->delete( {token => $token} );
        $hash{"code"} = -1 ;
        $hash{"msg"} = "token已经过期" ; 
        return \%hash; 
    }
    $hash{"code"} = 0 ;
    $hash{"msg"} = "token校验正常" ;
    return \%hash;
}

sub saveToken{
    my ($token,$expire,$timestamp) = @_;
    my %hash ;
    my %tokenhash = (
        token    => $token,
        expire => $expire,
        timestamp    => $timestamp
    );
    my $token_id = FastNotes::Model::Token->insert(\%tokenhash);
    my $query_token = scalar FastNotes::Model::Token->select( { token => $token } )->hash ;
    if( $query_token->{token} eq "$token") {
        $hash{"code"} = 0 ;
        $hash{"msg"} = "保存token成功" ;
    }else{
        $hash{"code"} = -1 ;
        $hash{"msg"} = "保存token失败" ;       
    }
    return \%hash;
}

sub checkapi {
    my ($self) = @_;
    my $token    = $self->param('token');
    my %result ;
    $result{"token"} = $token;
    my $getToken = getToken($token);
    my $code = $getToken->{code};
    if ( $code != 0 ) {
        $result{"code"} = -1;
        $result{"msg"} = "token校验不通过";
        $result{"getToken"} = $getToken;
        $self->render(json => \%result);
        shift->session('user_id') ? 0 : 0;
    }else{
        shift->session('user_id') ? 1 : 1;
    }   
}

1;

