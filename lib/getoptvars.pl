sub getoptvars()
{

	my @gausslog;
	if ($_[0] eq '')
	{
		print "getoptvars() Error: No File Array given\n";
		return 0;
	}
	else
	{
		@gausslog = @{$_[0]};
	}
	my $zmat;
	if ($_[1] eq '')
	{
		print "getoptvars() Error: No hash reference given\n";
		return 0;
	}
	else
	{
		$zmat = $_[1];
	}
	my $numoptgeom = 0;
	my $linecounter = 0;
	my $numfilelines = @gausslog;
	while ($linecounter <= $numfilelines)
	{
		#look for optimized parameters
		if ($gausslog[$linecounter][2] eq "Optimized")
		{
			$numoptgeom++;
			$linecounter = $linecounter + 5;
			while ($gausslog[$linecounter][1] eq "!")
			{
				#this if code is need because sometimes
				#the variable names and values go
				#from being two words to one
				#this split the them into two words
				if ($gausslog[$linecounter][2] =~ /-\d/)
				{
			  		split(/-\d\w*.\w*/,$gausslog[$linecounter][2]);
			  		my $tempvar = $_[0];
			  		split(/$_[0]/,$gausslog[$linecounter][2]);
					$$zmat{opt}{vars}{$numoptgeom}{$tempvar} = $_[1];
			  		$linecounter++;
			  		next;
		  		}
				$$zmat{opt}{vars}{$numoptgeom}{$gausslog[$linecounter][2]} = $gausslog[$linecounter][3];
				$linecounter++;
			}

		}
	$linecounter++;
	}
return $zmat;
}
1;
