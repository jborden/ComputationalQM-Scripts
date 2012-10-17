sub getzmt()
{
#perl has some major beef with any variation of getzmat();
# the function can be named getz..getzma and than will no longer call the function
# if it is named getzmat();
# oh and it still seems to be able to get the z-matrix (no vars or constants) 
# even if it doesn't seem to have run

	my @gausslog;
	if ($_[0] eq '')
	{
		print "getzmt() Error: No file array given\n";
		return 0;
	}
	else
	{
		@gausslog = @{$_[0]};
	}
	my $zmat;	
	if ($_[1] eq '')
	{
		print "getzmt() Error: No hash given\n";
		return 0;
	}
	else
	{
		$zmat = $_[1];
	}

	my $counter = 0;
	my $i = 1;
	my $numfilelines = @gausslog;
	while ($counter <= $numfilelines)
      	{
		  if ($gausslog[$counter][1] eq "Charge")
	     	  {
			$counter++;
			while($gausslog[$counter][1] ne "Variables:")
		     	{
				$$zmat{label}{$i} = $gausslog[$counter][1];
				$$zmat{atom1}{$i} = $gausslog[$counter][2];
				$$zmat{bond}{$i} = $gausslog[$counter][3];
				$$zmat{atom2}{$i} = $gausslog[$counter][4];
				$$zmat{bangle}{$i} = $gausslog[$counter][5];
				$$zmat{atom3}{$i} = $gausslog[$counter][6];
				$$zmat{dangle}{$i} = $gausslog[$counter][7];	
				$i++;
		     	  	$counter++;
		     	}
	     		
	     	}
		
	     	if ($gausslog[$counter][1] eq "Variables:")
	     	{
	     	      $counter++;
		      $i = 1;
		      while($gausslog[$counter][1] ne "Constants:" and $gausslog[$counter][1] ne "")
		      {
			      $$zmat{initial}{variable}{$i} = $gausslog[$counter][1];

			      $counter++;
			      $i++;
		      }
	      	      $totalvars = $i;
	      	}
	     
	     	if ($gausslog[$counter][1] eq "Constants:")
	     	{
		     $counter++;
		     $j = 1;
		     while($gausslog[$counter][1] ne "")
		     {
				$$zmat{constants}{variable}{$j} = $gausslog[$counter][1];
		        	$$zmat{constants}{value}{$j} = $gausslog[$counter][2];
				$j++;
				$counter++;
		     }
		}
     		$counter++;	
       }
       
       if ($newconstant ne "")
       {
	     $$zmat{constants}{variable}{$j} = $newconstant;
       }	
       	
       $totalconstants = $j;
       $totalparams = $i + $j;
       $$zmat{totalparams} = $totalparams;

       return $zmat;
}
1;

