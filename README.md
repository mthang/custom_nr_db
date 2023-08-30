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
```

# Steps to generate a custom NR DB
This custom DB contains only Metazoa, Viridiplantae and Fungi only
```
1) Download the prot.accession2taxid.gz
2) Download nr.gz
3) Install the ete3, sqlite3 and python3
4) Run the taxid2name.py to retrieve the taxonomy information - Example ./taxid2name.py > taxid2taxa.txt
   - output - 100011,Fungi
              100019,Fungi
              10002,Metazoa
              1000278,Metazoa
              1000413,Viridiplantae
              1000414,Viridiplantae
5) Run transform_nr.sh to unfold the non-redundant entry having multiple accession
6) awk 'BEGIN{FS="\t";OFS=","}($1!="accession"){print $3,$2}' prot.accession2taxid.txt > prot.accession2taxid.subset.txt
7) See SQLITE section below (see https://ucsffrancislab.github.io/docs/Taxonomy.html for more information)
8) Subset Non-redundant DB
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
  .output fungi_out.csv
  SELECT accession.accession FROM accession INNER JOIN taxa ON accession.taxid = taxa.taxid WHERE taxa.tax_group = "Metazoa";

or
- Viridiplantae
  .mode csv
  .output fungi_out.csv
  SELECT accession.accession FROM accession INNER JOIN taxa ON accession.taxid = taxa.taxid WHERE taxa.tax_group = "Viridiplantae";

```

## Troubleshoot
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
