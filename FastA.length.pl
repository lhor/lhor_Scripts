#!/usr/bin/perl

my $file=$ARGV[0];

($file) or die <<HELP

This script calculates the length and average length of a set of sequences in FastA format.

Usage "perl $0 sampleID 16SFastaFile.fa > formatedFasta.fa"


HELP
;
open (FILE,"<",$file) or die "Cannot read file: $file: $!\n";
my $len = 0;
my $count = 0;
while ($lines = <FILE>)
	{
	chomp $lines;
	if($lines=~ m/^>/) {
	}
	else
	{
	$seql+= length ($lines);
	}
	$count++;
}
print "Total length: ",$seql,"\n","Average length: ",$seql/$count,"\n";	