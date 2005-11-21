
use strict;
use Pod::Simple::Search;
use Test;
BEGIN { plan tests => 7 }

print "# ", __FILE__,
 ": Testing the surveying of the current directory...\n";

my $x = Pod::Simple::Search->new;
die "Couldn't make an object!?" unless ok defined $x;

$x->inc(0);

use File::Spec;
use Cwd;
my $cwd = cwd();
print "# CWD: $cwd\n";

my $here;
if(     -e ($here = File::Spec->catdir($cwd, 'test^lib'))) {
  chdir $here;
} elsif(-e ($here = File::Spec->catdir($cwd, 't', 'test^lib'))) {
  chdir $here;
} else {
  die "Can't find the test corpus";
}
print "# OK, found the test corpus as $here\n";
ok 1;

print $x->_state_as_string;
#$x->verbose(12);

use Pod::Simple;
*pretty = \&Pod::Simple::BlackBox::pretty;

my($name2where, $where2name) = $x->survey('.');

my $p = pretty( $where2name, $name2where )."\n";
$p =~ s/, +/,\n/g;
$p =~ s/^/#  /mg;
print $p;

{
my $names = join "|", sort values %$where2name;
ok $names, "Blorm|Zonk::Pronk|perlfliff|perlthang|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

{
my $names = join "|", sort keys %$name2where;
ok $names, "Blorm|Zonk::Pronk|perlfliff|perlthang|squaa|squaa::Glunk|squaa::Vliff|zikzik";
}

ok( ($name2where->{'squaa'} || 'huh???'), '/squaa\.pm$/');

ok grep( m/squaa\.pm/, keys %$where2name ), 1;

ok 1;

__END__
