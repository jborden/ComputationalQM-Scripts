#!/usr/bin/perl
use File::Basename;
my $dirname = dirname(__FILE__);
require "$dirname/lib/argvcombine.pl";
require "$dirname/lib/getcombine.pl";
require "$dirname/lib/printcombinesurface.pl";
require "$dirname/lib/openglog.pl";
use warnings;
use Cwd;
$reftosurfacedata = &getlineargs();
#print "before getcombine()\n";
&getcombine($reftosurfacedata);
#print "after getcombine()\n";
&printcombinesurface($combinesurface);
