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
4) Run the taxid2name.py to retrieve the taxonomy information - Example ./taxid2name.py > taxid2name.py
   - output - 100011,Fungi
              100019,Fungi
              10002,Metazoa
              1000278,Metazoa
              1000413,Viridiplantae
              1000414,Viridiplantae
5) Run transform_nr.sh to unfold the non-redundant entry having multiple accession
 
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
