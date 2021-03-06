# usage perl in_silico_GA.pl [options]

use Getopt::Long;
use Math::Random qw(:all);

$argu=GetOptions('in=s'=>\$infile, # input fasta chr file
                 'out=s'=>\$outfile, # output file name
                 'coverage=s'=>\$cov, # desired output
                 'seq_error=s'=>\$seq_error, # sequencing error
                 'read_len=s'=>\$read_len, # simulated read length
                 'ins_len=s'=>\$ins_exp,  # average insert size
                 'ins_var=s'=>\$ins_var); # variance of insert size

$chr='';
open(IN,$infile);
open(OUT,">$outfile");
%code=();
$code{'0'}='C';
$code{'1'}='A';
$code{'2'}='T';
$code{'3'}='G';

while(<IN>){
  chomp;
  if(!/^\>/){
	$chr.=$_;
  }
  else{
    $gi=$_;
    if($gi= ~/^\>gi\|(\S+)\|\S+\|\S+/){
      $gi=$1;}

}
}
close(IN);
  
$chr_size=length $chr;
print "chromosome size: $chr_size\n";
$reads_number=int($cov*$chr_size/($read_len*2));
print "generated reads $reads_number x 2\n";

# Insert size distribution
my $alpha = (($ins_exp-$read_len)**2)/$ins_var;
my $beta  = ($ins_exp-$read_len)/$ins_var;

for(1..$reads_number){
  $index=$_;
  $l=length $index;
  $k=8-$l;
  $kk='0' x $k;
  $id= 'read'.$kk.$index.'_'.$gi;

#make start site;
  $start_site=int(rand($chr_size));
#make short seg length;
  my $ins_size_i = $read_len + int(random_gamma(1, $beta, $alpha));

#extract the segment
  $seg=substr($chr,$start_site,$ins_size_i);
  if($start_size+$ins_size_i-1 > length($chr) ){
	$seg.=substr($chr, 0, $start_size+$ins_size_i-1-length($chr));
  }

  $id.='.start'.$start_site.'.seg_len'.$ins_size_i;

#get the reads
  $seq1=substr($seg,0,$read_len);
  #$seg=~tr/ATCG/TAGC/ this line can change the orientation of the second read;
  $seq2=substr($seg,-$read_len);
# sequencing error introducing
  @seq1=split(//,$seq1);
  @seq2=split(//,$seq2);
  @mut1=random_binomial($read_len,1,$seq_error);
  @mut2=random_binomial($read_len,1,$seq_error);

  for(0..$#mut1){
	$i=$_;
	if($mut1[$i]==1){
	  $r=int(rand(4));
	  $seq1[$i]=$code{$r};
	}
	if($mut2[$i]==1){
	  $r=int(rand(4));
	  $seq2[$i]=$code{$r};
	}
  }
  $seq1=join('',@seq1);
  $seq2=join('',@seq2);

  $id1=$id.'#0/1';
  $id2=$id.'#0/2';
  
  print OUT ">$id1\n$seq1\n>$id2\n$seq2\n";
}
