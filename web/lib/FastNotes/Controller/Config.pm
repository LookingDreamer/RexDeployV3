package FastNotes::Controller::Config;

use strict;
use warnings;
use v5.10;
use utf8;
use base 'Mojolicious::Controller';
use Mojo::Log;
use Data::Dumper;
use Mojo::JSON qw(decode_json encode_json);
use YAML::Tiny;
use POSIX qw(strftime); 

my $log = Mojo::Log->new;


#配置文件查询
sub index {
    my ($self) = @_;
    my ($conf,$confFile,$res,$start_time,$section,$key,%result,@keyArray);
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $confFile = $self->param('confFile');
    $section = $self->param('section');
    $key = $self->param('key');
    $conf =  $self->app->defaults->{"config"}->{"rexConfig"};
    $start_time = strftime("%Y/%m/%d %H:%M:%S", localtime(time));
    $result{"start_time"} = $start_time;
    @keyArray = split(",",$key);
    my $start = time();
    if ($confFile) {
      $conf = $confFile;
    }
    $log->info("conf:".$conf);
    $result{"conf"} = $conf;
    $result{"param"} = {confFile=>$confFile,section=>$section,key=>\@keyArray};

    eval {
        $res = getYmlFile($conf,$section,\@keyArray)
    };
    if ($@) {
        $result{"code"} = 2 ;
        $result{"msg"} = "执行异常: $@" ;
        $log->error("执行异常: $@");
        $self->render(json => $res);
    }
    my $end = time();
    my $take = $end - $start;
    $log->info("返回结果:".Dumper($res));
    # my $stdout = $result->{"stdout"};
    # my $yaml = Load($stdout);
    $result{"data"} = $res;
    # say Dumper($yaml);
    $result{"take"} = $take;
    $result{"code"} = 0 ;
    $result{"msg"} = "成功" ;
    $self->render(json => \%result);
}

#配置文件添加
sub add {
    my ($self) = @_;
    my ($conf,$confFile,$res,$start_time,$section,$key,$isovewite,%result,@keyArray);
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $confFile = $self->param('confFile');
    $section = $self->param('section');
    $isovewite = $self->param('isovewite');
    $key = $self->param('key');
    $conf =  $self->app->defaults->{"config"}->{"rexConfig"};
    $start_time = strftime("%Y/%m/%d %H:%M:%S", localtime(time));
    $result{"start_time"} = $start_time;
    @keyArray = split(",",$key);
    my $start = time();
    if ($confFile) {
      $conf = $confFile;
    }
    $log->info("conf:".$conf);
    $result{"conf"} = $conf;
    $result{"param"} = {confFile=>$confFile,section=>$section,isovewite=>$isovewite,key=>\@keyArray};

    eval {
        $res = addYmlFile($conf,$section,\@keyArray,$isovewite)
    };
    if ($@) {
        $result{"code"} = 2 ;
        $result{"msg"} = "执行异常: $@" ;
        $log->error("执行异常: $@");
        $self->render(json => $res);
    }
    my $end = time();
    my $take = $end - $start;
    $log->info("返回结果:".Dumper($res));
    # my $stdout = $result->{"stdout"};
    # my $yaml = Load($stdout);
    $result{"data"} = $res;
    # say Dumper($yaml);
    $result{"take"} = $take;
    $result{"code"} = 0 ;
    $result{"msg"} = "成功" ;
    $self->render(json => \%result);
}

#配置文件删除
sub delete {
    my ($self) = @_;
    my ($conf,$confFile,$res,$start_time,$section,$key,%result,@keyArray);
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $confFile = $self->param('confFile');
    $section = $self->param('section');
    $key = $self->param('key');
    $conf =  $self->app->defaults->{"config"}->{"rexConfig"};
    $start_time = strftime("%Y/%m/%d %H:%M:%S", localtime(time));
    $result{"start_time"} = $start_time;
    @keyArray = split(",",$key);
    my $start = time();
    if ($confFile) {
      $conf = $confFile;
    }
    $log->info("conf:".$conf);
    $result{"conf"} = $conf;
    $result{"param"} = {confFile=>$confFile,section=>$section,key=>\@keyArray};

    eval {
        $res = deleteYmlFile($conf,$section,\@keyArray);
    };
    if ($@) {
        $result{"code"} = 2 ;
        $result{"msg"} = "执行异常: $@" ;
        $log->error("执行异常: $@");
        $self->render(json => $res);
    }
    my $end = time();
    my $take = $end - $start;
    $log->info("返回结果:".Dumper($res));
    # my $stdout = $result->{"stdout"};
    # my $yaml = Load($stdout);
    $result{"data"} = $res;
    # say Dumper($yaml);
    $result{"take"} = $take;
    $result{"code"} = 0 ;
    $result{"msg"} = "成功" ;
    $self->render(json => \%result);
}



sub parse {
  my (@lines) = @_;
  my $ini;

  my $section;
  for (@lines) {
    chomp;
    s/\n|\r//g;

    (/^#|^;|^\s*$/) && (next);

    if ( /^\[(.*)\]/ && !/^\[(\d+((?:,)|(?:\.\.))*)+(\/\d+)*\]/ ) {

      # check for inheritance
      $section = $1;
      $ini->{$section} = {};

      if ( $section =~ /</ ) {
        delete $ini->{$section};
        my @inherit = split( /</, $section );
        s/^\s*|\s*$//g for @inherit;
        $section = shift @inherit;

        for my $is (@inherit) {
          for my $ik ( keys %{ $ini->{$is} } ) {
            $ini->{$section}->{$ik} = $ini->{$is}->{$ik};
          }
        }
      }

      next;
    }

    my ( $key, $val ) = split( /[= ]/, $_, 2 );
    $key =~ s/^\s*|\s*$//g if $key;
    $val =~ s/^\s*|\s*$//g if $val;

    my @splitted;
    if ( !$val ) {
      $val      = $key;
      @splitted = ($key);
    }

    # commented out due to #184
    else {
      #@splitted = split(/\./, $key);
      @splitted = ($key);
    }

    my $ref  = $ini->{$section};
    my $last = pop @splitted;
    for my $sub (@splitted) {

      unless ( exists $ini->{$section}->{$sub} ) {
        $ini->{$section}->{$sub} = {};
      }

      $ref = $ini->{$section}->{$sub};
    }

    # include other group
    if ( $key =~ m/^\@(.*)/ ) {
      for my $ik ( keys %{ $ini->{$1} } ) {
        $ini->{$section}->{$ik} = $ini->{$1}->{$ik};
      }
      next;
    }

    if ( $val =~ m/\$\{(.*)\}/ ) {
      my $var_name = $1;
      my $ref      = $ini;
      my @splitted = split( /\./, $var_name );
      for my $s (@splitted) {
        $ref = $ref->{$s};
      }

      $val = $ref;
    }

    if ( $val =~ m/=/ ) {
      $val = { string2hash($val) };
    }

    $ref->{$last} = $val;

  }

  return $ini;
}



sub groups_file {
  my ($file) = @_;
  my $section;
  my %hash;
  my %group;
  open( my $INI, "<", "$file" ) || die "Can't open $file: $!\n";
  my @lines = <$INI>;
  chomp @lines;
  close($INI);
  my $hash = parse(@lines);
  for my $k ( keys %{$hash} ) {
    my @servers;
    for my $servername ( keys %{ $hash->{$k} } ) {
      push @servers, $servername;
    }
    $group{"$k"} =  \@servers;
  }
  return \%group;
}

sub write_groups_file{
  my ($file,$action,$deletecode,$delete) = @_;
  my $contentHash = groups_file($file);
  my @deleteArray = @{$delete};
  my $deleteCount = @deleteArray;
  my @keyArray;
  for my $key ( keys %{$contentHash} ) {
    push @keyArray, $key;
  }
  my %result ;
  $result{"params"} = {file=>$file,action=>$action,deletecode=>$deletecode,delete=>$delete};
  $result{"before"} = $contentHash;
  open( my $fh, ">", "$file" ) || die "Can't open $file: $!\n";
  if ( $action eq "add"  && $deleteCount > 0  ) {
    if ( ! grep /^$deletecode$/, @keyArray) {
      print "重新写入node $deletecode IP地址: @deleteArray \n";
      print $fh "[$deletecode]\n";
      for my $server ( @deleteArray ) {
        print $fh "$server\n";
      }      
    }

  }

  for my $k ( keys %{$contentHash} ) {
    if ( $action eq "delete" && $deletecode eq "0"  && $deleteCount > 0  ) {
      if ( grep /^$k$/, @deleteArray) {
        print "skip write $k\n";
        last;
      }
    }
    print $fh "[$k]\n";
    my @serverArray = @{$contentHash->{$k}};
    my @ipArray ;
    for my $servername (@serverArray){
      if ( $action eq "delete" && $deletecode eq "1"  && $deleteCount > 0  ) {
        if ( grep /^$k:$servername$/, @deleteArray) {
          print "skip write server:$servername  k:$k\n";
          last;
        }
      } 
      push @ipArray,$servername; 
      print $fh "$servername\n";
    }

    if ( $action eq "add"  && $deleteCount > 0  ) {
      if (  $deletecode eq "$k" ) {
        for my $server ( @deleteArray ) {
          if( ! grep /^$server$/, @ipArray){
            print "重新写ip $deletecode IP地址: @deleteArray\n";
            print $fh "$server\n";
          }
        }      
      }

    }

  }
  close $fh;
  my $newcontentHash = groups_file($file);
  $result{"after"} = $newcontentHash;
  print Dumper(\%result);

}

sub getYmlFile{
  my ($file,$section,$key) = @_;
  my %result; 
  my $yaml = YAML::Tiny->read( $file);
  my $config = $yaml->[0];
  my @keyArray = @$key;
  my $ketCount = @keyArray;
  # $result{"config"} = $config;
  my @data ; 

  if ( ! $section && $ketCount == 0 ) {
    $result{"config"} = $config;
    return \%result;
  }

  if ($section && $ketCount == 0 ) {
    for my $keystring (keys $config->{$section}){
      my %resHash = ($keystring=>$config->{$section}->{$keystring});
      push @data,\%resHash;
    }
    $result{"data"} = \@data;
    return \%result;
  } 
 
  for my $keystring (@keyArray){
    my %resHash = ($keystring=>$config->{$section}->{$keystring});
    push @data,\%resHash;
  }
  $result{"data"} = \@data;
  return \%result;  
}

sub addYmlFile{
  my ($file,$section,$key,$isovewite) = @_;
  my %result ;
  my @keyArray = @$key;
  my $ketCount = @keyArray;
  my $params = {file=>$file,section=>$section,key=>$key,isovewite=>$isovewite};
  if ( ! $section) {
    my %result = (code=>-1,msg=>"section不能为空",data=>[],params=>$params);
    return \%result;
  }
  if ($ketCount  == 0 ) {
    my %result = (code=>-1,msg=>"key不能为空",data=>[],params=>$params);
    return \%result;
  }
  for my $keyStr (@keyArray){
    my @keyVal = split(":",$keyStr);
    my $keyValCount = @keyVal;
    if ($keyValCount  != 2 ) {
      my %result = (code=>-1,msg=>"key格式不正确",data=>[],params=>$params);
      return \%result;
    }
    my $key = $keyVal[0];
    my $val = $keyVal[1]; 
    if ( $key  eq "") {
      my %result = (code=>-1,msg=>"解析key格式键为空:$key",data=>\@keyVal ,params=>$params);
      return \%result;
    }
    if ( $val  eq "") {
      my %result = (code=>-1,msg=>"解析key格式键值为空:$val",data=>\@keyVal,params=>$params);
      return \%result;
    }       
  }
  my $configObj = getYmlFile($file,"",[]);
  my $config = $configObj->{config};
  my @srcKeyArray = keys $config;
  $result{"srcconfig"} = $config;
  my $yaml = YAML::Tiny->read( $file); 
  $result{"is_add_code"} = 0; 
  if ( ! grep /^$section$/, @srcKeyArray) {
    for my $keyStr (@keyArray){
      my @keyVal = split(":",$keyStr);
      my $keyValCount = @keyVal;
      if ($keyValCount  != 2 ) {
        my %result = (code=>-1,msg=>"key格式不正确",data=>[],params=>$params);
        return \%result;
      }
      my $key = $keyVal[0];
      my $val = $keyVal[1];
      $yaml->[0]->{$section} = { $key => $val }; 
    }
    $result{"is_add_code"} = 1; 
  }else{
    my @srcKeyNextArray ;
    my $noNextCount;
    for my $linekey (keys $config->{$section}){
      push @srcKeyNextArray,$linekey;
    }
    my @keyexistArray;
    for my $keyStr (@keyArray){
      if ( ! grep /^$keyStr$/, @srcKeyNextArray) {
        $noNextCount = $noNextCount + 1 ;
      }else{
        push @keyexistArray,$keyStr;
      }
    }
    if ( $noNextCount == 0 ) {
      for my $keyStr (@keyArray){  
          my @keyVal = split(":",$keyStr);
          my $keyValCount = @keyVal;
          if ($keyValCount  != 2 ) {
            my %result = (code=>-1,msg=>"key格式不正确",data=>[],params=>$params);
            return \%result;
          }
          my $key = $keyVal[0];
          my $val = $keyVal[1];
          $yaml->[0]->{$section} = { $key => $val }; 
      }
      $result{"is_add_code"} = 2; 
    }else{
      if($isovewite){
        for my $keyStr (@keyArray){  
            my @keyVal = split(":",$keyStr);
            my $keyValCount = @keyVal;
            if ($keyValCount  != 2 ) {
              my %result = (code=>-1,msg=>"key格式不正确",data=>[],params=>$params);
              return \%result;
            }
            my $key = $keyVal[0];
            my $val = $keyVal[1];
            $yaml->[0]->{$section} = { $key => $val }; 
        }
        $result{"is_add_code"} = 3; 
      }else{
        my %result = (code=>-1,msg=>"新增key已经存在,当前设置是不覆盖",data=>\@keyexistArray,params=>$params);
        return \%result;        
      }
   }
  }
  # $yaml->[0]->{section}->{Foo} = 'Not Bar!';     # Change a value
  # delete $yaml->[0]->{section};                  # Delete a value
  $yaml->write( $file );
  $result{"code"} = 0;
  $result{"params"} = $params;
  $result{"msg"} = "新增或者修改成功";
  my $configObj2 = getYmlFile($file,"",[]);
  my $config2 = $configObj2->{config};

  $result{"newconfig"} = $config2;  
  return \%result;   

}


sub deleteYmlFile{
  my ($file,$section,$key) = @_;
  my %result ;
  my @keyArray = @$key;
  my $ketCount = @keyArray;
  my $params = {file=>$file,section=>$section,key=>$key};
  if ( ! $section) {
    my %result = (code=>-1,msg=>"section不能为空",data=>[],params=>$params);
    return \%result;
  }
  if ($ketCount  == 0 ) {
    my %result = (code=>-1,msg=>"key不能为空",data=>[],params=>$params);
    return \%result;
  }

  my $configObj = getYmlFile($file,"",[]);
  my $config = $configObj->{config};
  my @srcKeyArray = keys $config;
  $result{"srcconfig"} = $config;
 
  if ( ! grep /^$section$/, @srcKeyArray){
    my %result = (code=>-1,msg=>"$file 中不存在 $section",data=>[],params=>$params);
    return \%result;
  }


  my $yaml = YAML::Tiny->read( $file); 
  if ($ketCount  == 1 and $keyArray[0] eq  "-1") {
    delete $yaml->[0]->{$section};
    $yaml->write( $file );
    my $configObj3 = getYmlFile($file,"",[]);
    my $config3 = $configObj3->{config};
    my %result = (code=>0,msg=>"删除成功",srcconfig=>$config,newconfig=>$config3,is_section_code=>1,data=>[],params=>$params);
    return \%result;
  }
  my @nextkeyArray;
  for my $keyStr (keys $config->{$section}){
    push @nextkeyArray,$keyStr;
  }

  for my $keyStr (@keyArray){
    if ( ! grep /^$keyStr$/, @nextkeyArray){
      my %result = (code=>-1,msg=>"$file 中 $section 不存在 $keyStr",srcconfig=>$config,data=>[],params=>$params);
      return \%result;
    }  
  }


  for my $keyStr (@keyArray){
    delete $yaml->[0]->{$section}->{$keyStr};
  }
  $yaml->write( $file );
  $result{"code"} = 0;
  $result{"params"} = $params;
  $result{"is_section_code"} = 0;
  $result{"msg"} = "删除成功";
  my $configObj2 = getYmlFile($file,"",[]);
  my $config2 = $configObj2->{config};
  $result{"newconfig"} = $config2;

  return \%result;   

}

# print Dumper(deleteYmlFile("file.yml","testsec",["test"]));
# print Dumper(addYmlFile("file.yml","testsec",["test:teastValsdd"],1));
# getYmlFile("config_test.yml");
# groups_file("ip_lists.ini");
# write_groups_file("ip_lists.ini","delete","0",["group1"]);
# write_groups_file("ip_lists.ini","delete","1",["group1:192.168.0.76"]);
# write_groups_file("ip_lists.ini","add","group1",["192.168.0.76","192.168.0.1"]);


1;
