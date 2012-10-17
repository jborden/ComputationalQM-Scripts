sub printnonoptgeom() 
{
	my $geomdata;	
	if ($_[0] eq '')
	{
		print "printnonoptgeom() Error: No hash reference given\n";
		return 0;
	}
	else
	{
		$geomdata = $_[0];
	}
	my $dir;
	if ($_[1] eq '')
	{
		print "printnonoptgeom() Error: No dir given to write to!\n";
		return 0;
	}
	else 
	{
		$dir = $_[1];
	}

	my @Userfile;
	my $userfilelength;
	if ( $nonoptuserfile eq "" )
	{
		$Userfile[0] = "\%mem=250MB\n";
		$Userfile[1] = "#HF STO-3G\n";
		$userfilelength = 2;
		print "printnonoptgeom(): No nonoptimized nonoptuserfile given, defaulting to HF STO-G\n";
	}
	else 
	{
		open(USERFILE,"<$nonoptuserfile");
     		@Userfile = <USERFILE>;
     		close USERFILE;
     		$userfilelength = @Userfile;
	}
	#get the working dir
	my @methods = split /([#\s])/, $Userfile[1];
	#replace the * with the word star so that it doesn't have wildcards in
	#filenames! Notice that this depends on the user declaring <method> <basis set> in that specific order!
	$methods[4] =~ s/\*/star/;
	#start from the first geometry
	my $geomcounter = 1;

	#loop through each geometry until the last one
	while ($geomcounter <= $$geomdata{nonopt}{num})
	{
		#declare the new com file
		my $newfile;
		#if there isn't a second parameter go ahead and make a 1
		# parameter com file name
		if ($line2param eq "")
		{
			#create a newfile name with the method, basis set and parameter in the filename
			$newfile = join "",$dir,"/","Non-Opt-",$methods[2],"-",$methods[4],"-",$line1param,"-",$$geomdata{nonopt}{$geomcounter}{$line1param},".com";
		}	
		#same like above, but for two parameters
		else
		{
			
			$newfile = join "",$dir,"/","Non-Opt-",$methods[2],"-",$methods[4],"-",$line1param,"-",$$geomdata{nonopt}{$geomcounter}{$line1param},"-",$line2param,"-",$$geomdata{nonopt}{$geomcounter}{$line2param},".com";
		}
		#now to declar the chkpoint files so that they are unique
		#to the comfile
		#the checkpoint files are created similiar to the com
		#file names
		my $chkfile;
		
		if ($line2param eq "")
		{
			$chkfile = join "","\%chk=/tmp/",$methods[2],"-",$methods[4],"-",$$geomdata{nonopt}{$geomcounter}{$line1param},".chk\n";
		}
		else 
		{

			$chkfile = join "","\%chk=/tmp/",$methods[2],"-",$methods[4],"-",$$geomdata{nonopt}{$geomcounter}{$line1param},"-",$$geomdata{nonopt}{$geomcounter}{$line2param},".chk\n";
		}
		#open the comfile as declared above	
		open(COMFILE,">$newfile");
		#print to the comfile the chkfile
		print COMFILE "$chkfile";
		#print any user specifed lines
	       	print COMFILE "$Userfile[0]";
		print COMFILE "$Userfile[1]";
		print COMFILE "\n";
		#list the choosen parameters, along with the SCF gas energy for
		#that corresponding geometry
		#Note: the surface creation perl script depend on having SCF
		#gas IN the associated comfiles for solvation!
		print COMFILE "Choosen Parameters are listed as follows:\n";
		print COMFILE "$line1param is $$geomdata{nonopt}{$geomcounter}{$line1param}\n";
		if ($line2param ne "")
		{
			print COMFILE "$line2param is $$geomdata{nonopt}{$geomcounter}{$line2param}\n";
		}
		print COMFILE "SCF Done: $$geomdata{nonopt}{$geomcounter}{scfgas}\n";	
		print COMFILE "\n";
		print COMFILE "$$geomdata{charge} $$geomdata{multiplicity}\n";
	#these are a bunch of variable declarations because format
	#cannot see pointers for some reason... is is beyond me why not 
	#and I can not find any mention of it on the web

#setting up format to print "hard variables" that have
#to be declared in the loop that prints!
format CART_COMFILE_NONOPT =
@<<	@###.#####	@###.#####	@###.#####
$type,$x,$y,$z
.
	#select the comfile filehandle so its format can be changed
	select COMFILE;
	#set its FORMAT, $~, to the one specified up top
	$~="CART_COMFILE_NONOPT";
	#go back to using STDOUT as default filehandle
	select STDOUT;
	my $atomcounter = 1;
		while ($atomcounter <= $$geomdata{natoms})
		{
			#this is a "hack" to get around format's
			#inability to "see" references
			$type = $$geomdata{nonopt}{$geomcounter}{$atomcounter}{type};
			$x = $$geomdata{nonopt}{$geomcounter}{$atomcounter}{x};
			$y = $$geomdata{nonopt}{$geomcounter}{$atomcounter}{y};
			$z = $$geomdata{nonopt}{$geomcounter}{$atomcounter}{z};
			write COMFILE;
			$atomcounter++;
		}
	$filecounter = 2;
		#this prints everything after the second line in the
		#user specified append file to the end of the com file
		if ( $userfilelength > 2)
		{
			print COMFILE "\n";
			while ( $filecounter <= $userfilelength)
			{
				print COMFILE "$Userfile[$filecounter]";
				$filecounter++;
		
			}
		}
	print COMFILE "\n";
	close (COMFILE);
	print "$newfile\n";
	$geomcounter++;
	}
}
1;

