sub readCpuUsageMap() {

	#read in the mapfile
	my $mapfile;
	if ($_[0] eq '')
	{
		print "readCpuMapfile() error: No map file specified\n";
		return 0;
	}
	else
	{
		$mapfile = $_[0];
	}
	#open and split the mapfile, this is dependent upon openglog
	my @mapfile = &openglog($mapfile);
	my $linecount = @mapfile;
	my $counter = 0;
	my %cpumap;
	while ($counter < $linecount)
	{
		if ($mapfile[$counter][0] =~ /\#/)
		{
			$counter++;
			next;
		}
		$cpumap{$mapfile[$counter][0]} = $mapfile[$counter][1];
		
		$counter++;
	}
	
	return \%cpumap;
}
1;
	
