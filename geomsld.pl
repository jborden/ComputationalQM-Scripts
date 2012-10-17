#!/usr/bin/perl
use File::Basename;
my $dirname = dirname(__FILE__);
require "$dirname/lib/getgeomld.pl";
require "$dirname/lib/charge_multiplicity.pl";
require "$dirname/lib/openglog.pl";
require "$dirname/lib/argvgeomsld.pl";
require "$dirname/lib/printld.pl";
require "$dirname/lib/printnonoptgeom.pl";
use Cwd;
use warnings;
&getlineargs();
#define the directory from which to extract as $workingdir
chdir $workingdir;
#get perl compatible dir information
$currentdir = $topdir = getcwd;
#show the current working dir
print "$currentdir\n";
opendir WD, "$currentdir";
#grab all directories, besides . and ..
@directories = grep -d, grep { $_ ne '.' and $_ ne '..'} readdir WD;
closedir WD;
#set $numdir to the amount of directories
$numdir = @directories;
print "There are $numdir subdirectories ";
print "listed :\n @directories\n";
$k = 0;
#go to individual directories and extract data	
while ($k < $numdir)
{
	chdir $directories[$k];
	$directory = getcwd;
	print "$directory is the current directory\n";
	print "$directories[$k] is the current directory\n";
	#this can be modified for the particular seed file names in the directorie
	#i.e. if you are getting optimized data from Non-Opt files than use 
	#$filename = `ls Non-Opt-$method*$basisset*log`;
	@filename = `ls Opt-$method*$basisset*.log`;
#	`rm optscript`;
#	`rm nonoptscript`;	
	foreach $file (@filename)
	{
		chomp($file);
		@gausslog = &openglog($file);
		&getcharge();
		&getgeomld();
		&printld();
	}
	chdir $topdir;
	$k++;
}
