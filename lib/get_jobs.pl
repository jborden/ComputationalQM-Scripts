sub getjobs() {

	my $i = 0;
	my @job;
	my $submitf;
	if ($_[0] eq '') #did the user give us a que file? This is specified in the main script, submitd.pl
	{
		print "getjobs() Error: No submit file given\n";
		return 0;
	}
	else
	{
		$submitf = $_[0];
	}
	if(open(SUBMIT,$submitf))
	{
		@submit = <SUBMIT>; #dump the contents of the que into @submit
		close SUBMIT;
		foreach $line (@submit)
		{
			chomp($line); #clean off any newlines
			unless (@job{$line} eq $line) #look for repeats, ignore them
			{
				@job{$line} = $line; #hash that allows for keeping track of repeats
				push (@job, $line); #put the filename into the array
			}
		}
	}
	return @job; #return the array @job that contains the filenames
}
1;
