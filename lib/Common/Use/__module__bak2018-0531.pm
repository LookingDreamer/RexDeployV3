package Common::Use;

use Rex -base;
use Rex::Commands::Rsync;
use Deploy::Db;
use threads;
use POSIX;
use File::Basename;
use LWP::UserAgent;
use LWP::Protocol::https;
use Encode;
use URI::Escape;
use Sort::Naturally;
use JSON;
use Rex::Commands::Upload;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use vars qw( $opt_j );
use Getopt::Std;
use File::Basename;
use Data::Dumper;
use File::Spec;
# use Storable qw(store retrieve freeze thaw dclone);
use Storable;

my $env;
my $checkurl_respoon_print;
my $upload_method;
my $download_method;
my $temp;
my $savetmpDir;
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
        $checkurl_respoon_print = $param->{checkurl_respoon_print};
        $upload_method = $param->{upload_method};
        $download_method = $param->{download_method};
        $temp = $param->{temp};
        $savetmpDir = $param->{savetmpDir};
    }
);

desc "批量命令模块: rex [-H 'x.x.x.x x.x.x.x']/[-G  group] run --cmd='uptime'";
task run =>,sub {

my $self = shift;
my $cmd = $self->{cmd};
my $w = $self->{w};
my $wb = $self->{wb};
my $random = $self->{random};
my $db = $self->{db};
my $hash = {} ;

run $cmd, sub {
     my ($stdout, $stderr) = @_;
     my $server = Rex::get_current_connection()->{server};
     my $names ;
     eval{ 
      if ( $db ne "1") {
        $names = Deploy::Db::showname($server);
      }
      
     };
     if($@){
        Rex::Logger::warn("根据IP在数据库中查询主机信息超时或异常(不影响后续执行)");
     }


    $hash->{"stdout"} = $stdout;
    $hash->{"server"} = "$server";
    # $hash->{"names"} = $names;

    if ( "$wb" eq "1" && "$w" eq "1") {
      return $hash;
    }

    if ( "$w" eq "1" ) {
      Common::Use::json($w,"0","成功",[$hash],$random);
      return $hash;
    }

    if($names eq "none"){
      say "[$server] $stdout";
      say "" ;
    }elsif($names eq "null"){
      say "[$server] $stdout";
      say "" ;
    }else{
      say "[$server]-[$names] $stdout";
      say "" ;
    }      
};

return $hash;

};

desc "文件下载模块 远程->本地:rex [-H 'x.x.x.x']/[-G  group] Common:Use:download --dir1='/tmp/1.txt' --dir2='/tmp/' [--ipsep='1'] [--http='1']";
task "download", sub {
   my $self = shift;
   my $dir1 = $self->{dir1};
   my $dir2 = $self->{dir2};
   my $ipsep = $self->{ipsep};
   my $app_key = $self->{app_key};
   my $http = $self->{http};
   my $w = $self->{w};
   my $random = $self->{random};
   my %hash_pids;
   my $server = Rex::get_current_connection()->{server};
   my %hash;
   my %reshash;
   my $sufer_dir2_status;
   my $sufer_dir1_status;
   my $du_dir;
   my $basename;

   $reshash{"server"} = "$server";
   $reshash{"params"} = {dir1=>$dir1,dir2=>$dir2,ipsep=>$ipsep,app_key=>$app_key,http=>$http,w=>$w};

   if ( $app_key ne "" && $ipsep eq "2" ) {
      $dir2 = "$dir2/$app_key";
   }else{
     if ( $ipsep eq "1") {
       if ( "$server" eq "<local>") {
          $dir2 = "$dir2/local";
       }else{
          $dir2 = "$dir2/$server";
       }
       
     }
   }

   if(  $dir2  =~m/\/$/ ) { 
     $sufer_dir2_status = "true";
   }else{
     $sufer_dir2_status = "false";
   }

   if(  $dir1  =~m/\/$/ ) { 
     $sufer_dir1_status = "true";
   }else{
     $sufer_dir1_status = "false";
   }
   # my $thread_1_01 = threads->create('download_thread','Download_Thread_1');
   # my $thread_2_01 = threads->create('download_thread',$dir1,$dir2);
   # $thread_2_01->join();
   if ( "$http" ne "1") {
     if (  ! is_dir($dir1) &&  ! is_file($dir1) ) {
       Rex::Logger::info("[文件传输] [$server] $dir1 远程目录或文件不存在.");
       $reshash{"code"} = -1;
       $reshash{"msg"} = "[$server] $dir1 is not exist";
       Common::Use::json($w,"","[文件传输] [$server] $dir1 远程目录或文件不存在.",[\%reshash]);
       return \%reshash;
       # exit;
     }
   }

   LOCAL{
    if ( !is_dir($dir2) ) {
      mkdir($dir2);
    }
   };

    #判断是带目录传输还是直接传输子目录或文件
  if ( $sufer_dir1_status eq "true" &&  $sufer_dir2_status eq "true" ) {
     $du_dir = $dir2;
   } elsif ( $sufer_dir1_status eq "true" &&  $sufer_dir2_status eq "false" ) {
     $du_dir = $dir2;
   } elsif ( $sufer_dir1_status eq "false" &&  $sufer_dir2_status eq "true" ) {
     $basename = basename $dir1;
     $du_dir = "$dir2/$basename";
   } else {
     $basename = basename $dir1;
     $du_dir = "$dir2/$basename";
   }
     
   #判断是否开启了sudo,如果开启了则查看修改/etc/sudoers
  my $env;
  my $key_auth;
  my $username;
  Rex::Config->register_config_handler("env", sub {
    my ($param) = @_;
    $env = $param->{key} ;
  });
  Rex::Config->register_config_handler("$env", sub {
    my ($param) = @_;
    $key_auth = $param->{key_auth} ;
    $username = $param->{user} ;
  });
  if (Rex::is_sudo && "$http" ne "1") {

       my $sudo_config_status = run "grep 'Defaults:$username !requiretty' /etc/sudoers |wc -l";
       if (  $sudo_config_status eq '0') {
         run "echo 'Defaults:$username !requiretty' >> /etc/sudoers ";
         Rex::Logger::info("[文件传输] echo 'Defaults:$username !requiretty' >> /etc/sudoers ");
       }else{
         Rex::Logger::info("[文件传输] sudo tty终端已经关闭.");
       }
       $reshash{"is_sudo"} = 1; 
  };

   if ("$http" ne "1") {
       my $real_size = run " du -sh $dir1 | awk '{print \$1}'";
       my $size = run " du -s $dir1 | awk '{print \$1}'";
       Rex::Logger::info("[文件传输] [$server]  $dir1-->$dir2大小: $real_size .");
       $reshash{"size"} = "$real_size"; 
   } 

   my $time_start=time();
   my $downres = download_thread($dir1,$dir2,$http,$w);
   my $time_end=time();
   my $time =$time_end-$time_start; 
   Rex::Logger::info("[文件传输] 传输完成,耗时: $time秒");
   $reshash{"take"} = "$time"; 
   $reshash{"download"} = $downres;
   if ( $downres->{"code"}  == 0 ) {
     $reshash{"code"} = 0;
     $reshash{"msg"} = "download success";
   }else{
     $reshash{"code"} = -1;
     $reshash{"msg"} = "download faild";    
   }
    
   Common::Use::json($w,"0","成功",[\%reshash],$random);
   return \%reshash;
 };

sub download_thread{
 my ($dir1,$dir2,$http,$w) = @_;
 my %data ;
 my $src = $dir1 ;
 $dir1=~ s/ //g;

if( "$http" eq "1" ){
  $download_method = "http";
} 
$data{"code"} = 1;
$data{"download_method"} = $download_method ; 
Rex::Logger::info("当前传输文件方式:$download_method");

 if ( "$download_method" eq "rsync" ) {
    sync $dir1,$dir2, {
    download => 1,
    exclude => ["*.sw*", "*.tmp"],
    parameters => '--delete --progress',
    };
 }elsif( "$download_method" eq "sftp" ){

    if ( is_dir($dir1) ) {
      $dir1 =~ s/\/$//;
      my $randomdir = "/tmp/remotetmp_".get_random( 8, 'a' .. 'z' );
      mkdir "$randomdir",
        mode => 1777;
      my $zipFileName = $randomdir."/" . get_random( 8, 'a' .. 'z' ) . time().".zip";
      my @dir1Array = split("/",$dir1);
      my $max = @dir1Array;
      my $lastVal = $max - 1 ;
      my $lastName = $dir1Array[$lastVal];
      $dir1 =~ s/${lastName}$//; 
      if ( $src =~ m/\/$/ ) {
        Rex::Logger::info("压缩: cd $src ; zip -r $zipFileName *"); 
        run "cd $src ; zip -r $zipFileName *";
      }else{
        Rex::Logger::info("压缩: cd $dir1 ; zip -r $zipFileName $lastName"); 
        run "cd $dir1 ; zip -r $zipFileName $lastName";
      }
      
      if ( $? != 0   ) {
        Rex::Logger::info("压缩远程文件:$dir1 失败,请检查远程服务器是否安装zip: cd $dir1 ; zip -r $zipFileName $lastName","error"); 
        # exit;
        $data{"code"} = -1;
        $data{"msg"} = "zip remote file: $dir1 faild";
        return \%data;
      }
      Rex::Logger::info("压缩临时文件:$zipFileName");
      my $filename = basename($zipFileName);
      download "$zipFileName", "$dir2/$filename";
      Rex::Logger::info("$zipFileName -> $dir2/$filename下载完成");
      unlink($zipFileName); 
      Rex::Logger::info("删除远程临时压缩文件:$zipFileName");
      rmdir("$randomdir");
      LOCAL {
        if ( ! is_file("$dir2/$filename") ) {
          Rex::Logger::info("本地压缩文件不存在: $dir2/$filename","error");
          # exit;
          $data{"msg"} = "local zip file($dir2/$filename) is not exist!";
          $data{"code"} = -1;
          return \%data;
        }
        run "cd $dir2 && unzip -o $filename && rm -f $filename";
        if ( $? != 0   ) {
          Rex::Logger::info("解压缩远程文件:$filename 失败,请检查本地服务器是否安装unzip: cd $dir2 && unzip $filename","error"); 
          # exit;
          $data{"msg"} = "unzip local zip file: $filename faild";
          $data{"code"} = -1;
          return \%data;
        }
        # chdir($dir2);
        # unzipFile($filename);
        Rex::Logger::info("解压缩$dir2/$filename完成");  
        Rex::Logger::info("删除本地临时压缩文件:$dir2/$filename完成"); 
        Rex::Logger::info("目录: $src ->$dir2 下载成功"); 

      };


    }else{
      my $filename = basename($dir1);
      download "$dir1", "$dir2/$filename";
      Rex::Logger::info("文件: $dir1 ->$dir2 下载成功"); 
    }

   
 }elsif( "$download_method" eq "http" ){
    # my $filename = basename($dir1);
    download "$dir1", "$dir2";
    Rex::Logger::info("http文件: $dir1 ->$dir2 下载成功");  
 }else{
    sync $dir1,$dir2, {
    download => 1,
    exclude => ["*.sw*", "*.tmp"],
    parameters => '--delete --progress',
    };  
 }

 #校验下载的文件或者目录
 my $nextDir ;
 if(  $src  =~m/\/$/ ) { 
       if (is_dir($src)) {
          $nextDir = run "ls $src|awk '{print \$1}' |head -n 1";
       }
 }

 LOCAL{

      my $src1 = $src;
      $src1=~ s/ //g;
      $src1 =~ s/\/$//;
      my @dir1Array = split("/",$src1);
      my $max = @dir1Array;
      my $lastVal = $max - 1 ;
      my $lastName = $dir1Array[$lastVal];

       if(  $src  =~m/\/$/ ) { 
              my $checkDir = "$dir2/$nextDir";
              Rex::Logger::info("本地校验目录或文件: $checkDir"); 
              if ( ! is_file("$checkDir")  && ! is_dir("$checkDir") ) {
                Rex::Logger::info("下载后文件或目录: $checkDir 校验失败,文件或者目录不存在","error");  
                $data{"msg"} = "download check,local file or dir is not exist: $checkDir ";
                $data{"code"} = -1;
                return \%data;

              }else{
                $data{"code"} = 0;
                $data{"localPath"} = "$checkDir";
                Rex::Logger::info("下载后文件或目录: $checkDir  校验成功");  
              }
       }else{
            if ( ! is_file("$dir2/$lastName")  && ! is_dir("$dir2/$lastName") ) {
              Rex::Logger::info("下载后文件或目录: $dir2/$lastName 校验失败,文件或者目录不存在","error");  
              $data{"msg"} = "download check,local file or dir is not exist: $dir2/$lastName ";
              $data{"code"} = -1;
              return \%data;

            }else{
              $data{"code"} = 0;
              $data{"localPath"} = "$dir2/$lastName";
              Rex::Logger::info("下载后文件或目录: $dir2/$lastName  校验成功");  
            }     
       }


  
 };

 return \%data;



 # sync $dir1,$dir2, {
 # download => 1,
 # parameters => '--progress --delete',
 # };
}

desc "文件上传模块 本地->远程:rex [-H 'x.x.x.x']/[-G  group] Common:Use:upload --dir1='/tmp/1.txt' --dir2='/tmp/' [--ipsep='1']";
task "upload", sub {
    my $self = shift;
    my $dir1 = $self->{dir1};
    my $dir2 = $self->{dir2};
    my $ipsep = $self->{ipsep};
    my $app_key= $self->{app_key};
    my $w= $self->{w};
    my $random= $self->{random};
    my %hash_pids;
    my $server = Rex::get_current_connection()->{server};
    my %hash;
    my @sizearr;
    my $sufer_dir2_status;
    my $sufer_dir1_status;
    my $du_dir;
    my $basename;
    my $time_start;
    my %reshash;
    $reshash{"server"} = "$server";
    $reshash{"params"} = {dir1=>$dir1,dir2=>$dir2,ipsep=>$ipsep,app_key=>$app_key,w=>$w};

   if ( $app_key ne "" && $ipsep eq "2" ) {
      $dir2 = "$dir2/$app_key";
   }else{
     if ( $ipsep eq "1") {
       $dir2 = "$dir2/$server";
     }
   }

   if(  $dir2  =~m/\/$/ ) { 
     $sufer_dir2_status = "true";
   }else{
     $sufer_dir2_status = "false";
   }

   if(  $dir1  =~m/\/$/ ) { 
     $sufer_dir1_status = "true";
   }else{
     $sufer_dir1_status = "false";
   }

  $time_start=time();

  my $uploadres = upload_thread($dir1,$dir2);
  my $time_end=time();
  my $time =$time_end-$time_start; 
  Rex::Logger::info("[文件传输] 传输完成,耗时: $time秒");
  $reshash{"take"} = $time;

  $reshash{"upload"} = $uploadres;
  if ( $uploadres->{"code"}  == 0 ) {
   $reshash{"code"} = 0;
   $reshash{"msg"} = "upload success";
  }else{
   $reshash{"code"} = -1;
   $reshash{"msg"} = "upload faild";    
  }
  Common::Use::json($w,"0","成功",[\%reshash],$random);

  return \%reshash;

 };


sub upload_thread{
my ($dir1,$dir2) = @_;
my %data ;
my $src = $dir1;
$data{"code"} = 1;
LOCAL{
    if ( !is_dir($dir1) && ! is_file($dir1) ) {
      Rex::Logger::info("[文件传输] [local]: $dir1 目录或文件不存在.");
      $data{"code"} = -1 ;
      $data{"msg"} = "[local]: $dir1 file or dir is not exist." ;
      return \%data;
    };
    my $real_size = run " du -sh $dir1 | awk '{print \$1}'";
    my @sizearr = readpipe " du -s $dir1 | awk '{print \$1}'";
    Rex::Logger::info("[文件传输] [local]: $dir1-->$dir2大小: $real_size .");
    $data{"size"} = "$real_size" ;
  };


  #判断是否开启了sudo,如果开启了则查看修改/etc/sudoers
  my $env;
  my $key_auth;
  my $username;
  Rex::Config->register_config_handler("env", sub {
    my ($param) = @_;
    $env = $param->{key} ;
  });
  Rex::Config->register_config_handler("$env", sub {
    my ($param) = @_;
    $key_auth = $param->{key_auth} ;
    $username = $param->{user} ;
  });
  if (Rex::is_sudo) {

       my $sudo_config_status = run "grep 'Defaults:$username !requiretty' /etc/sudoers |wc -l";
       if (  $sudo_config_status eq '0') {
         run "echo 'Defaults:$username !requiretty' >> /etc/sudoers ";
         Rex::Logger::info("[文件传输] echo 'Defaults:$username !requiretty' >> /etc/sudoers ");
       }else{
         Rex::Logger::info("[文件传输] sudo tty终端已经关闭.");
       }
       $data{"is_sudo"} = 1 ;

  };

 Rex::Logger::info("当前传输文件方式:$upload_method");
 $data{"upload_method"} = "$upload_method" ;

 if ( "$upload_method" eq "rsync" ) {
    sync $dir1,$dir2, {
    exclude => ["*.sw*", "*.tmp"],
    parameters => '--delete --progress',
    };
 }elsif( "$upload_method" eq "sftp" ){
    if ( ! is_dir($dir2) ) {
      mkdir "$dir2",
        mode => 1777;
    }
    my $randomdir = "/tmp/localtmp_".get_random( 8, 'a' .. 'z' );
    LOCAL {     
      mkdir "$randomdir",
        mode => 1777;      
    };
    my $zipFileName = $randomdir."/" . get_random( 8, 'a' .. 'z' ) . time().".zip";

    # zipFile($zipFileName,$dir1);
    LOCAL {      
      if ( $dir1 =~ m/\/$/ ) {
        Rex::Logger::info("压缩: cd $dir1 ; zip -r $zipFileName *"); 
        run "cd $dir1 ; zip -r $zipFileName *";
      }else{
        $dir1=~ s/ //g;
        $dir1 =~ s/\/$//;     
        my @dir1Array = split("/",$dir1);
        my $max = @dir1Array;
        my $lastVal = $max - 1 ;
        my $lastName = $dir1Array[$lastVal];
        $dir1 =~ s/${lastName}$//;
        if ( "$dir1" eq "" ) {
           Rex::Logger::info("压缩: cd . ; zip -r $zipFileName $lastName"); 
           run "cd . ; zip -r $zipFileName $lastName";
        }else{
           Rex::Logger::info("压缩: cd $dir1 ; zip -r $zipFileName $lastName"); 
           run "cd $dir1 ; zip -r $zipFileName $lastName";
        }

      }  
      if ( $? != 0   ) {
        Rex::Logger::info("压缩本地文件:$dir1 失败,请检查本地服务器是否安装zip","error"); 
        $data{"code"} = -1 ;
        $data{"msg"} = "[local]: zip $dir1 file or dir faild." ;
        return \%data;
      }  

    };
    Rex::Logger::info("$zipFileName -> $dir2 开始上传."); 
    upload "$zipFileName", "$dir2";
    Rex::Logger::info("$zipFileName -> $dir2上传完成"); 
    LOCAL {
      unlink($zipFileName);
      Rex::Logger::info("删除本地临时压缩文件:$zipFileName");
      rmdir($randomdir); 
    }; 
    my $filename = basename($zipFileName);
    my $destFile =  "$dir2/$filename";
    Rex::Logger::info("解压远程压缩文件:$destFile"); 
    run "cd $dir2 && unzip -o $destFile -d .";
    if ( $? != 0   ) {
      Rex::Logger::info("解压远程压缩文件:$destFile 失败,请检查远程服务器是否安装unzip: cd $dir2 && unzip -o $destFile","error"); 
      $data{"code"} = -1 ;
      $data{"msg"} = "[local]: unzip $destFile  faild." ;
      return \%data;      
      exit;
    }
    unlink($destFile);
    Rex::Logger::info("删除远程临时压缩文件:$destFile"); 
 }else{
    sync $dir1,$dir2, {
    exclude => ["*.sw*", "*.tmp"],
    parameters => '--delete --progress',
    };  
 }

#校验上传是否成功
 my $nextDir ;
 if(  $src  =~m/\/$/ ) { 
       if (is_dir($src)) {
          $nextDir = run "ls $src|awk '{print \$1}' |head -n 1";
       }
 }
  my $src1 = $src;
  $src1=~ s/ //g;
  $src1 =~ s/\/$//;
  my @dir1Array = split("/",$src1);
  my $max = @dir1Array;
  my $lastVal = $max - 1 ;
  my $lastName = $dir1Array[$lastVal];

   if(  $src  =~m/\/$/ ) { 
          my $checkDir = "$dir2/$nextDir";
          Rex::Logger::info("远程校验目录或文件: $checkDir"); 
          if ( ! is_file("$checkDir")  && ! is_dir("$checkDir") ) {
            Rex::Logger::info("上传后文件或目录: $checkDir 校验失败,文件或者目录不存在","error");  
            $data{"msg"} = "upload check,local file or dir is not exist: $checkDir ";
            $data{"code"} = -1;
            return \%data;

          }else{
            $data{"code"} = 0;
            Rex::Logger::info("上传后文件或目录: $checkDir  校验成功");  
          }
   }else{
        if ( ! is_file("$dir2/$lastName")  && ! is_dir("$dir2/$lastName") ) {
          Rex::Logger::info("上传后文件或目录: $dir2/$lastName 校验失败,文件或者目录不存在","error");  
          $data{"msg"} = "upload check,local file or dir is not exist: $dir2/$lastName ";
          $data{"code"} = -1;
          return \%data;

        }else{
          $data{"code"} = 0;
          Rex::Logger::info("上传后文件或目录: $dir2/$lastName  校验成功");  
        }     
   }

 return \%data;

};

#压缩文件或者目录
sub zipFile{
    my ($zipfileName,$zipDir) = @_; 
    my @zipArray = ("$zipfileName", "$zipDir");
    if ( "$zipfileName" eq ""  ){
        Rex::Logger::info("压缩的文件名不能为空:","error");
        exit;
    }
    if ( "$zipDir" eq ""  ){
        Rex::Logger::info("压缩的文件或者目录不能为空:","error");
        exit;
    }    
    LOCAL {          
            my $zipName = shift(@zipArray);
            my $zip     = Archive::Zip->new();
             
            foreach my $memberName (map { glob } @zipArray) {
                if (-d $memberName) {
                    if ( $zip->addTree($memberName, $memberName) != AZ_OK ) {
                        Rex::Logger::info("添加压缩目录树失败: $memberName","error");
                        exit;
                    }
                } else {
                    if ( ! $zip->addFile($memberName) ) {
                        Rex::Logger::info("添加压缩文件失败: $memberName","error");
                        exit;
                    }
                }
            }

            unless ( $zip->writeToFileNamed($zipName) == AZ_OK ) {
                Rex::Logger::info("压缩$zipDir->$zipName失败","error");
                exit;
            }else{
                Rex::Logger::info("压缩$zipDir->$zipName成功");
            }      
    }

};


#解压缩文件
sub unzipFile{
    my ($unzipName) = @_; 
    if ( "$unzipName" eq ""  ){
        Rex::Logger::info("解压缩的文件名不能为空:","error");
        exit;
    }   
    my $zip     = Archive::Zip->new();
    my $status  = $zip->read($unzipName);
    if ($status != AZ_OK) {
      Rex::Logger::info("读取压缩包失败:","error");
      exit;
    }     
    $zip->extractTree();
    Rex::Logger::info("解压缩文件成功 $unzipName");
};



desc "内部命令调用模块: rex [-H 'x.x.x.x x.x.x.x']/[-G  group] run --cmd='uptime'";
task apirun =>,sub {

my $self = shift;
my $cmd = $self->{cmd};
my $result = run "$cmd";
return $result;
 
};

desc "get请求: rex Common:Use:get --url='[url]' --header='[header参数]'  [--print='1']";
task get =>,sub {

my $self = shift;
my $url = $self->{url};
my $header = $self->{header};
my $print = $self->{print};
my $w = $self->{w};
my $ua = LWP::UserAgent->new;
if ( "$url" eq "" ) {
  Rex::Logger::info("请求url不能为空","error");
  Common::Use::json($w,"","请求url不能为空","");
  exit;
}
Rex::Logger::info("请求url: $url");
my @headerArray;
if ( "$header" ne "" ) {
  Rex::Logger::info("请求header: $header");
  @headerArray = split(/;/,$header);
}
Rex::Logger::info("开始GET请求数据...");
my $server_endpoint = "$url";
my $req = HTTP::Request->new(GET => $server_endpoint);
for my $headerLine (@headerArray){
   my @headerLineArray = split(/:/,$headerLine);
   my $headerLineLen = @headerLineArray;
   if ( $headerLineLen == 2 ) {
     $req->header( "$headerLineArray[0]"=> "$headerLineArray[1]");
   }
}
# $req->header('content-type' => 'application/json');
# $req->header('x-auth-token' => 'kfksj48sdfj4jd9d');
my @data ; 
my $resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    push @data,$resp->code;
    push @data,$message;
}else {
    push @data,$resp->code;
    push @data,$resp->message,;
}
utf8::encode($data[1]); 

if ( "$print" eq "1") {
  Rex::Logger::info("返回状态码: $data[0] 返回数据:$data[1]"); 
}else{
  if ( "$checkurl_respoon_print"  eq "0") {
    Rex::Logger::info("返回状态码: $data[0]");
  }else{
    Rex::Logger::info("返回状态码: $data[0] 返回数据:$data[1]");  
  }  
}


Common::Use::json($w,"0","成功",\@data);
return \@data;
 
};


desc "post请求: rex Common:Use:post --url='[url]' --header='[header参数]' --param='[参数]' [--print='1']";
task post =>,sub {

my $self = shift;
my $url = $self->{url};
my $header = $self->{header};
my $param = $self->{param};
my $print = $self->{print};
my $w = $self->{w};
my $ua = LWP::UserAgent->new;
if ( "$url" eq "" ) {
  Rex::Logger::info("请求url不能为空","error");
  Common::Use::json($w,"","请求url不能为空","");
  exit;
}
Rex::Logger::info("请求url: $url");
my @headerArray;
if ( "$header" ne "" ) {
  Rex::Logger::info("请求header: $header");
  @headerArray = split(/;/,$header);
}
if ( "$param" ne "" ) {
  Rex::Logger::info("请求参数: $param");
}
Rex::Logger::info("开始POST请求数据...");
my $server_endpoint = "$url";
my $req = HTTP::Request->new(POST  => $server_endpoint);
for my $headerLine (@headerArray){
   my @headerLineArray = split(/:/,$headerLine);
   my $headerLineLen = @headerLineArray;
   if ( $headerLineLen == 2 ) {
     $req->header( "$headerLineArray[0]"=> "$headerLineArray[1]");
   }
}
# $req->header('content-type' => 'application/json');
# $req->header('x-auth-token' => 'kfksj48sdfj4jd9d');
$req->content($param);
my @data ; 
my $resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    push @data,$resp->code;
    push @data,$message;
}else {
    push @data,$resp->code;
    push @data,$resp->message,;
}
utf8::encode($data[1]); 
if ( "$print" eq "1") {
  Rex::Logger::info("返回状态码: $data[0] 返回数据:$data[1]"); 
}else{
  if ( "$checkurl_respoon_print"  eq "0") {
    Rex::Logger::info("返回状态码: $data[0]");
  }else{
    Rex::Logger::info("返回状态码: $data[0] 返回数据:$data[1]");  
  }  
}

Common::Use::json($w,"0","成功",\@data);
return \@data;
 
};


desc "print JSON";
task json =>,sub {
    my ($w,$code,$msg,$data,$random) = @_;
    if ( "$w" ne "1" ) {
      return ;
    }
    my %hash;
    my $j;
    my $output;
    if ( "$msg" eq "" ){
        $msg = "未知消息";
    }
    if ( "$code" eq "" ){
        $code = -1;
    }
    if ( "$data" eq ""){
       $data = [] ;
    }
  eval {
     $j = JSON::XS->new->utf8->pretty(1);
     $output = $j->encode({
        code => $code,
        data => $data,
        msg =>$msg
    });
     %hash = (
        "code" => $code,
        "data" => $data,
        "msg" =>$msg     
     );
  };
  if ($@) {
     $j = JSON::XS->new->utf8->pretty(1);
     $output = $j->encode({
        code => 2,
        data => ["$@"],
        msg =>"解析JSON异常"
    });
     %hash = (
        "code" => 2,
        "data" => ["$@"],
        "msg" =>"解析JSON异常" 
     );

  }
  if ( "$w" eq "1" && "$random" eq "" ) {
    $output = decode("utf-8", $output);
    print "$output";
  }elsif( "$w" eq "1" && "$random" ne "" ) {
    $output = decode("utf-8", $output);
    my $randomDir = $savetmpDir."/".$random ;
    my $hashFile =$randomDir ."/".$$."_".get_random( 8, 'a' .. 'z' ) . time().".hash";
    if ( ! is_dir("$randomDir") ) {
        mkdir("$randomDir");
    }
    if (is_file($hashFile )) {
        unlink($hashFile );
    }
    # Rex::Logger::info("保存返回数据到文件: $hashFile");
    store \%hash, $hashFile ;
  }
  
};


desc "get JSON";
task getJson =>,sub {  
    my $self = shift;
    my $random=$self->{random};
    my $delete=$self->{delete};
    my $j;
    my $output;
    my $randomDir = $savetmpDir."/".$random ;
    if ( "$random" eq "" ) {
        Rex::Logger::info("ranom param is null","error");
        exit;
    }
    my @Array ;
    if (is_dir($randomDir)) {
        opendir DIR, ${randomDir} or die "打开目录失败";
        my @filelist = readdir DIR;
        foreach my $file (@filelist) {
            if (  $file =~ m/.hash$/ ) {
               my $hashFile =  $randomDir."/".$file ;
               Rex::Logger::info("read file: $hashFile");
               if ( is_file($hashFile) ) {
                  my $hash = retrieve($hashFile);
                  push @Array,$hash;
               }else{
                  Rex::Logger::info("read file : $hashFile is not exist","error");
               }
               
            }
        }       
    }
    if ( "$delete" eq "1" ) {
       if (is_dir($randomDir)) {
           rmdir($randomDir);
       }
    }
    my $count = @Array;
    eval {
        $j = JSON::XS->new->utf8->pretty(1);
        $output = $j->encode({
          count => "$count",
          code => 1,
          data => \@Array,
          msg =>"success"
        });
    };
    if ($@) {
        $j = JSON::XS->new->utf8->pretty(1);
        $output = $j->encode({
          count => "0",         
          code => 2,
          data => ["$@"],
          msg =>"解析JSON异常"
        });
    }
    $output = decode("utf-8", $output);
    print "$output";
    # say Dumper( @Array);
};

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Common::Use/;

 task yourtask => sub {
    Common::Use::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
