sub printsurface(){ 
	#if you are obtaining the surface hash from getsurface() the values
	#are:
	#$$href{$x}{$y}{gas} = gas phase scf
	#$$href{$x}{$y}{com} = com file for pcm, scf gas from optimized geometries are here
	#$$href{$x}{$y}{pcm_deltaG} = pcm deltaG
	#$$href{$x}{$y}{solv_log} = log file of PCM solvation calculation
	#$$href{$x}{$y}{ld_deltaG} = LD solvation
	#$$href{$x}{$y}{ld_out} = output file from LD calculation
	my $reftosurface;
	if ($_[0] eq '')
	{
		print "printsurface() Error: No surface hash given\n";
		return 0;
	}
	else 
	{
		#$reftohash = shift;
		$reftosurface = $_[0];
	} 
	my $surfacedir;
	if ($_[1] eq '')
	{
		print "printsurface() Error: No dir given\n";
		return 0;
	}
	else
	{
		$surfacedir = $_[1];
	}
	my @tempsplit = split /\//,$surfacedir;
	my $surfacefile = join "",$tempsplit[$#tempsplit],".txt";
	my $surfacefile = join "",$surfacedir,"/",$surfacefile;
	open (SURFACE, ">$surfacefile") or die "Can't open $surfacefile\n";
	print SURFACE "# Ground State Energy - Gas Phase:	$groundstategas\n";
	print SURFACE "# Ground State Energy - PCM Solvation:	$groundpcm\n";
	print SURFACE "# Ground State Energy - LD Solvation:	$groundld\n";
	print SURFACE "# 1<xvar> ";
	if ( $yyes)
	{
		print SURFACE "2<yvar> 3<gas> 4<gas - groundgas * 627.5 = rel_gas> 5<pcm_deltaG> 6<pcm_deltaG - groundpcm = rel_pcm_deltaG> 7<LD_deltaG> 8<ld_deltaG - groundld = rel_ld_deltaG> ";
	       if ($unimolecular)
       	       {
			print SURFACE "9<rel_gas + rel_pcm_deltaG> 10<rel_gas + rel_ld_deltaG> ";
	       }
	       else
	       {
		       print SURFACE "9<rel_gas + rel_pcm_deltaG + 2.4> 10<rel_gas + rel_ld_deltaG + 2.4> ";
	       }
	}
	else
	{
		print SURFACE "2<gas> 3<gas - groundgas * 627.5 = rel_gas> 4<pcm_deltaG> 5<pcm_deltaG - groundpcm = rel_pcm_deltaG> 6<LD_deltaG> 7<ld_deltaG - groundld = rel_ld_deltaG> ";
		if ($unimolecular)
		{
			print SURFACE "8<rel_gas + rel_pcm_deltaG> 9<rel_gas + rel_ld_deltaG> ";
		}
		else
		{
			print SURFACE "8<rel_gas + rel_pcm_deltaG + 2.4> 9<rel_gas + rel_ld_deltaG + 2.4> ";
		}
	}	
	if ( (($atom1 && $atom2) ne "") && ($yvar ne ""))
	{
		print SURFACE "11<bondlength $atom1 $atom2>\n";
	}
	elsif ((($atom1 && $atom2) ne "") && ($yvar eq ""))
	{
		print SURFACE "10<bondlength $atom1 $atom2>\n";
	}
	else
	{
		print SURFACE "\n";
	}
	for $x (sort keys %$reftosurface) 
	{
		for $y (sort keys %{$$reftosurface{$x} } )
		{
			
			$$reftosurface{$x}{$y}{rel_gas} = (($$reftosurface{$x}{$y}{gas} - $groundstategas) * 627.5);
			$$reftosurface{$x}{$y}{rel_pcm_deltaG} = ($$reftosurface{$x}{$y}{pcm_deltaG} - $groundpcm);
			$$reftosurface{$x}{$y}{rel_ld_deltaG} = ($$reftosurface{$x}{$y}{ld_deltaG} - $groundld);
			if ($unimolecular)
			{
				$$reftosurface{$x}{$y}{gas_pcm} = $$reftosurface{$x}{$y}{rel_gas} + $$reftosurface{$x}{$y}{rel_pcm_deltaG};
				$$reftosurface{$x}{$y}{gas_ld} = $$reftosurface{$x}{$y}{rel_gas} + $$reftosurface{$x}{$y}{rel_ld_deltaG};
			}
			else
			{
				
				$$reftosurface{$x}{$y}{gas_pcm} = $$reftosurface{$x}{$y}{rel_gas} + $$reftosurface{$x}{$y}{rel_pcm_deltaG} + 2.4;
				$$reftosurface{$x}{$y}{gas_ld} = $$reftosurface{$x}{$y}{rel_gas} + $$reftosurface{$x}{$y}{rel_ld_deltaG} + 2.4;
			}
			if ($y eq "")
			{
				print SURFACE "$x ";
			}
			else
			{
				
				print SURFACE "$x $y ";
			}
			if ($$reftosurface{$x}{$y}{gas} eq "")
			{
				print SURFACE "no_gas_scf ";
			}
			else
			{
				$$reftosurface{$x}{$y}{rel_gas} = sprintf("%.2f",$$reftosurface{$x}{$y}{rel_gas});
				print SURFACE "$$reftosurface{$x}{$y}{gas} $$reftosurface{$x}{$y}{rel_gas} ";
			}
		        if ($$reftosurface{$x}{$y}{pcm_deltaG} eq "")
			{
				print SURFACE "no_pcm_deltaG ";
			}
			else 
			{
				$$reftosurface{$x}{$y}{pcm_deltaG} = sprintf("%.2f",$$reftosurface{$x}{$y}{pcm_deltaG});
				$$reftosurface{$x}{$y}{rel_pcm_deltaG} = sprintf("%.2f",$$reftosurface{$x}{$y}{rel_pcm_deltaG});
				print SURFACE "$$reftosurface{$x}{$y}{pcm_deltaG} $$reftosurface{$x}{$y}{rel_pcm_deltaG} ";
			}
			if ($$reftosurface{$x}{$y}{ld_deltaG} eq "")
		        {
				print SURFACE "no_ld_deltaG ";
			}
			else
			{
				$$reftosurface{$x}{$y}{rel_ld_deltaG} = sprintf("%.2f",$$reftosurface{$x}{$y}{rel_ld_deltaG});
				$$reftosurface{$x}{$y}{gas_pcm} = sprintf("%.2f",$$reftosurface{$x}{$y}{gas_pcm});
				$$reftosurface{$x}{$y}{gas_ld} = sprintf("%.2f",$$reftosurface{$x}{$y}{gas_ld});
				print SURFACE "$$reftosurface{$x}{$y}{ld_deltaG} $$reftosurface{$x}{$y}{rel_ld_deltaG} $$reftosurface{$x}{$y}{gas_pcm} $$reftosurface{$x}{$y}{gas_ld} ";  
			}
			if ($charge_surface)
			{
				$i = 0;
				while ($i < $$reftosurface{$x}{$y}{total_charges})
			        {
					print SURFACE "$$reftosurface{$x}{$y}{charge}{$i} ";
					$i++;
				}
			}	
			if (($atom1 && $atom2) ne "")
			{
				print SURFACE "$$reftosurface{$x}{$y}{bondlength} \n";
			}
			else
			{
				print SURFACE "\n";
			}
			if ($$reftosurface{$x}{$y}{gas} eq "")
			{
				print SURFACE "!! SCF Gas missing from:\n";
				print SURFACE "!! $$reftosurface{$x}{$y}{com}\n";
			}
			if ($$reftosurface{$x}{$y}{pcm_deltaG} eq "")
			{
				print SURFACE "!! No PCM DeltaG from:\n";
				print SURFACE "!! $$reftosurface{$x}{$y}{solv_log}\n";
			}
			if ($$reftosurface{$x}{$y}{ld_deltaG} eq "")
			{
				print SURFACE "!! No LD DeltaG from:\n";
				print SURFACE "!! $$reftosurface{$x}{$y}{ld_out}\n";
			}
		}
		if ($yvar ne "")
		{
			print SURFACE "\n";
		}
	}
	return $surfacefile;
}
1;
