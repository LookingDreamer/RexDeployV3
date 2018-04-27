#!/usr/bin/env perl
use Data::Dumper;

sub test {

my $VAR1 = {
          'deploy_take' => 'Total Take:28 || Rsync Time:14 || Start App Time:5',
          'deloy_prodir_after' => '/data/www/html1_20180427_015702',
          'rollbackNumber' => '0',
          'end_time' => '2018-04-27 01:57:59',
          'rsync_war_time' => '2018-04-27 01:57:45',
          'processNumber' => '2',
          'deploy_ip' => '172.16.0.76',
          'deloy_prodir_before' => '/data/www/html1_20180427_011208',
          'deloy_prodir_real_before' => undef,
          'start_time' => '2018-04-27 01:57:31',
          'randomStr' => '1524805051812518010',
          'deploy_key' => 'server1',
          'rollRecord' => '0',
          'deloy_configdir_after' => '/data/www/config1_20180427_015702',
          'deloy_configdir_before' => '/data/www/config1_20180427_011208',
          'rollStatus' => '0',
          'deloy_size' => '32M /data/www/html1_20180427_015702 24K /data/www/config1_20180427_015702',
          'start_app_time' => '2018-04-27 01:57:54'
        };
my $VAR2 = {
          'deploy_take' => 'Total Take:25 || Rsync Time:13 || Start App Time:3',
          'deloy_prodir_after' => '/data/www/html2_20180427_015702',
          'rollbackNumber' => '0',
          'end_time' => '2018-04-27 01:57:57',
          'rsync_war_time' => '2018-04-27 01:57:45',
          'processNumber' => '2',
          'deploy_ip' => '172.16.0.248',
          'deloy_prodir_before' => '/data/www/html2_20180427_011208',
          'deloy_prodir_real_before' => undef,
          'start_time' => '2018-04-27 01:57:32',
          'randomStr' => '1524805052095065134',
          'deploy_key' => 'server2',
          'rollRecord' => '0',
          'deloy_configdir_after' => '/data/www/config2_20180427_015702',
          'deloy_configdir_before' => '/data/www/config2_20180427_011208',
          'rollStatus' => '0',
          'deloy_size' => '32M /data/www/html2_20180427_015702 24K /data/www/config2_20180427_015702',
          'start_app_time' => '2018-04-27 01:57:54'
        };

my @data ;
push @data,$VAR1;
push @data,$VAR2;

# print Dumper(ref @data);
# print Dumper(@data);
# print Dumper(ref \@data);
return \@data;

}


my $res = test();
print Dumper($res);
