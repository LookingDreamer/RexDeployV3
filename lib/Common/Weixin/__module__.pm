package Common::Weixin;

use Rex -base;

desc "test";
task example => sub {
   my $output = run "uptime";
   say $output;
};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Common::Weixin/;

 task yourtask => sub {
    Common::Weixin::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
