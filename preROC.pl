open (BLAST, $ARGV[0]);
open (OUT, ">pROC_bitscore.table");


while (my $blast = <BLAST>){
        chomp $blast;
        @col=split("\t",$blast);

        if ($col[0] =~m/@%/) {
        $true=1;
        print OUT $col[11],"\t",$true,"\n";

        }else{
        $false=0;
        print OUT $col[11],"\t",$false,"\n";

        }

}