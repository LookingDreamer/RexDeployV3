#!/usr/bin/perl -w
#
# Test of shared hashes courtesy Joe Thomas <jthomas@women.com>
use strict;
use IPC::Shareable;
 
use vars qw($counter %hash);
tie %hash, 'IPC::Shareable', undef, {create => 'yes', destroy => 'yes'};
tie $counter, 'IPC::Shareable', undef, {create => 'yes', destroy => 'yes'};
 
$| = 1;
 
for (my $i = 0; $i < 3; $i++) {
 sleep 1;
 next if fork();
 hashcount(3, 3);
 exit;
}
 
while (1) {
 last if wait() == -1;
}
 
sub hashcount {
 my ($loops, $sleeptime) = @_;
 for (my $i = 0; $i < $loops; $i++) {
  (tied $counter)->shlock;
  (tied %hash)->shlock;
  $hash{++$counter} = $$;
 
  print "Process $$ sees:\n";
  for my $key (sort keys %hash) {
   print "\$hash{$key} = $hash{$key}\n";
  }
  (tied %hash)->shunlock;
  (tied $counter)->shunlock;
  sleep $sleeptime;
 }
}
 
exit;
 
__END__