sub getlineargs(){

foreach $argnum ( 0 .. $#ARGV) {

if ($ARGV[$argnum] eq "-h")
        {
		
		print "Usage: get_surface -d -m <SolventPhaseMethod> -b <SolventPhaseBasisSet> -gm <GasPhaseMethod> -gb <GasPhaseBasisSet> -g <GasPhaseGroundStateEnergy> -sg <SolventGroundStateEnergy> -sd <LDGroundStateEnergy> -a1 <atom #1> -a2 <atom #2> <workingdir>\n\n";
	        print "-d get files for surface from current working dir only\n\n";
		print "-m Solvent Phase Method used when calculating surface. Must be given in the format you specified in creaction of 2 dimensional surface.\n\n";
		print "-b Solvent Phase Basis Set used for generation of 2 Dimensional surface. Must be given in the format you specified in creation of surface.\n\n";
		print "-gm Gas Phase Method. Gas Phase Method used to calculate alternative SCF Energy.\n\n";
		print "-gb Gase Phase Basis Set. Gas Phase Basis Set used to calculated alternative SCF Energy.\n\n";
		print "Gas phase method and basis set extracts an alternatve Gas phase energy. The default energy used corresponds to the method and basis set used to generate the optimized geometry\n\n";
		print "-g Gas Phase Ground State energy in a.u. Ground state energy of the reactants involved, if any in atomic units. Defaults to 0.\n\n";
		print "-sg Solvent Ground State energy in kcal/mol. Energy of solvation. Typically given as DeltaG obtained via routecard=(read) and keyword (given after geometry specification) 'scfvac'.\n\n";
		print "-sd LD Ground State energy in kcal/mol.\n\n";
		print "-u Unimolecular reaction, no entropy terms are added to system.\n\n";
		print "The following options relate to finding the distance between two bonds\n";
		print "a1 refers to atomnumber 1 and a2 refers to atomnumber 2\n";
		print "-a1 <atom 1>\n";
		print "-a2 <atom 2>\n";
		print "-c Produce a surface containing charges\n";
		die "<workingdir> is the directory where surface is located.\n";
	}	

if ($ARGV[$argnum] eq "-d")
	{
	$get_local = 1;
	}
if ($ARGV[$argnum] eq "-u")
	{
	$unimolecular = 1;
	}	
if ($ARGV[$argnum] eq "-m")
        {
        $method = $ARGV[$argnum + 1];
        }
if ($ARGV[$argnum] eq "-b")
        {
        $basisset = $ARGV[$argnum + 1];
        }
if ($ARGV[$argnum] eq "-g")
        {
        $groundstategas = $ARGV[$argnum + 1];
	}
if ($ARGV[$argnum] eq "-gm")
	{
	$gasmethod = $ARGV[$argnum + 1];
	}
if ($ARGV[$argnum] eq "-gb")
	{
	$gasbasis = $ARGV[$argnum + 1];
	}
if ($ARGV[$argnum] eq "-sm")
        {
        $solventmethod = $ARGV[$argnum + 1];
        }
if ($ARGV[$argnum] eq "-sb")
        {
        $solventbasisset = $ARGV[$argnum + 1];
        }
if ($ARGV[$argnum] eq "-sg")
        {
        $groundpcm = $ARGV[$argnum + 1];
        }
if ($ARGV[$argnum] eq "-sd")
        {
        $groundld = $ARGV[$argnum + 1];
        }
if ($ARGV[$argnum] eq "-a1")
	{
	$atom1 = $ARGV[$argnum + 1];
	}
if ($ARGV[$argnum] eq "-a2")
	{
	$atom2 = $ARGV[$argnum + 1];
	}
if ($ARGV[$argnum] eq "-c")
	{
	$charge_surface = 1;
 	}
if ([$ARGV[$#ARGV]] != '')
	{
	  $workingdir = $ARGV[$#ARGV];
	}
   }
}
1;
