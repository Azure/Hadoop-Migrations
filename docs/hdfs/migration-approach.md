## Migration Approach

The migration approach of HDFS to ADLS typically involves the below 6 steps.

![img](..\images\clip_image012.png)

​        [[DK19\]](#_msocom_19)

### HDFS Assessment

​        On premises assessment scripts can be run to plan what workloads can be migrated to the Azure Storage account/s , priority of migration ie all data or move in parts . The below decision flow helps decide the criteria and commands can be run to get the data/ metrics. 3rd party tools like Unravel can support in getting the metrics and support auto assessment of the on premise HDFS . Data Migration planning can be split based on – Data Volume , Business Impact , Ownership of Data , Processing/ETL Jobs complexity , Sensitive Data / PII data , based on the date/time data generated. Based on this either entire workload or parts can be planned to be moved to Azure to avoid downtimes/business impact.[[DK20\]](#_msocom_20) The sensitive data can be chosen to remain on premise and moving only non PII data to cloud as an approach. All historical data can be planned to be moved and tested prior to moving the incremental load.

![img](..\images\clip_image014.png)

HDFS commands and reports that can help with getting the key assessment metrics from HDFS include –

- **To list all directories in a location**
- - - hdfs dfs -ls books[[DK21\]](#_msocom_21)

- **Recursively list all files in a location**
- - - hdfs       dfs -ls -R books

- **Size of the HDFS File/Directory**
- - - Hadoop fs -du -s -h command[[DK22\]](#_msocom_22)
    - The Hadoop fs -du -s -h command is used to check the       size of the HDFS file/directory in human readable format. Since the       Hadoop file system replicates every file, the actual physical size of       the file will be number of replication with multiply of size of the       file.

- **Hdfs-site.xml**
- - - dfs.namenode.acls.enabled : Check if acls.enabled – helpful to plan the access       control on Azure storage account

For more information refer - https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

 3rd party tools like Unravel provides assessment reports that can help plan the migration of data . The tool is required to be installed in the on premise environment or be able to connect to the Hadoop cluster to generate the assessment report. Based on the customer requirements the tool can be installed or scripts can be built using the hdfs commands to assess the HDFS cluster. Some of the metrics related to data migration include –

[[NM24\]](#_msocom_24)

- **List of small files -**      generates reports that     can help assess the on premise Hadoop system . The sample below generates     a report on the small files being generated – that helps with planning the     next action on moving to Azure.

![img](..\images\clip_image016.jpg)

- **list of file files based on size** – generates reports based on the data volume and groups     into- large, medium , tiny , empty

![Graphical user interface, application  Description automatically generated](..\images\clip_image018.jpg)

### Data Transfer

Based on the identified strategy for data migration identify the data sets to be moved to Azure.

 *Pre-checks prior to Transfer*

1. **Identify all the ingestion points** for the chosen use case to migrate to Azure .. Due to     security requirements if data cannot be landed to the cloud directly then     on premise can continue to exist in parallel as the intermediary landing     zone and pipelines can be built in Azure Data Factory to pull the data     from on premise systems or AZCopy scripts can be scheduled to push the     data to Azure storage account.

Common ingestion sources include –

\1.   SFTP Server

\2.   File Ingestion

\3.   Database Ingestion

\4.   Database dump

\5.   CDC

\6.   Streaming Ingestion

1. **Plan the number of     storage accounts needed**

To plan the number of storage accounts needed , understand the total load on the current hdfs by using the metric TotalLoad that gives the concurrent file access across all the data nodes. Based on the total load on premise and the expected growth on Azure , limit needs to be checked on the storage account in the region. If it is possible to increase the limit , a single storage account may suffice. However for a data lake , it is advised to keep a separate storage account per zone considering the future data volume growth. Other reasons to keep a separate storage account include – access control , resiliency requirements, data replication requirements , exposing the data for public usage.  It is important to understand if an hierarchical namespace is needed to be enabled on the storage account- as once it has been enabled cannot revert back to a flat namespace . Workloads like backups , images etc do not gain any benefit from enabling a hierarchical namespace.

![img](..\images\clip_image020.png)

 . Availability     Requirements

Hadoop platforms have the replication factor specified in the hdfs-site.xml or per file . The replication on ADLS Gen2 can be planned based on the nature of the data ie. If an application requires the data to be reconstructed in case of a loss then ZRS can be an option . In ADLS Gen 2 ZRS – data is copied synchronously across 3 AZs in the primary region. For applications that require high availability and is not constrained by the region of storage – the data can additionally be copied in a secondary region – ie. geo redundancy .

![img](..\images\clip_image022.png)

1. Check for     corrupted/missing blocks

Check for corrupted/missing blocks by checking the block scanner report – if any corrupted blocks are found then wait for the data to be restored prior to transferring the file associated with the corrupted blocks.

![img](..\images\clip_image024.png)

1. Check if NFS is     enabled

Check if NFS is enabled on the on premise Hadoop platform checking the core-site.xml file , that holds the property – nfsserver.groups and nfsserver.hosts. The NFS3.0 feature is currently in preview in ADLS Gen 2 and a few features aren’t yet supported with ADLS Gen2 -

 Refer the link - https://docs.microsoft.com/en-us/azure/storage/blobs/network-file-system-protocol-support for the NFS 3.0 features that aren't yet supported with Azure Data Lake Storage Gen2 .

![img](..\images\clip_image026.png)

1. Check Hadoop     File Formats

[[DK25\]](#_msocom_25)

![img](..\images\clip_image028.png)

 1. Choose an Azure     solution for data transfer

Data transfer can be online over the network or offline using physical shippable devices based on the data volume, network bandwidth and the frequency of the data transfer( historical data would be a one time transfer and incremental load would be at periodic interval ).

For more details on the option to choose refer the link - https://docs.microsoft.com/en-us/azure/storage/common/storage-choose-data-transfer-solution

**1.**  **Azcopy**[[HT26\]](#_msocom_26)

Azcopy is a command line utility that can be used to copy files from HDFS to a storage account. This is an option when there is high network bandwidth to move the data ( ie over 1 gbps)

 Sample command to move an hdfs directory -

*azcopy copy "C:\local\path" "https://account.blob.core.windows.net/mycontainer1/?sv=2018-03-28&ss=bjqt&srt=sco&sp=rwddgcup&se=2019-05-01T05:01:17Z&st=2019-04-30T21:01:17Z&spr=https&sig=MGCXiyEzbtttkr3ewJIh2AR8KrghSy1DGM9ovN734bQF4%3D" --recursive=true*[[DK27\]](#_msocom_27)

**2.**  **Distcp**

[DistCp](https://hadoop.apache.org/docs/current3/hadoop-distcp/DistCp.html) is a command-line utility in Hadoop to perform distributed copy operations in a Hadoop cluster. Distcp creates several map jobs in the Hadoop cluster to copy the data from source to the sink . This push approach is good when there is good network bandwidth and doesn’t require extra compute resources to be provisioned for data migration. However , if the source HDFS cluster is already running out of capacity and additional compute cannot be added then consider using Azure Data Factory ( with distcp copy activity) as a pull approach instead of the push approach.

*hadoop distcp -D fs.azure.account.key.<account name>.blob.core.windows.net=<Key> wasb://<container>@<account>.blob.core.windows.net<path to wasb file> hdfs://<hdfs path>*[[DK28\]](#_msocom_28)

**3.**  **Azure Data Box ( for large data transfers)**

Azure Data Box is a service that provides large-scale data transfers – particularly to move the historical data and is a physical device ordered from Microsoft. For an offline data transfer option , when network bandwidth is limited or no bandwidth  and         data volume is high ( say a few TB to PB scale) then Azure data box is an option.

There are multiple options for a data box provided based on the data volume – Data Box Disk , Data Box or Data Box Heavy  . The device when received is connected to the Local Area Network and data is transferred to it and shipped back to the MS data center. The data from the Data box is then transferred by the engineers to the configured storage account.

Data extraction and transfer Scripts using the Data Box approach can be referred to at the location - [GitHub - Azure/databox-adls-loader: Tools and scripts to load data from Hadoop clusters to Azure Data Lake Storage using Data Box](https://github.com/Azure/databox-adls-loader)

**4.**  **Azure Data Factory**

Azure Data Factory is a data-integration service that helps create data-driven workflows orchestrating and automating data movement and data transformation.  This option can be used when there is high network bandwidth available and there is a need to orchestrate and monitor the data migration process. Also can be an approach for regular incremental load of data when the incremental data arrives on the on premise system as a first hop and cannot be directly transferred to the Azure storage account due to security requirements.

For details on comparison of the approaches refer the link - [Azure data transfer options for large datasets, moderate to high network bandwidth | Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/common/storage-solution-large-dataset-moderate-high-network)

For details on copying data from HDFS using ADF refer the link [Copy data from HDFS by using Azure Data Factory - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/connector-hdfs#hdfs-as-source)

**5.**  **Third Party solutions like – WANDISCO Live Data Migration**

WANdisco LiveData Platform for Azure is one of Microsoft’s preferred solutions for Hadoop to Azure migrations and provides the capability through the Azure Portal and CLI.

For more details related to Live Data migrator refer [Migrate your Hadoop data lakes with WANDisco LiveData Platform for Azure | Azure Blog and Updates | Microsoft Azure]

## Reference Implementation - ARM Templates

TBD v2

## Pseudocode

TBD v2


## Architectural Guidance

TBD v2

### Patterns & Anti – Patterns

### Performance Tuning

# Databricks – Migration

## Considerations & Feature Map

| **Enterprise Feature** | **Hadoop**                                                   | **Databricks**                                               |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| User  Management       | No  out of the box integration with AAD  Complex  user provisioning with AAD Domain Services | Out  of the box AAD Integration  Supports  Industry standard SCIM API for user  and group sync |
| User Experience        | Mix of Hue, Ambari Views, Zeppelin &  Jupyter Notebooks  No integrated multi-user workspace  experience for team collaboration  No integration with Azure Teams or Git | Rich multi-user experience with personal  and shared workspaces  Industry leading notebook with support  for visualization, comments, version management & out of the box Git  integration |
| Security               | Designed  for on-prem long running clusters.   Offers Ranger/Sentry for data authorization. Ranger/Sentry are proprietary lock-in that  limit choice of analytic tools (Hadoop only), offer low data bandwidth and  limited API (primarily SQL) | Designed  out of the box with Cloud Native Security.   Works transparently with ADLS and AKV ACLs. No proprietary lock-in or single point of  bottleneck. Supports data access via  object, dataframe and SQL API |
| Clusters               | Designed for “Always-On” cluster. High Cluster startup time  Cluster setup requires elevated  subscription privileges. | Designed for “Ephemeral” clusters. Low cluster startup time  End user can create / decommission  clusters without need for elevated subscription level privileges |
| Scale                  | Cluster  size is fixed. Requires manual  adjustment          | Clusters  auto-scale based on “usage” and include auto-termination during periods of  inactivity |
| Administration         | High administrative cost with need to  manage multiple services that bring little/no value in cloud (YARN, HDFS,  MapReduce, Pig, Oozie, Zookeeper) | Zero administration. Fully managed with  guaranteed 99.99% uptime. |
| API                    | Limited  REST API support for programmatic interaction       | Extensive  support for REST API & CLI for programmatic interactions  Native  integration with Azure DevOps |

## Technology Mapping

| **Hadoop**      | **Description**                                              | **Equivalent  Cloud Native Service**                         | **Advantages  of Cloud Native Service**                      |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| YARN            | Resource  manager for allocation & orchestration of multi-user workloads on an  “Always-On” Cluster | Azure  Resource Manager + ”On-Demand” Azure Virtual Machines | “Always-On”  is an anti-pattern in cloud. Azure  offers the capability to create and decommission clusters of Virtual Machines  per workload with improved resource isolation and performance guarantees |
| HDFS            | Distributed File System to pool disks  across multiple hosts into a single namespace. Valid for “Always-On” cluster with co-located  Storage & Compute | Azure Data Lake Storage (ADLS) Gen2                          | Co-located compute and storage is an  anti-pattern in cloud. ADLS Gen2  offers disaggregated & infinitely scalable storage that’s independent of  compute. |
| Hive            | SQL  engine for Big Data                                     | Azure  Databricks                                            | Azure  Databricks Delta with in-memory architecture is 10-100x faster than Hive  while offering capabilities that go beyond SQL to include streaming, machine  learning and data science |
| Spark           | Unified Analytics engine for Stream Processing,  ETL, SQL & ML | Azure Databricks                                             | Azure Databricks Delta offers  performance, reliability & throughput improvements of up to 5-10x Apache  Spark. With support for Transactions,  Schema management, Secondary indexes and Granular Security, Delta is enterprise  ready version of Spark by the creators of Apache Spark |
| Storm           | Distributed  Stream Processing framework                     | Azure  Databricks & Azure Stream Analytics                   | Stream  Analytics & Azure Databricks Structured Streaming offer higher  resiliency, improved throughput and lower management cost. |
| Kafka           | Pub & Sub system for streams of  records                     | Azure Events Hub & IOT Hub                                   | Kafka is the only service in Hadoop that  offers differentiated capability over cloud native service. As an example, Kafka can support higher  throughput. On the contrary, both  Events Hub and IOT Hub offer simplicity of management & elasticity  unavailable in Kafka. |
| HBase           | Columnar  NoSQL Database with strong consistency guarantees  | Cosmos  DB                                                   | Cosmos  DB combines best of document & columnar database with geo-redundancy for  modern high scale web applications |
| Ranger / Sentry | Data Authorization & Audit                                   | ADLS Gen2 ACL & Azure Monitor                                | ADLS Gen2 ACL & Azure monitor offer  consistent cloud native data security and monitoring that’s enforced across  all data access engines. Ranger/Sentry  only protects data access via Hadoop while resulting in administration  overhead and duplicate access management |
| Oozie           | Workflow  orchestration engine                               | Azure  Data Factory                                          | Azure  Data Factory offers rich and extensive GUI based workflow orchestration  capabilities unavailable in Oozie. |


## Migrations Patterns

There are different approaches to migration of workloads from Hadoop on Azure Databricks. One common approach is to migrate use-cases individually. Here, all the relevant resources (data, scripts, pipelines, user permissions) are migration to Azure Databricks in separate phases. This allows for an steady and organized approach to migrating to the cloud with simplicity in mind.

Another approach is to move workloads associated to the various teams within the organization. For example, all the data and scripts used by the Data Science team could be migrated first, followed by all the resourced needed by the Data Engineering team. This approach takes on more of a bulk migration approach, but can be implemented independently and parallelly by the various teams involved.

Data migration can be accomplished by copying on-prem data onto an Azure storage solution, like Azure Data Lake Gen2. This copying can be accomplished via Azure Data Factory, involving potential data conversions to optimized formats like [Parquet](https://docs.microsoft.com/en-us/azure/data-factory/format-parquet) and [Delta](https://docs.microsoft.com/en-us/azure/data-factory/format-delta).

![img](..\images\clip_image030.png)
