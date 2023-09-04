# How to create a custom NR DB
## Tool requirement
### Installation
```
ETE3 - see http://etetoolkit.org/download/
SQLITE3 - see https://www.digitalocean.com/community/tutorials/how-to-install-and-use-sqlite-on-ubuntu-20-04
SEQKIT - see https://bioinf.shenwei.me/seqkit/download/
```
## Database requirement
```
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
```
## Protein to Accession File
```
wget https://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz

Inside the prot.accession2taxid.gz

accession       accession.version       taxid   gi
A0A009IHW8      A0A009IHW8.1    1310613 1835922267
A0A011QK89      A0A011QK89.1    522306  2203519076
A0A017SE81      A0A017SE81.1    1388766 2316836429
A0A017SE85      A0A017SE85.1    1388766 2316836434
A0A017SEF3      A0A017SEF3.1    1388766 2316836433
A0A017SEX7      A0A017SEX7.1    1388766 2316836426
A0A017SEY2      A0A017SEY2.1    1388766 2316836432
A0A017SFB8      A0A017SFB8.1    1388766 2316836430
A0A017SGC7      A0A017SGC7.1    1388766 2316836431
A0A017SP50      A0A017SP50.1    1388766 2414731956
A0A017SPL2      A0A017SPL2.2    1388766 2414732007
A0A017SQ41      A0A017SQ41.2    1388766 2414732010
A0A017SR40      A0A017SR40.1    1388766 2414731998
A0A023FBW4      A0A023FBW4.1    34607   1939884164
A0A023FBW7      A0A023FBW7.1    34607   1939884197
```

# Steps to generate a custom NR DB
This custom DB contains only Metazoa, Viridiplantae and Fungi only
```
1) Download the prot.accession2taxid.gz
2) Download nr.gz
3) Install ete3, sqlite3 and python3
4) Run the taxid2name.py to retrieve the taxonomy information and label taxon id with kingdom  - Example ./taxid2name.py > taxid2taxa.txt
   taxid2taxa output:
              100011,Fungi
              100019,Fungi
              10002,Metazoa
              1000278,Metazoa
              1000413,Viridiplantae
              1000414,Viridiplantae
   Note: change the following code to specify the taxa/kingdom/species of interest in the taxid2name.py script 
                keep_taxa_name = ['Metazoa','Viridiplantae','Fungi'] # kingdom
                or
                keep_taxa_name = ['Caenorhabditis elegans','Chelonia mydas'] # species
5) awk 'BEGIN{FS="\t";OFS=","}($1!="accession"){print $3,$2}' prot.accession2taxid.txt > prot.accession2taxid.subset.txt
6) See SQLITE section below (see https://ucsffrancislab.github.io/docs/Taxonomy.html for more information)
7) Run subset_nr.sh to subset Non-redundant DB
8) run decompress.sh to decompress each fasta file
9) Create blast index - see https://dmnfarrell.github.io/bioinformatics/local-refseq-db for more information
   Example - makeblastdb -in Fungi.fa -out Fungi -dbtype prot (see makeBlastDB.sh script)

```

# Step to create Accession file for each species of interest using SQLITE3
```
sqlite3 taxonomy.sqlite
CREATE TABLE IF NOT EXISTS "taxa" ("taxid" INTEGER NOT NULL PRIMARY KEY,"tax_group" VARCHAR(255) NOT NULL);
CREATE TABLE IF NOT EXISTS "accession" ("taxid" INTEGER NOT NULL, "accession" VARCHAR(255) NOT NULL, FOREIGN KEY ("taxid") REFERENCES "taxa" ("taxid"));
CREATE INDEX "accession_taxid" ON "accession" ("taxid");
CREATE UNIQUE INDEX "accession_accession" ON "accession" ("accession");
CREATE UNIQUE INDEX "taxa_taxid" ON "taxa" ("taxid");
.separator ,
.import taxid2taxa.txt taxa
.separator ,
.import prot.accession2taxid.subset.txt accession

- Save the accession to a flat file
- Fungi
  .mode csv
  .output fungi_out.csv
  SELECT accession.accession FROM accession INNER JOIN taxa ON accession.taxid = taxa.taxid WHERE taxa.tax_group = "Fungi";

or
- Metazoa
  .mode csv
  .output metazoa_out.csv
  SELECT accession.accession FROM accession INNER JOIN taxa ON accession.taxid = taxa.taxid WHERE taxa.tax_group = "Metazoa";

or
- Viridiplantae
  .mode csv
  .output viridiplanta_out.csv
  SELECT accession.accession FROM accession INNER JOIN taxa ON accession.taxid = taxa.taxid WHERE taxa.tax_group = "Viridiplantae";

```

## Troubleshoot
This is a known issue when downloading the taxonomy file from NCBI using ete3 in the ncbiquery.py script
```
There is a bug in the ete3 ncbiquery.py. if you see the error message below
- db.execute("INSERT INTO synonym (taxid, spname) VALUES (?, ?);", (taxid, spname))
  sqlite3.IntegrityError: UNIQUE constraint failed: synonym.spname, synonym.taxid

Follow this post to fix it https://groups.google.com/g/etetoolkit/c/DZV09SQreKw
Replace this 
  db.execute("INSERT INTO synonym (taxid, spname) VALUES (?, ?);", (taxid, spname))
By
  db.execute("INSERT OR REPLACE INTO synonym (taxid, spname) VALUES (?, ?);", (taxid, spname))
```
