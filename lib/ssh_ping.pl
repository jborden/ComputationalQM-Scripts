sub ssh_ping() {
open(STDERR, "/dev/null");
$hostname = $_[0];					#set first argument to $hostname
$pid = open (SSH, "ssh $hostname |");			#create socket to interface with the command ssh
$timeout = 5;
$size = 10;
	eval 
	{
		local $SIG{ALRM} = sub { die "alarm"}; #SIGALARM = $SIG{ALRM}, part of %SIG
		alarm $timeout;				#will return SIGALARM after $timeout seconds
		$nread = sysread SSH, $buffer, $size;   #operation waiting to work,`` does not work
		alarm 0;				#turns the alarm off if above works, this eval  
	};
kill HUP,$pid;			#gives the "hangup" signal, kills without reset screen
close SSH;
	if ($@) 
	{
		#die unless $@ eq "alarm";	# propagate unexpected errors, i.e. any error msg besides one 
						# explicilty created above will be "caught"
						#generates unecesarry comments at compile time
		return 0;			# timed out
	}	
	else 
	{
		
		return 1;
	}
close STDERR;
}	
1;
