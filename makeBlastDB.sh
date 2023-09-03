#!/bin/bash

INPUT_FASTA=nr_viridiplantaea.fa
#INPUT_FASTA=fungi_nr.fa
#INPUT_FASTA=metazoa.fa
#INPUT_FASTA=nr_celegans.fa
#INPUT_FASTA=nr_mydas.fa

# build viridiplantaea blast index file
makeblastdb -in ${INPUT_FASTA} -title "Viridiplantaea $today" -parse_seqids -dbtype prot -out viridiplantaea
