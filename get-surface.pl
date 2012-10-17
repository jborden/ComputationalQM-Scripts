#!/usr/bin/perl
use File::Basename;
my $dirname = dirname(__FILE__);
require "$dirname/lib/newgetsurface.pl";
require "$dirname/lib/newprintsurface.pl";
require "$dirname/lib/argvgetsurface.pl";
require "$dirname/lib/getsurfaceSOLCOMS.pl";
require "$dirname/lib/getsurfaceGASLOGS.pl";
require "$dirname/lib/openglog.pl";
require "$dirname/lib/getbondlength.pl";
require "$dirname/lib/get_charges.pl";
require "$dirname/lib/getcharge.pl";
use Cwd 'abs_path';
use Cwd;

&getlineargs();
@comfiles = &getsurfaceSOLCOMS();
if ($gasmethod ne "" && $gasbasis ne "")
{
	@logfiles = &getsurfaceGASLOGS();
	$reftosurface = &getsurface(\@comfiles,\@logfiles);
}
else
{
	$reftosurface = &getsurface(\@comfiles);
}
my $surfacefile = &printsurface($reftosurface,$currentdir);
print "surfacefile is $surfacefile\n";
