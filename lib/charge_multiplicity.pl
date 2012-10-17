sub getcharge()
{
$counter = 0;

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
$counter = 0;
}
1;

