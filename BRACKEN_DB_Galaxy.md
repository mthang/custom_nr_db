# Bracken DB On Galaxy

## Official Kraken 2 / Bracken DB indexes
```
Kraken 2, KrakenUniq and Bracken Indexes - https://benlangmead.github.io/aws-indexes/k2

```

## Steps to make Bracken DB available on Galaxy
### Any tool wrapper using DB indexes can use the steps below to make the DB available on Galaxy (dev in this case)
```
1. check the db name defined in the <options> tag in the tool wrapper. For example, <options from_data_table="bracken_databases"> and the "bracken_databases" is the defined DB name
2. the bracken_databases name must be defined in the tool_data_conf.xml (this is in the /mnt/galaxy/galaxy-app/config or a custom config path)
3. The bracken_databases.loc in /mnt/galaxy/tool-data will be available after installing the Bracken tool
4. the location of the paths in tool_data_conf.xml or a custom tool_data_conf.xml (i.e local_tool_data_conf.xml ) contains the entry of the DB pointing to a loc file (see the format below)
       <!-- Locations of protein BLAST databases -->
    <table name="bracken_databases" comment_char="#" allow_duplicate_entries="False">
        <columns>value, name, path</columns>
        <file path="/mnt/galaxy/tool-data/bracken_databases.loc" />
    </table>
5. The local_tool_data_conf.xml (data table for local tools) is located in /mnt/galaxy/config
6. The local_tool_data.conf.xml needs to be included in galaxy.yml under the tool_data_table_config_path or tool_data_path variable.

galaxy tools from toolshed is installed in the location below on dev
/mnt/galaxy/shed_tools

Example blastdb_p.loc - the loc file is located in the path below on dev machine
/cvmfs/data.galaxyproject.org/byhand/location/blastdb_p.loc
```

## Blast DB and tools location
```
galaxy tools from toolshed is installed at the location below on dev
/mnt/galaxy/shed_tools

Example blastdb_p.loc - the loc file is located in the path below on dev machine
/cvmfs/data.galaxyproject.org/byhand/location/blastdb_p.loc

```
