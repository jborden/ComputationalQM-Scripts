sub getsurfaceGASLOGS()
{
	#define the directory from which to extract as $workingdir
	chdir $workingdir;
	#get perl compatible dir information
	$currentdir = getcwd;
	#show the current working dir
	opendir WD, "$currentdir";
	#grab all directories, besides . and ..
	@directories = grep -d, grep { $_ ne '.' and $_ ne '..'} readdir WD;
	closedir WD;
	#set $numdir to the amount of directories
	$numdir = @directories;
	if ($numdir eq 0 or $get_local)
	{
		my @logfiles = `ls *$gasmethod-$gasbasis*.log`;
		foreach $log (@logfiles)
		{
			#get rid of newline from ls
			chomp($log);	
		 	$log = abs_path($log);
			push @files, $log;
		}
		return @logfiles;
	}
	print "There are $numdir subdirectories in $currentdir\n";
	print "listed :\n @directories\n";
	
	sort @directories;
	#lets you know where you start at
	my $k = 0;
	my $j = 0;
	my @files;
	#go to individual directories and extract data	
	while ($k < $numdir)
	{
  		chdir $directories[$k] or die "Can't open $directories[$k]\n";
		#lets you know where you are
		
		$dir = getcwd;
		my @logfiles = `ls *$gasmethod-$gasbasis*.log`;
		
		foreach $log (@logfiles)
		{
			#get rid of newline from ls
			chomp($log);	
		 	$log = abs_path($log);
			push @files, $log;
		}
		$k++;
		chdir '..';
	}
	return @files;
}
1;

