package FastNotes::Controller::Groupconfig;

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


#分组配置文件查询
sub index {
    my ($self) = @_;
    my ($conf,$confFile,$res,$start_time,$section,$key,%result,$action,$code,$codeVal,@codeValArray);
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $confFile = $self->param('confFile');
    $section = $self->param('group');
    $action = $self->param('action');
    $code = $self->param('code');
    $codeVal = $self->param('codeVal');
    $conf =  $self->app->defaults->{"config"}->{"ipListsFile"};
    $start_time = strftime("%Y/%m/%d %H:%M:%S", localtime(time));
    $result{"start_time"} = $start_time;
    if ($codeVal ) {
      @codeValArray = split(",",$codeVal);
    }
    my $start = time();
    if ($confFile) {
      $conf = $confFile;
    }
    $log->info("conf:".$conf);
    $result{"conf"} = $conf;
    $result{"param"} = {confFile=>$confFile,group=>$section,action=>$action,code=>$code,codeVal=>$codeVal};

    eval {
        if ( $action eq "add" && $section  && $codeVal ) {
          $res = write_groups_file($conf,$action,$section,\@codeValArray);
        }elsif( $action eq "delete"  && $codeVal ){
          $res = write_groups_file($conf,$action,$code,\@codeValArray);
        }else{
          $res = groups_file($conf,$section);
        }
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
  my ($file,$groupName) = @_;
  my $section;
  my %hash;
  my %group;
  open( my $INI, "<", "$file" ) || die "Can't open $file: $!\n";
  my @lines = <$INI>;
  chomp @lines;
  close($INI);
  my $hash = parse(@lines);
  my %queryGroup;
  for my $k ( keys %{$hash} ) {
    my @servers;
    for my $servername ( keys %{ $hash->{$k} } ) {
      push @servers, $servername;
    }
    $group{"$k"} =  \@servers;
    if ( $groupName && "$groupName" eq "$k") {
      $queryGroup{"$groupName"} =  \@servers;
    }
  }
  if ($groupName) {
    return \%queryGroup;
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
  $log->info("file=>$file,action=>$action,deletecode=>$deletecode,delete=>\@deleteArray");
  $result{"before"} = $contentHash;
  my ($addIpCount,$deleteIpCount,$addgroupCount,$deletegroupCount);
  $addIpCount = 0 ;
  $deleteIpCount = 0 ;
  $addgroupCount = 0 ;
  $deletegroupCount =0 ;
  open( my $fh, ">", "$file" ) || die "Can't open $file: $!\n";
  if ( $action eq "add"  && $deleteCount > 0  ) {
    if ( ! grep /^$deletecode$/, @keyArray) {
      $log->info("重新写入node $deletecode IP地址: @deleteArray");
      print $fh "[$deletecode]\n";
      $addgroupCount = $addgroupCount + 1;
      for my $server ( @deleteArray ) {
        print $fh "$server\n";
        $addIpCount = $addIpCount + 1;
      }      
    }

  }

  for my $k ( keys %{$contentHash} ) {
    if ( $action eq "delete" && $deletecode eq "0"  && $deleteCount > 0  ) {
      if ( grep /^$k$/, @deleteArray) {
        $log->info("skip write $k");
        $deletegroupCount = $deletegroupCount + 1;
        last;
      }
    }
    print $fh "[$k]\n";
    my @serverArray = @{$contentHash->{$k}};
    my @ipArray ;
    for my $servername (@serverArray){
      if ( $action eq "delete" && $deletecode eq "1"  && $deleteCount > 0  ) {
        if ( grep /^$k:$servername$/, @deleteArray) {
          $log->info("skip write server:$servername  k:$k");
          $deleteIpCount = $deleteIpCount + 1 ;
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
            $log->info("重新写ip $deletecode IP地址: @deleteArray");
            $addIpCount = $addIpCount + 1;
            print $fh "$server\n";
          }
        }      
      }

    }

  }
  close $fh;
  my $newcontentHash = groups_file($file);
  $result{"after"} = $newcontentHash;
  $result{"addIpCount"} = $addIpCount;
  $result{"deleteIpCount"} = $deleteIpCount;
  $result{"addgroupCount"} = $addgroupCount;
  $result{"deletegroupCount"} = $deletegroupCount;
  my $total = $addIpCount + $deleteIpCount + $addgroupCount + $deletegroupCount;
  if ( $total  == 0  ) {
    $result{"code"} = -1;
  }else{
    $result{"code"} = 0;
  }
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
