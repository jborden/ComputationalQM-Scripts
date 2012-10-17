sub getlineargs()
{

foreach $argnum ( 0 .. $#ARGV) 
	{

	if ($ARGV[$argnum] eq "-h")
        	{
		
		print "Usage: geomsld -u <append> -b <BasisSet> -m <Method> <workingdir>\n\n";
	        print "-u <append> is the file containing user supplied information to be appeneded to the *.cs file\n";
		print "-b Basis Set used for the calculation of ESP charges and PCM dGsolv. Must be same basis set used for solvation.\n\n";
		print "-m Method used for the calculation of ESP charges and PCM dGsolv. Must be same method used for solvation.\n\n";
		die "<workingdir> is the directory where surface is located.\n";
		}	

	if ($ARGV[$argnum] eq "-u")
		{
			$append = $ARGV[$argnum + 1];
			open(APPEND, "<$append");
			@append = <APPEND>;
			close APPEND;
		}
	if ($ARGV[$argnum] eq "-m")
        	{
        	$method = $ARGV[$argnum + 1];
        	}
	if ($ARGV[$argnum] eq "-b")
        	{
        	$basisset = $ARGV[$argnum + 1];
        	}
	if ($ARGV[$#ARGV] eq '')
		{
			die "No workingdir specified\n";
		}
	if([$ARGV[$#ARGV]] != '')
		{
		$workingdir = $ARGV[$#ARGV];
		}
	}
}
1;
