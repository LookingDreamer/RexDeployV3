#!/bin/perl
 
use strict;
use threads;
use Cwd;
use POSIX qw(strftime);
 
################################################################################
# 函数名:  count
# 函数描述:  数数
# 输入:   name 随意输入一个名字
# 输出:   无
# 调用:  
# 被调用: 
# 返回:
################################################################################
sub count
{
   my ($name) = @_;
   my $current_time = strftime "%Y-%m-%d %H:%M:%S", localtime;
   for (my $i = 0; $i <= 2; $i++){
     print "$current_time  $name $i \n";
   }
}
 
#创建第一批线程
my $thread_1_01 = threads->create('count','Thread_1');
my $thread_1_02 = threads->create('count', 'Thread_2');
my $thread_1_03 = threads->create('count', 'Thread_3');
my $thread_1_04 = threads->create('count', 'Thread_4');

#查看当前线程总数
my $thread_count = threads->list();
print "thread_count is $thread_count\n"; 

#确定当前线程是否作业完成，进行回收
foreach my $thread (threads->list(threads::all)){
    if ($thread->is_joinable()){
        $thread->join();
    }
}
 
# 等待第一批线程结束完成
# $thread_1_01->join();
# $thread_1_02->join();
# $thread_1_03->join();
# $thread_1_04->join();
 
# # 创建第二批线程
# my $thread_2_01 = threads->create('count', 'Thread_5');
# my $thread_2_02 = threads->create('count', 'Thread_6');
# my $thread_2_03 = threads->create('count', 'Thread_7');
 
# # 等待第二批线程结束完成
# $thread_2_01->join();
# $thread_2_02->join();
# $thread_2_03->join();