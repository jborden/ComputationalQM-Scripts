sub getnonoptvars()
{
	my @gausslog;
	if ($_[0] eq '')
	{
		print "getnonoptvars() Error: No file array given\n";
		return 0;
	}
	else
	{
		@gausslog = @{$_[0]};
	}
	my $zmat;
	if ($_[1] eq '')
	{
		print "getnonoptvars() Error: No hash reference given\n";
		return 0;
	}
	else
	{
		$zmat = $_[1];
	}
	my $numfilelines = @gausslog;
	my $numnonoptgeom = 0;
	my $linecounter = 0;
	while ($linecounter !~ $numfilelines)
	{

		if ($gausslog[$linecounter][2] eq "Non-Optimized")
		{
			$numnonoptgeom++;
			$linecounter = $linecounter + 5;
			while ($gausslog[$linecounter][1] eq "!")
			{
				if ($gausslog[$linecounter][2] =~ /-\d/)
				{
			  	split(/-\d\w*.\w*/,$gausslog[$linecounter][2]);
			  	$tempvar = $_[0];
			  	split(/$_[0]/,$gausslog[$linecounter][2]);
			  	$$zmat{nonopt}{vars}{$numnonoptgeom}{$tempvar} = $_[1];
			  	$linecounter++;
			  	next;
		  		}  
				$$zmat{nonopt}{vars}{$numnonoptgeom}{$gausslog[$linecounter][2]} = $gausslog[$linecounter][3];
				$linecounter++;
			}

		}
	$linecounter++;
	}
return $zmat;
}
1;
