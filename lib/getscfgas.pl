sub getscfgas() {
	if ($_[0] eq '')
	{
		print "getscfgas() Error: No File Array given\n";
		return 0;
	}
	else
	{
		
		my @gausslog = @{$_[0]};
	}
#set the number of filelines
my $numfilelines = @gausslog;
#set the linecount	
my $linecount = 0;
#number of optimized geometries
my $numoptgeomcounter = 0;
#number of nonoptimized geometries
my $numnonoptgeomcounter = 0;
#creation of the geomdata array
my %geomdata;
#go through the entire file
while ($linecount <= $numfilelines)
	{
		if ($gausslog[$linecount][1] eq "SCF" && $gausslog[$linecount][2] eq "Done:")
		{
	  		$tempscf = $gausslog[$linecount][5];
		}
		if ($gausslog[$linecount][2] eq "Optimized" && $gausslog[$linecount][3] eq "Parameters")
		{
			#increment the amount of optimized geometries by one, $numoptgeom refers both to total of optimized geometries and starts with 1 in the index of optimized data
			$numoptgeomcounter++;
			#determine the SCF GAS for the geometry
			$geomdata{opt}{$numoptgeomcounter}{scfgas} = $tempscf;
		}
		if($gausslog[$linecount][2] eq "Non-Optimized" && $gausslog[$linecount][3] eq "Parameters")
		{
			#increment the amount of non-optimized geometries by one
			$numnonoptgeomcounter++;
			#determine the SCF gas for the non opt geometry
			$geomdata{nonopt}{$numnonoptgeomcounter}{scfgas} = $tempscf;

		}
		$linecount++;
	}
#this gets the charge, multiplicty and number of atoms
my @system = &getcharge(\@gausslog);
#adds the system information to the geomdata hash
$geomdata{charge} = $system[0];
$geomdata{multiplicity} = $system[1];
$geomdata{natoms} = $system[2];
$geomdata{opt}{num} = $numoptgeomcounter;
$geomdata{nonopt}{num} = $numnonoptgeomcounter;
#returns a pointer to the geom data hash
return \%geomdata;
}
1;

