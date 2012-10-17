sub getsurface()
{
#this sub will need to "Use Cwd;" in the main program
#this sub will take the entire list of comfiles for the surface and return
#a hash, %surface to be processed for printing

       	my @coms;	
	if ($_[0] eq '')
	{
	
		print "getsurface() Error: No list of com files given\n";
		return 0;
	}
	else
	{
		@coms = @{$_[0]};
	}	
        my @log;
	if ($_[1] eq '' && $gasmethod ne "" && $gasbasis ne "")
	{
		print "getsurface() Error: No log files for gas phase calculation given\n";
		return 0;
	}
	elsif ($gasmethod ne "" && $gasbasis ne "")
	{
		@logs = @{$_[1]};
	}
	
	#create a surface hash
	my %surface;
	#create charge array
	my @charges;
	my $surfaceGas;
	my $xvar;
	my $yvar;	
	my $j = 0;
	foreach $com (@coms)
	{
		$j++;
		#need to get the path for 
		#get rid of newline from ls
		my @comfile = &openglog($com) or die "getsurface(): Can not open $com\n";
		my $numfilelines = @comfile;

		#zero out the temp variable and the com file
	        my $i = 0;
			while ($i <= $numfilelines)
			{
				     
				if ($comfile[$i][0] eq "SCF" && $comfile[$i][1] eq "Done:")
				{
					if ($gasbasis eq "" && $gasmethod eq "")
					{
						$surfaceGas = sprintf("%.6f",$comfile[$i][2]);
					}
				}
				if ($comfile[$i][0] eq "Choosen" && $comfile[$i][1] eq "Parameters")
				{
					#$xvar  = sprintf("%.2F",$comfile[$i + 1][2]);
					$xvar = $comfile[$i + 1][2];
					$xname = $comfile[$i + 1][0];
					if ($comfile[$i + 2][0] eq "SCF")
				        {
						$yvar = "";
					}	
					else
					{
						#$yvar  = sprintf("%.2F",$comfile[$i + 2][2]);
						$yvar  = $comfile[$i + 2][2];
						$yname = $comfile[$i + 2][0];
						$yyes  = 1;
					}
				}
				$i++;
			}
			
			if ($gasbasis ne "" && $gasmethod ne "")
			{
				for $log (@logs)
				{
					if ($yvar ne "")
					{
						if ($log =~ /$xname-$xvar/) 
						{
							if ($log =~ /$yname-$yvar/)
							{
#this could be an independent function
								my @logfile = &openglog($log) or die "getsurface(): Can not open $log\n";		
								my $numloglines = @logfile;	
								my $j = 0;
								while ($j < $numloglines)
								{
									if ($logfile[$j][1] eq "SCF" && $logfile[$j][2] eq "Done:" && $logfile[$j][5] =~ /\d.\d/)
									{
										$surfaceGas = $logfile[$j][5];
										
										last;
									}
									$j++;
								}	
							}
						}
						#print "getsurface(): yvar was $yvar\n";
					}
					elsif ($yvar eq "")
					{
						if ($log =~ /$xname-$xvar/)
						{
								
							my @logfile = &openglog($log) or die "getsurface(): Can not open $log\n";		
							my $numloglines = @logfile;	
							my $j = 0;
							while ($j < $numloglines)
							{
								if ($logfile[$j][1] eq "SCF" && $logfile[$j][2] eq "Done:")
								{
									$surfaceGas = $logfile[$j][5];
									last;
								}
								$j++;
							}	
						}
						#	print "getsurface(): yvar was $yvar\n com was $com\n";
					}
				}
			}
		$surface{$xvar}{$yvar}{gas} = $surfaceGas;
		#my @presplit = split /\//,$com;
		#my @newfilename = split /\.com/, $presplit[$#presplit];
		#my $log = join "",$newfilename[0],".log";
		my $log = $com;  
		$log =~ s/\.com/\.log/;
		my $out = $com;
		$out =~ s/\.com/\.out/;
		#this is for later processing of LD .out files
		#my $out = join "",$newfilename[0],".out";
		#openglog the file of interest
		
		my @gausslog = &openglog($log);
		#$Distance[$j] = &getbondlength($atom1,$atom2,@gausslog);
		$i = 0;
		$numfilelines = @gausslog;
		if (($atom1 && $atom2) ne "")
		{
			$surface{$xvar}{$yvar}{bondlength} = &getbondlength($atom1,$atom2,\@gausslog);
		}
		if ($charge_surface)
		{
			@charges = &get_charges(\@gausslog);
			$i = 0;
			$total_charges = @charges;
			$surface{$xvar}{$yvar}{total_charges} = $total_charges;
			while ($i < $total_charges)
		       	{
				$surface{$xvar}{$yvar}{charge}{$i} = $charges[$i];
				$i++;
			}	
		}
			while ($i <= $numfilelines)
			{
#It is recomended to always use "pcm=scfvac" to get solvation in kcal/mol
#here is one to ponder: above I use $logfile[$i][0]... here I need
#$logfile[$i][1]... why ? because there is a space before "DeltaG" in 
#the logfiles.	
				if ($gausslog[$i][1] eq "DeltaG")
				{
					
					$surface{$xvar}{$yvar}{pcm_deltaG} = $gausslog[$i][5];	
				}
				$i++;
			}
		my @outfile = &openglog($out);
		$numfilelines = @outfile;
		$i = 0;
			while ($i <= $numfilelines)
			{
				if ($outfile[$i][1] eq "Total" and $outfile[$i][2] eq "dG")
				{
					$surface{$xvar}{$yvar}{ld_deltaG} = $outfile[$i][3];
				}
				$i++;
			}
	        @outfile = 0;	
		@logfile = 0;
		$surface{$xvar}{$yvar}{com} = $com;
		$surface{$xvar}{$yvar}{ld_out} = $out;
		$surface{$xvar}{$yvar}{solv_log} = $log;
		$j++;
	$k++;
	}
	#return the reference to the surface hash
	return \%surface;
}
1;
