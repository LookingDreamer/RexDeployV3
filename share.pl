#!/usr/bin/perl
use IPC::SysV qw(S_IRWXU IPC_CREAT);
use IPC::Semaphore;

my $sem0;
my $sem1;
my @childs;

my $sem = IPC::Semaphore->new(1556, 1, S_IRWXU|IPC_CREAT)
        || die "IPC::Semaphore->new: $!\n";
##创建一个信号量集，1556是key，1是信号量的个数，S_IRWXU即700权限，IPC_CREAT没有则创建
$sem->setval(0,0);
##设置初始值，这里只有一个信号量则下标为0，初始值为0
for ($i=0; $i<5; $i++){
                if($pid=fork())
                        {
                        $childs[$i] = $pid;
                }elsif(defined $pid){
                        sleep(1);
                        $sem->op(0, +1, SEM_UNDO);
                        $sem->op(1, "test", SEM_UNDO);
                        $sem->setval(2, 'value');
##op方法通过semop来调用系统PV原子操作，子进程退出时会通过 SEM_UNDO 来解锁
                        exit;
                }else{
                        print "Error!\n";
                        exit;
                }
}
        for  $p (@childs){
                waitpid($p, 0);
        }

$sem1 = $sem->getval(0);
##获取信号量值
print $sem1."\n";
print $sem->getall."\n";
print $sem->getval(2);