sub getpath() {

	my $file = $_[0];
	$path = abs_path($file);
	@temppath = split /\//,$path;
	my $i = 1;
	$temppath = @temppath;
	$temppath--;
	my $pathname;
	while ($i < $temppath)
	{
		$pathname = join "",$pathname,"/",$temppath[$i];
		$i++;
	}
	
	return $pathname;
}
1;

