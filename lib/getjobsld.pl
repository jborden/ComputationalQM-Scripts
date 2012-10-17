sub getjobsld()
{
	chdir $workingdir or die "Can't chdir $workingdir\n";
	$printdir = getcwd;
	opendir (WD, $workingdir) or die "Can't open dir $workingdir\n";
	# perl does not reconize ../ need to do ~/workindir not ../workingdir
	@allfiles =  readdir WD;
	@allfiles = grep -d, grep { $_ ne "." and  $_ ne ".."} @allfiles; #must be in wd in order for this to work
	$numberdir = @allfiles;
	closedir WD;
	foreach $line (@allfiles)
	{
		$line = join "",$workingdir,$line;
	}
	$j=0;
	foreach $line (@allfiles)
	{
		#this line gets rid of the error message from the ls
		#open(STDERR,"/dev/null");
		#change this line depending upon the kind of file you are
		#dealing with
		
		@tempjob = `ls $line/*.cs`;
		foreach $jobs (@tempjob)
		{
			chomp($jobs);
			#split file into com and logs
			@newfilename = split /\.cs/, $jobs;
			$log = join "",$newfilename[0],".out";
			#open the file of interest
			$job{in}{$j} = $jobs;
			$job{out}{$j} = $log;
			$j++;
		}
	}
	$numjobs = $j;
        print "Number of jobs: $numjobs\n";
}
1;
