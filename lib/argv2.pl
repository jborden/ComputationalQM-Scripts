sub getlineargs()
{
foreach $argnum ( 0 .. $#ARGV)
{
	if ($ARGV[$argnum] eq "-h")
	{
		print "Usage: geom -x (i,j,..,l) -y (i,j,..,l) -l -v <newvariable> \"<newvalue>\" -c <newconstant> -m <userfile> -n <nonoptuserfile> <logfile>\n\n";
		print "-x 1st variable. Must be given in the format i,j,..,k for either bond length, angle or dihedral. Mandatory input.\n\n";
		print "-y 2nd variable. Must be given in the format i,j,..,k for either bond length, angle or dihedral.\n\n";
		print "-l Flag for printing of only the last optimized geometry of a scan log file. Useful for resubmitting crashed files\n\n";
		print "-v New variable and value.If the new value is space seperated i.e. 3.4 S 36 -0.05 it must be enclosed in quotations, \"3.4 S 36 -0.05\" \n\n";
		print "-c New constant. Variable name of new constant in z-matrix.Will be extracted from optimized parameters.\n\n";
		print "-m User defined Gaussian input generation file. If no userfile is given, default route is #HF STO-3G.\n";
		print "The user file is in the following format:\n";
		print "Line 1:\%mem=\n";
		print "Line 2:#Route card\n";
		print "Remaining lines in the userfile are appended to the com file.\n\n";
		print "-n User defined Gaussian input generation file for non-optimized cordinates.Same format as userfile.\n\n";
		die "<logfile> log file from which optimized geometries are taken. Mandatory input\n\n";
	}
}
foreach $argnum ( 0 .. $#ARGV) 
{
	if ($ARGV[$argnum] eq "-l")
	{
		$lastgeom = 1;
	}
	if ($ARGV[$argnum] eq "-v")
	{
		$newvariable = $ARGV[$argnum+1];
		$newvalue = $ARGV[$argnum+2];
	}
	if ($ARGV[$argnum] eq "-m")
	{
		$userfile = $ARGV[$argnum+1];
	}
	if ($ARGV[$argnum] eq "-c")
	{
		$newconstant = $ARGV[$argnum+1];
	}
	if ($ARGV[$argnum] eq "-n")
	{
		$nonoptuserfile = $ARGV[$argnum+1];
	}
	if ($ARGV[$argnum] eq "-x")
	{
		$line1param = $ARGV[$argnum + 1];
        }
	if ($ARGV[$argnum] eq "-y")
	{
 		$line2param = $ARGV[$argnum + 1];
	}
	if ($ARGV[$argnum] =~ m/log/) 
	{
	 	push @filename, $ARGV[$argnum];
	}
#	if ($ARGV[$#ARGV] =! m/log/ ) 
#	{
#		die "Error: Gaussian .log file not given $ARGV[$#ARGV]\n";
#	}
}


#	if ($ARGV[$#ARGV] =! m/log/ ) 
#	{
#		 print "crashed = $ARGV[$#ARGV]\n";
#
#	}
#	die "$ARGV[$#ARGV]\n";
	
	if ($filename[0] eq "")
	{
		die "Error: No Filename given filename\n";
	}
#	elsif (!(eval { $line1param =~ /\d,\d/}) && $line1param ne "")
#	{
#	        die "Error: Line 1 Parameters do not seem to be correct format\nPlease give parameters in L,L or A,A,A or D,D,D,D format\n";
#	}
#	elsif (!(eval { $line2param =~ /\d,\d/}) && $line2param ne "")
#	{
#	        die "Error: Line 2 Parameters do not seem to be correct format\nPlease give parameters in L,L or A,A,A or D,D,D,D format\n";
#	}
	
}
1;

