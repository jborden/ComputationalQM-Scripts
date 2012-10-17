sub printld() {

	if ($_[0] eq '')
	{
		print "printld() Error: No hash array given\n";
	}
	#reads in the hash pointer to geomdata
	else
	{
		$geomdata = $_[0];
	}
	#start with the first geom
	my $geomcounter = 1;
	while ($geomcounter <= $$geomdata{numgeom})
	{
		@tempfile = split (/\.log/,$file);
		$newfile = join "",$tempfile[0],".cs";
	
		open(LDFILE,">$newfile") or die "Can't open output file $newfile\n";
		print LDFILE "LD $newfile\n";
		print LDFILE "  $natoms   1\n";
		print LDFILE "\n";
		my $atomcounter = 1;
		while ($atomcounter <= $$geomdata{natoms})
		{
			#another hack to setup variables so format
			#can see pointers!
			
			$type = $$geomdata{$geomcounter}{$atomcounter}{type};
			$atom = $$geomdata{$geomcounter}{$atomcounter}{atom};
			$charge = $$geomdata{$geomcounter}{$atomcounter}{charge};
			$x = $$geomdata{$geomcounter}{$atomcounter}{x};
			$y = $$geomdata{$geomcounter}{$atomcounter}{y};
			$z = $$geomdata{$geomcounter}{$atomcounter}{z};
	
format LDFILE =
@|         @##.#   @#.####  @##.#### @##.#### @##.####
$type,$atom,$charge,$x,$y,$z
.
		
			select LDFILE;
			$~="LDFILE";
			select STDOUT;
			write LDFILE;		
			$atomcounter++;
		}
		if ($append ne "")
		{
			foreach $line (@append)
			{
				print LDFILE "$line";
			}	
		}
	
	$geomcounter++;
	print LDFILE "\n";
	print "$newfile\n";
	
	}
}	
1;

