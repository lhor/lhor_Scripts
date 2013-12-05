#!/usr/bin/perl

my $name=$ARGV[0];
my $file=$ARGV[1];

($name and $file) or die <<HELP

This script will prepare the input fasta files for the qiime pipeline, 
by renaming each sequence's IDs to include the sample ID

Usage "perl $0 sampleID 16SFastaFile.fa > formatedFasta.fa"


HELP
;
open (FILE,"<",$file) or die "Cannot read file: $file: $!\n";
$count=1;
while ($lines = <FILE>)
	{
	chomp $lines;
	if($lines=~ m/^>(.*$)/) {
	$id=$1;
	}
	else
	{
	$seq=$lines;
	}
	print ">${name}_$count $id sample=$name\n$seq\n";
	$count++;
}
		