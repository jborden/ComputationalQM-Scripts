#everything centers artound the array @jobs for submission. It is where the filenames to be submitted are kept. These are taken from a user-specified que file (usually ~/submits/submits) 
sub submit() {
	
	#what node are we using?
	my $node;
	my $filename;
	if ($_[0] eq '')
	{
		print "submit() Error: No hostname given\n";
		return 0;
	}
	else
	{
		$node = $_[0];
	}	
	#what filename needs to be submitted?
	if ($_[1] eq '')
	{
		print "submit() Error: No filename given\n";
		return 0;
	}
	else
	{
		$localfile = $_[1];
	}
	my $cpumap;
	if ($_[2] eq '')
	{
		print "submit() Error: No cpu map given\n";
		return 0;
	}
	else
	{
		$cpumap = $_[2];
	}	
        my @tempsplit 	= split /\//,$localfile;
	$stamp 		= int(rand(100000));
	my $remotefile 	= join "",$remotedir,$tempsplit[$#temsplit],".",$stamp;
	my $remotelog 	= $remotefile;
	if ($remotelog =~ /\.com/)
	{
		$remotelog	=~ s/\.com/\.log/;  
	}
	if ($remotelog =~ /\.cs/)
	{
		$remotelog	=~ s/\.cs/\.out/;
	}
	my $remotevdw 	= join "",$remotedir,"vdw.par";
	#how many free slots available?	
	$freeslot = &addcpu("$node",$cpumap); #this is dependant on addcpu.pl
	#does the node have freeslots ?
	if ($freeslot <= 0)
	{
		return 0;
	}	
	#yes it does... lets do some work
	elsif($freeslot > 0)
	{
		while (!&ssh_check("$node","$remotefile") and (&addcpu("$node",$cpumap) > 0)) #is the job running on that node and does that node have free space?
			{
				print "submit():   (1)	I am trying to copy $localfile to $node\n";
				`scp $localfile $node\:$remotefile`;
				print "submit():   (2)	I am trying to run $remotefile on $node as $remotefile\n";
				if ($node =~ /jf1/ or $node =~ /jf8/ or $node =~ /jf9/)
				{
					#apparently the new leopard has changed things a lot with basic system commands
					#ssh must now be run like below:
					if ($remotefile =~ /\.com/)
					{
						`ssh -f $node "source $remotedir.profile ; g03 $remotefile $remotelog &"`;
					}
					elsif ($remotefile =~ /\.cs/)
					{
						`ssh -f $node "source $remotedir.profile ; cs21 $remotevdw $remotefile $remotelog &"`;
					}
				}
				else
				{
					if ($remotefile =~ /\.com/)
					{
						`ssh -f $node "source $remotedir.profile ; g03 $remotefile $remotelog &" ; killall ssh`;
					}
					elsif ($remotefile =~ /\.cs/)
					{
						`ssh -f $node "source $remotedir.profile ; cs21 $remotevdw $remotefile $remotelog &" ; killall ssh`;
					}	
				}				
#here is the crux around which the program was designed.ssh is called (RTFM to understand the ssh call).  profile is loaded and g03 ran. than the "hanging" ssh is killed. there really is no better way to do this. 
			      	sleep 2; #sleep for 2 seconds so as to allow time for everything to go through
				
			}
		
		print "submit():   *	Running $remotefile on $node\n";
	
		return $remotefile; #succesfully submitted
	}
}
1;
sub writetolog(){

	my $node;
	my $filename;	
	if ($_[0] eq '') #was a node given?
	{
		print "writetolog() Error: No node given\n";
	}
	else
	{
		$node = $_[0];
	}
	if ($_[1] eq '') #was a logfile to write to given?
	{
		print "writetolog() Error: No filename given\n";
		return 0;
	}
	else
	{
		$filename = $_[1];
	}
	if ($_[2] eq '') #remotefile name on the server
	{
		print "writetolog() Error: No remotefile name given\n";
		return 0;
	}
	else
	{
		$remotefile = $_[2];
	}
	@time = localtime;
	my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec ); #this makes human readable months
	$time[5] = $time[5] - 100 + 2000; #this makes human readable years.
	#this is the file to write log information to
	my $submitlog = "$ENV{HOME}/james/submits/$months[$time[4]]-$time[3]-$time[5]-submitd.log";
	#print to the logfile of jobs submitted	
	open(JOBFILE, ">>$submitlog") or (print "writetolog() Error: Could not open $submitlog\n" and return 0);	
	print JOBFILE "$filename was submitted as $remotefile on $node on $months[$time[4]]-$time[3]-$time[5] at $time[2]:$time[1]\n"; 
	close JOBFILE;
}
1;
sub removefromque(){
		
	my $que;
	if ($_[0] eq '') #was there a que file given?
	{
		print "removefromque() Error: No que file given\n";
		return 0;
	}
	else
	{
		$que = $_[0];
	}
	my @jobs; #jobs... passed by pointers
	if ($_[1] eq '')
	{
		print "removefromque() Error: No jobs list given\n";
		return 0;
	}
	else
	{
		@jobs = @{$_[1]};
	}
	shift @jobs;	#remove the first entry in the array @jobs, 'shift' everything down one position (i.e. 2nd place becomes 1st)
	open(QUE,">$que") or (print "removefromque() Error: Can not open $que\n" and (return 0));
	foreach $line (@jobs) #the entire job list, minus the submitted file, is written to the que file. There is no better way to do this in perl
	{
		print QUE "$line\n";
	}
	close QUE;
	return @jobs; #return the updated jobs list
}
1;
sub mass_submit(){
#this is the "main" function that does the actual work of taking a huge list of @jobs and putting them on the nodes
#it is a very simple sequential walk down the node list, from node2-node16 
	my @jobs;
	my $cluster;
	if ($_[0] eq '') #which cluster set, m or n?
	{
		print "mass_submit() Error: No node cluster given\n";
		return 0;
	}
	else
	{
		$cluster = $_[0];
	}
	if ($_[1] eq '') #list of jobs given?
	{
		print "mass_submit() Error: No jobs file given\n";
		return 0;
	}
	else
	{
		@jobs = @{$_[1]};
	}
	my $cpumap;
	if ($_[2] eq '')
	{
		print "mass_submit() Error: No cpu map given\n";
		return 0;
	}
	else
	{
		$cpumap = $_[2];
	}
	my $i = 2;
	while ($i <= 16)
	{
		$node = "$cluster$i"; #create specific node name cluster + count
		if ($i == 16)
		{
			$j = 2;
		}
		else
		{
			$j = $i + 1;
		}
		$nextnode = "$cluster$j";
		$freespace = &addcpu("$node",$cpumap); 
		if ($jobs[0] eq '')
		{
			die "mass_submit():	All jobs submitted\n";
		}
		if ($freespace <= 0) #if there is no free space, go to next node
		{
			
			print "mass_submit():	$node is full, checking $nextnode\n";
			$i++;
		}
		elsif (&addcpu("$node",$cpumap) > 0) #double check to make sure there is room on the node (technically, triple check because submit checks this too
		{
			my $remotefile;
			#submit is relentless in that it will keep trying until it can submit to the node,
			#only returning 1 after it succedes. It can not "fail" i.e. return 0
			#so it is safe to just put it as a call before the writing to the log file
			#and the deletion of the entry from the submit file
			$remotefile = &submit($node,$jobs[0],$cpumap); #call to function submit
			&writetolog($node,$jobs[0],$remotefile); #call to write an account of submission to the nodes
			@jobs =	&removefromque($submitf,\@jobs); #call to remove the job from que 
		}

	}	
	return @jobs; #return the jobs that have not been submitted yet

}
1;
