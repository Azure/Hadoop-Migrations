## Migration Approach

Metadata

**Finding CPU information:**

Execute the command cat /proc/cpuinfo shell to get complete information( number of CPUs, Memory, Frequency etc..) on server

![img](..\images\clip_image047.png)

**Finding network interfaces** 

Execute command ifconfig –a to get network interfaces

![img](..\images\clip_image049.png)

 **Finding hive version:**

  Execute command at command line hive --version.

![img](..\images\clip_image051.png)

**Finding hive related packages:**

rpm -qa|grep hive

![Text  Description automatically generated](..\images\clip_image052.png)

**Finding Total DB size** 

hdfs dfs -du -h /apps/hive/warehouse

![Text  Description automatically generated](..\images\clip_image054.png)

**Finding Hive metastore DB type** 

![Graphical user interface, text, application, email  Description automatically generated](..\images\clip_image056.png)

**Finding number of databases;**

![Text  Description automatically generated](..\images\clip_image057.png)

**Finding number of tables.**

![Text  Description automatically generated](..\images\clip_image059.png)

**Executing script to find out the table/DB information.**

![Text  Description automatically generated](..\images\clip_image061.png)

### Sizing

Please refer the VM information for the link to choose right instance [VM sizes - Azure Virtual Machines ](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)

[VM sizes - Azure Virtual Machines | Microsoft Docs](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)

Export Hive Metadata

This section describes how to export the Hive metadata from On-Premises cluster.

Perform the following steps to export hive metadata:

\1.   Get the target Cluster HDFS Path to update hive_migrate.properties.

a.   To retrieve the TARGET_HDFS_PATH, login to target Target cluster using SSH/CLI.

b.   Extract value of key : <fs.DefaultFS> from target cluster core-site.xml file

[root@ram-hadoopsrv-xu1 linuxadmin]# cat /etc/hadoop/conf/core-site.xml | grep -A1 "fs.defaultFS"

   <name>fs.defaultFS</name>

   <value>hdfs://ram-hadoopsrv-xu0.southeastasia.cloudapp.azure.com:8020</value>

[root@ram-hadoopsrv-xu1 linuxadmin]#

![Text  Description automatically generated](..\images\clip_image063.png)

c.    Note the TARGET_HDFS_PATH.

2.Update the TARGET_HDFS_PATH and TARGET_OBJECTSTORE_PATH in hive_migrate.properties script to the location where HIVE tables data will be typically available post migration. Please note that you need not escape the forward slashes in the path.

![Graphical user interface, text, application, email  Description automatically generated](..\images\clip_image065.png)

3.Connect to the target cluster via ssh as root user. See Connect to a Cluster Node Through Secure Shell (SSH) in Using Source Cluster

\4. Create a script named generate_target_ddl_from_source.sh in the root home directory with the attached code. This script generates the DDL statements that you can run on the target cluster to create the hive metadata.

\5. As root user, run the generate_target_ddl_from_source.sh script.

\1.   CREATE_TARGET_DB.hql

\2.   CREATE_TARGET_TABLE.hql

\3.   ADD_TARGET_PARTITION.hql

/****

Other options to migrate Hive metastore are bases on underlined Database and its utilities like export import, replication, log shipping etc.

[[DK43\]](#_msocom_43)

*****/

**Decision flow for selecting target DB for hive metadata:**

![img](..\images\clip_image067.png)

### Modernization – Databricks

When an Azure Databricks workspace provisioned, a default Hive [Metastore](https://docs.microsoft.com/en-us/azure/databricks/data/metastores/) comes automatically with the workspace. Alternative, an [external Hive Metastore](https://docs.microsoft.com/en-us/azure/databricks/data/metastores/external-hive-metastore) can be provision on Azure and connected to Azure Databricks. The migration of on-premises Hive to Azure Databricks essentially include two major parts: Metastore migration and underlying hive table data migration.

#### Metastore Migration

The first step is to migrate the Hive Metastore from Hadoop to Azure Databricks (or Azure SQL-DB). Hive Metastore contains all the location and structure of all the data assets in the Hadoop environment. Migrating the Hive Metastore is required for users to query tables in Databricks notebooks using SQL statements. During migration process, the locations of the underlying datasets will need to be updated to reference the Azure Databricks file system mounts.

##### Export Hive table DDL

There are two methods you can use to generate the DDL for hive tables:

##### ·    Use SHOW CREATE TABLE command

The “show create table” hive command can be used to generate the DDL for the single hive table (syntax: SHOW CREATE TABLE HIVE_TABLE_NAME; )

![img](..\images\clip_image069.png)

·    Use shell script + beeline to dump all tables DDL in the given Hive database

You can leverage on the same command “SHOW CREATE TABLE” to export all hive table DDL. The following handy script demonstrate the scripting approach to export DDL for multiple tables:

  table_name_file='/home/sshdanny/tablenames.txt'  ddl_file='/home/sshdanny/hivetableddl.txt'  rm -f  $table_name_file  rm -f  $ddl_file  beeline  -u "jdbc:hive2://zk0-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk2-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk3-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2"  -n "danny" -p "[password]" --showHeader=false --silent=true  --outputformat=csv2 -e "show tables" >$table_name_file     wait    cat $table_name_file | while read LINE    do    beeline -u "jdbc:hive2://zk0-  danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk2-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk3-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2"  -n "danny" -p "[password]" --showHeader=false --silent=true  --outputformat=csv2 -e "show create table $LINE" >> $ddl_file    echo   -e "\n" >> $ddl_file    echo $LINE    done  rm -f  $table_name_file  echo  "Table DDL were generated"  

![img](..\images\clip_image071.png)

![img](..\images\clip_image073.png)

**Note**: Before executing the generated DDL file in Azure databricks DBFS to re-create the tables, the location of each hive table needs to be updated according (the corresponding dbfs:// paths) You can [export all table metadata](https://docs.microsoft.com/en-us/azure/databricks/kb/metastore/create-table-ddl-for-metastore) from Hive to the Databricks default or external metastore:

#### Hive Data & Job Assets Migration

Once the Hive metastore have been migrated over, the actual data residing in Hive can be migrated.

There are several tools available for the data migration:

\1.   [Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/connector-hive) – connect directly to Hive and copy data, in a parallelized manner, to ADLS or [Databricks Delta Lake](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-databricks-delta-lake) (big data solution)

\2.   Connect to Hive via [ODBC/JDBC driver](https://docs.microsoft.com/en-us/azure/databricks/integrations/bi/jdbc-odbc-bi) and copy to Hive storing in Azure (small data option)

\3.   Connect to Azure Databricks via [Databricks CLI](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/)  and copy the data to [DBFS](https://docs.microsoft.com/en-us/azure/databricks/data/databricks-file-system) 

[Set up](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/) the databricks CLI on the hive node

[Set up authentication](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/#--set-up-authentication) to connect to azure databricks 

Copy the data to DBFS via “databricks fs” commands.

Example:

Connecting to Azure databricks via token and list down the folders in DBFS 

![img](..\images\clip_image075.png)Copy the file from local to DBFS

![img](..\images\clip_image077.png)

Finally, the Hive jobs can be migrated over to Azure Databricks. Given that Apache Spark SQL in Azure Databricks is designed to be [compatible](https://docs.microsoft.com/en-us/azure/databricks/spark/latest/spark-sql/compatibility/hive) with the Apache Hive, including metastore connectivity, SerDes, and UDFs, even the “copy/paste” approach to Hive job migration is feasible. The [Workspace CLI](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/workspace-cli) can be used to perform bulk imports of scripts onto Azure Databricks.

### Modernization – Synapse

Azure Synapse Analytics is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. Azure synapse analytics provides one the freedom to query data either using serverless or dedicated resources—at scale. Azure Synapse brings these worlds together with a unified experience to ingest, explore, prepare, manage, and serve data for immediate BI and machine learning needs.

Following document provides guidance on migrating Hive cluster running on Hadoop to Azure Synapse Analytics service

### MPP Architecture

### Serverless / Dedicated SQL / Spark Pools

### Columnar Table Storage

### Polybase and Data Loading options

### Distribution Options: - Hash / Round Robin / Replicate

### Security

## Target Architecture:

High level architecture added below. <write up to be added soon>

![img](..\images\clip_image079.png)

## Migration approach:

There are 2 possible approaches when one considers migrating hive database to synapse. They are

·    Live migration – when the source (environment running Hive cluster ) can connect to azure

·    Offline migration – when the source environment is disconnected from azure

### Live migration:

Following are the high-level steps involved in migrating Apache hive cluster running in on-premise environment

High level decision flow diagram while performing live migration:

 ////insert viseo

#### Scenario 1: Live migration with Hadoop cluster directly connecting to Azure without Self hosted integration runtime

\1.   Create the destination synapse database and open synapse studio as shown below. For example, a synapase database called “hiveimport” has been created in a synapse dedicated sql pool

![img](..\images\clip_image081.png)

\1.   Create a linked service to “Hive” cluster as shown below:

Click on “manage” on synapse pool and click on “linked services”. Click on “New”

![img](..\images\clip_image083.png)

Search for “Hive” and click continue:

![img](..\images\clip_image085.png)

Provide the relevant details as shown below:

![img](..\images\clip_image086.png)![img](..\images\clip_image088.png)

Test the connection and create the linked service.

\1.   Create the copy activity

Click on the integrate button on synapse studio. Click on the “+” button to add new pipeline. Search for the “Copy” activity and add the copy activity to the pipeline:

![img](..\images\clip_image090.png)

Click on the copy activity. Rename the activity from “Copy data1” to “HivetoSynapse” as shown below

![img](..\images\clip_image092.png)

Click on “New Dataset”

![img](..\images\clip_image094.png)

Search for “Hive” and the add the dataset. Click on the “open” button to open the dataset

![img](..\images\clip_image095.png)

Map the dataset to linked service created earlier as shown below. Pick the hive table to be transferred.

![img](..\images\clip_image097.png)

Switch the tab and return to the copy activity. Click on the “sink” tab and click on “+ New” button to create a dataset for “Synapse” destination table. Search for synapse in dataset creation and pick “azure synapse dedicated pool”

![img](..\images\clip_image098.png)

Provide a name which can identify the table being transferred. Pick the dedicated pool to which data is to be imported to. Click on the edit button and provide the destination table name, manually. Set “Import Schema” to “None”

![img](..\images\clip_image099.png)

On the sink settings, select “Copy method” as “Bulk Insert” and Table option as “Auto Create Table” as shown below

![img](..\images\clip_image101.png)

Hit the “Mapping” tab, Click on “import schemas” and perform “mapping” if required.

![img](..\images\clip_image103.png)

Change the pipeline name as “HivetoSynapse” and hit the publish button.

![img](..\images\clip_image105.png)

\1.   Execute the Pipeline and verify the results

Execute the pipeline by clicking on the “Add Trigger” -> “Trigger Now” button

Upon successful completion of the run, verify if the new table has been created and the data has been successfully transferred by clicking on the data section of synapse studio and querying the table as shown below.

![img](..\images\clip_image107.png)

![img](..\images\clip_image109.png)

#### Scenario 2: Live migration with Hadoop cluster directly Via self hosted IR

·    Install Self hosted Integration runtime in a on-premise server which can access azure. Refer [Create a self-hosted integration runtime - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/create-self-hosted-integration-runtime#setting-up-a-self-hosted-integration-runtime)

·    Create a linked service to hive data source using the integration run time. Example linked service connecting to SQL database via Integration time provided here - [Copy data from SQL Server to Blob storage using Azure portal - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-hybrid-copy-portal). Similar steps can be followed to create linked service for hive database via integration runtime

·    Use copy activity task as done in previous scenario to move the tables to synapse

#### Scenario 3: Live migration with Hadoop “kerberized” cluster in on premise environment

·    Install Self hosted Integration runtime in a on-premise server which can access azure. Refer [Create a self-hosted integration runtime - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/create-self-hosted-integration-runtime#setting-up-a-self-hosted-integration-runtime)

·    Install odbc driver in self hosted IR - [Cloudera ODBC Driver for Apache Hive Installation and Configuration Guide](https://docs.cloudera.com/documentation/other/connectors/hive-odbc/2-6-9/Cloudera-ODBC-Driver-for-Apache-Hive-Install-Guide.pdf)

·    Setup kerberos authentication in self hosted integration runtime as explained [here](https://www.simba.com/products/Hive/doc/ODBC_InstallGuide/win/content/odbc/hi/kerberos.htm)

·    After the setup, create the linked service using use Azure Data Factory odbc connector to connect to the hive cluster

·    Use copy activity and copy the tables as mentioned in previous scenario

#### Considerations:

·    Complex types such as arrays, maps, structs, and unions are not supported for read via Azure Data Factory.

·    Hive connector only supports Hive tables in Apache Hive of version 3.1.0

#### Hive object mapping to Azure Synapse

| Hive object                     | Synapse object                                               | High level migration method                                  |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Hive internal tables            | Table in Azure Synapse dedicated pool                        | Azure Data Factory                                           |
| Hive external tables            | Synapse external tables using polybase. Data  resides as files in ADL Gen 2 | ·      Azure Data Factory / azcopy to move  HDFS files to ADL Gen 2  ·      DDL Scripts to create external tables |
| Hive partitions                 | Synapse tables with distribution option                      | ·      DDL Scripts                                           |
| Hive table / object permissions | Synapse access controls at the database layer                | ·      DDL Scripts                                           |

## Offline migration: 

If the on-premise Hive cluster cannot be connected to Azure, then one may perform an offline / disconnected migration. Following are the high level steps. < Details to be added>

·    Script out all the DDL scripts for the external and internal tables in Hive. Sample script to extract DDL statements provided below.

  #!/bin/bash  rm -f tableNames.txt  rm -f HiveTableDDL.txt  hive -e "use $1; show  tables;" > tableNames.txt   wait  cat tableNames.txt |while read LINE     do     hive -e "use $1;show create table $LINE;"  >>HiveTableDDL.txt     echo -e "\n" >>  HiveTableDDL.txt     done  rm -f tableNames.txt  echo "Table DDL  generated"

Reference: [sql - How to get/generate the create statement for an existing hive table? - Stack Overflow](https://stackoverflow.com/questions/18134131/how-to-get-generate-the-create-statement-for-an-existing-hive-table)

·    Export the internal tables as csv files to local HDFS storage

·    Move the HDFS storage to Azure Data Lake using Azcopy / distcp / databox as described in [Copy data from HDFS by using Azure Data Factory - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/connector-hdfs)

·    Create Azure Synapse instance and use serverless pools and create the external tables connecting to Azure data lake gen 2. Use serverless pools ( SQL or spark ) to explore the data

·    Perform any processing of data via notebooks or SQL Scripts and ingest the prepared data into Synapse SQL dedicated pools or Synapse spark database

·    Import the hive internal table to azure synapse dedicated SQL Pool or spark database via T-SQL scripts.

### Post migration checks:

<Details to be added>

### Synapse Optimization Guidance

<Details to be added. Will cover data loading recommendations, table distribution guidance,indexing and maintenance guidance etc..>

### Lift and Shift – HDInsight

Refer the documentation provided by the HDI product team

### Lift and Shift – IAAS 

Other options to migrate Hive Tables

An hive has following type of workloads:

·    Managed Tables

·    External tables

·    User defined functions

For migrating data between HDFS and ADLS please refer the HDFS migration part.

**Migrating table data** 

**Migrating table data for every managed table**

**Step 1)**

Execute below command at source cluster to copy the data to transit folder

**hdfs dfs -copyToLocal /apps/hive/warehouse/\*.\* /tmp**

![img](..\images\clip_image111.png)

Step 2).

Copy all the data to the folder of /hive/warehouse/managed target cluster by using azcopy command. Refer the HDFS migration section for this

Step3) Execute the DDL scripts provided in metadata migration step to create the tables on the new cluster.

**Migrating table data for specific managed table**

Step 1).

List out the tables in database to choose the specific table to migrate. Use SHOW TABLES query

![img](..\images\clip_image112.png)

Step 2).

Get the DDL for the specific table to migrate. Use SHOW CREATE TABLE query to get DDL of the table.

![img](..\images\clip_image114.png)

Step 3).

Execute below command at source cluster to copy the data to transit folder.

**hdfs dfs -copyToLocal /apps/hive/warehouse/\* /tmp**

![img](..\images\clip_image111.png)

Step 4.

Copy specific table data to the folder of /apps/hive/warehouse/managed target cluster by using azcopy command. Refer the HDFS migration section for this

Step 5.

 Execute the DDL scripts provided in metadata migration step to create the specific tables on the new cluster.

**Migrating table data for external tables**

Step 1) external tables data is not stored in /apps/hive/warehouse

We can find the location using show create table query

![img](..\images\clip_image116.png)

Step 2

Retrieve the table data from the Migrated using HDFS commands.

Step 3

use AZcopy command to copy the data identified to the target cluster.

Step 4.

Create the external tables using the DDL generated in Metastore migration step.

**Other approached to migrate the Hive data.**

 **Use hive export import with distcp /azcopy option.**

**Step 1.**

Exporting the table data to transient folder.

![img](..\images\clip_image118.png)

Step 2.

Copy the exported data using distcp.

![img](..\images\clip_image120.png)

Step 3.

Import table data from transient folder on target cluster.

![img](..\images\clip_image122.png)

We can use Hive replication approach to migrate Hive to new cluster. Refer below link which depicts the replication to HDInsight

[How to use Apache Hive replication in Azure HDInsight clusters | Microsoft Docs](https://docs.microsoft.com/en-us/azure/hdinsight/interactive-query/apache-hive-replication)

## Decision Map/Flowchart

![img](..\images\clip_image124.png)

|      |      |      |
| ---- | ---- | ---- |
|      |      |      |
|      |      |      |
|      |      |      |
