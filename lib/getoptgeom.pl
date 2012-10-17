sub getoptgeom()
{
	my @gausslog;
	if ($_[0] eq '')
	{
		print "getoptgeom() Error: No file array given\n";
		return 0;
	}
	else
	{
		@gausslog = @{$_[0]};
	}
	my $geomdata;
	if ($_[1] eq '')
	{
		print "getoptgeom() Error: No hash reference given\n";
		return 0;
	}
	else 
	{
		$geomdata = $_[1];
	}
	
	my $numoptgeom = 0;
	my $counter = 0;
	my $atomplace;
	my $counter2;
	my $numfilelines = @gausslog;
	
	while ($counter < $numfilelines)
	{
		if ($gausslog[$counter][1] eq "Input")
		{
			$atomplace = 1;
			$counter2 = 1;
		while ($atomplace <= $$geomdata{natoms})
			{
			$tempgeom[$atomplace][1] = $gausslog[$counter+5][2];
			$tempgeom[$atomplace][2] = $gausslog[$counter+5][4]; 
			$tempgeom[$atomplace][3] = $gausslog[$counter+5][5];
			$tempgeom[$atomplace][4] = $gausslog[$counter+5][6];
			$counter++;
			$atomplace++;
			}
		}
		if ($gausslog[$counter][2] eq "Optimized" && $gausslog[$counter][3] eq "Parameters" && $gausslog[$counter][2] ne "Non-Optimized")
		{
			#increment amount of optimized geomtries by one, index begins at 1		
           		$numoptgeom++;		
	   		$atomplace = 1; 
			
			while($atomplace <= $$geomdata{natoms})
			{
		
			$$geomdata{opt}{$numoptgeom}{$atomplace}{type} = $tempgeom[$atomplace][1];
			$$geomdata{opt}{$numoptgeom}{$atomplace}{x} = $tempgeom[$atomplace][2];
			$$geomdata{opt}{$numoptgeom}{$atomplace}{y} = $tempgeom[$atomplace][3];
			$$geomdata{opt}{$numoptgeom}{$atomplace}{z} = $tempgeom[$atomplace][4];
			$atomplace++;
			}
			$counter2 = $counter;
			
			while($counter2 < $numfilelines)
			{
				if ($gausslog[$counter2][3] =~ /\($line1param\)/)
				{
				$$geomdata{opt}{$numoptgeom}{$line1param} = $gausslog[$counter2][4];
				last;
				}
				$counter2++;
			}
			while($counter2 < $numfilelines)
			{
				if ($gausslog[$counter2][3] =~ /\($line2param\)/)
				{
				$$geomdata{opt}{$numoptgeom}{$line2param} = $gausslog[$counter2][4];
				last;
				}
				$counter2++;
			}
		}
		$counter++;
	}
$counter = 0;
return $geomdata;
}
1;

