#!/usr/bin/perl
use Cwd;
use Cwd 'abs_path';
use File::Basename;
my $dirname = dirname(__FILE__);
$currentdir = getcwd();
@time = localtime;
my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
$time[5] = $time[5] - 100 + 2000;
foreach $line (@ARGV)
{
	if ($line eq "local")
	{
		$submitfile = "solvscript";
		$local = 1;
		last;
	}
	else
	{
		$submitfile = "$dirname/config/submits";
		$local = 0;
	}
}
open(SUBMIT,">>$submitfile");
foreach $line (@ARGV)
{
	my $check;
	my $cs_check;
	if ($line eq "local")
	{
		next;
	}
	$line = abs_path($line);
	if ($line =~ /com/)
	{
		$log = $line;
		$log =~ s/com/log/;
		$check = `grep 'Normal termination' $log 2>/dev/null`;
	}
	if ($line =~ /cs/)
	{
		$out = $line;
		$out =~ s/cs/out/;
		$cs_check = `grep 'FINAL RESULTS' $out 2>/dev/null`;
	}
	if ($check)
	{
		print "It appears that $log ran succesfully, skipping $line\n";
		next;
	}
	if ($cs_check)
	{
		print "It appears that $out ran succesfully, skipping $line\n";
		next;
	}
	if ($local)
	{
		if ($line =~ /com/)
		{
			print SUBMIT "g03 $line\n";
		}
		if ($line =~ /cs/)
		{
			print SUBMIT "cs21 $line\n";
		}
	}
	else
	{
		print SUBMIT "$line\n";
	}
	print "$line has been placed in que\n";
}
close(SUBMIT);
if ($local)
{
	`chmod +x solvscript`;
}
