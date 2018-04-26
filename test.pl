# use 5.020;
use warnings;
use Encode;

my $str_raw = "我勒个去";
my $str_utf8 = decode('utf-8', $str_raw);
my @rslt = split(//, $str_utf8);

# print @rslt ;
print encode('utf-8', \@rslt);