# How to create a custom NR DB
## Tool requirement
### Installation
```
ETE3 - see http://etetoolkit.org/download/
SQLITE3 - see https://www.digitalocean.com/community/tutorials/how-to-install-and-use-sqlite-on-ubuntu-20-04
```
## Database requirement
```
wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
```
## Protein to Accession File
```
wget https://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz
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
