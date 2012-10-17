#!/usr/bin/perl
use File::Basename;
my $dirname = dirname(__FILE__);
require "$dirname/lib/getoptgeom.pl";
require "$dirname/lib/getnonoptgeom.pl";
require "$dirname/lib/getcharge.pl";
require "$dirname/lib/openglog.pl";
require "$dirname/lib/argv2.pl";
require "$dirname/lib/printoptgeom.pl";
require "$dirname/lib/printnonoptgeom.pl";
require "$dirname/lib/getscfgas.pl";
require "$dirname/lib/zmattest.pl";
require "$dirname/lib/getzmt.pl";
require "$dirname/lib/getoptvars.pl";
require "$dirname/lib/getnonoptvars.pl";
require "$dirname/lib/printoptzmat.pl";
require "$dirname/lib/printnonoptzmat.pl";
require "$dirname/lib/getnewvars.pl";
require "$dirname/lib/getpath.pl"; #needs Cwd 'abs_path'
use Cwd 'abs_path';
#use warnings;
&getlineargs();
foreach $line (@filename)
	{
		#get the path name, will be used by print* functions to write
		#to the correct filename
		$line = abs_path($line);
		$dir = &getpath($line);
		#convert log file to array, @gausslog
		#splitting each line by white space
		#defined as: $gausslog[$i][$j]
		#where $i and $j are the line (row) and coloumn position,
		#respectively
		@gausslog = &openglog($line); #this step takes the bulk of the time to accomplish
		#test for zmatrix determines which subroutines are to be
		#run
		if (&zmattest(\@gausslog) == 0)
		{
			#getscfgas is given array gausslog
			#and returns reference to hash %geomdata
			my $reftogeomdata = &getscfgas(\@gausslog);
			#give the reference to hash created by getscfgas
			#to the functions that extract optimized and nonoptimized
			#geometry information
			$reftogeomdata = &getoptgeom(\@gausslog,$reftogeomdata);
			$reftogeomdata = &getnonoptgeom(\@gausslog,$reftogeomdata);
			#print the optimized and nonoptimized geometries	
			&printoptgeom($reftogeomdata,$dir);
			&printnonoptgeom($reftogeomdata,$dir);
		
		}

		if (&zmattest(\@gausslog) == 1)
		
		{
			#getscf performs the same function as above
			my $reftozmat = &getscfgas(\@gausslog);
			#get the zmat topology
			$reftozmat = &getzmt(\@gausslog,$reftozmat);
			#get the variables that are from optimized geometries
			$reftozmat = &getoptvars(\@gausslog,$reftozmat);
			#get the variables that are from nonoptimized geometries
			$reftozmat = &getnonoptvars(\@gausslog,$reftozmat);
			#print the zmatrices 
			&printoptzmat($reftozmat,$dir);
			&printnonoptzmat($reftozmat,$dir);
		}
}	
