#!/usr/bin/env perl

use strict;
use warnings;
use Bio::DB::EUtilities;

my $infile= $ARGV[0];
open  (my $filehandle,'<',$infile) or die "Could not open $infile\n";

my @ids;
while (my $line = <$filehandle>){
	chomp $line;
	my @linearray = split(" ",$line);
	push(@ids,@linearray);
}

my $factory = Bio::DB::EUtilities->new(-eutil          => 'elink',
                                       -email          => 'mymail@foo.bar',
                                       -db             => 'nucleotide',
                                       -dbfrom         => 'protein',
                                       -correspondence => 1,
                                       -id             => \@ids);
 while (my $ds = $factory->next_LinkSet) {
 	print $ds->get_submitted_ids,"\t",$ds->get_ids,"\n";
 }