# Migration Approach

- [Metadata](#metadata)

- [Modernization – Databricks](#modernization-databricks)
- [Modernization – Synapse](#modernization-synapse)
- [Lift and Shift – HDInsight](#lift-and-shift---hdinsight)
- [Lift and Shift - IAAS](#lift-and-shift---iaas)
- [Decision Map/Flowchart](#decision-mapflowchart)
- [Migrate Hive SQL Workloads](#migrate-hive-sql-workloads)

## Metadata

For exploring metadata information, assesment, exporting metadata, importing metadata and deploying metada to target cluster please refer metadata migration steps of Hive. Please click [here](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/hive/migration-approach.md#metadata)

## Decision flow for impala

![impala-discissionflow](../images/Impala-decision-flow.png)

## Modernization Databricks

Azure Databricks is structured to enable secure cross-functional team collaboration while keeping a significant amount of backend services managed by Azure Databricks so you can stay focused on your data science, data analytics, and data engineering tasks.
Although architectures can vary depending on custom configurations (such as when you’ve deployed a Azure Databricks workspace to your own virtual network, also known as VNet injection), the following architecture diagram represents the most common structure and flow of data for Azure Databricks.

### Modernization Synapse

Azure Synapse Analytics is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. Azure synapse analytics provides one the freedom to query data either using serverless or dedicated resources—at scale. Azure Synapse brings these worlds together with a unified experience to ingest, explore, prepare, manage, and serve data for immediate BI and machine learning needs.

Following document provides guidance on migrating Impala cluster running on Hadoop to Azure Synapse Analytics service

### MPP Architecture

[Synapse Architecture](https://docs.microsoft.com/azure/synapse-analytics/sql/overview-architecture)

## Target Architecture

![hive-to-synapse-livemigration-arch](../images/hive-to-synapse-livemigration-arch.png)

## Migration approach

There are 2 possible approaches when one considers migrating hive database to synapse. They are

- Live migration – when the source (environment running Impala cluster ) can connect to azure

- Offline migration – when the source environment is disconnected from azure

### Live migration

Following are the high-level steps involved in migrating Apache Impala cluster running in on-premise environment

High level decision flow diagram while performing live migration:

#### Scenario 1: Live migration with Hadoop cluster directly connecting to Azure without Self hosted integration runtime

1. Create the destination synapse database and open synapse studio as shown below. For example, a synapase database called “hiveimport” has been created in a synapse dedicated sql pool

![hive-synapse-sqlpool](../images/hive-synapse-sqlpool.png)

1. Create a linked service to “Impala” cluster as shown below:

Click  on “linked services”. Click on “New”

![impala-to-synapse-linkedservice-creation](../images/impala-synapse_copyactivity_linkedservice.png)

Search for “Impala” and click continue:

![impala-synapse-connectionstring](../images/impala-synapse-copyactivity1.png)

Provide the relevant details as shown below:

![hive-synapse-connectionstring1](../images/hive-synapse-connectionstring1.png)

![hive-synapse-connectionstring2](../images/hive-synapse-connectionstring2.png)

Test the connection and create the linked service.

1. Create the copy activity

Click on the integrate button on synapse studio. Click on the “+” button to add new pipeline. Search for the “Copy” activity and add the copy activity to the pipeline:

![impala-synapse-create-copy-activity1](../images/impala-synapse-copyactivity2.png)

Click on the copy activity. Rename the activity from “Copy data1” to “ImpalatoSynapse” as shown below

![impala-synapse-create-copy-activity2](../images/impala-synapse-copyactivity3.png)

Click on “New Dataset”

![impala-synapse-create-copy-activity3](../images/impala-synapse-copyactivity4.png)

Search for “Impala” and the add the dataset. Click on the “open” button to open the dataset.Map the dataset to linked service created earlier as shown below. Pick the Impala table to be transferred.

![impala-synapse-create-copy-activity4](../images/impala-synapse-copyactivity5.png)

![impala-synapse-create-copy-activity5](../images/impala-synapse-copyactivity6.png)

Switch the tab and return to the copy activity. Click on the “sink” tab and click on “+ New” button to create a dataset for “Synapse” destination table. Search for synapse in dataset creation and pick “azure synapse dedicated pool”

![impala-synapse-create-copy-activity6](../images/impala-synapse-copyactivity7.png)

Provide a name which can identify the table being transferred. Pick the dedicated pool to which data is to be imported to. Click on the edit button and provide the destination table name, manually. Set “Import Schema” to “None”

![impala-synapse-create-copy-activity7](../images/impala-synapse-copyactivity8.png)


Upon successful completion of the run, verify if the new table has been created and the data has been successfully transferred by clicking on the data section of synapse studio and querying the table as shown below.

![impala-synapse-create-copy-activity8](../images/impala-synapse-copyactivity9.png)

Please refer the MS Docs for futher details  here [Copy data from Impala using Azure Data Factory or Synapse Analytics ](https://docs.microsoft.com/azure/data-factory/connector-impala?tabs=data-factory)
#### Scenario 2: Live migration with Hadoop cluster directly Via self hosted IR

- Install Self hosted Integration runtime in a on-premise server which can access azure. Refer [Create a self-hosted integration runtime - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime#setting-up-a-self-hosted-integration-runtime)

- Create a linked service to hive data source using the integration run time. Example linked service connecting to SQL database via Integration time provided here - [Copy data from SQL Server to Blob storage using Azure portal - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/tutorial-hybrid-copy-portal). Similar steps can be followed to create linked service for hive database via integration runtime

- Use copy activity task as done in previous scenario to move the tables to synapse

#### Scenario 3: Live migration with Hadoop “kerberized” cluster in on premise environment

- Install Self hosted Integration runtime in a on-premise server which can access azure. Refer [Create a self-hosted integration runtime - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime#setting-up-a-self-hosted-integration-runtime)

- Install odbc driver in self hosted IR - [Cloudera ODBC Driver for Apache Impala Installation and Configuration Guide](https://docs.cloudera.com/documentation/other/connectors/impala-odbc/latest/Cloudera-ODBC-Driver-for-Impala-Install-Guide.pdf)

- Setup kerberos authentication in self hosted integration runtime as explained [here](http://simba.wpengine.com/products/Impala/doc/ODBC_InstallGuide/win/content/odbc/hi/kerberos.htm)

- After the setup, create the linked service using use Azure Data Factory odbc connector to connect to the hive cluster

- Use copy activity and copy the tables as mentioned in previous scenario

#### Considerations

- Complex types such as arrays, maps, structs, and unions are not supported for read via Azure Data Factory.

#### Impala object mapping to Azure Synapse

| Hive object                     | Synapse object                                               | High level migration method                                  |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Impala internal tables            | Table in Azure Synapse dedicated pool                        | Azure Data Factory                                           |
| Impala external tables            | Synapse external tables using polybase. Data  resides as files in ADL Gen 2 | ·      Azure Data Factory / azcopy to move  HDFS files to ADL Gen 2  ·      DDL Scripts to create external tables |
| Impala partitions                 | Synapse tables with distribution option                      | ·      DDL Scripts                                           |
| Impala table / object permissions | Synapse access controls at the database layer                | ·      DDL Scripts                                           |

## Offline migration

If the on-premise Hive cluster cannot be connected to Azure, then one may perform an offline / disconnected migration. Following are the high level steps. < Details to be added>

- Script out all the DDL scripts for the external and internal tables in Hive Metadata. Use above provided Sample script to extract DDL statements.

- Export the internal tables as csv files to local HDFS storage

- Move the HDFS storage to Azure Data Lake using Azcopy / distcp / databox as described in [Copy data from HDFS by using Azure Data Factory - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/connector-hdfs)

- Create Azure Synapse instance and use serverless pools and create the external tables connecting to Azure data lake gen 2. Use serverless pools ( SQL or spark ) to explore the data

- Perform any processing of data via notebooks or SQL Scripts and ingest the prepared data into Synapse SQL dedicated pools or Synapse spark database

- Import the impala internal table to azure synapse dedicated SQL Pool or spark database via T-SQL scripts.

### Migrate - Impala to HDInsight Hive

Steps in migrating the Impala to HDInsight Hive

- Compare the differences between Hive and Impala
  - SQL Differences between Hive and Impala 1 [Differences between Hive and Impala](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/impala_langref_unsupported.html)
  - SQL Differences between Hive and Impala 2 [Differences between Hive and Impala](https://docs.cloudera.com/documentation/enterprise/6/6.3/topics/impala_langref_unsupported.html)
- Migrate metadata (HDInsight supports only Azure SQL Db for Metadata)
  - Migrating PostgresSQL to Azure SQLDB [Migrating PostgresSQL to Azure SQLDB](https://docs.microsoft.com/azure/dms/tutorial-postgresql-azure-postgresql-online)
  - Migrating MySQL to Azure SQLDB [Migrating MySQL to Azure SQLDB](https://docs.microsoft.com/azure/dms/tutorial-mysql-azure-mysql-offline-portal)
- Create and export DDLs for Tables in Impala with above mentioned Scripts
- Execute DDLs in already deployed HDInsight Hive
- when we migrate from Impala to hive we have options to execute we have diffeent options and interfaces. Please refer the link for [Interactive Query In Azure HDInsight](https://docs.microsoft.com/azure/hdinsight/interactive-query/apache-interactive-query-get-started#execute-apache-hive-queries-from-interactive-query)
  
### Lift and Shift - IAAS

Other options to migrate Impala Tables

An Impala has following type of workloads:

- Managed Tables

- External tables

- User defined functions

For migrating data between HDFS and ADLS please refer the HDFS migration part.

### Migrating table data

#### Migrating table data for every managed table**

##### Step 1

Execute below command at source cluster to copy the data to transit folder

```shell
 hdfs dfs -copyToLocal /apps/hive/warehouse/\*.\* /tmp**
```

##### Step 2

Copy all the data to the folder of /hive/warehouse/managed target cluster by using azcopy command. Refer the HDFS migration section for this

##### Step 3

Execute the DDL scripts provided in metadata migration step to create the tables on the new cluster.

#### Migrating table data for specific managed table

##### Step A

List out the tables in database to choose the specific table to migrate. Use SHOW TABLES query

![hive-iaas-migrate-specific-managetables](../images/hive-iaas-migrate-specific-managetables.png)

##### Step B

Get the DDL for the specific table to migrate. Use SHOW CREATE TABLE query to get DDL of the table.

```sql
SHOW CREATE TABLE t1

CREATE TABLE `t1`(
   `x` int,  
  `y` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  'hdfs://ram-hadoopsrv-xu0.southeastasia.cloudapp.azure.com:8020/apps/hive/warehouse/migration.db/t1'
TBLPROPERTIES (
   'COLUMN_STATS_ACCURATE'='{\"BASIC_STATS\":\"true\"}',  
   'numFiles'='0',  
   'numRows'='0',  
   'rawDataSize'='0',  
   'totalSize'='0',  
  'transient_lastDdlTime'='1610415855')
```

##### Step C

Execute below command at source cluster to copy the data to transit folder.

```shell
hdfs dfs -copyToLocal /apps/hive/warehouse/\* /tmp**
```

##### Step D

Copy specific table data to the folder of /apps/hive/warehouse/managed target cluster by using azcopy command. Refer the HDFS migration section for this

##### Step E

 Execute the DDL scripts provided in metadata migration step to create the specific tables on the new cluster.

#### Migrating table data for external tables

##### Step a

External tables data is not stored in /apps/hive/warehouse

We can find the location using show create table query

```sql
SHOW CREATE TABLE t1

CREATE TABLE `t1`(
   `x` int,  
  `y` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  'hdfs://ram-hadoopsrv-xu0.southeastasia.cloudapp.azure.com:8020/apps/hive/warehouse/migration.db/t1'
TBLPROPERTIES (
   'COLUMN_STATS_ACCURATE'='{\"BASIC_STATS\":\"true\"}',  
   'numFiles'='0',  
   'numRows'='0',  
   'rawDataSize'='0',  
   'totalSize'='0',  
  'transient_lastDdlTime'='1610415855')
```

##### Step b

Retrieve the table data from the Migrated using HDFS commands.

##### Step c

Use the AZcopy command to copy the data identified to the target cluster.

##### Step d

Create the external tables using the DDL generated in Metastore migration step.

### Other approaches to migrate the Hive data

#### Use hive export import with distcp /azcopy option.**

##### Step 1)

Exporting the table data to transient folder.

```sql
export table t1 to '/temp';
```

##### Step 2)

Copy the exported data using distcp.

```shell
distcp hdfs://source:8020/source/first hdfs://target:8020/source/second hdfs://nn2:8020/target
```

##### Step 3)

Import table data from transient folder on target cluster.

```sql
import table t1 from '/temp/t1';
```

[Previous](challenges.md)