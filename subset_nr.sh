#!/bin/bash

export PATH=$PATH:/path/to/seqkit

#ACCFILE=Fungi_out.csv
#ACCFILE=Viridiplantae_out.csv
ACCFILE=Metazoa_out.csv

cat nr/nr.fa | seqkit grep -f ${ACCFILE} -o Metazoa_nr.fa
