#this sub is now dependant on ssh_ping.pl
sub ssh_check()
{
	my $node;
	my $job;
	#first supplied argument is the node to look on
	if ($_[0] eq '')
	{
			print "ssh_check() Error: No node given\n";
			return 0;
	}
	else
	{
			$node = $_[0];
	}
	#second supplied argument is the job to look for
	if ($_[1] eq '')
	{
		
			print "ssh_check() Error: No job given\n";
			return 0;
	}
	else
	{
			$job = $_[1];
	}
		
		if (eval {&ssh_ping("$node")})
		{
		
			if ($job =~ /.cs/)
			{	
				@output = `ssh $node "ps -wwax" | grep $job | grep cs21`;
			}	
			else
			{
				@output = `ssh $node "ps -wwax" | grep $job | grep -v tmp`; #look for a specific command (g03, Qdyn5)	
			}
			if (@output)
			{
				return 1; #if nothing is in @output, return failure
			}
			else
			{
		        	return 0;	
			}
		}
		else
		{
			return -1;
		}
}
1;
