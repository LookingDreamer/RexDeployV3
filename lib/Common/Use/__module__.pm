package Common::Use;

use Rex -base;
use Rex::Commands::Rsync;
use Deploy::Db;
use threads;

desc "批量命令模块: rex [-H 'x.x.x.x x.x.x.x']/[-G  jry-com] run --cmd='uptime'";
task run =>,sub {

my $self = shift;
my $cmd = $self->{cmd};

run $cmd, sub {
     my ($stdout, $stderr) = @_;
     my $server = Rex::get_current_connection()->{server};
     my $names = Deploy::Db::showname($server);
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
};

desc "文件下载模块 远程->本地:rex [-H 'x.x.x.x']/[-G  jry-com] Common:Use:download --dir1='/tmp/1.txt' --dir2='/tmp/'";
task "download", sub {
   my $self = shift;
   my $dir1 = $self->{dir1};
   my $dir2 = $self->{dir2};
   # say "aa";
   # exit;
   sync $dir1,$dir2, {
   download => 1,
   parameters => '--backup',
   };
 };

desc "文件上传模块 本地->远程:rex [-H 'x.x.x.x']/[-G  jry-com] Common:Use:upload --dir1='/tmp/1.txt' --dir2='/tmp/'";
task "upload", sub {
    my $self = shift;
    my $dir1 = $self->{dir1};
    my $dir2 = $self->{dir2};

    sync $dir1,$dir2, {
    exclude => ["*.sw*", "*.tmp"],
    parameters => '--backup --delete',
   };
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
