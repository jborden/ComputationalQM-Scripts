sub printoptzmat()
{
#declare formats
format ZMAT_COMFILE =
@<< @<< @<<<<<< @<< @<<<<<<<<<<< @<< @<<<<<<<<<<<<<<<
$label,$atom1,$bond,$atom2,$bangle,$atom3,$dangle
.
# $label = $$zmat{elabel}{$i}
# $atom1  = $$zmat{atom1}{$i}
# $bond   = $$zmat{bond}{$i}
# $atom2  = $$zmat{atom2}{$i}
# $bangle = $$zmat{bangle}{$i}
# $atom3  = $$zmat{atom3}{$i}
# $dangle = $$zmat{atom3}{$i}
format ZVARS_COMFILE =
@<<<<<<<<<<<<<<<@###.####
$variable,$value
.
# $initial = $$zmat{vars}{initial}{$i} 
# $value   = $$zmat{opt}{vars}{$geomcounter}{$$zmat{vars}{initial}{$i}}

format ZVARS_USER_COMFILE =
@<<<<<<<<<<<<<<<@>>>>>>>>>>>>>>>>>>
$newvariable,$newvalue
.
# $initial = $$zmat{initial}{$i} 
# $value   = $$zmat{opt}{vars}{$geomcounter}{$$zmat{vars}{initial}{$i}}
format ZCONSTANTS_COMFILE =
@<<<<<<<<<<<<<<<@###.####
$constant,$value
.
# $value = $$zmat{opt}{vars}{$geomcounter}{$newconstant}

#end of formats
	#declare pointers
	my $zmat;
	if ($_[0] eq '')
	{
		print "printoptzmat() Error: No hash array given\n";
		return 0;
	}
	else
	{
		$zmat = $_[0];
	}
	#declare directory
	my $dir = $_[0];
	if ($_[1] eq '')
	{
		print "printoptzmat() Error: No dir specified\n";
		return 0;
	}
	else
	{
		$dir = $_[1];
	}
	#if no userfile is selected, setup default 
	#com file inputs else open custom userfile for zmat com file 
	my $userfilelength;
	my @methods;
	my @Userfile;
	if ( $userfile eq "" )
	{
   		$Userfile[0] = "\%mem=250MB\n";
		$Userfile[1] = "#HF STO-3G\n";
		$userfilelength = 2;
	}
	else
	{
	        open(USERFILE,"<$userfile") or die "Could not open $userfile\n";
	        @Userfile = <USERFILE>;
	        close USERFILE;
	        $userfilelength = @Userfile;
	}
	
	@methods = split /([#\s])/, $Userfile[1];	
	$methods[4] =~ s/\*/star/;
	my $geomcounter = 1;
	if ($lastgeom)
	{
		$geomcounter = $$zmat{opt}{num};
	}
	#go through each opt geoms until the last is reached
	while ($geomcounter <= $$zmat{opt}{num})
	{
		#properly format the user specified line parameters
		$$zmat{opt}{vars}{$geomcounter}{$line1param} = sprintf("%.2f",$$zmat{opt}{vars}{$geomcounter}{$line1param});
		
		$$zmat{opt}{vars}{$geomcounter}{$line2param} = sprintf("%.2f",$$zmat{opt}{vars}{$geomcounter}{$line2param});
		#create a new description to create a com file from	
		if ($line2param eq '')
		{
		$newdescription = join "",$methods[2],"-",$methods[4],"-optimized-zmatrix-","$line1param-","$$zmat{opt}{vars}{$geomcounter}{$line1param}";
		}
		else
		{
		$newdescription = join "",$methods[2],"-",$methods[4],"-optimized-zmatrix-","$line1param-","$$zmat{opt}{vars}{$geomcounter}{$line1param}-","$line2param-","$$zmat{opt}{vars}{$geomcounter}{$line2param}";
		}
		#create a new com file with the above description
		$newcom = join "",$dir,"/",$newdescription,".com";
		#create a chk file name with the above description
	        $newchk = join "",$newdescription,".chk";	
		#open the comfile for printing, or die trying
		open(COMFILE,">$newcom") or die "Can't open output file: $newcom\n";
		#write the checkpoint info to comfile
		print COMFILE "\%chk=/tmp/james/$newchk\n";
		#write the command line to comfile
		print COMFILE "$Userfile[0]";
		print COMFILE "$Userfile[1]";
		print COMFILE "\n";
		#write the selected parameters to comfile
		print COMFILE "Choosen Parameters\n";
		print COMFILE "$line1param is $$zmat{opt}{vars}{$geomcounter}{$line1param}\n";
		if ($line2param ne '')
		{
		print COMFILE "$line2param is $$zmat{opt}{vars}{$geomcounter}{$line2param}\n";
		}
		#write the SCF gas related to the selected geometries
		#to the com file
		print COMFILE "SCF Done: $$zmat{opt}{$geomcounter}{scfgas}\n";
		print COMFILE "\n";
		#write the charge and multiplicity to the file
		print COMFILE "$$zmat{charge} $$zmat{multiplicity}\n";
		#select the filehandle
		select COMFILE;
		#change the format to be used,$~,to ZMAT_COMFILE
		$~="ZMAT_COMFILE";
		select STDOUT;
		my $atomcount = 1;
		while ($$zmat{label}{$atomcount} ne "")
		{
			$label =  $$zmat{label}{$atomcount};
			$atom1  = $$zmat{atom1}{$atomcount};
			$bond   = $$zmat{bond}{$atomcount};
			$atom2  = $$zmat{atom2}{$atomcount};
			$bangle = $$zmat{bangle}{$atomcount};
			$atom3  = $$zmat{atom3}{$atomcount};
			$dangle = $$zmat{dangle}{$atomcount};	
			write COMFILE;
			$atomcount++;
		}
	      	
		print COMFILE "Variables:\n";	
		#select the filehandle
		if ($newvariable ne "")
		{
			#check out argv2.pl for where $newvariable
			#and $newvalue come from
			select COMFILE;
			$~="ZVARS_USER_COMFILE";
			select STDOUT;
			write COMFILE;
		}	
		my $paramcount = 1;	
		#write the parameters to the file
		while ($paramcount <= $$zmat{totalparams})
		{
			if ($$zmat{initial}{variable}{$paramcount} eq $newconstant)
			{
				$paramcount++;
				next;
			}
			if ($$zmat{initial}{variable}{$paramcount} eq "")
			{
				$paramcount++;
				next;
			}
			if ($$zmat{initial}{variable}{$paramcount} eq $newvariable)
			{
				$paramcount++;
				next;
			}	
			select COMFILE;
			#change the format to be used,$~, to ZVARS_COMFILE
			$~="ZVARS_COMFILE";
			select STDOUT;
			$variable = $$zmat{initial}{variable}{$paramcount};
			$value   = $$zmat{opt}{vars}{$geomcounter}{$$zmat{initial}{variable}{$paramcount}};
			write COMFILE;
			$paramcount++;
		}
		#write constants to com file
		my $constantcount = 1;	
		if ($$zmat{constants}{variable}{$constantcount} ne "")
		{
			print COMFILE "Constants:\n";
			
			while ($$zmat{constants}{variable}{$constantcount} ne "")
			{
				if ($$zmat{constants}{variable}{$constantcount} ne $newvariable)
				{
					select(COMFILE);
					$~="ZCONSTANTS_COMFILE";
					$constant = $$zmat{constants}{variable}{$constantcount};
					$value = $$zmat{opt}{vars}{$geomcounter}{$$zmat{constants}{variable}{$constantcount}};
					select STDOUT;
					write COMFILE;
					$constantcount++;
					next;
				}
				$constantcount++;
			}
		
		}
		print COMFILE "\n";	
			
		if ( $userfilelength > 2)
	        {
			$i = 2;	
			while ( $i <= $userfilelength)
			{
				print COMFILE "$Userfile[$i]";
				$i++;
			}
			print COMFILE "\n";
		}				
		$geomcounter++;	
		print "$newcom\n";
	}
}
1;
