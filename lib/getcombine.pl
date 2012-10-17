sub getcombine() {

	my $surfacedata;
	if ($_[0] eq '')
	{
		print "getcombine(): Error: No surface data given\n";
		return 0;
	}
	else
	{
		$surfacedata = $_[0];
	}
	
foreach $surface (sort keys %$surfacedata)
{
	print "opened $surface\n";
	for $range (sort keys %{$$surfacedata{$surface}})
	{
		my @range = split(":",$$surfacedata{$surface}{$range});
		$min 	   = $range[0];
		$max 	   = $range[1];
		if ($min > $max)
		{
			print "getcombine() Error: Minimum $min is greater than maximum $max in $surface`s $range!\n";
			return 0;
		}
		$slice{$surface}{$range}{min} = $min;
		$slice{$surface}{$range}{max} = $max;
		print "Exluding for $range : $min : $max in $surface\n"; 
	}	
		
	@gausslog = &openglog($surface);
	my $numfilelines = @gausslog;
	$i = 0;
	while ($i < $numfilelines)
        {
		# skip comment lines in surfaces
		if ($gausslog[$i][0] eq "!!")
	           {
		     if ($gausslog[$i][5] eq "Gas")
		     {
			$slice{$surface}{gasground} = $gausslog[$i][7];
		        $combinedgroundgas = $slice{$surface}{gasground};
		     }
     		     if ($guasslog[$i][5] eq "Solvent")
		     {
			$slice{$surface}{groundsolvent} = $gausslog[$i][7];
   		        $combinedgroundsolvent = $slice{$surface}{groundsolvent};
		     }
		     if ($gausslog[$i][5] eq "LD")
		     {
			$slice{$surface}{groundLD} = $gausslog[$i][8];
		        $combinedgroundLD = $slice{$surface}{groundLD};
		     }			
		     $i++;
	             next;
	     	   }	   
		#skip blank lines in surfaces
	        if ($gausslog[$i][0] eq "")
		   {
		     $i++;
	             next;
	           }	     
		#assign values to the corresponding %slice keys

		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{GasSCF} = $gausslog[$i][2];
		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{dGasSCF} = $gausslog[$i][3];
		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{DeltaG} = $gausslog[$i][4];
		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{dDeltaG} = $gausslog[$i][5];
		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{DeltaGld} = $gausslog[$i][6];
		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{dDeltaGld} = $gausslog[$i][7];
		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{sum} = $gausslog[$i][8];
		$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{sumld} = $gausslog[$i][9];
	
		$j = 10;
			while ($gausslog[$i][$j] ne "")
			{
				$slice{$surface}{$gausslog[$i][0]}{$gausslog[$i][1]}{$j} = $gausslog[$i][$j];
				$j++;
			}
		
		push @xvars, $gausslog[$i][0];
		push @yvars, $gausslog[$i][1];
		$i++;
                   
	}
}

#set up range of x and y values in the surface
	@xvars = sort @xvars;
	@yvars = sort @yvars;
	$firstx = $xvars[0]; #lowest x value
	$lastx = $xvars[$#xvars]; #highest x value
	$firsty = $yvars[0]; #lowest y value
	$lasty = $yvars[$#yvars]; #highest y value
	
	$i = 0;
	while (($xvars[$i+1] - $xvars[$i]) == 0)
	{
		$i++;
	}
	$xstep = $xvars[$i+1] - $xvars[$i]; #by what value to step x by
	
	$i = 0;
	while (($yvars[$i+1] - $yvars[$i]) == 0)
	{
		$i++;
	}
	
	$ystep = $yvars[$i+1] - $yvars[$i]; #by what value to step y by
	$whichsurface = 0;


	foreach $surface (sort keys %$surfacedata) 
	{
		print "analyzing $surface\n";
		$i = $firstx;
		while ($i <= $lastx)
		{
			#set the count for the first y value
			$j = $firsty;
			while ($j <= $lasty)
			{
				if ($useld == 0 && $usegas ne 1)
				{
					if (($slice{$surface}{$i}{$j}{sum}) eq "" or ($slice{$surface}{$i}{$j} !~ /\d.\d/))
					{
						$j = sprintf("%.2f",($j + $ystep));
						next;
					}
					
					if ($slice{$surface}{$i}{$j}{sum} ne "")
					{
						if ($newslice{$i}{$j}{sum} eq "")
						{
							&set_slice();
						}
						elsif(&check_exclude())
						{
							$j = sprintf("%.2f",($j + $ystep));
							next;
						}
						elsif ($slice{$surface}{$i}{$j}{sum} < $newslice{$i}{$j}{sum})
						{
							&set_slice();
			        		}
					}
				}
				if ($useld == 1)
				{
					if (($slice{$surface}{$i}{$j}{sumld} eq "") or ($slice{$surface}{$i}{$j}{sumld} !~ /\d.\d/))
					{
						$j = sprintf("%.2f",($j + $ystep));
						next;
					}
					if ($slice{$surface}{$i}{$j}{sumld} ne "")
					{
						if ($newslice{$i}{$j}{sumld} eq "")
						{
							&set_slice();
						}
						elsif(&check_exclude())
						{
							$j = sprintf("%.2f",($j + $ystep));
							next;
						}
						elsif ($slice{$surface}{$i}{$j}{sumld} < $newslice{$i}{$j}{sumld})
						{
							&set_slice();
						}	
					}
				}
				if ($usegas == 1)
				{
					if (($slice{$surface}{$i}{$j}{GasSCF}) eq "" or ($slice{$surface}{$i}{$j}{GasSCF} !~ /\d.\d/)) 
					{
						$j = sprintf("%.2f",($j + $ystep));
						next;
					}
					
					if ($slice{$surface}{$i}{$j}{GasSCF} ne "")
					{
						if ($newslice{$i}{$j}{GasSCF} eq "")
						{
							&set_slice();
						}
						elsif(&check_exclude())
						{
							$j = sprintf("%.2f",($j + $ystep));
							next;
						}
						elsif ($slice{$surface}{$i}{$j}{GasSCF} < $newslice{$i}{$j}{GasSCF})
						{
							&set_slice();
			        		}
					}
				}
				$j = sprintf("%.2f",($j + $ystep));
			}	
	
			$i = sprintf("%.2f",($i + $xstep));
		}
	}
#notes so far:
# for specific calls for a value in a hash... all calls for key values, {}, must be enclosed in '' 
# marks except for the last key call. 
# example: $slice{'methanol-attack-CH3-6.7-CH3.txt'}{'3.35'}{'3.40'}{GasSCF} where GasSCF does NOT
# need to be enclosed in ''
# the easiest method is probably to call
# $slice{$surfacetemp}{$xtemp}{$ytemp}{GasSCF} where each variable is defined like: 
# $surfacetemp = "methanol-attack-CH3-6.7-CH3.txt";
}
1;
sub set_slice() {

	$newslice{$i}{$j}{GasSCF} = $slice{$surface}{$i}{$j}{GasSCF}; 
	$newslice{$i}{$j}{dGasSCF} = $slice{$surface}{$i}{$j}{dGasSCF};
	$newslice{$i}{$j}{DeltaG} = $slice{$surface}{$i}{$j}{DeltaG};
	$newslice{$i}{$j}{dDeltaG} = $slice{$surface}{$i}{$j}{dDeltaG};
	$newslice{$i}{$j}{DeltaGld} = $slice{$surface}{$i}{$j}{DeltaGld};
	$newslice{$i}{$j}{dDeltaGld} = $slice{$surface}{$i}{$j}{dDeltaGld};
	$newslice{$i}{$j}{sum} = $slice{$surface}{$i}{$j}{sum};
	$newslice{$i}{$j}{sumld} = $slice{$surface}{$i}{$j}{sumld}; 
	$newslice{$i}{$j}{surface} = $surface;
	my $k = 10;
	while ($slice{$surface}{$i}{$j}{$k} ne "")
	{
		$newslice{$i}{$j}{$k} = $slice{$surface}{$i}{$j}{$k};
		$k++;
	}

}
1;
sub check_exclude() {

	for $name (sort keys %slice)
	{
		if ($surface ne $name)
		{
			if ($i >= $slice{$name}{xrange}{min} and $i <= $slice{$name}{xrange}{max})
			{
				if ($j >= $slice{$name}{yrange}{min} and $j <= $slice{$name}{yrange}{max})
				{	
					return 1;
				}
			}
		}
	}
return 0;
}
1;
