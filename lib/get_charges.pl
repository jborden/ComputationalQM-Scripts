sub get_charges()
{
	my @gausslog;
	if ($_[0] eq '')
	{
		print "getgeomld() Error: No file array given\n";
	}
	#point to the gausslog array
	else
	{
		@gausslog = @{$_[0]};
	}
	#make the charge array
	my @charges;
	#make the geomdata hash, to be returned later
	my %geomdata;
	#set the number of lines to the size of the gausslog array
	$numfilelines = @gausslog;
	#set the geom count and the linecounter variables
	my $numgeom = 0;
	my $linecounter = 0;
	#this gets the system information
	my @system = &getcharge(\@gausslog);
	#adds the system information to the geomdata hash
	$geomdata{charge} = $system[0];
	$geomdata{multiplicity} = $system[1];
	$geomdata{natoms} = $system[2];
	#go through till the end of file
	my $atomplace;
	while ($linecounter <= $numfilelines)
	{
		#look for a "Input Orientation" line for cartesians
		#and atom type information
		if ($gausslog[$linecounter][1] eq "Input")
		{
			$atomplace = 1;
			$numgeom++;
			#go through all atoms
			while ($atomplace <= $geomdata{natoms} )
			{
			$geomdata{$numgeom}{$atomplace}{atom} = $gausslog[$linecounter+5][2];
			$geomdata{$numgeom}{$atomplace}{x} = $gausslog[$linecounter+5][4];
			$geomdata{$numgeom}{$atomplace}{y} = $gausslog[$linecounter+5][5];
			$geomdata{$numgeom}{$atomplace}{z}= $gausslog[$linecounter+5][6];
			$linecounter++;
			$atomplace++;
		
			}
		}
		#look for ESP charges for LD calculations
		if ($gausslog[$linecounter][1] eq "Charges" && $gausslog[$linecounter][3] eq "ESP")         
		{   
		
			$atomplace = 1;
			$i = $atomplace - 1; #added to start from the first position of @charges array
			#get all of the charges
			$linecounter = $linecounter + 3;
			while ($atomplace <= $geomdata{natoms} )
			{
			$geomdata{$numgeom}{$atomplace}{type} = $gausslog[$linecounter][2];
			$geomdata{$numgeom}{$atomplace}{charge} = $gausslog[$linecounter][3]; 
			$charges[$i] = $gausslog[$linecounter][3];
			$linecounter++;	
			$atomplace++;
			$i++;
			}
		
	 	}	
	$linecounter++;
	
	}
	#set the total number of found geometries to geomdata
	$geomdata{numgeom} = $numgeom;
	#return the array with charges 
	return @charges;
}
1;


