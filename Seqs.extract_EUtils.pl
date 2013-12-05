#!/usr/bin/env perl

use strict;
use warnings;
use Bio::DB::EUtilities;

my $infile= $ARGV[0];
open  (my $filehandle,'<',$infile) or die "Could not open $infile\n";

my @refSeqIDs;
while (my $line = <$filehandle>){
	chomp $line;
	my @linearray = split(" ",$line);
	push(@refSeqIDs,@linearray);
}


my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch', 
                                       -db      => 'protein', 
                                       -rettype => 'fasta',
                                       -email   => 'x@y.com',
                                       -id      => \@refSeqIDs);

print $factory->get_Response->content;