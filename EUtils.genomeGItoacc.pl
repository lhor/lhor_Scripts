use LWP::Simple;

my $infile= $ARGV[0];
open  (my $filehandle,'<',$infile) or die "Could not open $infile\n";

while (my $line= <$filehandle>)  {
	chomp $line;
	$gi_list = $line;
	#assemble the URL
	$base = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
	$url = $base . "efetch.fcgi?db=protein&id=$gi_list&rettype=acc";
	#post the URL
	$output = get($url);
	chomp $output;
	print $line,"\t",$output;
}