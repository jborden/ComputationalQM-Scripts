sub getnonoptgeom()
{
	my @gausslog;
	if ($_[0] eq '')
	{
		print "getoptgeom Error: No file array given\n";
	}
	else
	{
		@gausslog = @{$_[0]};
	}
	my $geomdata;
	if ($_[1] eq '')
	{
		print "getoptgeom Error: No hash reference given\n";
	}
	else 
	{
		$geomdata = $_[1];
	}
	
	my $numnonoptgeom = 0;
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
		if ($gausslog[$counter][2] eq "Non-Optimized" && $gausslog[$counter][3] eq "Parameters" && $gausslog[$counter][2] ne "Optimized")
		{
			#increment amount of optimized geomtries by one, index begins at 1		
           		$numnonoptgeom++;		
	   		$atomplace = 1; 
			
			while($atomplace <= $$geomdata{natoms})
			{
		
			$$geomdata{nonopt}{$numnonoptgeom}{$atomplace}{type} = $tempgeom[$atomplace][1];
			$$geomdata{nonopt}{$numnonoptgeom}{$atomplace}{x} = $tempgeom[$atomplace][2];
			$$geomdata{nonopt}{$numnonoptgeom}{$atomplace}{y} = $tempgeom[$atomplace][3];
			$$geomdata{nonopt}{$numnonoptgeom}{$atomplace}{z} = $tempgeom[$atomplace][4];
			$atomplace++;
			}
			$counter2 = $counter;
			
			while($counter2 < $numfilelines)
			{
				if ($gausslog[$counter2][3] =~ /\($line1param\)/)
				{
				$$geomdata{nonopt}{$numnonoptgeom}{$line1param} = $gausslog[$counter2][4];
				last;
				}
				$counter2++;
			}
			while($counter2 < $numfilelines)
			{
				if ($gausslog[$counter2][3] =~ /\($line2param\)/)
				{
				$$geomdata{nonopt}{$numnonoptgeom}{$line2param} = $gausslog[$counter2][4];
				last;
				}
				$counter2++;
			}
		}
		$counter++;
	}
$$geomdata{nonopt}{num} = $numnonoptgeom;
$counter = 0;
return $geomdata;
}
1;

