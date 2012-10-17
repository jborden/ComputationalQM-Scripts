sub printcombinesurface()
{
  if ($_[0] ne "")
  {
	  $combinedsurfaces = $_[0];
  }
  else
  {
	  $combinedsurfaces = "combined_surfaces.txt";
  }
  open(COMBINE,">$combinedsurfaces") or die "Could not open $combinedsurfaces\n";

  print COMBINE "!! This surface is a combination of the following surfaces:\n";

  foreach $surface (@surfaces)
  {
	  print COMBINE "!! $surface\n";
  }
  if ( $useld == 0)
  {
 	 print COMBINE "!! This surface is based upon a PCM surface\n";
  }
  if ( $useld == 1)
  {
	print COMBINE "!! This surface is based upon a LD surface\n";
  }	
  print COMBINE "!! Variables are -\n";
  print COMBINE "!! Xvar Yvar GasSCF dGasSCF DeltaG dDeltaG DeltaGld dDeltaGld sum sumld surface\n";

  $i = $firstx;
  while ($i <= $lastx)
  {
	 $j = $firsty;
	 while($j <= $lasty)
	 {
	 	print COMBINE "$i $j $newslice{$i}{$j}{GasSCF} $newslice{$i}{$j}{dGasSCF} $newslice{$i}{$j}{DeltaG} $newslice{$i}{$j}{dDeltaG} $newslice{$i}{$j}{DeltaGld} $newslice{$i}{$j}{dDeltaGld} $newslice{$i}{$j}{sum} $newslice{$i}{$j}{sumld} ";
		$k = 10;
		while ($newslice{$i}{$j}{$k} ne "")
		{
			print COMBINE "$newslice{$i}{$j}{$k} ";
		        $k++;
		}
		print COMBINE "	!! $newslice{$i}{$j}{surface} \n";
		$j = sprintf("%.2f",($j + $ystep));
	 }
 	 print COMBINE "\n";
	 $i = sprintf("%.2f",($i + $xstep));
  }
}
1;
