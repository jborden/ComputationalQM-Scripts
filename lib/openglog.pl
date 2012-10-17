sub openglog()
{
#this functions returns a split file
# 0 first col....n last coloumn
my $filename = $_[0]; 
open(GLOG,"<$filename"); # or die "openglog() Error: $filename does not exist!\n";
my @tempsplit = <GLOG>;
#this is to reset the gausslog variable for geoms.pl. As push is used, 
#it does not create a new @gausslog... instead it just appends data from geoms.pl 
#to the end, making all the functions work on just the first logfile
my @splitfile;
#Index of the number of lines in file
#Read file into memory and format it into "coloumns"
	foreach $line (@tempsplit)
	{
		@tmp = split(/\s+/,$line);
  		push @splitfile, [@tmp];
	}

#clear out templog from memory
@tempsplit = 0;
close GLOG;
return @splitfile;
}
1;

