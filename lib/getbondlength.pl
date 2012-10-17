sub getbondlength() #this file is dependant upon openglog.pl
{
	#here is how to get an array from the input
	#the sub must have scalars as arguments first, followed by array
	#i.e. &getbondlength($a1,$a2,@log) works
	#     &getbondlength(@log,$a1,$a2) will confuse the compiler
	my @gausslog;
	my $filesize;
	if ($_[2] eq "")
	{
		return 0;
	}
	else
	{
		@gausslog = @{$_[2]}; #what to do with more than one array pass
		$filesize = @gausslog;
	}
	my $a1 = $_[0];
	my $a2 = $_[1];
	if($a2 eq $a1)
	{
		die "&getbondlength: Error:  $a1 and $a2 are the same\n";
	}
	#the information in the log file's distance matrix is ordered such that the atom number with the largest value should be the looked up by row and vicea versa
	#this line insures that is the case 
	if ($a2 > $a1)
	{
		$row = $a2;
		$col = $a1;
	}	
	else
	{
		$row = $a1;
		$col = $a2;
	}
	my $i = 0;
	#increment counter until distance matrix is reached
	while ($gausslog[$i][1] ne "Distance" && $i <= $filesize)
	{
		$i++;
	}
	$i++;
	#increase through variables until distance matrix is exhausted
	my $relativecol;
	while ($gausslog[$i][1] =~ /\d/ && $i <= $filesize)
	{
		my $j = 2;
		#is coloumn information in first line and are we in coloumn description row?
		if (($gausslog[$i][1] eq $col) && ($gausslog[$i][2] =~ /\d/))
		{
			 $relativecol = 1;
		}
		#is the next coloumn in a coloumn decription line (i.e. is the second position a number?
		elsif ($gausslog[$i][$j] =~ /\d/)
		{
			#go through the coloumn description line until a non number is reached (i.e. end of line)
			while ($gausslog[$i][$j] =~ /\d/)
			{
				
				if($gausslog[$i][$j] eq $col)
				{
				    #set poisition of coloumn
				    $relativecol = $j;
		   		}
				$j++;
			}
		}
		#do we have a coloumn with our data in it?
		if ($relativecol =~ /\d/)
		{
			#are we in a row with distance information?
			if ($gausslog[$i][2] !~ /\d/)
			{
				#are we in the right row?
				if ($gausslog[$i][1] eq $row)
				{
					#distance is located at row/relative coloumn
					my $distance = $gausslog[$i][$relativecol+2];
					$distance = sprintf("%.2f",$distance);
					return $distance;
					last;

				}
			}
		}
		$i++;
	}
	return "error";
}
1;

