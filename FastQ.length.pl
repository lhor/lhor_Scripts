#!/bin/perl

my ($seqs) = @ARGV;

$seqs or die "

Description:
   Calculates the added and average 
   length of a set of sequeces.
   
Usage:
   $0 seqs.fastq

   seqs.fastq	A FastQ file containing the sequences.
  
";

open SEQ, "<", $seqs or die "Cannot read file: $seqs: $!\n";

my $len = 0;
my $count = 0;
while(<SEQ>){
	if($.%4==2){
		chomp;
		$total += length $_;
		$count++;
	}
}
print "Total length: ",$total,"\n","Average length: ",$total/$count,"\n";

close SEQ;