sub getcharge()
{
my $charge;
my $multiplicity;
my $counter = 0;
my @gausslog;
if ($_[0] eq '')
{
   print "getcharge() Error: No file array given\n";
}
else
{
	 @gausslog = @{$_[0]};
}
my $numfilelines = @gausslog;
while ($counter !~ $numfilelines)
	{
		if ($gausslog[$counter][1] eq "Charge")
		{
		$charge = $gausslog[$counter][3];
	  	$multiplicity = $gausslog[$counter][6];
		}
		if ($gausslog[$counter][1] eq "NAtoms=")
		{
		$natoms = $gausslog[$counter][2];
	  	$counter = 0;       
	  	last;
		}
		$counter++;
	}
	my @charge = ($charge,$multiplicity,$natoms);
	return @charge;
}
1;

