#!/usr/bin/perl
use File::Basename;
my $dirname = dirname(__FILE__);
require "$dirname/lib/ssh_check.pl";
require "$dirname/lib/addcpu2.pl";
require "$dirname/lib/ssh_ping.pl";
require "$dirname/lib/get_jobs.pl";
require "$dirname/lib/submitnew.pl";
require "$dirname/lib/readCpuUsageMap.pl";
require "$dirname/lib/openglog.pl";
#below are some "universal" constants that need to be changed per user
#they are not passed from function to function
#change the following submitf file to reflect the file that "submit.pl" writes to
$submitf = "$dirname/config/submits";
#I built my own cpu map of all of the local machines for future submits across all machines
#It is of utmost importance that cpumap.txt be accurate, otherwise the machines could become overloaded with jobs
#there is no other way for this script to know how many jobs can be submitted to a remote machine!
$cpumap  = "$dirname/config/cpumap.txt";
#this is the directory where the .profile to be loaded on each login on the remote machine when jobs are submitted 
#and where files should be copied to on the remote machines
$remotedir = "/Volumes/james/";
@jobs = &getjobs($submitf);
$reftocpumap = &readCpuUsageMap($cpumap);
foreach (@jobs)
{
	print "$_\n";
}
while ($jobs[0] ne '')
{
	@jobs = &mass_submit("m",\@jobs,$reftocpumap);
	@jobs = &mass_submit("n",\@jobs,$reftocpumap);
}
print "All jobs succesfully submitted!\n";
