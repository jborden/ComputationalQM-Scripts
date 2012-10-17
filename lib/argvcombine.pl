sub getlineargs(){

my %surfacedata;
foreach $argnum ( 0 .. $#ARGV) {

if ($ARGV[$argnum] eq "-h")
        	{
		
		print "Usage: combine_surfaces.pl -ld -f <combined_surface_filename> <surface.txt>\n\n";
		print "-ld - use the Langevin Dipoles generated surfaces\n";
		print "<combine_surface_filename> is the name of the file for outputting of combined surfaces\n";
		print "<surface.txt> are the surfaces to be combined.\n";
		die "surfaces must have a .txt extension\n";
		}	
        
	if ($ARGV[$argnum] eq "-ld")
	{
		$useld = 1;
	}
	if ($ARGV[$argnum] eq "-f")
	{
		$combinesurface = $ARGV[$argnum + 1];
	}
	if ($ARGV[$argnum] =~ m/txt/ && $ARGV[$argnum - 1] ne "-f")
	{       
			$surfacedata{$ARGV[$argnum]} = $ARGV[$argnum];
			my $i = 1;
			while(( $ARGV[$argnum + $i] !~ m/txt/ and $ARGV[$argnum + $i] !~ /-f/ and $ARGV[$argnum + $i] !~ /-ld/ and $ARGV[$argnum + $i] !~ /-gas/) && (($argnum + $i) < $#ARGV))
			{
				
				
				if ($ARGV[$argnum + $i] eq "-x")
				{
					$surfacedata{$ARGV[$argnum]}{xrange} = $ARGV[$argnum + ($i + 1)];
					$i++;
				}
				if ($ARGV[$argnum + $i] eq "-y")
				{
					$surfacedata{$ARGV[$argnum]}{yrange} = $ARGV[$argnum + ($i + 1)];
					$i++;
				}
				$i++;
			}
	}
	if ($ARGV[$argnum] eq "-gas")
	{
		$usegas = 1;
	}
}
   	
	if ($useld != 1)
	{
		$useld = 0;
	}

	return \%surfacedata;
}
1;
