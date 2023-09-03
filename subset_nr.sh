#!/bin/bash

export PATH=$PATH:/path/to/seqkit

# nr.fa.gz downloaded from here https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
#ACCFILE=Fungi_out.csv
#ACCFILE=Viridiplantae_out.csv
ACCFILE=Metazoa_out.csv

cat <(echo) <(pigz -dc nr.fa.gz) \
    | perl -e 'BEGIN{ $/ = "\n>"; <>; } while(<>){s/>$//;  $i = index $_, "\n"; $h = substr $_, 0, $i; $s = substr $_, $i+1; if ($h !~ />/) { print ">$_"; next; }; $h = ">$h"; while($h =~ />([^ ]+ .+?) ?(?=>|$)/g){ $h1 = $1; $h1 =~ s/^\W+//; print ">$h1\n$s";} } ' \
    | seqkit grep -f ${ACCFILE} -o nr.viridiplantaea.fa.gz
