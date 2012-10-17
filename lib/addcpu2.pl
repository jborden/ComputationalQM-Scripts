#this sub is now dependant on ssh_ping.pl
sub addcpu()
{
	my $node;
	my $numberofnodes;
	my $freeslot;
	my $j;
	#first supplied argument is the nodes to look on
	if ($_[0] eq '')
	{
		print "addcpu() Error: No node given\n";
		return 0;
	}
	else
	{
		$node = $_[0];
	}
	#get the map for the amount of free cpu space
	my $maphash;
	my $maxslot;
	if ($_[1] eq '')
	{
		print "addcpu(): No maphash given, default for maxslot is set to 2\n";
		$maxslot = 2;
	}
	else
	{
		$maphash = $_[1];
		$maxslot = $$maphash{$node};
	}
	#is the node up and running ? this depends on ssh_ping.pl
	if (eval {&ssh_ping("$node")})
	{
	
		@tmp1 = `ssh $node "ps -wwaxu user" | grep g03 | grep exe`; #check for gaussian jobs running
		@tmp2 = `ssh $node "ps -wwaxu user" | grep Qdyn5`; #check for Qdyn jobs running
		@tmp3 = `ssh $node "ps -wwaxu user" | grep cs21`; #check for chemsol jobs	
		$j = 0;
		
			foreach $line (@tmp1) 
			{
				$j++; #each time there is an occurance of g03, increments j
			}
		
			foreach $line (@tmp2)
			{
				$j++; #""                 		    "" Qdyn5, increments j
			}
			
			foreach $line (@tmp3)
			{
				$j++; #""				    "" cs21, increments j
			}
	}	
	else
	{
		$j = 2;
	}	
	#this calculates freespace based upon the total number of free slots available ($maxslots)
	$freeslot = ($maxslot - $j); 
	return ($freeslot); #return the amount of free slots on the nodes
}
1;
