#!/usr/bin/env python3

import csv
import pandas as pd
from ete3 import NCBITaxa

ncbi = NCBITaxa()

def get_desired_ranks(taxid, desired_ranks):
    lineage = ncbi.get_lineage(taxid)
    lineage2ranks = ncbi.get_rank(lineage)
    ranks2lineage = dict((rank, taxid) for (taxid, rank) in lineage2ranks.items())
    return {'{}_id'.format(rank): ranks2lineage.get(rank, '<not present>') for rank in desired_ranks}

def main(taxids, desired_ranks, path):
    with open(path, 'w') as csvfile:
        fieldnames = ['{}_id'.format(rank) for rank in desired_ranks]
        writer = csv.DictWriter(csvfile, delimiter='\t', fieldnames=fieldnames)
        writer.writeheader()
        for taxid in taxids:
            writer.writerow(get_desired_ranks(taxid, desired_ranks))

def get_lineage(taxid):
    taxid = int(taxid)
    try:
        lineage = ncbi.get_lineage(taxid)
        names=ncbi.get_taxid_translator(lineage)
        scientific_list = ', '.join(map(str,[names[taxid] for taxid in lineage]))
        #print("%s %s" % (taxid,scientific_list))
        #version 1
        #print("%s\t%s" % (taxid,[names[taxid] for taxid in lineage if names[taxid] in keep_taxa_name]))
        #version 2
        tax_list_output = [names[taxid] for taxid in lineage if names[taxid] in keep_taxa_name]
        if tax_list_output !=[]:
            print("%s\t%s" % (taxid,''.join(tax_list_output)))
        #print("%s\t%s" % (taxid, [names[taxid] if names[taxid] in keep_taxa_name else "test" for taxid in lineage]))
    except Exception:
        pass

keep_taxa_name = ['Metazoa','Viridiplantae','Fungi']

with open('acc.txt') as csv_file:
     csvreader = csv.reader(csv_file,delimiter=",")
     for row in csvreader:
        get_lineage(''.join(map(str,row)))
