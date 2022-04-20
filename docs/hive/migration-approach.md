# Migration Approach

- [Metadata](#metadata)
- [Sizing](#sizing)
- [Export Hive Metadata](#export-hive-metadata)
- [Decision flow for selecting target DB for hive metadata](#decision-flow-for-selecting-target-db-for-hive-metadata)
- [Decision Flow Matrix for Hive on Azure](#decision-flow-matrix-for-hive-on-azure)
- [Modernization – Databricks](#modernization-databricks)
- [Modernization – Synapse](#modernization-synapse)
- [Lift and Shift – HDInsight](#lift-and-shift---hdinsight)
- [Lift and Shift - IAAS](#lift-and-shift---iaas)
- [Migrate Hive SQL Workloads](#migrate-hive-sql-workloads)

## Metadata

### Finding CPU information

Execute the command cat /proc/cpuinfo shell to get complete information( number of CPUs, Memory, Frequency etc..) on server

```shell
[ramreddyy@apacoracle ~]$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 85
model name      : Intel(R) Xeon(R) Platinum 8272CL CPU @ 2.60GHz
stepping        : 7
microcode       : 0xffffffff
cpu MHz         : 2593.879
cache size      : 36608 KB
physical id     : 0
siblings        : 16
core id         : 0
cpu cores       : 8
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 21
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology eagerfpu pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti tpr_shadow vnmi ept vpid fsgsbase bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx avx512f rdseed adx smap clflushopt avx512cd xsaveopt xsavec
bugs            : cpu_meltdown spectre_v1 spectre_v2
bogomips        : 5187.75
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:
```

### Finding network interfaces

Execute command ifconfig –a to get network interfaces

```shell
[ramreddyy@apacoracle ~]$ ifconfig -a
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.0.4  netmask 255.255.255.0  broadcast 10.10.0.255
        inet6 fe80::20d:3aff:fec8:c553  prefixlen 64  scopeid 0x20<link>
        ether 00:0d:3a:c8:c5:53  txqueuelen 1000  (Ethernet)
        RX packets 34689  bytes 44675389 (42.6 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12234  bytes 2713561 (2.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 0  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

[ramreddyy@apacoracle ~]$
```

### Finding hive version

  Execute command at command line hive --version.

```shell
hive --version
```

### Finding hive related packages

```shell
rpm -qa|grep hive
```

### Finding Total DB size

```shell
hdfs dfs -du -h /apps/hive/warehouse
```

### Finding Hive metastore DB type

![hive-metastore-information](../images/hive-metastore-information.png)

### Finding number of databases

```sql
select count(DB_ID) from hive.DBS
```

### Finding number of tables

```sql
select count(*) from hive.TBLS;
```

### Executing script to find out the table/DB information

```bash
sh generate_hive_metadata.sh
```

The following set of assessment questions are designed to gain an insight into existing deployment of Hive and establish a set of requirements that must be considered for any type of Hive migration scenario to Azure.

| Layer  | Questions | Background  |
|------- |---|---|
|  **Infrastructure**  | Number of servers for each type of role -   Hive Services; Metadata DB; Processing layer | Understand scale and design of incumbent solution.|
|&nbsp; | Number of cores per server | ```lscpu``` *OR* ```cat /proc/cpuinfo``` commands can be used to list cores per server.|
|&nbsp; | Available memory per server | This is the total memory available per server. On Linux, commands such as ```free -mg``` *OR* ```cat /proc/meminfo``` can be used to report on memory available on each server.|
|&nbsp; | Is the existing environment virtualized or deployed on bare-metal servers? | The information will be used as one of the inputs when it comes to sizing and understanding performance characterstics of on-premises Hive environment.|
|&nbsp; | Network | Understand the network bandwidth each VM can support; and if any special NIC configuration is used to support high bandwidth between Hive servers.   Use the following commands to extract details of VM network configuration ```ifconfig -a``` *OR* ```ethtool <name of the interface>```|
|&nbsp; | Storage | What is the total size of data post-replication? Usually, default configuration of HDFS replicates data 3x.|
|**Operating System** | Version and distro type | The following command will print out details of Linux distro and version in use  ```uname -a```|
|&nbsp; | Kernel parameters | Understand if customer has applied any specific kernel-level parameters to improve the performance of Hive deployment. Hence, we do not recommend changing default parameters straightaway unless it has been recommended by your OS and/or application vendor. In most cases, customers tweak these parameters to address specific workload performance requirements. Whilst it's fairly straight-forward to change config, however customers usually arrive at this decision after carrying out extensive testing.   <br> **Linux memory and block device parameters** <br> ```cat /sys/kernel/mm/transparent_hugepage/enabled``` <br>```cat /sys/kernel/mm/transparent_hugepage/defrag```<br>```cat /sys/block/sda/queue/scheduler```<br>```cat /sys/class/block/sda/queue/rotational```<br>```cat /sys/class/block/sda/queue/read_ahead_kb```<br>```cat /proc/sys/vm/zone_reclaim_mode```<br> **Linux network stack parameters** <br> ```sudo sysctl -a \ grep -i "net.core.rmem_max\|net.core.wmem_max\|net.core.rmem_default\| net.core.wmem_default\|net.core.optmem_max\|net.ipv4.tcp_rmem\|net.ipv4.tcp_wmem"```|
|**Security & administration** | Accessing Hive | How do users access the data in Hive? Is it via APIs or directly via Hive shell?<br> How applications consume data?<br> How is data written to HIve and proximity of these systems? Are they within the same data centre or located outside of DC where Hive is deployed?|
|&nbsp; | User provisioning | How are users authenticated and authorized? <br>•Ranger?<br>•Knox?<br>•Kerberos?|
|&nbsp; | Encryption | Is there a requirement to have data encrypted in transport and/or at-rest? What encryption solutions are currently in-use?|
|&nbsp; | Tokenization | Is there a requirement to tokenize data? If yes, how is data tokenized? Popular applications used for tokenization include (but not limited to) Protegrity; Vormetric etc.|
|&nbsp; | Compliance | Are there any special regulatory requirements applicable to Hive workloads? For example – PCI-DSS; HIPAA etc.|
|&nbsp; | Keys, certificates, and secrets management policies. | If applicable, please describe and what tools/applications are used for this function.|
|**High-Availability and Disaster Recovery** | What is the SLA, RPO and RTO of the source Hive deployment? | This will drive decision on the landing target on Azure and whether to have a hot-standby OR active-active regional deployment on Azure.|
|  | BC and DR strategy for HIve workloads. | Describe BR and DR strategy in detail. Impact of HIve being unavailable.|

### Sizing

Please refer the VM information for the link to choose right instance [VM sizes - Azure Virtual Machines](https://docs.microsoft.com/azure/virtual-machines/sizes)

[VM sizes - Azure Virtual Machines | Microsoft Docs](https://docs.microsoft.com/azure/virtual-machines/sizes)

### Export Hive Metadata

This section describes how to export the Hive metadata from On-Premises cluster.

Perform the following steps to export hive metadata:

  1. Get the target Cluster HDFS Path to update hive_migrate.properties.

      a.   To retrieve the TARGET_HDFS_PATH, login to target Target cluster using SSH/CLI.

      b.   Extract value of key : <fs.DefaultFS> from target cluster core-site.xml file

      ```console
        [root@ram-hadoopsrv-xu1 linuxadmin]# cat /etc/hadoop/conf/core-site.xml | grep -A1 "fs.defaultFS"
    
        <name>fs.defaultFS</name>
    
        <value>hdfs://ram-hadoopsrv-xu0.southeastasia.cloudapp.azure.com:8020</value>
    
        [root@ram-hadoopsrv-xu1 linuxadmin]#
    
      ```

        c.   Note the TARGET_HDFS_PATH.

  2. Update the TARGET_HDFS_PATH and TARGET_OBJECTSTORE_PATH in hive_migrate.properties script to the location where HIVE tables data will be typically available post migration. Please note that you need not escape the forward slashes in the path.

      ```xml
      #!/bin/bash
        #
        # This file will be sourced by the generate_target_ddl_from_source.sh
        # to customize/overide properties
        # SRC_HDFS_PATH and SRC_OBJECTSTORE_PATH will be derived automatically from the cluster.
        # You will be customizing
        #     RUNDIR , TARGET_HDFS_PATH, TARGET_OBJECTSTORE_PATH
        # 
        #     --------------------------------------------------------    ---- 
        # Location to hold intermediate and final scripts to be generated.
        # You must have write privileges on this directory
        export RUNDIR=/tmp/hivemigrate
    
    
        #         ------------------------------------------------------------ 
        # Modify expected target BDS hdfs path in your hive DDL script
        #
        export TARGET_HDFS_PATH=hdfs://ram-ambarisrv-xu.    southeastasia.cloudapp.azure.com:8020/tmp/hivemigrate/export
    
    
        # ------------------------------------------------------------ 
        # Modify expected target BDS Object Store path in your hive DDL script
        #
        export TARGET_OBJECTSTORE_PATH=hdfs://ram-ambarisrv-xu.southeastasia.cloudapp.azure.com:8020/tmp/hivemigrate/export
    
      ```

  3. Connect to the target cluster via ssh as root user. See Connect to a Cluster Node Through Secure Shell (SSH) in Using Source Cluster
  4. Create a script named generate_target_ddl_from_source.sh in the root home directory with the attached code. This script generates the DDL statements that you can run on the target cluster to create the hive metadata.

  5. As a root user, run the generate_target_ddl_from_source.sh script.

      ```sql
           1 . CREATE_TARGET_DB.hql
        
           2 . CREATE_TARGET_TABLE.hql
        
           3 . ADD_TARGET_PARTITION.hql
        ```

> [!TIP]
Other options to migrate Hive metastore are based upon underlying Databases and its utilities like export import, replication, log shipping etc.

### Decision flow for selecting target DB for hive metadata

![hive-metadata-db-discissionflow](../images/hive-metadata-db-discissionflow.png)

### Decision Flow Matrix for Hive on Azure

Please refer the decission flow matrix for correct target service on Azure

![hive-decission-matrix.png](../images/hive-decission-matrix.png)
  
## Modernization Databricks

Azure Databricks is structured to enable secure cross-functional team collaboration while keeping a significant amount of backend services managed by Azure Databricks so you can stay focused on your data science, data analytics, and data engineering tasks.
Although architectures can vary depending on custom configurations (such as when you’ve deployed a Azure Databricks workspace to your own virtual network, also known as VNet injection), the following architecture diagram represents the most common structure and flow of data for Azure Databricks.

![image](https://user-images.githubusercontent.com/70247096/116026874-25816e80-a686-11eb-83c0-80cc14a0d111.png)

### Databricks Migration Approach

When an Azure Databricks workspace provisioned, a default Hive Metastore comes automatically with the workspace. Alternative, an external Hive Metastore can be provision on Azure and connected to Azure Databricks. The migration of on-premises Hive to Azure Databricks essentially include two major parts: Metastore migration and Hive Data & Job Assets migration.

### Metastore Migration

The first step is to migrate the Hive Metastore from Hadoop to Azure Databricks (or Azure SQL-DB). Hive Metastore contains all the location and structure of all the data assets in the Hadoop environment. Migrating the Hive Metastore is required for users to query tables in Databricks notebooks using SQL statements. During the migration process, the locations of the underlying datasets will need to be updated to reference the Azure Databricks file system mounts.

### Export Hive table DDL

There are two methods you can use to generate the DDL for hive tables:

```sql
show tables;

SHOW CREATE TABLE person;
```

- Use SHOW CREATE TABLE command

The “show create table” hive command can be used to generate the DDL for the single hive table (syntax: SHOW CREATE TABLE HIVE_TABLE_NAME; )

- Use shell script + beeline to dump all tables DDL in the given Hive database

You can leverage on the same command “SHOW CREATE TABLE” to export all hive table DDL. The following handy script demonstrate the scripting approach to export DDL for multiple tables:

```shell
table_name_file='/home/sshdanny/tablenames.txt'  ddl_file='/home/sshdanny/hivetableddl.txt'  rm -f  $table_name_file  rm -f  $ddl_file  beeline  -u "jdbc:hive2://zk0-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk2-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk3-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2"  -n "danny" -p "[password]" --showHeader=false --silent=true  --outputformat=csv2 -e "show tables" >$table_name_file     wait    cat $table_name_file | while read LINE    do    beeline -u "jdbc:hive2://zk0-  danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk2-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181,zk3-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2"  -n "danny" -p "[password]" --showHeader=false --silent=true  --outputformat=csv2 -e "show create table $LINE" >> $ddl_file    echo   -e "\n" >> $ddl_file    echo $LINE    done  rm -f  $table_name_file  echo  "Table DDL were generated" 
```

> [!NOTE] Before executing the generated DDL file in Azure databricks DBFS to re-create the tables, the location of each hive table needs to be updated according (the corresponding dbfs:// paths) You can [export all table metadata](https://docs.microsoft.com/azure/databricks/kb/metastore/create-table-ddl-for-metastore) from Hive to the Databricks default or external metastore:

#### Hive Data & Job Assets Migration

Once the Hive metastore have been migrated over, the actual data residing in Hive can be migrated.

There are several tools available for the data migration:

1. [Azure Data Factory](https://docs.microsoft.com/azure/data-factory/connector-hive) – connect directly to Hive and copy data, in a parallelized manner, to ADLS or [Databricks Delta Lake](https://docs.microsoft.com/azure/data-factory/connector-azure-databricks-delta-lake) (big data solution)

2. Connect to Hive via [ODBC/JDBC driver](https://docs.microsoft.com/azure/databricks/integrations/bi/jdbc-odbc-bi) and copy to Hive storing in Azure (small data option)

3. Connect to Azure Databricks via [Databricks CLI](https://docs.microsoft.com/azure/databricks/dev-tools/cli/)  and copy the data to [DBFS](https://docs.microsoft.com/azure/databricks/data/databricks-file-system)

[Set up](https://docs.microsoft.com/azure/databricks/dev-tools/cli/) the databricks CLI on the hive node

[Set up authentication](https://docs.microsoft.com/azure/databricks/dev-tools/cli/#--set-up-authentication) to connect to azure databricks

Copy the data to DBFS via “databricks fs” commands.

Example:

Connecting to Azure databricks via token and list down the folders in DBFS

```shell
databricks configure --token
```

```shell
databricks fs cp /tmp/hivetables /tmp/ -r
databricks fs ls /tmp/
```

Finally, the Hive jobs can be migrated over to Azure Databricks. Given that Apache Spark SQL in Azure Databricks is designed to be [compatible](https://docs.microsoft.com/azure/databricks/spark/latest/spark-sql/compatibility/hive) with the Apache Hive, including metastore connectivity, SerDes, and UDFs, even the “copy/paste” approach to Hive job migration is feasible. The [Workspace CLI](https://docs.microsoft.com/azure/databricks/dev-tools/cli/workspace-cli) can be used to perform bulk imports of scripts onto Azure Databricks.

### Modernization Synapse

Azure Synapse Analytics is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. Azure synapse analytics provides one the freedom to query data either using serverless or dedicated resources—at scale. Azure Synapse brings these worlds together with a unified experience to ingest, explore, prepare, manage, and serve data for immediate BI and machine learning needs.

Following document provides guidance on migrating Hive cluster running on Hadoop to Azure Synapse Analytics service

### MPP Architecture

[Synapse Architecture](https://docs.microsoft.com/azure/synapse-analytics/sql/overview-architecture)

## Target Architecture

![hive-to-synapse-livemigration-arch](../images/hive-to-synapse-livemigration-arch.png)

## Migration approach

There are 2 possible approaches when one considers migrating hive database to synapse. They are

- Live migration – when the source (environment running Hive cluster ) can connect to azure

- Offline migration – when the source environment is disconnected from azure

### Live migration

Following are the high-level steps involved in migrating Apache hive cluster running in on-premise environment

High level decision flow diagram while performing live migration:

#### Scenario 1: Live migration with Hadoop cluster directly connecting to Azure without Self hosted integration runtime

1. Create the destination synapse database and open synapse studio as shown below. For example, a synapase database called “hiveimport” has been created in a synapse dedicated sql pool

![hive-synapse-sqlpool](../images/hive-synapse-sqlpool.png)

1. Create a linked service to “Hive” cluster as shown below:

Click on “manage” on synapse pool and click on “linked services”. Click on “New”

![hive-to-synapse-linkedservice-creation](../images/hive-to-synapse-linkedservice-creation.png)

Search for “Hive” and click continue:

![hive-synapse-connectionstring](../images/hive-synapse-connectionstring.png)

Provide the relevant details as shown below:

![hive-synapse-connectionstring1](../images/hive-synapse-connectionstring1.png)

![hive-synapse-connectionstring2](../images/hive-synapse-connectionstring2.png)

Test the connection and create the linked service.

1. Create the copy activity

Click on the integrate button on synapse studio. Click on the “+” button to add new pipeline. Search for the “Copy” activity and add the copy activity to the pipeline:

![hive-synapse-create-copy-activity1](../images/hive-synapse-create-copy-activity1.png)

Click on the copy activity. Rename the activity from “Copy data1” to “HivetoSynapse” as shown below

![hive-synapse-create-copy-activity2](../images/hive-synapse-create-copy-activity2.png)

Click on “New Dataset”

![hive-synapse-create-copy-activity3](../images/hive-synapse-create-copy-activity3.png)

Search for “Hive” and the add the dataset. Click on the “open” button to open the dataset

![hive-synapse-create-copy-activity4](../images/hive-synapse-create-copy-activity4.png)

Map the dataset to linked service created earlier as shown below. Pick the hive table to be transferred.

![hive-synapse-create-copy-activity5](../images/hive-synapse-create-copy-activity5.png)

Switch the tab and return to the copy activity. Click on the “sink” tab and click on “+ New” button to create a dataset for “Synapse” destination table. Search for synapse in dataset creation and pick “azure synapse dedicated pool”

![hive-synapse-create-copy-activity6](../images/hive-synapse-create-copy-activity6.png)

Provide a name which can identify the table being transferred. Pick the dedicated pool to which data is to be imported to. Click on the edit button and provide the destination table name, manually. Set “Import Schema” to “None”

![hive-synapse-create-copy-activity7](../images/hive-synapse-create-copy-activity7.png)

On the sink settings, select “Copy method” as “Bulk Insert” and Table option as “Auto Create Table” as shown below

![hive-synapse-create-copy-activity8](../images/hive-synapse-create-copy-activity8.png)

Hit the “Mapping” tab, Click on “import schemas” and perform “mapping” if required.

![hive-synapse-create-copy-activity9](../images/hive-synapse-create-copy-activity9.png)

Change the pipeline name as “HivetoSynapse” and hit the publish button.

![hive-synapse-create-copy-activity10](../images/hive-synapse-create-copy-activity10.png)

1. Execute the Pipeline and verify the results

Execute the pipeline by clicking on the “Add Trigger” -> “Trigger Now” button

Upon successful completion of the run, verify if the new table has been created and the data has been successfully transferred by clicking on the data section of synapse studio and querying the table as shown below.

![hive-synapse-create-copy-activity11](../images/hive-synapse-create-copy-activity11.png)

![hive-synapse-create-copy-activity12](../images/hive-synapse-create-copy-activity12.png)

#### Scenario 2: Live migration with Hadoop cluster directly Via self hosted IR

- Install Self hosted Integration runtime in a on-premise server which can access azure. Refer [Create a self-hosted integration runtime - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime#setting-up-a-self-hosted-integration-runtime)

- Create a linked service to hive data source using the integration run time. Example linked service connecting to SQL database via Integration time provided here - [Copy data from SQL Server to Blob storage using Azure portal - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/tutorial-hybrid-copy-portal). Similar steps can be followed to create linked service for hive database via integration runtime

- Use copy activity task as done in previous scenario to move the tables to synapse

#### Scenario 3: Live migration with Hadoop “kerberized” cluster in on premise environment

- Install Self hosted Integration runtime in a on-premise server which can access azure. Refer [Create a self-hosted integration runtime - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/create-self-hosted-integration-runtime#setting-up-a-self-hosted-integration-runtime)

- Install odbc driver in self hosted IR - [Cloudera ODBC Driver for Apache Hive Installation and Configuration Guide](https://docs.cloudera.com/documentation/other/connectors/hive-odbc/2-6-9/Cloudera-ODBC-Driver-for-Apache-Hive-Install-Guide.pdf)

- Setup kerberos authentication in self hosted integration runtime as explained [here](https://www.simba.com/products/Hive/doc/ODBC_InstallGuide/win/content/odbc/hi/kerberos.htm)

- After the setup, create the linked service using use Azure Data Factory odbc connector to connect to the hive cluster

- Use copy activity and copy the tables as mentioned in previous scenario

#### Considerations

- Complex types such as arrays, maps, structs, and unions are not supported for read via Azure Data Factory.

- Hive connector only supports Hive tables in Apache Hive of version 3.1.0

#### Hive object mapping to Azure Synapse

| Hive object                     | Synapse object                                               | High level migration method                                  |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Hive internal tables            | Table in Azure Synapse dedicated pool                        | Azure Data Factory                                           |
| Hive external tables            | Synapse external tables using polybase. Data  resides as files in ADL Gen 2 | ·      Azure Data Factory / azcopy to move  HDFS files to ADL Gen 2  ·      DDL Scripts to create external tables |
| Hive partitions                 | Synapse tables with distribution option                      | ·      DDL Scripts                                           |
| Hive table / object permissions | Synapse access controls at the database layer                | ·      DDL Scripts                                           |

## Offline migration

If the on-premise Hive cluster cannot be connected to Azure, then one may perform an offline / disconnected migration. Following are the high level steps. < Details to be added>

- Script out all the DDL scripts for the external and internal tables in Hive. Sample script to extract DDL statements provided below.

```bash
  #!/bin/bash  rm -f tableNames.txt  rm -f HiveTableDDL.txt  hive -e "use $1; show  tables;" > tableNames.txt   wait  cat tableNames.txt |while read LINE     do     hive -e "use $1;show create table $LINE;"  >>HiveTableDDL.txt     echo -e "\n" >>  HiveTableDDL.txt     done  rm -f tableNames.txt  echo "Table DDL  generated"
```

Reference: [sql - How to get/generate the create statement for an existing hive table? - Stack Overflow](https://stackoverflow.com/questions/18134131/how-to-get-generate-the-create-statement-for-an-existing-hive-table)

- Export the internal tables as csv files to local HDFS storage

- Move the HDFS storage to Azure Data Lake using Azcopy / distcp / databox as described in [Copy data from HDFS by using Azure Data Factory - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/azure/data-factory/connector-hdfs)

- Create Azure Synapse instance and use serverless pools and create the external tables connecting to Azure data lake gen 2. Use serverless pools ( SQL or spark ) to explore the data

- Perform any processing of data via notebooks or SQL Scripts and ingest the prepared data into Synapse SQL dedicated pools or Synapse spark database

- Import the hive internal table to azure synapse dedicated SQL Pool or spark database via T-SQL scripts.

### Lift and Shift - HDInsight

Refer [the documentation](https://azure.microsoft.com/resources/migrating-big-data-workloads-hdinsight/) provided by the HDInsight product team

### Lift and Shift - IAAS

Other options to migrate Hive Tables

An hive has following type of workloads:

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

We can use Hive replication approach to migrate Hive to new cluster. Refer below link which depicts the replication to HDInsight

[How to use Apache Hive replication in Azure HDInsight clusters | Microsoft Docs](https://docs.microsoft.com/azure/hdinsight/interactive-query/apache-hive-replication)


## Migrate Hive SQL Workloads
  
### Migrate Hive SQL Queries to HDIsight Spark SQL
  
[To Migrate Hive SQL Queries to HDIsight Spark SQL please refer MLens product from Knowledgelens.](https://azuremarketplace.microsoft.com/marketplace/apps/knowledgelens1591334415709.knowledgelens_mlens?tab=Overview)

### Migrate Hive SQL Queries to Databricks
  
[To Migrate Hive SQL Queries to Databricks please refer MLens product from Knowledgelens.](https://www.youtube.com/watch?v=I3uQvZVIalo)

Please contact harman@knowledgelens.com & deepanjali@knowledgelens.com for further assistance.

[Previous](considerations.md)
