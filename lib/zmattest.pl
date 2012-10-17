sub zmattest()
{
	my $linecounter = 0;
	my $zmattest = 0;
	if ($_[0] eq '')
	{
		print "zmattest Error: No File Array given\n";
	}
	else
	{
		my @gausslog = @{$_[0]};
	}
	my $numfilelines = @gausslog;
	while ($linecounter <= $numfilelines)
	{
		if ($gausslog[$linecounter][1] eq "Z-Matrix")
		{
			$zmattest = 1;
			last;
		}
		$linecounter++;
	}
	$linecounter = 0;
	return $zmattest;
}
1;

