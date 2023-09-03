#!/bin/bash

# decompressed gz file

pigz -dc nr.elegans.fa.gz > nr_celegans.fa
pigz -dc nr.mydas.fa.gz > nr_mydas.fa
pigz -dc nr.fungi.fa.gz > nr_fungi.fa
pigz -dc nr.metazoa.fa.gz > nr_metazoa.fa
pigz -dc nr.viridiplantaea.fa.gz > nr_viridiplantaea.fa
