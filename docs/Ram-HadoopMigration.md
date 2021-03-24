> Hadoop Migration Guide v1.0

Ram9991

**\
**
<<<<<<< HEAD
**Ram**

=======
>>>>>>> fc64dcfb359be61d68c399bc86ad3c89282c8b1e
Table of Contents

[Structure of this guide 6](#structure-of-this-guide)

[Further reading 6](#further-reading)

[Hadoop Architecture & Components 7](#hadoop-architecture-components)

[Brief introduction to Apache Hadoop
7](#brief-introduction-to-apache-hadoop)

[Hadoop Distributed File Systems (HDFS)
8](#hadoop-distributed-file-systems-hdfs)

[Common Challenges of an on premise HDFS
9](#common-challenges-of-an-on-premise-hdfs)

[HDFS Architecture and Components 11](#hdfs-architecture-and-components)

[Considerations 13](#considerations)

[Migration Approach 14](#migration-approach)

[HDFS Assessment 14](#hdfs-assessment)

[Data Transfer 17](#data-transfer)

[Feature Map & Workaround 22](#feature-map-workaround)

[Reference Implementation - ARM Templates
25](#reference-implementation---arm-templates)

[Pseudocode 25](#pseudocode)

[Architectural Guidance 25](#architectural-guidance)

[Patterns & Anti -- Patterns 25](#patterns-anti-patterns)

[Performance Tuning 25](#performance-tuning)

[HA & DR 25](#_Toc67357480)

[HBase 26](#hbase)

[Challenges of HBase on premise 26](#challenges-of-hbase-on-premise)

[HBase Architecture and Components
26](#hbase-architecture-and-components)

[Brief introduction to Apache Hbase
26](#brief-introduction-to-apache-hbase)

[Core Concepts 27](#core-concepts)

[Considerations 29](#considerations-1)

[Migration Approach 30](#migration-approach-1)

[Lift and shift -- Azure IaaS 31](#lift-and-shift-azure-iaas)

[Modernization -- Cosmos DB (SQL API)
45](#modernization-cosmos-db-sql-api)

[Hive 70](#hive)

[Challenges of Hive on premise 70](#challenges-of-hive-on-premise)

[Hive Architecture and Components 70](#hive-architecture-and-components)

[Considerations 70](#considerations-2)

[Migration Approach 70](#migration-approach-2)

[Modernization -- Databricks 70](#modernization-databricks)

[Modernization -- Synapse 75](#modernization-synapse)

[Lift and Shift -- HDInsight 75](#lift-and-shift-hdinsight)

[Lift and Shift -- IAAS 75](#lift-and-shift-iaas)

[Decision Map/Flowchart 75](#decision-mapflowchart)

[Feature Map & Workaround 75](#feature-map-workaround-1)

[Reference Implementation - ARM Templates
75](#reference-implementation---arm-templates-1)

[Pseudocode 76](#pseudocode-1)

[Architectural Guidance 76](#architectural-guidance-1)

[Patterns & Anti -- Patterns 76](#patterns-anti-patterns-1)

[Performance Tuning 76](#performance-tuning-1)

[HA & DR 76](#ha-dr)

[Apache Ranger 76](#apache-ranger)

[Apache Ranger: Overview -- Features
76](#apache-ranger-overview-features)

[Challenges of Ranger on premise 76](#challenges-of-ranger-on-premise)

[Apache Ranger Architecture and Components
77](#apache-ranger-architecture-and-components)

[Apache Ranger 77](#apache-ranger-1)

[Apache Ranger: Overview -- Features
78](#apache-ranger-overview-features-1)

[Challenges of Ranger on premise 78](#challenges-of-ranger-on-premise-1)

[Apache Ranger Architecture and Components
79](#apache-ranger-architecture-and-components-1)

[Migration Approach 80](#migration-approach-3)

[Modernization -- AAD + Databricks 80](#modernization-aad-databricks)

[Modernization -- AAD + Azure PAAS Services
81](#modernization-aad-azure-paas-services)

[Lift and Shift -- HDInsight 85](#lift-and-shift-hdinsight-1)

[Lift and Shift -- IAAS (INFRASTRUCTURE AS A SERVICE)
88](#lift-and-shift-iaas-infrastructure-as-a-service)

[Decision Map/Flowchart 89](#decision-mapflowchart-1)

[Ranger - Hbase 90](#ranger---hbase)

[Ranger -- HDFS 90](#ranger-hdfs)

[Ranger -- Hive 92](#ranger-hive)

[Feature Map & Workaround 92](#feature-map-workaround-2)

[Pseudocode 93](#pseudocode-2)

[Architectural Guidance 93](#architectural-guidance-2)

[Patterns & Anti -- Patterns 93](#patterns-anti-patterns-2)

[Performance Tuning 93](#performance-tuning-2)

[HA & DR 93](#ha-dr-1)

[Apache Spark 93](#apache-spark)

[Challenges of Spark on premise 93](#challenges-of-spark-on-premise)

[Apache Spark Architecture and Components
94](#apache-spark-architecture-and-components)

[Considerations 94](#considerations-3)

[Migration Approach 94](#migration-approach-4)

[Modernization -- Databricks 94](#modernization-databricks-1)

[Modernization -- Synapse 94](#modernization-synapse-1)

[Lift and Shift -- HDInsight 94](#lift-and-shift-hdinsight-2)

[Lift and Shift -- IAAS 94](#lift-and-shift-iaas-1)

[Decision Map/Flowchart 94](#decision-mapflowchart-2)

[Feature Map & Workaround 95](#feature-map-workaround-3)

[Reference Implementation - ARM Templates
95](#reference-implementation---arm-templates-2)

[Pseudocode 95](#pseudocode-3)

[Architectural Guidance 95](#architectural-guidance-3)

[Patterns & Anti -- Patterns 95](#patterns-anti-patterns-3)

[Performance Tuning 95](#performance-tuning-3)

[HA & DR 95](#ha-dr-2)

￼

# Structure of this guide

This guide recognizes that Hadoop provides an extensive ecosystem of
services and frameworks. This guide is not intended to be a definitive
document that describes components of the Hadoop ecosystem in detail, or
how they are implemented on Azure. Rather, this guide focuses on
specific guidance and considerations you can follow to help move your
existing data storage -- HDFS , Other Cloud Storage like AWS S3 data to
Azure.

It is assumed that you already have HDFS deployed in an on-premises
datacentre or Cloud storage- AWS S3 and exploring one of migration
targets on Azure -- Azure ADLS Gen2 ;

## Further reading

For customers new to Azure, we recommend [Enterprise Scale Landing Zone
guidance](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/)
to build fundamental capabilities so that and scale in a performant
fashion. These capabilities enable customers to land new workloads
whilst maintaining a strong policy-driven governance to ensure that the
platform and workloads are compliant.

For designing and deploying workloads to Azure, we recommend [Microsoft
Azure Well-Architected
Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/).
It serves as a guide and highlights key areas like scalability,
operations, reliability etc. that one must consider and factor-in while
building a solution on Azure.

For support on Azure migration , we recommend [Azure Migration
Program](https://gearup.microsoft.com/resources/azure-migration-program-overview)
( AMP) is a centrally managed program to help simplify and accelerate
migration and enable customer success. Customers can get the help they
need to simplify the journey to the cloud. Wherever they are in their
cloud journey, AMP help accelerate progress. AMP offers **proactive
guidance and the right mix of expert help** at every stage of the
migration journey to ensure they can migrate infrastructure, databases
and application workloads with confidence. All customers can access
resources and tools such as free migration tools, step-by-step technical
guidance, training and help in finding a migration partner.

# Hadoop Architecture & Components

## Brief introduction to Apache Hadoop

Hadoop provides a distributed file system and a framework for the
analysis and transformation of very large data sets using the MapReduce
paradigm. An important characteristic of Hadoop is the partitioning of
data and computation across many (thousands) of hosts, and executing
application computations in parallel close to their data. A Hadoop
cluster scales computation capacity, storage capacity and IO bandwidth
by simply adding commodity hardware. The key components of an Hadoop
system include-

  HDFS        Distributed File System
  ----------- ----------------------------------------------------
  MapReduce   Distributed computation framework
  HBase       Column-oriented table service
  Pig         Dataflow language and parallel execution framework
  Hive        Datawarehouse infrastructure
  Zookeeper   Distributed coordination service
  Chukwa      System for collecting management data
  Avro        Data serialization system

Reference : <https://gearup.microsoft.com/resources/azure-migration>

**Hive**\
Hive is data warehousing software that addresses how data is structured
and queried in distributed Hadoop clusters. Hive is also a well-known
development environment that is used to build queries for data in the
Hadoop environment. It provides tools for ETL workloads and brings
SQL-like capabilities to the Hadoop. Hive is a declarative language that
is used to develop applications for the Hadoop environment.

**Pig**

Pig is a platform for performing analysis on large data sets that
consists of a high-level language for expressing data analysis programs,
coupled with infrastructure for evaluating these programs. Pig includes
Pig Latin, which is a scripting language. Pig translates Pig Latin
scripts into MapReduce, which can then run on YARN and process data in
the HDFS cluster. Pig is popular because it automates some of the
complexity in MapReduce development.

**HBase**\
HBase is a structured noSQL database that rides atop Hadoop. It stores
the structured data on top of HDFS. HBase provides a fault-tolerant way
of storing sparse data sets. It is well suited for real-time data
processing or random read/write access to large volumes of data. Unlike
traditional [RDBMS](https://www.ibm.com/analytics/relational-database),
HBase does not support a structured query language like SQL. It
comprises a set of standard tables with rows and columns, much like a
traditional database. Each table must have an element defined as a
primary key, and all access attempts to HBase tables must use this
primary key.

**Zookeeper**\
Apache Zookeeper is a centralized service and a Hadoop Ecosystem
component for maintaining configuration information, naming, providing
distributed synchronization, and providing group services. Zookeeper
manages and coordinates a large cluster of machines.

# Hadoop Distributed File Systems (HDFS)

The file system component of Hadoop is Hadoop Distributed File System (
HDFS). The interface to Hadoop is based on UNIX. The data related to an
application and file

HDFS stores file system metadata and application data separately. Like
the distributed file systems, HDFS also has 2 type of servers --

-   # NameNode : File system metadata is stored on a NameNode . It holds the the directory tree of all files in the system and tracks where data files is kept. {#namenode-file-system-metadata-is-stored-on-a-namenode-.-it-holds-the-the-directory-tree-of-all-files-in-the-system-and-tracks-where-data-files-is-kept. .TOC-Heading}

-   # DataNode : Application Data is stored on the DataNodes.  {#datanode-application-data-is-stored-on-the-datanodes. .TOC-Heading}

All servers communicate with each other over TCP and for reliability the
file content is replicated on DataNodes.

## Common Challenges of an on premise HDFS

-   # Frequent HDFS version upgrades {#frequent-hdfs-version-upgrades .TOC-Heading}

-   # Growing volume of data on HDFS {#growing-volume-of-data-on-hdfs .TOC-Heading}

-   # Small file problem -- when too many small files are stored , the NameNode loads metadata of all the files in memory -- increasing the pressure on the NameNode . The small files also increase the read traffic on the name node when clients are reading the files and also increases the calls when the files are being written. {#small-file-problem-when-too-many-small-files-are-stored-the-namenode-loads-metadata-of-all-the-files-in-memory-increasing-the-pressure-on-the-namenode-.-the-small-files-also-increase-the-read-traffic-on-the-name-node-when-clients-are-reading-the-files-and-also-increases-the-calls-when-the-files-are-being-written. .TOC-Heading}

-   # Multiple teams in the organization may require different datasets - splitting the HDFS clusters by use case or organization is not possible thus increasing costs , data duplication leading to a decrease in the efficiency. {#multiple-teams-in-the-organization-may-require-different-datasets---splitting-the-hdfs-clusters-by-use-case-or-organization-is-not-possible-thus-increasing-costs-data-duplication-leading-to-a-decrease-in-the-efficiency. .TOC-Heading}

-   # It is difficult to scale HDFS cluster without impacting throughput of the NameNode  {#it-is-difficult-to-scale-hdfs-cluster-without-impacting-throughput-of-the-namenode .TOC-Heading}

-   Prior to Hadoop 2.0 , since all the metadata is stored in a single
    NameNode, it becomes a bottleneck as all client requests to an HDFS
    cluster must first pass through the NameNode making it a single
    point of failure (**SPOF**). Each cluster had a single NameNode, and
    if NameNode fails, the cluster as a whole would be out services. The
    cluster will be unavailable until the NameNode restarts or brought
    on a separate machine.

## HDFS Architecture and Components

# Hadoop Distributed Filesystem (HDFS) - a Java-based file system that follows the master -slave architecture -- with NameNode being the master and DataNode being the slave providing scalable and reliable data storage designed to span large clusters of commodity servers. {#hadoop-distributed-filesystem-hdfs---a-java-based-file-system-that-follows-the-master--slave-architecture-with-namenode-being-the-master-and-datanode-being-the-slave-providing-scalable-and-reliable-data-storage-designed-to-span-large-clusters-of-commodity-servers. .TOC-Heading}

#  {#section .TOC-Heading}

#   {#section-1 .TOC-Heading}

#  {#section-2 .TOC-Heading}

#  {#section-3 .TOC-Heading}

-   # **Namenode**: Is the master node that manages access to files and namespace. It is a hierarchy of files and directories.  {#namenode-is-the-master-node-that-manages-access-to-files-and-namespace.-it-is-a-hierarchy-of-files-and-directories. .TOC-Heading}

    -   # Files and directories are inodes on the NameNode - has attributes like permissions, modification and access times, namespace and disk space quotas.  {#files-and-directories-are-inodes-on-the-namenode---has-attributes-like-permissions-modification-and-access-times-namespace-and-disk-space-quotas. .TOC-Heading}

    -   # The file content is split into blocks (usually 128 megabytes , but can be customized per file) {#the-file-content-is-split-into-blocks-usually-128-megabytes-but-can-be-customized-per-file .TOC-Heading}

    -   # Each block of the file is independently replicated at multiple DataNodes. The replication factor is default 3 but can be customized on file to file basis.  {#each-block-of-the-file-is-independently-replicated-at-multiple-datanodes.-the-replication-factor-is-default-3-but-can-be-customized-on-file-to-file-basis. .TOC-Heading}

    -   # The NameNode maintains the namespace tree and the mapping of file blocks to DataNodes (the physical location of file data).  {#the-namenode-maintains-the-namespace-tree-and-the-mapping-of-file-blocks-to-datanodes-the-physical-location-of-file-data. .TOC-Heading}

    -   # An HDFS client that needs to read a file -  {#an-hdfs-client-that-needs-to-read-a-file-- .TOC-Heading}

1.  # Contacts the NameNode for the locations of data blocks comprising the file  {#contacts-the-namenode-for-the-locations-of-data-blocks-comprising-the-file .TOC-Heading}

2.  # Reads block contents from the DataNode closest to the client.  {#reads-block-contents-from-the-datanode-closest-to-the-client. .TOC-Heading}

    -   # An HDFS cluster can have thousands of DataNodes and tens of thousands of HDFS clients per cluster, as each DataNode can execute multiple application tasks concurrently.  {#an-hdfs-cluster-can-have-thousands-of-datanodes-and-tens-of-thousands-of-hdfs-clients-per-cluster-as-each-datanode-can-execute-multiple-application-tasks-concurrently. .TOC-Heading}

    -   # HDFS keeps the entire namespace in memory ie RAM.  {#hdfs-keeps-the-entire-namespace-in-memory-ie-ram. .TOC-Heading}

#  {#section-4 .TOC-Heading}

-   # **DataNode**: is the slave node that performs read/write operations on the file system as well as block operations like creation, replication, and deletion. {#datanode-is-the-slave-node-that-performs-readwrite-operations-on-the-file-system-as-well-as-block-operations-like-creation-replication-and-deletion. .TOC-Heading}

    -   # Contains a metadata file that holds the checksum  {#contains-a-metadata-file-that-holds-the-checksum .TOC-Heading}

    -   # Contains the data file that holds the block's data {#contains-the-data-file-that-holds-the-blocks-data .TOC-Heading}

    -   # On a file read, DataNode fetches the block locations and replica locations from the NameNode -- tries reading from the location closest to the client {#on-a-file-read-datanode-fetches-the-block-locations-and-replica-locations-from-the-namenode-tries-reading-from-the-location-closest-to-the-client .TOC-Heading}

#  {#section-5 .TOC-Heading}

-   # **HDFS Client** is the client used by applications to access the file systems {#hdfs-client-is-the-client-used-by-applications-to-access-the-file-systems .TOC-Heading}

# It is a code library that exports the HDFS file system interface.  {#it-is-a-code-library-that-exports-the-hdfs-file-system-interface. .TOC-Heading}

# Supports operations to read, write and delete files, and operations to create and delete directories.  {#supports-operations-to-read-write-and-delete-files-and-operations-to-create-and-delete-directories. .TOC-Heading}

# The steps followed when an application reads a file {#the-steps-followed-when-an-application-reads-a-file .TOC-Heading}

# Get the list of DataNodes and locations that host the blocks -- this includes the replicas {#get-the-list-of-datanodes-and-locations-that-host-the-blocks-this-includes-the-replicas .TOC-Heading}

# Gets the blocks from the DataNode directly based on the list received from NameNode {#gets-the-blocks-from-the-datanode-directly-based-on-the-list-received-from-namenode .TOC-Heading}

# HDFS provides an API that exposes the locations of file blocks. This allows applications like the MapReduce framework to schedule a task to where the data are located, thus improving the read performance.  {#hdfs-provides-an-api-that-exposes-the-locations-of-file-blocks.-this-allows-applications-like-the-mapreduce-framework-to-schedule-a-task-to-where-the-data-are-located-thus-improving-the-read-performance. .TOC-Heading}

-   # **Block**: is the unit of storage in HDFS. A file is comprised of blocks, and different blocks are stored on different data nodes. {#block-is-the-unit-of-storage-in-hdfs.-a-file-is-comprised-of-blocks-and-different-blocks-are-stored-on-different-data-nodes. .TOC-Heading}

#  {#section-6 .TOC-Heading}

## Considerations

-   # Don't store small, frequently-queried tables in HDFS, especially not if they consist of thousands of files ie tables in HDFS {#dont-store-small-frequently-queried-tables-in-hdfs-especially-not-if-they-consist-of-thousands-of-files-ie-tables-in-hdfs .TOC-Heading}

#  {#section-7 .TOC-Heading}

-   # HDFS symlinks - Jobs requiring file system features like strictly atomic directory renames, fine-grained HDFS permissions, or HDFS symlinks can only work on HDFS {#hdfs-symlinks---jobs-requiring-file-system-features-like-strictly-atomic-directory-renames-fine-grained-hdfs-permissions-or-hdfs-symlinks-can-only-work-on-hdfs .TOC-Heading}

#  {#section-8 .TOC-Heading}

-   # Azure Storage can be geo-replicated. Although geo-replication gives geographic recovery and data redundancy, a failover to the geo-replicated location severely impacts the performance, and it may incur additional costs. The recommendation is to choose the geo-replication wisely and only if the value of the data is worth the additional cost. {#azure-storage-can-be-geo-replicated.-although-geo-replication-gives-geographic-recovery-and-data-redundancy-a-failover-to-the-geo-replicated-location-severely-impacts-the-performance-and-it-may-incur-additional-costs.-the-recommendation-is-to-choose-the-geo-replication-wisely-and-only-if-the-value-of-the-data-is-worth-the-additional-cost. .TOC-Heading}

#  {#section-9 .TOC-Heading}

-   # If the file names have common prefixes , the storage treats them as a single partition and hence if ADF is used , all DMUs write to a single partition. {#if-the-file-names-have-common-prefixes-the-storage-treats-them-as-a-single-partition-and-hence-if-adf-is-used-all-dmus-write-to-a-single-partition. .TOC-Heading}

#  {#section-10 .TOC-Heading}

-   # If Azure Data factory is chosen as an approach for data transfer -- scan through each directory excluding snapshots , check the size of each directory using the hdfs du command. If there are multiple subfolders and large volume of data - initiate multiple copy activities in ADF -- one per subfolder instead of transferring the entire data in a directory in a single copy activity  {#if-azure-data-factory-is-chosen-as-an-approach-for-data-transfer-scan-through-each-directory-excluding-snapshots-check-the-size-of-each-directory-using-the-hdfs-du-command.-if-there-are-multiple-subfolders-and-large-volume-of-data---initiate-multiple-copy-activities-in-adf-one-per-subfolder-instead-of-transferring-the-entire-data-in-a-directory-in-a-single-copy-activity .TOC-Heading}

## 

## 

## 

## Migration Approach

### HDFS Assessment

On premises assessment scripts can be run to plan what workloads can be
migrated to the Azure Storage account/s , priority of migration ie all
data or move in parts . The below decision flow helps decide the
criteria and appropriate scripts can be run to get the data/ metrics.
3^rd^ party tools like Unravel can support in getting the metrics and
support auto assessment of the on premise HDFS . Data Migration planning
can be split based on -- Data Volume , Business Impact , Ownership of
Data , Processing/ETL Jobs complexity , Sensitive Data / PII data ,
based on the date/time data generated. Based on this either entire
workload or parts can be planned to be moved to Azure to avoid
downtimes/business impact. The sensitive data can be chosen to remain on
premise and moving only non PII data to cloud as an approach. All
historical data can be planned to be moved and tested prior to moving
the incremental load.

HDFS commands and reports that can help with getting the key assessment
metrics from HDFS include --

-   **To list all directories in a location**

    -   hdfs dfs -ls books

-   **Recursively list all files in a location**

    -   hdfs dfs -ls -R books

-   **Size of the HDFS File/Directory**

    -   Hadoop fs -du -s -h command

    -   The Hadoop fs -du -s -h command is used to check the size of the
        HDFS file/directory in human readable format. Since the Hadoop
        file system replicates every file, the actual physical size of
        the file will be number of replication with multiply of size of
        the file.

-   **Hdfs-site.xml**

    -   dfs.namenode.acls.enabled : Check if acls.enabled -- helpful to
        plan the access control on Azure storage account

    -   dfs.replication

    -   

> For more information refer -
> <https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml>

3rd party tool Unravel provides assessment reports that can help plan
the migration of data . Some the metrics related to data migration
include --

-   **List of small files -** generates reports that can help assess the
    on premise Hadoop system . The sample below generates a report on
    the small files being generated -- that helps with planning the next
    action on moving to Azure.

-   **List of files based on size** -- generates reports based on the
    data volume and groups into- large, medium , tiny , empty

### Data Transfer

Based on the identified strategy for data migration identify the data
sets to be moved to Azure.

*Pre-checks prior to Transfer*

1.  **Identify all the ingestion points** for the chosen use case to
    migrate to Azure .. Due to security requirements if data cannot be
    landed to the cloud directly then on premise can continue to exist
    in parallel as the intermediary landing zone and pipelines can be
    built in Azure Data Factory to pull the data from on premise systems
    or AZCopy scripts can be scheduled to push the data to Azure storage
    account.

> Common ingestion sources include --

1.  SFTP Server

2.  File Ingestion

3.  Database Ingestion

4.  Database dump

5.  CDC

6.  Streaming Ingestion

```{=html}
<!-- -->
```
2.  **Plan the number of storage accounts needed**

To plan the number of storage accounts needed , understand the total
load on the current hdfs by using the metric TotalLoad that gives the
concurrent file access across all the data nodes. Based on the total
load on premise and the expected growth on Azure , limit needs to be
checked on the storage account in the region. If it is possible to
increase the limit , a single storage account may suffice. However for a
data lake , it is advised to keep a separate storage account per zone
considering the future data volume growth. Other reasons to keep a
separate storage account include -- access control , resiliency
requirements, data replication requirements , exposing the data for
public usage. It is important to understand if an hierarchical namespace
is needed to be enabled on the storage account- as once it has been
enabled cannot revert back to a flat namespace . Workloads like backups
, images etc do not gain any benefit from enabling a hierarchical
namespace.

# Availability Requirements {#availability-requirements .TOC-Heading}

> Hadoop platforms have the replication factor specified in the
> hdfs-site.xml or per file . The replication on ADLS Gen2 can be
> planned based on the nature of the data ie. If an application requires
> the data to be reconstructed in case of a loss then ZRS can be an
> option . In ADLS Gen 2 ZRS -- data is copied synchronously across 3
> AZs in the primary region. For applications that require high
> availability and is not constrained by the region of storage -- the
> data can additionally be copied in a secondary region -- ie. geo
> redundancy .

#  {#section-14 .TOC-Heading}

#  {#section-15 .TOC-Heading}

#  {#section-16 .TOC-Heading}

#  {#section-17 .TOC-Heading}

#  {#section-18 .TOC-Heading}

#  {#section-19 .TOC-Heading}

#  {#section-20 .TOC-Heading}

# Check for corrupted/missing blocks {#check-for-corruptedmissing-blocks .TOC-Heading}

# Check for corrupted/missing blocks by checking the block scanner report -- if any corrupted blocks are found then wait for the data to be restored prior to transferring the file associated with the corrupted blocks.  {#check-for-corruptedmissing-blocks-by-checking-the-block-scanner-report-if-any-corrupted-blocks-are-found-then-wait-for-the-data-to-be-restored-prior-to-transferring-the-file-associated-with-the-corrupted-blocks. .TOC-Heading}

#  {#section-21 .TOC-Heading}

# Check if NFS is enabled {#check-if-nfs-is-enabled .TOC-Heading}

Check if NFS is enabled on the on premise Hadoop platform checking the
core-site.xml file , that holds the property -- nfsserver.groups and
nfsserver.hosts. The NFS3.0 feature is currently in preview in ADLS Gen
2 and a few features aren't yet supported with ADLS Gen2 -

Refer the link -
<https://docs.microsoft.com/en-us/azure/storage/blobs/network-file-system-protocol-support>
for the NFS 3.0 features that aren\'t yet supported with Azure Data Lake
Storage Gen2 .

#  {#section-22 .TOC-Heading}

# Check Hadoop File Formats {#check-hadoop-file-formats .TOC-Heading}

<https://docs.microsoft.com/en-us/azure/storage/common/storage-choose-data-transfer-solution>

Refer Pg 61 - section -- 'MIGRATE DATA TO HDINSIGHT' in the [HDInsight
Migration
Guide](https://gearup.microsoft.com/resources/azure-hdinsight?selectedassetcontainerid=74e4a248-96ee-44a9-a7c1-fc094b70240f)
for the details on the different approaches as below to transfer data to
the Azure Storage Account.

1.  # Azcopy Jobs  {#azcopy-jobs .TOC-Heading}

2.  # Azure Storage Explorer {#azure-storage-explorer .TOC-Heading}

3.  # Azure Powershell {#azure-powershell .TOC-Heading}

4.  # Azure CLI {#azure-cli .TOC-Heading}

5.  # Mount blob container as part of Linux FS with NFS3.0/Blobfuse drivers {#mount-blob-container-as-part-of-linux-fs-with-nfs3.0blobfuse-drivers .TOC-Heading}

6.  # Azure Express Route ( for large data transfers) {#azure-express-route-for-large-data-transfers .TOC-Heading}

7.  # Azure Data Box ( for large data transfers) {#azure-data-box-for-large-data-transfers .TOC-Heading}

# Data extraction and transfer Scripts using the Data Box approach can be referred to at the location - [GitHub - Azure/databox-adls-loader: Tools and scripts to load data from Hadoop clusters to Azure Data Lake Storage using Data Box](https://github.com/Azure/databox-adls-loader) {#data-extraction-and-transfer-scripts-using-the-data-box-approach-can-be-referred-to-at-the-location---github---azuredatabox-adls-loader-tools-and-scripts-to-load-data-from-hadoop-clusters-to-azure-data-lake-storage-using-data-box .TOC-Heading}

8.  # MapReduce Jobs using Hadoop Distcp  {#mapreduce-jobs-using-hadoop-distcp .TOC-Heading}

9.  # Azure Data Factory {#azure-data-factory .TOC-Heading}

10. # 3rd Party solutions like -- WANDISCO Live Data Migration {#rd-party-solutions-like-wandisco-live-data-migration .TOC-Heading}

## Feature Map & Workaround

##  

Core functionality of Hadoop Distributed File System and Azure Data Lake
Storage Gen2 comparison map is as follows -

+----------------------+----------------------+----------------------+
| **Feature**          | **ADLS**             | **HDFS**             |
+======================+======================+======================+
| **Access that is     | Can manage and       | MapR cluster can     |
| compatible with      | access data just as  | access an external   |
| Hadoop**             | you would with a     | HDFS cluster with    |
|                      | Hadoop Distributed   | the hdfs:// or       |
|                      | File System (HDFS).  | webhdfs:// protocols |
|                      | The Azure Blob File  |                      |
|                      | System (ABFS) driver |                      |
|                      | is available within  |                      |
|                      | all Apache Hadoop    |                      |
|                      | environments,        |                      |
|                      | including Azure      |                      |
|                      | HDInsight and Azure  |                      |
|                      | Databricks. Use ABFS |                      |
|                      | to access data       |                      |
|                      | stored in Data Lake  |                      |
|                      | Storage Gen2         |                      |
+----------------------+----------------------+----------------------+
| **POSIX              | The security model   | Jobs requiring file  |
| permissions**        | for Data Lake Gen2   | system features like |
|                      | supports ACL and     | strictly atomic      |
|                      | POSIX permissions    | directory renames,   |
|                      | along with some      | fine-grained HDFS    |
|                      | extra granularity    | permissions, or HDFS |
|                      | specific to Data     | symlinks can only    |
|                      | Lake Storage Gen2.   | work on HDFS         |
|                      | Settings can be      |                      |
|                      | configured through   |                      |
|                      | admin tools or       |                      |
|                      | frameworks like      |                      |
|                      | Apache Hive and      |                      |
|                      | Apache Spark.        |                      |
+----------------------+----------------------+----------------------+
| **Cost               | Data Lake Storage    |                      |
| effectiveness**      | Gen2 offers low-cost |                      |
|                      | storage capacity and |                      |
|                      | transactions. Azure  |                      |
|                      | Blob storage life    |                      |
|                      | cycles help lower    |                      |
|                      | costs by adjusting   |                      |
|                      | billing rates as     |                      |
|                      | data moves through   |                      |
|                      | its life cycle.      |                      |
+----------------------+----------------------+----------------------+
| **Optimized driver** | The ABFS driver is   |                      |
|                      | optimized            |                      |
|                      | specifically for big |                      |
|                      | data analytics. The  |                      |
|                      | corresponding REST   |                      |
|                      | APIs are surfaced    |                      |
|                      | through the          |                      |
|                      | distributed file     |                      |
|                      | system (DFS)         |                      |
|                      | endpoint,            |                      |
|                      | dfs.core.windows.net |                      |
+----------------------+----------------------+----------------------+
| **Metadata**         | Metadata in Azure    | The NameNode is the  |
|                      | can be stored in     | arbitrator and       |
|                      | Azure Purview        | repository for all   |
|                      |                      | HDFS metadata.       |
+----------------------+----------------------+----------------------+
| **Block Size**       | 'Blocks', this is    | HDFS stores the data |
|                      | equivalent to a      | in the form of the   |
|                      | single 'Append' API  | block where the size |
|                      | invocation (the      | of each data block   |
|                      | Append API creates a | is 128MB in size     |
|                      | new block) and is    | which is             |
|                      | limited to 100MB per | configurable means   |
|                      | invocation. However, | you can change it    |
|                      | the write pattern    | according to your    |
|                      | supports calling     | requirement          |
|                      | Append many times    | in                   |
|                      | per file (even in    | *hdfs-site.xml* file |
|                      | parallel) to a       | in your Hadoop       |
|                      | maximum of 50,000    | directory.           |
|                      | and then calling     |                      |
|                      | 'Flush' (equivalent  |                      |
|                      | of PutBlockList).    |                      |
|                      | This is the way the  |                      |
|                      | maximum files size   |                      |
|                      | of 4.75TB is         |                      |
|                      | achieved.            |                      |
+----------------------+----------------------+----------------------+
| **Default ACLS**     | Files do not have    | Files do not have    |
|                      | default ACLs and Not | default ACLs         |
|                      | enabled by default   |                      |
+----------------------+----------------------+----------------------+
| **Binary Files**     | Binary files can be  | Hadoop provides the  |
|                      | moved to Azure Blob  | facility to          |
|                      | Storage . Objects in | read/write binary    |
|                      | Blob storage are     | files. SequenceFile  |
|                      | accessible via the   | is a flat file       |
|                      | Azure Storage REST   | consisting of binary |
|                      | API, Azure           | key/value pairs. The |
|                      | PowerShell, Azure    | SequenceFile         |
|                      | CLI, or an Azure     | provides a Writer,   |
|                      | Storage client       | Reader and Sorter    |
|                      | library. Client      | classes for writing, |
|                      | libraries are        | reading and sorting  |
|                      | available for        | respectively.        |
|                      | different languages, | Convert the          |
|                      | including:           | image/video file     |
|                      |                      | into a SequenceFile  |
|                      | .NET Java Node.js    | and store it into    |
|                      | Python Go PHP Ruby   | the HDFS then the    |
|                      |                      | put command is used. |
|                      |                      | bin/hadoop fs -put   |
|                      |                      | /src_image_file      |
|                      |                      | /dst_image_file or   |
|                      |                      | the HDFS             |
|                      |                      | Seque                |
|                      |                      | nceFileReader/Writer |
|                      |                      | methods              |
+----------------------+----------------------+----------------------+
| **Permission         | ADLS Gen2 uses the   | Permissions for an   |
| inheritance**        | the POSIX-style      | item are stored on   |
|                      | model and follows    | the item itself. In  |
|                      | the same as in       | other words,         |
|                      | Hadoop if ACLs are   | permissions for an   |
|                      | used to control      | item cannot be       |
|                      | access on an object  | inherited from the   |
|                      |                      | parent items if the  |
|                      | Ref : [Access        | permissions are set  |
|                      | control lists in     | after the child item |
|                      | Azure Data Lake      | has already been     |
|                      | Storage Gen2 \|      | created.             |
|                      | Microsoft            |                      |
|                      | Docs](https:         | Permissions are only |
|                      | //docs.microsoft.com | inherited if default |
|                      | /en-us/azure/storage | permissions have     |
|                      | /blobs/data-lake-sto | been set on the      |
|                      | rage-access-control) | parent items before  |
|                      |                      | the child items have |
|                      |                      | been created.        |
+----------------------+----------------------+----------------------+
| **Data Replication** | Data in an Azure     | By default a file's  |
|                      | Storage account is   | replication factor   |
|                      | replicated three     | is three. For        |
|                      | times in the primary | critical files or    |
|                      | region. Zone --      | files which are      |
|                      | redundant storage is | accessed very often, |
|                      | the most recommended | having a higher      |
|                      | replication option   | replication factor   |
|                      | that synchronously   | improves their       |
|                      | replicates across    | tolerance against    |
|                      | three Azure          | faults and increase  |
|                      | availability zones   | their read bandwidth |
|                      | in the primary       |                      |
|                      | region.              |                      |
+----------------------+----------------------+----------------------+
| **Sticky bit**       | In the context of    | The Sticky bit can   |
|                      | Data Lake Storage    | be set on            |
|                      | Gen2, it is unlikely | directories,         |
|                      | that the sticky bit  | preventing anyone    |
|                      | will be needed. In   | except the           |
|                      | summary, if the      | superuser, directory |
|                      | sticky bit is        | owner or file owner  |
|                      | enabled on a         | from deleting or     |
|                      | directory, a child   | moving the files     |
|                      | item can only be     | within the           |
|                      | deleted or renamed   | directory.           |
|                      | by the child item\'s |                      |
|                      | owning user.         | Setting the sticky   |
|                      |                      | bit for a file has   |
|                      | The sticky bit       | no effect.           |
|                      | isn\'t shown in the  |                      |
|                      | Azure portal.        |                      |
+----------------------+----------------------+----------------------+

### 

## Reference Implementation - ARM Templates 

TBD v2

## Pseudocode

TBD v2

## Architectural Guidance

TBD v2

### Patterns & Anti -- Patterns

### Performance Tuning

# HBase 

## Challenges of HBase on premise

Common challenges associated with Hbase deployments:

-   # Scalability  {#scalability .TOC-Heading}

-   # Ageing infrastructure {#ageing-infrastructure .TOC-Heading}

-   # Capacity {#capacity .TOC-Heading}

-   # Hard to achieve HA-DR due to either capacity issues and/or lack of data-centre sites. {#hard-to-achieve-ha-dr-due-to-either-capacity-issues-andor-lack-of-data-centre-sites. .TOC-Heading}

-   # Lack of native tools that enable: {#lack-of-native-tools-that-enable .TOC-Heading}

    -   # Cost transparency {#cost-transparency .TOC-Heading}

    -   # Monitoring {#monitoring .TOC-Heading}

    -   # DevOps {#devops .TOC-Heading}

    -   # Automations {#automations .TOC-Heading}

## HBase Architecture and Components

### Brief introduction to Apache Hbase

Apache Hbase is a Java-based, NoSQL column-store, distributed
application that is built on top of Apache Hadoop Distributed Filesystem
(HDFS). It is modelled after Google BigTable paper and brings most of
the BigTable capabilities to Hadoop ecosystem.

In terms of workload profile, it is designed to serve as a datastore for
data-intensive applications that require low-latency and near real-time
random reads and writes.

It is a distributed system and from CAP theorem perspective, Hbase is
designed for Consistency and Partitioning.

We will discuss components and principles that will play a role in
planning and building of a Hbase cluster on Azure especially while
migrating to Azure HDI Hbase or Hbase on Azure virtual machines. These
concepts will also play role when it comes to re-platforming Hbase to
Cosmos DB migration.

Hbase is a distributed system, and it follows a leader-follower model. A
typical Hbase deployment consists of nodes with following roles.

#### Head nodes or Master nodes

The master server is responsible for all metadata operations for an
Hbase cluster. This includes but not limited to creation/deletion of
objects; monitoring RegionServers etc. There are usually two Master
servers deployed for high availability (HA).

#### ZooKeeper nodes 

ZooKeeper (ZK) nodes are required for coordination in a distributed
application environment such as Hbase.

#### Region Servers

RegionServers are responsible for serving and managing Regions (or
partitions). This is where bulk of the processing happens when a client
read/write request comes in. In a distributed deployment of Hbase
RegionServer runs on a Hadoop Data Node.

### Core Concepts

It is important to understand the core concepts of Hbase architecture
and data model as they will play a role in optimizing performance of a
given Hbase deployment.

#### Data Model

##### Namespace

Logical grouping of tables. It is like a database within relational
world. It is a key-enabler for several features related to
multi-tenancy.

##### Tables

Hbase tables are a grouping or collection of multiple rows. Tables are
stored in Regions (or partitions) spread across Region Servers.

##### Row

A row consists of a row key and a grouping of columns called column
family. The rows are sorted and stored based on the row key.

##### Column Family

Columns in Hbase are grouped into column families. All columns in a
column have the same prefix.

##### Cells 

A {row, column, version} tuple represent a cell.

##### Data model operations

There are 4 types of data model operations:

-   Get -- returns attributes for a specified row.

-   Put -- either adds new rows to the table or updates existing rows.

-   Scans -- allows iteration over multiple rows for specified
    attributes.

-   Delete -- removes a row from the table. A marker (called tombstone)
    is placed on record mark for deletion. These are then removed during
    major compactions.

![Diagram Description automatically
generated](C:\docs\images\media\image13.png){width="6.395833333333333in"
height="3.906516841644794in"}

##### Write Path

Hbase uses a combination of data structures that reside in-memory and
persistent storage to deliver fast writes.

When a write happens, data first gets written to a Write-Ahead Log
(WAL), which is a data structure stored on persistent storage. Role of
WAL is to track changes so that logs can be replayed in case there's a
server failure. WAL is purely for resiliency purposes.

Once data is committed to WAL, data gets written to MemStore, which is
an in-memory data structure. At this stage, a write is completed.

For long-term data persistence, Hbase uses a data structure called Hbase
file (Hfile). Hfile is stored on HDFS. Depending on MemStore size and
data flush interval, data from MemStore is written to Hbase file (or
Hfile).

*//insert diagram for Hbase write path*

To summarise, the components on the write-path are:

-   Write Ahead Log (WAL) is a data structure that is stored on
    persistent storage.

-   MemStore -- in-memory data structure. It's an on-heap data
    structure.

-   Hfile -- Hbase file used for data persistence and stored on HDFS.

##### Read Path

To deliver fast random and sequential reads, Hbase uses several data
structures. When a read request is sent to Hbase, it tries to serve the
read request through data cached in BlockCache and failing that, from
MemStore. Both are stored on-heap. If the data is not available in
cache, then the data is fetched from HFile and caches the data in
BlockCache.

For scenarios where you want low latency on reads, there is an option to
persist data in BucketCache which is also an in-memory data structure,
but it's hosted off-heap.

//insert diagram for Hbase read path

To summarise:

-   Hbase tries to serve a read request using data stored in cache --
    BlockCache and MemStore.

-   If data is not there, a read request is served using HFile.

##### Offheap Read and Write paths

To reduce latencies, Hbase 2.x has introduced a pool of offheap buffers
that are used along read and write paths. The workflow for writing and
reading data does its best to avoid on-heap memory allocations reducing
the amount of work that Garbage Collection (GC) must do to complete
reads and writes.

## Considerations

-   Azure Enterprise Scale Landing Zone (ESLZ) principles with special
    attention to using Subscription as a unit of scale.

-   Well-Architected Framework.

-   Azure compute and storage throughput limits and the role they play
    in sizing and scalability.

-   Apache Hbase and leveraging different Azure Storage options to
    balance performance and costs.

## Migration Approach

Azure has several landing targets for Apache Hbase. Depending on
requirements and product features, customers can choose between Azure
IaaS, HDI Hbase or Cosmos DB (SQL API).

### Lift and shift -- Azure IaaS

##### Planning and Sizing

The list below contains a set of questions that drive critical decision
points related to migration such as:

-   Sizing

-   Capacity planning and growth

-   Security

-   Administration

-   Monitoring

-   Dependencies on specific version of application(s)

-   Target SLA, RTO and RPO

The list is applicable to following migration scenarios:

-   On-premises Hbase migration to Azure IaaS or PaaS

-   Hbase migrations from 3P cloud to Azure IaaS or PaaS

-   Migrations from Azure IaaS to Azure PaaS (HDI Hbase or Cosmos DB).

#  {#section-25 .TOC-Heading}

+----------------------+----------------------+----------------------+
| Layer                | Questions            | Comments             |
+======================+======================+======================+
| Infrastructure       | Number of servers    |                      |
|                      | for each type of     |                      |
|                      | role:                |                      |
|                      |                      |                      |
|                      | Hbase master nodes   |                      |
|                      |                      |                      |
|                      | Hbase RegionServers  |                      |
|                      |                      |                      |
|                      | ZooKeeper            |                      |
+----------------------+----------------------+----------------------+
|                      | No. of CPUs and      | Following commands   |
|                      | cores per server     | can be used on Linux |
|                      |                      | to extract list of   |
|                      |                      | CPUs.                |
|                      |                      |                      |
|                      |                      | **lscpu**            |
|                      |                      |                      |
|                      |                      | **cat                |
|                      |                      | /proc/cpuinfo**      |
+----------------------+----------------------+----------------------+
|                      | Memory per server    | Following commands   |
|                      |                      | can be used on Linux |
|                      |                      | to extract memory    |
|                      |                      | specs for each       |
|                      |                      | individual server.   |
|                      |                      |                      |
|                      |                      | **free -mg**         |
|                      |                      |                      |
|                      |                      | **cat                |
|                      |                      | /proc/meminfo**      |
+----------------------+----------------------+----------------------+
|                      | Virtualized or       | Hbase infrastructure |
|                      | non-virtualized      | deployed on          |
|                      |                      | bare-metal or        |
|                      |                      | virtualized          |
|                      |                      | infrastructure?      |
|                      |                      |                      |
|                      |                      | Running Hbase (or    |
|                      |                      | any application) in  |
|                      |                      | a virtualized        |
|                      |                      | environment means    |
|                      |                      | that a subset of     |
|                      |                      | resources is devoted |
|                      |                      | to running/managing  |
|                      |                      | a layer of           |
|                      |                      | virtualization.      |
|                      |                      | Knowing about this   |
|                      |                      | will help a planner  |
|                      |                      | understand if        |
|                      |                      | additional resources |
|                      |                      | must be factored-in  |
|                      |                      | during migration to  |
|                      |                      | cloud.               |
+----------------------+----------------------+----------------------+
|                      | Network              | Hbase is a           |
|                      |                      | distributed          |
|                      |                      | application, and it  |
|                      |                      | relies on network    |
|                      |                      | heavily. Intent of   |
|                      |                      | asking this question |
|                      |                      | is to understand     |
|                      |                      | network topology and |
|                      |                      | how Hbase servers    |
|                      |                      | exchange traffic.    |
|                      |                      |                      |
|                      |                      | Understand the       |
|                      |                      | network bandwidth    |
|                      |                      | each VM can support; |
|                      |                      | and if any special   |
|                      |                      | NIC configuration is |
|                      |                      | used to support high |
|                      |                      | bandwidth between    |
|                      |                      | Hbase servers?       |
|                      |                      |                      |
|                      |                      | \#to list all the    |
|                      |                      | interfaces           |
|                      |                      |                      |
|                      |                      | **ifconfig -a**      |
|                      |                      |                      |
|                      |                      | \#to list standard   |
|                      |                      | information about a  |
|                      |                      | network device       |
|                      |                      | including bonding    |
|                      |                      | information and      |
|                      |                      | speed.               |
|                      |                      |                      |
|                      |                      | **ethtool \<name of  |
|                      |                      | the interface\>**    |
+----------------------+----------------------+----------------------+
|                      | Storage              | What is total size   |
|                      |                      | of data after        |
|                      |                      | replication?         |
|                      |                      |                      |
|                      |                      | Since Hbase stores   |
|                      |                      | Hfiles on HDFS, one  |
|                      |                      | can use the          |
|                      |                      | following command to |
|                      |                      | extract the total    |
|                      |                      | size of Hbase        |
|                      |                      | deployment. The size |
|                      |                      | reported includes    |
|                      |                      | replication.         |
|                      |                      |                      |
|                      |                      | hdfs dfs -du -h      |
|                      |                      | hdfs://\<datanode    |
|                      |                      | address\>/hbase      |
|                      |                      |                      |
|                      |                      | What type of storage |
|                      |                      | is used? SSD or a    |
|                      |                      | high-performance     |
|                      |                      | storage array?       |
|                      |                      |                      |
|                      |                      | **IOPS** during peak |
|                      |                      | and normal periods?  |
|                      |                      |                      |
|                      |                      | **Throughput**       |
|                      |                      | during peak and      |
|                      |                      | normal periods       |
|                      |                      |                      |
|                      |                      | Size of IOPS can be  |
|                      |                      | calculated if IOPS   |
|                      |                      | and throughput data  |
|                      |                      | is available. Your   |
|                      |                      | infrastructure admin |
|                      |                      | or storage admin     |
|                      |                      | should be able to    |
|                      |                      | provide these stats. |
|                      |                      |                      |
|                      |                      | Example - This       |
|                      |                      | information can be   |
|                      |                      | captured from Linux  |
|                      |                      | command line tools   |
|                      |                      | like **sar** (if     |
|                      |                      | it's enabled). We    |
|                      |                      | recommend that you   |
|                      |                      | run this command on  |
|                      |                      | a RegionServer. If   |
|                      |                      | Regions are          |
|                      |                      | distributed          |
|                      |                      | uniformly, then all  |
|                      |                      | RegionServers should |
|                      |                      | have [similar]{.ul}  |
|                      |                      | peak and average     |
|                      |                      | IOPS and             |
|                      |                      | throughputs.         |
|                      |                      |                      |
|                      |                      | sar -b               |
+----------------------+----------------------+----------------------+
| Operating System     | Version and distro   | Use uname command to |
|                      | type                 | print system         |
|                      |                      | information          |
|                      |                      | including Linux      |
|                      |                      | kernel and OS        |
|                      |                      | version.             |
|                      |                      |                      |
|                      |                      | uname -a             |
+----------------------+----------------------+----------------------+
|                      | Kernel parameters    | The values set for   |
|                      |                      | kernel parameters    |
|                      |                      | has an implication   |
|                      |                      | on the performance   |
|                      |                      | and stability of a   |
|                      |                      | server. Hence, we do |
|                      |                      | not recommend        |
|                      |                      | changing default     |
|                      |                      | parameters           |
|                      |                      | straightaway unless  |
|                      |                      | it has been          |
|                      |                      | recommended by your  |
|                      |                      | OS and/or            |
|                      |                      | application vendor.  |
|                      |                      | In most cases,       |
|                      |                      | customers tweak      |
|                      |                      | these parameters to  |
|                      |                      | suit workload        |
|                      |                      | requirements.        |
|                      |                      |                      |
|                      |                      | **\# Linux memory    |
|                      |                      | and block device     |
|                      |                      | parameters**         |
|                      |                      |                      |
|                      |                      | cat                  |
|                      |                      | /sy                  |
|                      |                      | s/kernel/mm/transpar |
|                      |                      | ent_hugepage/enabled |
|                      |                      |                      |
|                      |                      | cat                  |
|                      |                      | /s                   |
|                      |                      | ys/kernel/mm/transpa |
|                      |                      | rent_hugepage/defrag |
|                      |                      |                      |
|                      |                      | cat                  |
|                      |                      | /sys/block           |
|                      |                      | /sda/queue/scheduler |
|                      |                      |                      |
|                      |                      | cat                  |
|                      |                      | /sys/class/block/    |
|                      |                      | sda/queue/rotational |
|                      |                      |                      |
|                      |                      | cat                  |
|                      |                      | /sys/class/block/sda |
|                      |                      | /queue/read_ahead_kb |
|                      |                      |                      |
|                      |                      | cat                  |
|                      |                      | /proc/sys/           |
|                      |                      | vm/zone_reclaim_mode |
|                      |                      |                      |
|                      |                      | **\# Linux network   |
|                      |                      | stack**              |
|                      |                      |                      |
|                      |                      | sudo sysctl -a \|    |
|                      |                      | grep -i              |
|                      |                      | \"net.cor            |
|                      |                      | e.rmem_max\\\|net.co |
|                      |                      | re.wmem_max\\\|net.c |
|                      |                      | ore.rmem_default\\\| |
|                      |                      |                      |
|                      |                      | net.core.            |
|                      |                      | wmem_default\\\|net. |
|                      |                      | core.optmem_max\\\|n |
|                      |                      | et.ipv4.tcp_rmem\\\| |
|                      |                      |                      |
|                      |                      | net.ipv4.tcp_wmem\"  |
+----------------------+----------------------+----------------------+
| Application          | What version of      | There are a few      |
|                      | Hbase and other      | popular versions of  |
|                      | components are in    | Hbase that customers |
|                      | use?                 | use:                 |
|                      |                      |                      |
|                      | Is it part of a      | -   Open-source      |
|                      | commercially         |     Hbase            |
|                      | supported distro?    |                      |
|                      |                      | -   Hortonworks      |
|                      |                      |                      |
|                      |                      | -   Cloudera         |
|                      |                      |                      |
|                      |                      | To find out Hbase    |
|                      |                      | version, run the     |
|                      |                      | following command on |
|                      |                      | one of the servers   |
|                      |                      | where Hbase is       |
|                      |                      | deployed.            |
|                      |                      |                      |
|                      |                      | hbase version        |
+----------------------+----------------------+----------------------+
|                      | Hbase specific       | The following pieces |
|                      | information          | of information can   |
|                      |                      | be extracted from    |
|                      |                      | Ambari UI.           |
|                      |                      |                      |
|                      |                      | Number of tables?    |
|                      |                      |                      |
|                      |                      | Number of            |
|                      |                      | RegionServer?        |
|                      |                      |                      |
|                      |                      | Number of Regions    |
|                      |                      | per RegionServer?    |
|                      |                      |                      |
|                      |                      | From Hbase shell     |
|                      |                      |                      |
|                      |                      | scan \'hbase:meta\', |
|                      |                      | {F                   |
|                      |                      | ILTER=\>\"PrefixFilt |
|                      |                      | er(\'tableName\')\", |
|                      |                      | COLUMNS=\>\[\'       |
|                      |                      | info:regioninfo\'\]} |
|                      |                      |                      |
|                      |                      | For Hbase shell      |
|                      |                      | version 1.4+         |
|                      |                      |                      |
|                      |                      | list_regions         |
|                      |                      | \'foobar1.TEST1\'    |
+----------------------+----------------------+----------------------+
|                      | Java version         | Use the following    |
|                      |                      | command to find out  |
|                      |                      | which version of     |
|                      |                      | Java is deployed.    |
|                      |                      |                      |
|                      |                      | java -version        |
+----------------------+----------------------+----------------------+
|                      | Hbase GC             | What GC is used for  |
|                      | configuration        | Hbase deployment?    |
|                      |                      |                      |
|                      |                      | HDI currently uses   |
|                      |                      | CMS and there are    |
|                      |                      | discussions to       |
|                      |                      | migrate to G1GC in   |
|                      |                      | future (timelines    |
|                      |                      | are not available).  |
|                      |                      |                      |
|                      |                      | On Azure IaaS,       |
|                      |                      | customers are free   |
|                      |                      | to choose which Java |
|                      |                      | version and GC type  |
|                      |                      | they want to use.    |
+----------------------+----------------------+----------------------+
| Security and         | Accessing Hbase      | How do users access  |
| administration       |                      | the data in Hbase?   |
|                      |                      | Is it via APIs or    |
|                      |                      | directly via Hbase   |
|                      |                      | shell?               |
|                      |                      |                      |
|                      |                      | How applications     |
|                      |                      | consume data?        |
|                      |                      |                      |
|                      |                      | How is data written  |
|                      |                      | to Hbase and         |
|                      |                      | proximity of these   |
|                      |                      | systems? Are they    |
|                      |                      | within the same data |
|                      |                      | centre or located    |
|                      |                      | outside of DC where  |
|                      |                      | Hbase is deployed?   |
+----------------------+----------------------+----------------------+
|                      | User-provisioning    | How are users        |
|                      |                      | authenticated and    |
|                      |                      | authorized?          |
|                      |                      |                      |
|                      |                      | -   Ranger?          |
|                      |                      |                      |
|                      |                      | -   Knox?            |
|                      |                      |                      |
|                      |                      | -   Kerberos?        |
+----------------------+----------------------+----------------------+
|                      | Encryption           | Is there a           |
|                      |                      | requirement to have  |
|                      |                      | data encrypted in    |
|                      |                      | transport and/or     |
|                      |                      | at-rest? What        |
|                      |                      | encryption solutions |
|                      |                      | are currently        |
|                      |                      | in-use?              |
+----------------------+----------------------+----------------------+
|                      | Tokenization         | Is there a           |
|                      |                      | requirement to       |
|                      |                      | tokenize data? If    |
|                      |                      | yes, how is data     |
|                      |                      | tokenized? Popular   |
|                      |                      | applications used    |
|                      |                      | for tokenization     |
|                      |                      | include (but not     |
|                      |                      | limited to)          |
|                      |                      | Protegrity;          |
|                      |                      | Vormetric etc.       |
+----------------------+----------------------+----------------------+
|                      | Compliance           | Are there any        |
|                      |                      | special regulatory   |
|                      |                      | requirements         |
|                      |                      | applicable to Hbase  |
|                      |                      | workloads? For       |
|                      |                      | example -- PCI-DSS;  |
|                      |                      | HIPAA etc.           |
+----------------------+----------------------+----------------------+
|                      | Keys, certificates,  | If applicable,       |
|                      | and secrets          | please describe and  |
|                      | management policies. | what                 |
|                      |                      | tools/applications   |
|                      |                      | are used for this    |
|                      |                      | function.            |
+----------------------+----------------------+----------------------+
| High-Availability    | What is the SLA, RPO | This will drive      |
| and Disaster         | and RTO of the       | decision on the      |
| Recovery             | source Hbase         | landing target on    |
|                      | deployment?          | Azure and whether to |
|                      |                      | have a hot-standby   |
|                      |                      | OR active-active     |
|                      |                      | regional deployment  |
|                      |                      | on Azure.            |
+----------------------+----------------------+----------------------+
|                      | BC and DR strategy   | Is there one in      |
|                      | for Hbase workloads. | place? Please        |
|                      |                      | describe.            |
+----------------------+----------------------+----------------------+
| Data                 | Growth               | How much data will   |
|                      |                      | be migrated to Hbase |
|                      |                      | on Azure at go-live? |
|                      |                      |                      |
|                      |                      | How much growth is   |
|                      |                      | expected in 6-12     |
|                      |                      | months' time?        |
+----------------------+----------------------+----------------------+
|                      | Ingestion            | What tools are used  |
|                      |                      | to write data to     |
|                      |                      | Hbase?               |
+----------------------+----------------------+----------------------+
|                      | Consumption          |                      |
+----------------------+----------------------+----------------------+
|                      | Access pattern       | Is Hbase deployment  |
|                      |                      | read-heavy or        |
|                      |                      | write-heavy?         |
|                      |                      |                      |
|                      |                      | This has an          |
|                      |                      | implication on the   |
|                      |                      | sizing of servers.   |
+----------------------+----------------------+----------------------+

There are several 3P solutions as well that can assist with assessment.
[Unravel](https://unraveldata.com/) is one such partner that offers
solutions that can help customers fast-track assessment for data
migrations to Azure.

####### Azure compute

Taking from Cloud Adoption Framework enterprise-scale design principles,
we use **subscription** as a unit of management and scale aligned with
business needs and priorities to support business areas and portfolio
owners to accelerate application migrations and new application
development. Subscriptions should be provided to business units to
support the design, development, and testing of new workloads and
migration of workloads.

In context of Apache Hbase, we recommend having a separate subscription
as it will allow a deployment to scale in terms of compute and storage.
Azure scale-limits are published
[here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)
and should be considered when planning Hbase deployment on Azure VMs and
storage.

Azure Virtual Machines (VM) families are optimized to suit different
use-cases and provide a balance of compute (vCores) and memory.

  **Type**                                                                                     **Sizes**      **Description**
  -------------------------------------------------------------------------------------------- -------------- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  [Entry-level](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general)         A, Av2         Have CPU performance and memory configurations best suited for entry level workloads like development and test. They are economical and provide a low-cost option to get started with Azure.
  [General purpose](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general)     D, DSv2, Dv2   Balanced CPU-to-memory ratio. Ideal for testing and development, small to medium databases, and low to medium traffic web servers.
  [Compute optimized](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-compute)   F              High CPU-to-memory ratio. Good for medium traffic web servers, network appliances, batch processes, and application servers.
  [Memory optimized](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-memory)     Esv3, Ev3      High memory-to-CPU ratio. Great for relational database servers, medium to large caches, and in-memory analytics.

In terms of nature of resource footprint, Apache Hbase is designed to
leverage memory and premium storage (such as SSDs).

-   Hbase ships with features like BucketCache which can significantly
    improve read performance. BucketCache is stored off-heap. Hence, we
    recommend VMs that have higher memory to CPU ratio.

-   Hbase write path includes writing changes to a write-ahead log (WAL)
    which is a data structure persisted on a storage medium. Storing WAL
    on fast storage medium such as SSDs will improve write performance.

-   Hbase is designed to scale out.

Scalability targets of Azure compute
[Ds-series](https://docs.microsoft.com/en-us/azure/virtual-machines/dv2-dsv2-series-memory)
and
[Es-series](https://docs.microsoft.com/en-us/azure/virtual-machines/ev3-esv3-series)
along with [premium SSD (managed
disks)](https://docs.microsoft.com/en-us/azure/virtual-machines/disks-types#premium-ssd)
are available on Microsoft Docs and these must be considered during
sizing and planning.

From compute and memory perspective, we recommend using the following
Azure compute family types for various Hbase node types:

-   **Hbase Master** -- For enterprise deployments, we recommend at
    least 2 x Master (from HA perspective). For a large Hbase cluster, a
    DS5_v2 Azure VM with 16 vCPUs and 56 GiB memory should suffice most
    deployments. For medium-sized clusters, recommendation is to have at
    least 8 vCPU and 20-30GB memory.

-   **HDFS NameNode** -- We recommend hosting NameNode on separate set
    of virtual machines and not to co-locate with Hbase Master. From HA
    perspective, 2 x NameNodes should be deployed. Like Hbase Master,
    Azure VM DS5_v2 is recommended for large production-grade clusters.

-   **Hbase Region Server** -- We recommend using Azure VMs with high
    memory to vCPU ratio. Hbase has several features that can leverage
    memory for improving reads and writes. Azure VMs like DS14_v2 or
    DS15_v2 will be a good starting point. Hbase is designed for
    scale-out and more Region Servers can be added to improve
    performance.

-   **ZooKeeper (ZK) nodes** -- Hbase relies on ZK for operations. An
    Azure VM with 4-8 vCPU; 4-8 GB memory is a good starting point.
    Ensure that there is local storage available. ZK nodes should be
    deployed on a separate set of VMs.

#######  Azure Storage

For an Azure IaaS-based Hbase deployment, Azure offers several storage
options. The following flowchart uses features of various options to
land on a storage target. Each storage option on Azure has a different
performance, availability, and cost targets.

There are **two key factors** that influence of sizing of Hbase storage
-- volume and throughput.

-   Volume of data.

> This is the data that must be persisted on Hbase. The data gets
> persisted to underlying storage and when we refer to volume of data,
> for sizing and planning purposes, volume includes raw data + 3x
> replication. Total storage size is the metric that we use to drive
> volume.

-   Throughput of reads and writes.

> This is how fast one wants Hbase to service writes and reads. IOPS and
> throughput are the two metrics that drive this.

Volume of raw data to be stored in Hbase. For each byte of data stored
on disk, there's an overhead on Hbase Java heap side. Hence, raw storage
(Premium SSD) and memory available per Region Server must be balanced.

The correlation between storage and memory per Region Server can be
worked out using the formula:

regions.hbase.hregion.max.filesize /\
hbase.hregion.memstore.flush.size \*\
dfs.replication \*\
hbase.regionserver.global.memstore.lowerLimit

####### Sizing Azure IaaS deployment

If you are planning a **brand-new deployment of Hbase on Azure IaaS**,
our recommendation is to go with the following sizing and then add
RegionServers as the volume of data or demand for higher read/write
throughput grows. Azure compute belonging to Ds or Es series are well
suited for Hbase RegionServer roles. For Hbase Master and ZooKeeper
nodes, we recommend using smaller Ds-series VMs. See **Azure compute**
for guidance on compute size suitable for workloads.

If you are **migrating an existing workload from on-premises or a 3P
cloud**, we recommend the following approach where the existing Hbase
deployment serves as a guide and inputs from **On-premises Assessment**
will play a pivotal role in sizing deployment on Azure IaaS. The output
of on-premises assessment should give a fairly accurate view of scale of
infrastructure required on Azure.

For more sizing accuracy and establishing a performance baseline, we
recommend customers to run tests on Azure IaaS using Hbase dataset,
model, and workload pattern. If moving data is not possible, we
recommend using benchmarking tools such as **YCSB** to generate
synthetic data and simulate sequential and random I/O traffic. The
intent of this exercise is to help customers gain an understanding of
level of performance one can expect using a combination of Azure compute
and premium storage. It's worth calling out that the tests should
include day-to-day workload pattern and special cases like any workloads
which may cause a spike in resource usage such as month-end or year-end
activities. For example, a retailer using Hbase will observe spike in
resource usage around holiday periods whereas a financial services
customer will observe spikes around key financial periods.

Inputs from assessment and performance baseline should give customers a
fairly accurate view of sizing on Azure IaaS. Due to the nature of the
workloads, there will be room to optimize operations by scaling-out or
scaling-in clusters post go-live. We recommend customers should
familiarise themselves with various [Cost
Optimization](https://docs.microsoft.com/en-us/azure/architecture/framework/cost/overview)
levers available to them to optimize costs and operations.

//insert a summary table here for guidance on compute and storage sizing
for brand new and existing deployments

######## Further reading

-   Architecting Hbase applications by Jean-Marc Spaggiari; Kevin
    O\'Dell. Published by O\'Reilly Media, Inc., 2016

-   [CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem)

-   [Apache Hbase
    master](https://hbase.apache.org/book.html#architecture.master)

-   [Apache ZooKeeper](https://zookeeper.apache.org/)

-   [Apache Hbase
    RegionServer](https://hbase.apache.org/book.html#regionserver.arch)

-   Apache Hbase RegionServer [Offheap Read/Write
    path](https://hbase.apache.org/book.html#offheap_read_write).

-   General guidance and best practices on designing [table
    schemas](https://hbase.apache.org/book.html#table_schema_rules_of_thumb).

-   

#### Data migration

Note - Apache Hbase persists data in a file called HFile which are
stored on HDFS. From migration perspective, it's not recommended to
directly copy HFiles between two Hbase clusters.

+----------------+----------------+----------------+----------------+
| Sour           | Tool to read   | Tool to write  | Considerations |
| ce(s)/scenario | from source    | to target      |                |
|                | datastore      | Hbase          |                |
+================+================+================+================+
| **Bulk load    | Extract data   | Use Bulk Load  | Separate       |
| scenarios**    | and write to   | utility to     | infrastructure |
| where source   | HDFS.          | read data from | required to    |
| data is not in |                | HDFS and write | host migration |
| Hbase.         | WANdisco       | directly to    | tool/runtime.  |
|                |                | Hbase HFile.   |                |
| MongoDB        | *OR*           |                | Handling       |
|                |                | *OR*           | encryption and |
| Cassandra      | Azure HDI      |                | tokenisation   |
|                | Spark or Azure | Azure HDI      | requirements   |
| PostgreSQL     | Databricks.    | Spark or Azure | during data    |
|                |                | Databricks     | migration.     |
|                |                |                |                |
|                |                |                | Keeping data   |
|                |                |                | source and     |
|                |                |                | target (Hbase) |
|                |                |                | in-sync during |
|                |                |                | migration and  |
|                |                |                | then planning  |
|                |                |                | for final      |
|                |                |                | cut-over.      |
|                |                |                |                |
|                |                |                | Network        |
|                |                |                | latency        |
|                |                |                | between source |
|                |                |                | and target.    |
+----------------+----------------+----------------+----------------+
| Source is an   | **Hbase        | **CopyTable**  | Same as above  |
| Hbase          | CopyTable**    | can read from  | plus a few     |
| datastore BUT  |                | Hbase source   | related to     |
| different      | *OR*           | and write to   | specific tool  |
| version.       |                | Hbase target.  | used for       |
|                | **Azure HDI    | No additional  | migration.     |
|                | Spark or Azure | tool required. |                |
|                | Databricks.**  |                | **Hbase        |
|                |                | *OR*           | CopyTable**    |
|                | *OR*           |                |                |
|                |                | **Azure HDI    | Hbase version  |
|                | **Hbase Export | Spark or Azure | on source and  |
|                | utility**      | Databricks**   | target sides.  |
|                |                |                |                |
|                |                | *OR*           | Clusters       |
|                |                |                | should be      |
|                |                | **Hbase Import | online, and    |
|                |                | utility**      | table must be  |
|                |                |                | present on the |
|                |                | *OR*           | target side.   |
|                |                |                |                |
|                |                | **Hbase        | Additional     |
|                |                | HashTab        | resources      |
|                |                | le/SyncTable** | required on    |
|                |                |                | source side to |
|                |                |                | support        |
|                |                |                | additional     |
|                |                |                | read traffic   |
|                |                |                | on the source  |
|                |                |                | Hbase          |
|                |                |                | instance.      |
|                |                |                |                |
|                |                |                | CopyTable      |
|                |                |                | supports full  |
|                |                |                | and delta      |
|                |                |                | table copy.    |
|                |                |                | However, it    |
|                |                |                | must be        |
|                |                |                | considered for |
|                |                |                | migration.     |
|                |                |                |                |
|                |                |                | By default, it |
|                |                |                | only copies    |
|                |                |                | the latest     |
|                |                |                | version of a   |
|                |                |                | row cell. It   |
|                |                |                | also copies    |
|                |                |                | all Cells      |
|                |                |                | between a      |
|                |                |                | specified time |
|                |                |                | range.         |
|                |                |                |                |
|                |                |                | There might be |
|                |                |                | changes        |
|                |                |                | happening on   |
|                |                |                | source Hbase   |
|                |                |                | while          |
|                |                |                | CopyTable is   |
|                |                |                | running, in    |
|                |                |                | such a         |
|                |                |                | scenario, new  |
|                |                |                | changes will   |
|                |                |                | either be      |
|                |                |                | completed      |
|                |                |                | included or    |
|                |                |                | excluded.      |
|                |                |                |                |
|                |                |                | **Azure HDI    |
|                |                |                | Spark or Azure |
|                |                |                | Databrick**    |
|                |                |                | require        |
|                |                |                | addit          |
|                |                |                | ional/separate |
|                |                |                | cluster for    |
|                |                |                | migrating data |
|                |                |                | however it's a |
|                |                |                | tried/tested   |
|                |                |                | approach.      |
|                |                |                |                |
|                |                |                | **Hbase Export |
|                |                |                | utility**      |
|                |                |                |                |
|                |                |                | By default,    |
|                |                |                | latest version |
|                |                |                | of a Cell is   |
|                |                |                | copied across. |
|                |                |                |                |
|                |                |                | **HashTab      |
|                |                |                | le/SyncTable** |
|                |                |                |                |
|                |                |                | This is more   |
|                |                |                | efficient      |
|                |                |                | compared to    |
|                |                |                | CopyTable.     |
+----------------+----------------+----------------+----------------+
| Source is an   | All the        | **Ex           | Same           |
| Hbase          | options stated | portSnapshot** | considerations |
| datastore of   | above.         | tool should be | as stated      |
| **same**       |                | used to copy   | above and      |
| version.       | \+             | snapshots to   | certain that   |
|                |                | target cluster | are related to |
|                | **Hbase**      | HDFS.          | Hbase          |
|                | **Snapshots**. |                | Snapshots.     |
|                |                |                |                |
|                |                |                | Snapshot       |
|                |                |                | doesn't create |
|                |                |                | copy of data   |
|                |                |                | however it     |
|                |                |                | does create a  |
|                |                |                | reference back |
|                |                |                | to HFiles. The |
|                |                |                | referenced     |
|                |                |                | HFiles are     |
|                |                |                | archived       |
|                |                |                | separately in  |
|                |                |                | case           |
|                |                |                | compaction is  |
|                |                |                | triggered on   |
|                |                |                | parent table   |
|                |                |                | which is       |
|                |                |                | referenced in  |
|                |                |                | a snapshot.    |
|                |                |                |                |
|                |                |                | Footprint on   |
|                |                |                | source and     |
|                |                |                | target Hbase   |
|                |                |                | when a         |
|                |                |                | snapshot       |
|                |                |                | restore is     |
|                |                |                | triggered.     |
+----------------+----------------+----------------+----------------+

Migrating Apache Hbase to Azure Cosmos DB (SQL API)

Azure Cosmos DB is a scalable, globally distributed, fully managed
database. It provides guaranteed low latency access to your data. To
learn more about Azure Cosmos DB, see the
[overview](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)
article. This section provides guide to migrate from HBase to Cosmos DB.

### Modernization -- Cosmos DB (SQL API)

Before migrating, you need to understand the difference between Cosmos
DB and HBase.

#### Cosmos DB resource model

The resource model of Cosmos DB is as follows.

See ["Overview of Apache HBase and Architecture"](#_Overview_of_Apache)
section for the HBase resource model.

#### Resource mapping

The key differences between the Cosmos DB and HBase / Phoenix resource
and data models are shown in the table below.

  **HBase**             **Phoenix**            **Cosmos DB**
  --------------------- ---------------------- -----------------
  Cluster               Account                
  Namespace             Schema (if enabled)    Database
  Table                 Container/Collection   
  Column family         N/A                    
  Row                   Item/Document          
  Version (Timestamp)   N/A                    
  N/A                   Primary Key            Partition Key
  N/A                   Index                  Index
  N/A                   Secondary Index        Secondary Index
  N/A                   View                   N/A
  N/A                   Sequence               N/A

#### Data structural differences

The key differences regarding the data structure of Cosmos DB and HBase
data are as follows:

**RowKey**

HBase is sorted and stored by RowKey and horizontally divided into
Regions by the range of RowKey. Cosmos DB will be distributed to
partitions according to the Hash value of the specified Partition key.

**Column Family**

> HBase columns are grouped within a Column Family, but the Cosmos DB
> SQL API doesn\'t have a Column Family concept.

**Timestamp**

> HBase can use Timestamp to give a Cell multiple versions. You can use
> Timestamp to get the values of past versions. Cosmos DB does not have
> a history of values.

**HBase data format**

The following is an example of HBase table row.

It consists of RowKey, Column Family:Column Name, Timestamp, Value.

**Cosmos DB data format**

The following is an example of Cosmos DB document.

The following JSON object represents the data format in the Azure Cosmos
DB SQL API. The partition key resides in a field in the document and
sets which field is the partition key for the collection. Cosmos DB does
not have the concept of timestamp used for Column Family or version.

#### Consistency model

HBase offers strictly consistent reads and writes, Cosmos DB offers five
well-defined consistency levels. From strongest to weakest, the levels
are:

-   # Strong {#strong .TOC-Heading}

-   # Bounded staleness {#bounded-staleness .TOC-Heading}

-   # Session {#session .TOC-Heading}

-   # Consistent prefix {#consistent-prefix .TOC-Heading}

-   # Eventual {#eventual .TOC-Heading}

Each level provides availability and performance tradeoffs. The
following image shows the different consistency levels as a spectrum.
See
<https://docs.microsoft.com/en-us/azure/cosmos-db/consistency-levels>
for more details.

#### Sizing

**HBase**

> HBase is roughly composed of two types of processes, Master and Region
> server, and achieves a scalable database by dividing data into Region
> units by automatic sharding. HBase performance is determined by the
> size of the node\'s CPU / Memory / Disk, etc. for storing and
> processing this data, and the number of Region Servers.

**Cosmos DB**

> For Cosmos DB, you cannot specify the size or number of nodes. Cosmos
> DB uses Request Units (RUs), which are units of performance that
> abstract them.
>
> What is Request Units (RUs)
>
> The cost of all database operations is normalized by Azure Cosmos DB
> and is expressed by Request Units (or RUs, for short). Request unit is
> a performance currency abstracting the system resources such as CPU,
> IOPS, and memory that are required to perform the database operations
> supported by Azure Cosmos DB. The cost to do a point read (i.e.
> fetching a single item by its ID and partition key value) for a 1 KB
> item is 1 Request Unit (or 1 RU). All other database operations are
> similarly assigned a cost using RUs. No matter which API you use to
> interact with your Azure Cosmos container, costs are always measured
> by RUs. Whether the database operation is a write, point read, or
> query, costs are always measured in RUs.
>
> The number of RUs per second will be affected by the following
> factors:

-   # **Document size -** Larger documents will consume more RUs to read or write. {#document-size---larger-documents-will-consume-more-rus-to-read-or-write. .TOC-Heading}

-   # **Indexing -** Indexing is automatic for all items, but if you specify not to index an item, it will consume fewer RUs. {#indexing---indexing-is-automatic-for-all-items-but-if-you-specify-not-to-index-an-item-it-will-consume-fewer-rus. .TOC-Heading}

-   # **Consistency levels -** The most consistent Strong and Bounded Staleness consistency levels consume approximately double the number of RUs when compared to other consistency levels. {#consistency-levels---the-most-consistent-strong-and-bounded-staleness-consistency-levels-consume-approximately-double-the-number-of-rus-when-compared-to-other-consistency-levels. .TOC-Heading}

-   # **Queries, stored procedures, and triggers -** The same query on the same data will always consume the same RUs, but queries with bigger result sets, many and/or complex predicates, and including user-defined functions will consume more RUs. {#queries-stored-procedures-and-triggers---the-same-query-on-the-same-data-will-always-consume-the-same-rus-but-queries-with-bigger-result-sets-many-andor-complex-predicates-and-including-user-defined-functions-will-consume-more-rus. .TOC-Heading}

> You can use a calculation tool to estimate RUs.
>
> <https://cosmos.azure.com/capacitycalculator/>

#### Distribution

**HBase**

> HBase is sorted according to RowKey and stored in Region, and
> automatic sharding divides Region horizontally according to the
> partitioning policy. By default it follows the value of
> hbase.hregion.max.filesize (default 10GB). At this time, one Row
> always belongs to the same Region. The divided Regions are optimized
> by Compaction and balancing.

**Cosmos DB**

> Cosmos DB uses partitioning to scale individual containers in the
> database. Partitioning divides the items in a container into specific
> subsets called \"logical partitions\". Logical partitions are formed
> based on the value of the \"partition key\" associated with each item
> in the container. All items in a logical partition have the same
> partition key value. Each logical partition can hold up to 20GB of
> data.
>
> Physical partitions each contain a replica of your data and an
> instance of the Cosmos DB database engine. This structure makes your
> data durable and highly available and throughput is divided equally
> amongst the local physical partitions. Physical partitions are
> automatically created and configured, and it\'s not possible to
> control their size, location, or which logical partitions they
> contain. Logical partitions are not split between physical partitions.
>
> As with HBase RowKey, partition key design is important for Cosmos DB.
> See this document for details.
>
> <https://docs.microsoft.com/en-us/azure/cosmos-db/partitioning-overview>

#### Availability

**HBase**

> HBase consists of Master and Region Server (and ZooKeeper). High
> availability in a single cluster can be achieved by making each
> component redundant. When configuring geo-redundancy, you can build
> HBase clusters in remote locations and use replication mechanisms to
> maintain the same data across clusters.

**Cosmos DB**

> Cosmos DB does not require any configuration such as cluster component
> redundancy. It provides a comprehensive SLA for high availability,
> consistency and latency. With Cosmos DB, you can place data in
> multiple regions simply by specifying the Azure region where you want
> to place the replica. This allows you to maintain high availability in
> the unlikely event of a regional failure.

#### Data reliability

**HBase**

> HBase is built on HDFS and the stored data will have 3 replicas by
> default.

**Cosmos DB**

> Azure Cosmos DB primarily provides high availability in two ways.
> First, Azure Cosmos DB replicates data between regions configured
> within your Cosmos account. Second, Azure Cosmos DB keeps four
> replicas of the data in the region.

#### Planning

##### System dependencies

Is the current HBase system a completely independent component? Or Does
it call a process on another system, or is it called by a process on
another system, or is it accessed using a directory service? Are other
important processes working in your HBase cluster? These system
dependencies need to be clarified to determine the impact of migration.

##### Data migration

For successful data migration, it is important to understand the
characteristics of the business that uses the database and decide how to
do it. Select offline migration if you can completely shut down the
system, perform data migration, and restart the system at the
destination. Also, if your database is always busy and you can\'t afford
a long outage, consider migrating online. This document covers only
offline migration.

When performing offline data migration, it depends on the version of
HBase you are currently running and the tools available. See the Data
Migration chapter for details.

##### Performance considerations

When executing queries that request sorted data, HBase will return the
result quickly because the data is sorted by RowKey. However, Cosmos DB
doesn't have such a concept. In order to optimize the performance, you
can use composite index as needed.

See this document for more details.

<https://docs.microsoft.com/en-us/azure/cosmos-db/index-policy#composite-indexes>

#### Assessment

Data Discovery

Gather information in advance from your existing HBase cluster to
identify the data you want to migrate.

-   # HBase version {#hbase-version .TOC-Heading}

-   # Migration target tables {#migration-target-tables .TOC-Heading}

-   # Column family information {#column-family-information .TOC-Heading}

-   # Table status {#table-status .TOC-Heading}

Here the data is collected using an "hbase shell" script and stored in
the local file system of the operating machine.

HBase version

Output example

Table list

You can get a list of tables stored in HBase. If you have created a
namespace other than default, it will be output in the "Namespace:
Table" format.

Output example

Check the output table list to identify the table to be migrated.

The details of the column families in the table by specifying the table
name to be migrated.

Output example

You will get the column families in the table and their settings.

All tables status.

Output example

You can get useful sizing information such as the size of heap memory,
the number of regions, the number of requests as the status of the
cluster, and the size of the data in compressed / uncompressed as the
status of the table.

If you are using Apache Phoenix on HBase cluster, you need to collect
data from Phoenix as well.

-   # Migration target table  {#migration-target-table .TOC-Heading}

-   # Table schemas {#table-schemas .TOC-Heading}

-   # Indexes {#indexes .TOC-Heading}

-   # Primary key {#primary-key .TOC-Heading}

Connect to Apache Phoenix on your cluster.

Table list

Table details

Index details

Primary key details

#### Building

##### Deployment

To deploy the migration destination Cosmos DB SQL API, please see the
following documentation.

<https://docs.microsoft.com/en-us/azure/cosmos-db/create-cosmosdb-resources-portal>

##### Network consideration

Cosmos DB has three main network options. The first is a configuration
that uses a Public IP address and controls access with an IP firewall
(default). The second is a configuration that uses a Public IP address
and allows access only from a specific subnet of a specific virtual
network (service endpoint). The third is a configuration (private
endpoint) that joins a private network using a Private IP address.

See the following documents for more information on the three network
options:

-   # Public IP with Firewall <https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall> {#public-ip-with-firewall-httpsdocs.microsoft.comen-usazurecosmos-dbhow-to-configure-firewall .TOC-Heading}

-   # Public IP with Service Endpoint <https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-configure-vnet-service-endpoint> {#public-ip-with-service-endpoint-httpsdocs.microsoft.comen-usazurecosmos-dbhow-to-configure-vnet-service-endpoint .TOC-Heading}

-   # Private Endpoint <https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-configure-private-endpoints> {#private-endpoint-httpsdocs.microsoft.comen-usazurecosmos-dbhow-to-configure-private-endpoints .TOC-Heading}

#### Data migration

##### Data migration options

There are various methods for data migration with Offline, but here we
will introduce the method using Azure Data Factory and Data Migration
Tool.

##### HBase 1.x

**Data Factory**

> Suitable for large datasets. The Azure Cosmos DB Bulk Executor library
> is used. Please note that there are no checkpoints, so if you
> encounter any issues during the migration you will have to restart the
> migration process from the beginning. You can also use Data Factory\'s
> Self-hosted Integration Runtime to connect to your on-premises HBase,
> or deploy Data Factory to a Managed VNET and connect to your
> on-premises network via VPN or ExpressRoute.
>
> Data Factory\'s Copy activity supports HBase as a data source. Please
> refer to the following documents for the detailed method.
>
> <https://docs.microsoft.com/en-us/azure/data-factory/connector-hbase>
>
> You can specify Cosmos DB (SQL API) as the destination for your data.
> Please refer to the following documents for the detailed method.
>
> <https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-cosmos-db>

**Data Migration Tool**

A dedicated OSS tool for migrating data to Cosmos DB, suitable for small
datasets. It can be installed, set up and used on a Windows machine.

<https://docs.microsoft.com/en-us/azure/cosmos-db/import-data>

The source code is available here.

<https://github.com/azure/azure-documentdb-datamigrationtool>

##### HBase 2.x or later

The Data Factory and Data Migration Tool do not support HBase 2.x or
later REST APIs, but Spark can read HBase data and write it to Cosmos
DB.

**Apache Spark - Apache HBase Connector & Cosmos DB Spark connector**

Here is an example assuming that HBase 2.1.0 and Spark 2.4.0 are running
in the same cluster.

Apache Spark -- Apache HBase Connector repository can be found at:

<https://github.com/hortonworks-spark/shc>

For Cosmos DB Spark connector, refer to the following and download the
appropriate library for your Spark version.

<https://docs.microsoft.com/en-us/azure/cosmos-db/spark-connector>

Copy hbase-site.xml to Spark configuration directory.

Run spark -shell with Spark HBase connector and Cosmos DB Spark
connector.

After the Spark shell starts, execute the Scala code as follows. Import
the libraries needed to load data from HBase.

Define the Spark Catalog schema for your HBase tables. Here the
Namespace is "default" and the table name is "Contacts". The row key is
specified as the key. Below Columns, Column Family and Column are mapped
to Spark\'s catalog.

Next, define a method to get the data from the HBase Contacts table as a
DataFrame.

Create a DataFrame using the defined method.

Then import the libraries needed to use the Cosmos DB Spark connector.

Make settings for writing data to Cosmos DB.

Writes DataFrame data to Cosmos DB.

It writes in parallel at high speed, its performance is quite high. On
the other hand, note that it may consume up RU on the Cosmos DB side.

##### Phoenix

Phoenix is supported as a Data Factory data source. Please refer to the
following documents for detailed steps.

<https://docs.microsoft.com/en-us/azure/data-factory/connector-phoenix>

Tutorial: Use Data migration tool to migrate your data to Azure Cosmos
DB

<https://docs.microsoft.com/en-us/azure/cosmos-db/import-data>

Copy data from HBase using Azure Data Factory

<https://docs.microsoft.com/en-us/azure/data-factory/connector-hbase>

#### Migrate your code

This section describes the differences between creating Cosmos DB SQL
APIs and HBase applications.

This example uses Apache HBase 2.x APIs and Cosmos DB Java SDK v4.

<https://docs.microsoft.com/en-us/azure/cosmos-db/sql-api-sdk-java-v4>

The code for Cosmos DB presented here is based on the following
documentation. You can access the full code example from the
documentation.

<https://docs.microsoft.com/en-us/azure/cosmos-db/sql-api-java-sdk-samples>

The mappings for code migration are shown here, but the HBase RowKeys
and Cosmos DB Partition Keys used in these examples are not always
well-designed. Please design according to the actual data model of the
migration source.

##### Establish connection

HBase

Phoenix

Azure Cosmos DB

##### Create Database/Table/Collection

HBase

Phoenix

Azure Cosmos DB

##### Create Row / Document

HBase

Phoenix

Azure Cosmos DB

Azure Cosmos DB provides you type safety via data model. We use data
model named 'Family'.

The above is part of the code. See [full code
example](https://github.com/Azure-Samples/azure-cosmos-java-sql-api-samples/blob/df1840b0b5e3715b8555c29f422e0e7d2bc1d49a/src/main/java/com/azure/cosmos/examples/common/Family.java).

Use the Family class to define document and insert item.

##### Read Row / Document

HBase

Phoenix

Azure Cosmos DB

##### Update data

For HBase, use the append method and checkAndPut method to update the
value. append is the process of appending a value atomically to the end
of the current value, and checkAndPut atomically compares the current
value with the expected value and updates only if they match.

Phoenix

Azure Cosmos DB

In Azure Cosmos DB, updates are treated as Upsert operations. That is,
if the document does not exist, it will be inserted.

##### Delete Row / Document

HBase

In Hbase, there is no direct delete way of selecting the row by value.
You may have implemented the delete process in combination with
ValueFilter etc. In this example, the row to be deleted is simply
specified by RowKey.

Phoenix

Azure Cosmos DB

The deletion method by Document ID is shown below.

##### Query Rows / Documents

HBase allows you to retrieve multiple Rows using scan. You can use
Filter to specify detailed scan conditions.

Phoenix

Azure Cosmos DB

Filter operation

##### Delete Table / Collection

HBase

Phoenix

Azure Cosmos DB

##### Other considerations

HBase clusters may be used with HBase workloads as well as MapReduce,
Hive, Spark, and more. If you have other workloads with your current
HBase, they also need to be migrated. For details, refer to each
migration guides.

-   # MapReduce {#mapreduce .TOC-Heading}

-   # HBase {#hbase-1 .TOC-Heading}

-   # Spark {#spark .TOC-Heading}

#### Server-side programming

HBase offers several server-side programming features. If you are using
these features, you will also need to migrate their processing.

HBase

-   # Custom filters {#custom-filters .TOC-Heading}

    -   # Various filters are available as default in HBase, but you can also implement your own custom filters. Custom filters may be implemented if the filters available as default on HBase do not meet your requirements. {#various-filters-are-available-as-default-in-hbase-but-you-can-also-implement-your-own-custom-filters.-custom-filters-may-be-implemented-if-the-filters-available-as-default-on-hbase-do-not-meet-your-requirements. .TOC-Heading}

-   # Coprocessor :  {#coprocessor .TOC-Heading}

    -   # The Coprocessor is a framework that allows you to run your own code on the Region Server. By using the Coprocessor, it is possible to perform the processing that was being executed on the client side on the server side, and depending on the processing, it can be made more efficient. There are two types of Coprocessors, Observer and Endpoint. {#the-coprocessor-is-a-framework-that-allows-you-to-run-your-own-code-on-the-region-server.-by-using-the-coprocessor-it-is-possible-to-perform-the-processing-that-was-being-executed-on-the-client-side-on-the-server-side-and-depending-on-the-processing-it-can-be-made-more-efficient.-there-are-two-types-of-coprocessors-observer-and-endpoint. .TOC-Heading}

        -   # Observer {#observer .TOC-Heading}

            -   # Observer hooks specific operations and events. This is a function for adding arbitrary processing. This is a feature similar to RDBMS triggers. Endpoint {#observer-hooks-specific-operations-and-events.-this-is-a-function-for-adding-arbitrary-processing.-this-is-a-feature-similar-to-rdbms-triggers.-endpoint .TOC-Heading}

        -   # Endpoint {#endpoint .TOC-Heading}

            -   # Endpoint is a feature for extending HBase RPC. It is a function similar to an RDBMS stored procedure. {#endpoint-is-a-feature-for-extending-hbase-rpc.-it-is-a-function-similar-to-an-rdbms-stored-procedure. .TOC-Heading}

#  {#section-26 .TOC-Heading}

Azure Cosmos DB

-   # Stored Procedure {#stored-procedure .TOC-Heading}

    -   # Cosmos DB stored procedures are written in JavaScript and can perform operations such as creating, updating, reading, querying, and deleting items in Cosmos DB containers. <https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-write-stored-procedures-triggers-udfs#stored-procedures> {#cosmos-db-stored-procedures-are-written-in-javascript-and-can-perform-operations-such-as-creating-updating-reading-querying-and-deleting-items-in-cosmos-db-containers.-httpsdocs.microsoft.comen-usazurecosmos-dbhow-to-write-stored-procedures-triggers-udfsstored-procedures .TOC-Heading}

-   # Trigger {#trigger .TOC-Heading}

    -   # Triggers can be specified for operations on the database. There are two methods provided: a pre-trigger that runs before the database item changes and a post-trigger that runs after the database item changes. <https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-write-stored-procedures-triggers-udfs#triggers> {#triggers-can-be-specified-for-operations-on-the-database.-there-are-two-methods-provided-a-pre-trigger-that-runs-before-the-database-item-changes-and-a-post-trigger-that-runs-after-the-database-item-changes.-httpsdocs.microsoft.comen-usazurecosmos-dbhow-to-write-stored-procedures-triggers-udfstriggers .TOC-Heading}

-   # UDF {#udf .TOC-Heading}

    -   # Cosmos DB allows you to define User Defined Functions (UDFs). UDFs can also be written in JavaScript. <https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-write-stored-procedures-triggers-udfs#udfs> {#cosmos-db-allows-you-to-define-user-defined-functions-udfs.-udfs-can-also-be-written-in-javascript.-httpsdocs.microsoft.comen-usazurecosmos-dbhow-to-write-stored-procedures-triggers-udfsudfs .TOC-Heading}

Server-side programming mappings

  HBase                    Cosmos DB
  ------------------------ ------------------
  Custom filters           WHERE Clause
  Coprocessor (Observer)   Trigger
  Coprocessor (Endpoint)   Stored Procedure

\*Please note that different mappings and implementations may be
required in Cosmos DB depending on the processing implemented on HBase.

#### Security

Cosmos DB runs on the Azure platform, so it can be enhanced in a
different way than HBase. Cosmos DB does not require any additional
components to be installed for security. We recommend that you consider
migrating your database system security implementation using the
following checklist:

-   # Network security and firewall settings {#network-security-and-firewall-settings .TOC-Heading}

-   # User authentication and fine grained user controls {#user-authentication-and-fine-grained-user-controls .TOC-Heading}

-   # Ability to replicate data globally for regional failures {#ability-to-replicate-data-globally-for-regional-failures .TOC-Heading}

-   # Ability to fail over from one data center to another {#ability-to-fail-over-from-one-data-center-to-another .TOC-Heading}

-   # Local data replication within a data center {#local-data-replication-within-a-data-center .TOC-Heading}

-   # Automatic data backups {#automatic-data-backups .TOC-Heading}

-   # Restoration of deleted data from backups {#restoration-of-deleted-data-from-backups .TOC-Heading}

-   # Protect and isolate sensitive data {#protect-and-isolate-sensitive-data .TOC-Heading}

-   # Monitoring for attacks {#monitoring-for-attacks .TOC-Heading}

-   # Responding to attacks {#responding-to-attacks .TOC-Heading}

-   # Ability to geo-fence data to adhere to data governance restrictions {#ability-to-geo-fence-data-to-adhere-to-data-governance-restrictions .TOC-Heading}

-   # Physical protection of servers in protected data centers {#physical-protection-of-servers-in-protected-data-centers .TOC-Heading}

-   # Certifications {#certifications .TOC-Heading}

For more information on security, please refer to the following
document.
<https://docs.microsoft.com/en-us/azure/cosmos-db/database-security>

#### Monitoring

HBase typically monitors the cluster using the cluster metric web UI or
in conjunction with Ambari, Cloudera Manager, or other monitoring tools.
Cosmos DB allows you to use the monitoring mechanism built into the
Azure platform.

-   # Monitoring in the Cosmos DB portal  {#monitoring-in-the-cosmos-db-portal .TOC-Heading}

    -   # Metrics such as throughput, storage, availability, latency, consistency, etc. are automatically retrieved and retained for 7 days. {#metrics-such-as-throughput-storage-availability-latency-consistency-etc.-are-automatically-retrieved-and-retained-for-7-days. .TOC-Heading}

```{=html}
<!-- -->
```
-   # Monitoring using Azure Monitor metrics  {#monitoring-using-azure-monitor-metrics .TOC-Heading}

    -   # You can monitor metrics for your Cosmos DB account and create dashboards from Azure Monitor. Metrics are collected on a minute-by-minute basis and are retained for 30 days by default. {#you-can-monitor-metrics-for-your-cosmos-db-account-and-create-dashboards-from-azure-monitor.-metrics-are-collected-on-a-minute-by-minute-basis-and-are-retained-for-30-days-by-default. .TOC-Heading}

-   # Monitoring using Azure Monitor diagnostic logs  {#monitoring-using-azure-monitor-diagnostic-logs .TOC-Heading}

    -   # Telemetry such as events and traces that occur every second is stored as a log. You can analyze these logs by querying the collected data. {#telemetry-such-as-events-and-traces-that-occur-every-second-is-stored-as-a-log.-you-can-analyze-these-logs-by-querying-the-collected-data. .TOC-Heading}

-   # Monitor programmatically with SDKs {#monitor-programmatically-with-sdks .TOC-Heading}

    -   # You can monitor your Azure Cosmos account by writing your own program using .NET, Java, Python, Node.js SDK, and REST API. {#you-can-monitor-your-azure-cosmos-account-by-writing-your-own-program-using-.net-java-python-node.js-sdk-and-rest-api. .TOC-Heading}

For more information on Cosmos DB monitoring, please refer to the
following document.

<https://docs.microsoft.com/en-us/azure/cosmos-db/monitor-cosmos-db>

If your environment implements HBase system monitoring to send alerts,
such as by email, you may be able to replace it with Azure Monitor
alerts. You can receive alerts based on metrics or activity log events
for your Cosmos DB account.

See the following documentation for details on alerts.

<https://docs.microsoft.com/en-us/azure/cosmos-db/create-alerts>

Also, see below for Cosmos DB metrics and log types that can be
collected by Azure Monitor.
<https://docs.microsoft.com/en-us/azure/cosmos-db/monitor-cosmos-db-reference>

#### BC-DR

##### Backup

There are several ways to get a backup of HBase. For example, Snapshot,
Export, CopyTable, Offlibe backup of HDFS data, and other custom
backups.

Cosmos DB automatically backs up data at periodic intervals, which does
not affect the performance or availability of database operations.
Backups are stored in Azure storage and can be used to recover data if
needed. There are two types of Cosmos DB backups:

-   # Periodic backup {#periodic-backup .TOC-Heading}

    -   # This is the default backup method. Backups are performed on a regular basis and, by default, keep the latest two backups. You can change the backup interval and retention period according to your requirements. The data is restored by making a request to Azure support team. {#this-is-the-default-backup-method.-backups-are-performed-on-a-regular-basis-and-by-default-keep-the-latest-two-backups.-you-can-change-the-backup-interval-and-retention-period-according-to-your-requirements.-the-data-is-restored-by-making-a-request-to-azure-support-team. .TOC-Heading}

# <https://docs.microsoft.com/en-us/azure/cosmos-db/configure-periodic-backup-restore> {#httpsdocs.microsoft.comen-usazurecosmos-dbconfigure-periodic-backup-restore .TOC-Heading}

-   # Continuous backup (Public Preview at the time of publication of this document 2021/3) {#continuous-backup-public-preview-at-the-time-of-publication-of-this-document-20213 .TOC-Heading}

    -   # You can restore to any point in the last 30 days. You need to select this backup mode when you create your Cosmos DB account to enable it. You can do a self-service restore using the Azure portal, PowerShell or CLI. {#you-can-restore-to-any-point-in-the-last-30-days.-you-need-to-select-this-backup-mode-when-you-create-your-cosmos-db-account-to-enable-it.-you-can-do-a-self-service-restore-using-the-azure-portal-powershell-or-cli. .TOC-Heading}

# <https://docs.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-introduction> {#httpsdocs.microsoft.comen-usazurecosmos-dbcontinuous-backup-restore-introduction .TOC-Heading}

##### Disaster Recovery

HBase is a fault-tolerant distributed system, but you must implement
Disaster Recovery using Snapshot, replication, etc. when failover is
required at the backup location in the case of a data center level
failure. If the source HBase implements Disaster Recovery, you need to
understand how you can configure Disaster Recovery in Cosmos DB and meet
your system requirements.

Cosmos DB is a globally distributed database with built-in Disaster
Recovery capabilities. You can replicate Cosmos DB data to any Azure
region. Cosmos DB keeps your database highly available in the unlikely
event of a failure in some regions.

Cosmos DB account that uses only a single region may lose availability
in the event of a region failure. We recommend that you configure at
least two regions to ensure high availability at all times. You can also
ensure high availability for both writes and reads by configuring your
Azure Cosmos account to span at least two regions with multiple write
regions to ensure high availability for writes and reads. For
multi-region accounts that consist of multiple write regions, failover
between regions is detected and handled by the Azure Cosmos DB client.
These are momentary and do not require any changes from the application.

<https://docs.microsoft.com/en-us/azure/cosmos-db/high-availability>

###  

# Hive

## Challenges of Hive on premise

## Hive Architecture and Components

## Considerations

## Migration Approach

### Modernization -- Databricks

When an Azure Databricks workspace provisioned, a default Hive
[Metastore](https://docs.microsoft.com/en-us/azure/databricks/data/metastores/)
comes automatically with the workspace. Alternative, an [external Hive
Metastore](https://docs.microsoft.com/en-us/azure/databricks/data/metastores/external-hive-metastore)
can be provision on Azure and connected to Azure Databricks. The
migration of on-premises Hive to Azure Databricks essentially include
two major parts: Metastore migration and underlying hive table data
migration.

#### Metastore Migration

The first step is to migrate the Hive Metastore from Hadoop to Azure
Databricks (or Azure SQL-DB). Hive Metastore contains all the location
and structure of all the data assets in the Hadoop environment.
Migrating the Hive Metastore is required for users to query tables in
Databricks notebooks using SQL statements. During migration process, the
locations of the underlying datasets will need to be updated to
reference the Azure Databricks file system mounts.

Export Hive table DDL

There are two methods you can use to generate the DDL for hive tables:

# Use SHOW CREATE TABLE command {#use-show-create-table-command .TOC-Heading}

# The "show create table" hive command can be used to generate the DDL for the single hive table (syntax: SHOW CREATE TABLE HIVE_TABLE_NAME; ) {#the-show-create-table-hive-command-can-be-used-to-generate-the-ddl-for-the-single-hive-table-syntax-show-create-table-hive_table_name .TOC-Heading}

#  {#section-28 .TOC-Heading}

#  {#section-29 .TOC-Heading}

# Use shell script + beeline to dump all tables DDL in the given Hive database  {#use-shell-script-beeline-to-dump-all-tables-ddl-in-the-given-hive-database .TOC-Heading}

# You can leverage on the same command "SHOW CREATE TABLE" to export all hive table DDL. The following handy script demonstrate the scripting approach to export DDL for multiple tables: {#you-can-leverage-on-the-same-command-show-create-table-to-export-all-hive-table-ddl.-the-following-handy-script-demonstrate-the-scripting-approach-to-export-ddl-for-multiple-tables .TOC-Heading}

+----------------------------------------------------------------------+
| # table_name_file=\'/home/sshdanny/tablen                            |
| ames.txt\' {#table_name_filehomesshdannytablenames.txt .TOC-Heading} |
|                                                                      |
| # ddl_file=\'/home/sshdanny/hiv                                      |
| etableddl.txt\' {#ddl_filehomesshdannyhivetableddl.txt .TOC-Heading} |
|                                                                      |
| # rm -f \$table_name_file {#rm--f-table_name_file .TOC-Heading}      |
|                                                                      |
| # rm -f \$ddl_file {#rm--f-ddl_file .TOC-Heading}                    |
|                                                                      |
| # beeline -u \"jdbc:hive2://zk0-danny.3er3nak3hkxuzfakhju4xihqha.    |
| ix.internal.cloudapp.net:2181,zk2-danny.3er3nak3hkxuzfakhju4xihqha.i |
| x.internal.cloudapp.net:2181,zk3-danny.3er3nak3hkxuzfakhju4xihqha.ix |
| .internal.cloudapp.net:2181/;serviceDiscoveryMode=zooKeeper;zooKeepe |
| rNamespace=hiveserver2\" -n \"danny\" -p \"\[password\]\" \--showHea |
| der=false \--silent=true \--outputformat=csv2 -e \"show tables\" \>\ |
| $table_name_file {#beeline--u-jdbchive2zk0-danny.3er3nak3hkxuzfakhju |
| 4xihqha.ix.internal.cloudapp.net2181zk2-danny.3er3nak3hkxuzfakhju4xi |
| hqha.ix.internal.cloudapp.net2181zk3-danny.3er3nak3hkxuzfakhju4xihqh |
| a.ix.internal.cloudapp.net2181servicediscoverymodezookeeperzookeeper |
| namespacehiveserver2--n-danny--p-password---showheaderfalse---silent |
| true---outputformatcsv2--e-show-tables-table_name_file .TOC-Heading} |
|                                                                      |
| #  {#section-30 .TOC-Heading}                                        |
|                                                                      |
| wait                                                                 |
|                                                                      |
| cat \$table_name_file \| while read LINE                             |
|                                                                      |
| do                                                                   |
|                                                                      |
| beeline -u \"jdbc:hive2://zk0-                                       |
| danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net            |
| :2181,zk2-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net: |
| 2181,zk3-danny.3er3nak3hkxuzfakhju4xihqha.ix.internal.cloudapp.net:2 |
| 181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2\" |
| -n \"danny\" -p \"\[password\]\" \--showHeader=false \--silent=true  |
| \--outputformat=csv2 -e \"show create table \$LINE\" \>\> \$ddl_file |
|                                                                      |
| #                                                                    |
|   echo -e \"\\n\" \>\> \$ddl_file {#echo--e-n-ddl_file .TOC-Heading} |
|                                                                      |
| #  echo \$LINE {#echo-line .TOC-Heading}                             |
|                                                                      |
| #  done {#done .TOC-Heading}                                         |
|                                                                      |
| # rm -f \$table_name_file {#rm--f-table_name_file-1 .TOC-Heading}    |
|                                                                      |
| # echo \"Tabl                                                        |
| e DDL were generated\" {#echo-table-ddl-were-generated .TOC-Heading} |
+----------------------------------------------------------------------+

#  {#section-31 .TOC-Heading}

#  {#section-32 .TOC-Heading}

**Note**: Before executing the generated DDL file in Azure databricks
DBFS to re-create the tables, the location of the each hive table need
to be updated according (the corresponding dbfs:// paths)You can [export
all table
metadata](https://docs.microsoft.com/en-us/azure/databricks/kb/metastore/create-table-ddl-for-metastore)
from Hive to the Databricks default or external metastore:

#### Hive Data & Job Assets Migration

Once the Hive metastore have been migrated over, the actual data
residing in Hive can be migrated.

There are several tools available for the data migration:

-   # [Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/connector-hive) -- connect directly to Hive and copy data, in a parallelized manner, to ADLS or [Databricks Delta Lake](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-databricks-delta-lake) (big data solution) {#azure-data-factory-connect-directly-to-hive-and-copy-data-in-a-parallelized-manner-to-adls-or-databricks-delta-lake-big-data-solution .TOC-Heading}

-   # Connect to Hive via [ODBC/JDBC driver](https://docs.microsoft.com/en-us/azure/databricks/integrations/bi/jdbc-odbc-bi) and copy to Hive storing in Azure (small data option) {#connect-to-hive-via-odbcjdbc-driver-and-copy-to-hive-storing-in-azure-small-data-option .TOC-Heading}

-   # Connect to Azure Databricks via Databricks CLI and copy the data to DBFS  {#connect-to-azure-databricks-via-databricks-cli-and-copy-the-data-to-dbfs .TOC-Heading}

    -   # Set up the databricks CLI on the hive node  {#set-up-the-databricks-cli-on-the-hive-node .TOC-Heading}

    -   # Set up authentication to connect to azure databricks  {#set-up-authentication-to-connect-to-azure-databricks .TOC-Heading}

    -   # Copy the data to DBFS via "databricks fs" commands {#copy-the-data-to-dbfs-via-databricks-fs-commands .TOC-Heading}

# [Example:]{.ul} {#example .TOC-Heading}

# Connecting to Azure databricks via token and list down the folders in DBFS  {#connecting-to-azure-databricks-via-token-and-list-down-the-folders-in-dbfs .TOC-Heading}

#  {#section-33 .TOC-Heading}

#  {#section-34 .TOC-Heading}

# Copy the file from local to DBFS {#copy-the-file-from-local-to-dbfs .TOC-Heading}

#  {#section-35 .TOC-Heading}

#  {#section-36 .TOC-Heading}

> Finally, the Hive jobs can be migrated over to Azure Databricks. Given
> that Apache Spark SQL in Azure Databricks is designed to be
> [compatible](https://docs.microsoft.com/en-us/azure/databricks/spark/latest/spark-sql/compatibility/hive)
> with the Apache Hive, including metastore connectivity, SerDes, and
> UDFs, even the "copy/paste" approach to Hive job migration is
> feasible. The [Workspace
> CLI](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/workspace-cli)
> can be used to perform bulk imports of scripts onto Azure Databricks.

### Modernization -- Synapse

### Lift and Shift -- HDInsight

### Lift and Shift -- IAAS 

## Decision Map/Flowchart

##  {#section-37}

## Feature Map & Workaround

Core functionality of HIVE and Azure Synapse comparison map is as
follows -

+-------------+----------+-------------------------------+
| **Feature** | **Hive** | **Synapse**                   |
+=============+==========+===============================+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          | #  {#section-38 .TOC-Heading} |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+
|             |          |                               |
+-------------+----------+-------------------------------+

## Reference Implementation - ARM Templates 

TBD v2

## Pseudocode

TBD v2

## Architectural Guidance

TBD v2

### Patterns & Anti -- Patterns

### Performance Tuning

### HA & DR

# Apache Ranger

## Apache Ranger: Overview -- Features

-   # Centralized policy administration {#centralized-policy-administration .TOC-Heading}

-   # Centralized auditing {#centralized-auditing .TOC-Heading}

-   # Dynamic row filtering {#dynamic-row-filtering .TOC-Heading}

-   # Dynamic data masking {#dynamic-data-masking .TOC-Heading}

-   # Tag based authorisation {#tag-based-authorisation .TOC-Heading}

-   # Rich and extendable policy enforcement engine {#rich-and-extendable-policy-enforcement-engine .TOC-Heading}

-   # Key Management System {#key-management-system .TOC-Heading}

-   # Security Zone (New feature) {#security-zone-new-feature .TOC-Heading}

## Challenges of Ranger on premise

**Security risks**. Apart from the usual risk of cyberattack, when you
have physical servers, you take on 'real-world' risks including damage,
destruction, natural disasters, fire, water damage or simply hardware
'wear and tear'.

However, for many businesses, security is the key reason why they want
to stick with on-premise. With locally hosted data, some people believe
that they have better [data security]{.ul} compared to cloud-based
storage.

But this is nothing but a myth. Services like [Azure Active
Directory]{.ul} are another advantage Azure has over on-premise storage
solutions.

Active Directory is a multi-tenant, cloud-based directory and identity
management service. It allows IT admins to give employees single sign-on
(SSO) access to multiple cloud SaaS applications like [SharePoint]{.ul},
[Office 365]{.ul} and more.

In addition, it offers an extensive suite of identity management
services which include:

-   # Device registration. {#device-registration. .TOC-Heading}

-   # Multi-factor authentication. {#multi-factor-authentication. .TOC-Heading}

-   # Role-based access control. {#role-based-access-control. .TOC-Heading}

-   # Self-service group management. {#self-service-group-management. .TOC-Heading}

-   # Application usage monitoring. {#application-usage-monitoring. .TOC-Heading}

These services keep your business secure, ensuring only relevant users
have access to your most sensitive information.

Not only that, but by rejecting physical servers for the cloud you also
eliminate the risk of physical security as you don't have on-premise
servers to take care of in your building. Between that and your virtual
security, Azure helps secure your business on two fronts.

## Apache Ranger Architecture and Components

Apache Ranger is a framework to enable, monitor and manage comprehensive
data security across the Hadoop platform.

The vision with Ranger is to provide comprehensive security across the
Apache Hadoop ecosystem. With the advent of Apache YARN, the Hadoop
platform can now support a true data lake architecture. Enterprises can
potentially run multiple workloads, in a multi-tenant environment. Data
security within Hadoop needs to evolve to support multiple use cases for
data access, while also providing a framework for central administration
of security policies and monitoring of user access.

#  Apache Ranger

## Apache Ranger: Overview -- Features

-   # Centralized policy administration {#centralized-policy-administration-1 .TOC-Heading}

-   # Centralized auditing {#centralized-auditing-1 .TOC-Heading}

-   # Dynamic row filtering {#dynamic-row-filtering-1 .TOC-Heading}

-   # Dynamic data masking {#dynamic-data-masking-1 .TOC-Heading}

-   # Tag based authorisation {#tag-based-authorisation-1 .TOC-Heading}

-   # Rich and extendable policy enforcement engine {#rich-and-extendable-policy-enforcement-engine-1 .TOC-Heading}

-   # Key Management System {#key-management-system-1 .TOC-Heading}

-   # Security Zone (New feature) {#security-zone-new-feature-1 .TOC-Heading}

## Challenges of Ranger on premise

**Security risks**. Apart from the usual risk of cyberattack, when you
have physical servers, you take on 'real-world' risks including damage,
destruction, natural disasters, fire, water damage or simply hardware
'wear and tear'.

However, for many businesses, security is the key reason why they want
to stick with on-premise. With locally hosted data, some people believe
that they have better [data security]{.ul} compared to cloud-based
storage.

But this is nothing but a myth. Services like [Azure Active
Directory]{.ul} are another advantage Azure has over on-premise storage
solutions.

Active Directory is a multi-tenant, cloud-based directory and identity
management service. It allows IT admins to give employees single sign-on
(SSO) access to multiple cloud SaaS applications like [SharePoint]{.ul},
[Office 365]{.ul} and more.

In addition, it offers an extensive suite of identity management
services which include:

-   # Device registration. {#device-registration.-1 .TOC-Heading}

-   # Multi-factor authentication. {#multi-factor-authentication.-1 .TOC-Heading}

-   # Role-based access control. {#role-based-access-control.-1 .TOC-Heading}

-   # Self-service group management. {#self-service-group-management.-1 .TOC-Heading}

-   # Application usage monitoring. {#application-usage-monitoring.-1 .TOC-Heading}

These services keep your business secure, ensuring only relevant users
have access to your most sensitive information.

Not only that, but by rejecting physical servers for the cloud you also
eliminate the risk of physical security as you don't have on-premise
servers to take care of in your building. Between that and your virtual
security, Azure helps secure your business on two fronts.

## Apache Ranger Architecture and Components

Apache Ranger is a framework to enable, monitor and manage comprehensive
data security across the Hadoop platform.

The vision with Ranger is to provide comprehensive security across the
Apache Hadoop ecosystem. With the advent of Apache YARN, the Hadoop
platform can now support a true data lake architecture. Enterprises can
potentially run multiple workloads, in a multi-tenant environment. Data
security within Hadoop needs to evolve to support multiple use cases for
data access, while also providing a framework for central administration
of security policies and monitoring of user access.

**Image source: Ranger Architecture - Hortonworks Data Platform
(cloudera.com)**

The Apache Ranger has a decentralized architecture with the following
internal components:

  **Component**         **Description**
  --------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Ranger admin portal   The Ranger Admin portal is the central interface for security administration. Users can create and update policies, which are then stored in a policy database. Plugins within each component poll these policies at regular intervals. The portal also consists of an audit server that sends audit data collected from the plugins for storage in HDFS or in a relational database.
  Ranger plugins        Plugins are lightweight Java programs which embed within processes of each cluster component. For example, the Apache Ranger plugin for Apache Hive is embedded within Hiveserver2. These plugins pull in policies from a central server and store them locally in a file. When a user request comes through the component, these plugins intercept the request and evaluate it against the security policy. Plugins also collect data from the user request and follow a separate thread to send this data back to the audit server.
  User group sync       Apache Ranger provides a user synchronization utility to pull users and groups from Unix or from LDAP or Active Directory. The user or group information is stored within Ranger portal and used for policy definition.

*Information source: [Apache Ranger \| Cloudera]{.ul}*

## Migration Approach

###  {#section-39}

### Modernization -- AAD + Databricks

All user authentication to the Azure Databricks Workspace is done via
Azure Active Directory's (AAD) [single sign-on]{.ul} functionality.
Additionally, AAD [conditional access]{.ul} can be leveraged for
fine-grain access control to the Databricks workspace.

Authorization is achieved using a combination of AAD and Databricks
Access Control Lists (ACLs). Users and groups defined within AAD can be
imported to the Databricks workspace via [SCIM]{.ul}. Access to data
residing in ADLS gen1&2 (at the file or folder levels) can be
orchestrated using AAD [credential passthrough]{.ul}. Access the
Databricks workspace objects are [governed by ACLs]{.ul}. Row-level and
column-level permissions and [data
masking](https://docs.microsoft.com/en-us/azure/databricks/security/access-control/table-acls/object-privileges#data-masking)
for table data is managed using Databricks [dynamic views]{.ul}.

Advanced security features can be implemented using 3^rd^ party partner
solutions, [Privacera]{.ul} and [Immuta]{.ul}.

### Modernization -- AAD + Azure PAAS Services

When moving from On-premises Hadoop to hosting Big Data Environments on
cloud, there can be a few different options architecture can be designed
around based on needs, e.g Using **Azure Cosmos DB** while moving from
Hbase and/or Hosting data and leveraging **Azure Synapse analytics** for
Hive workload. Optionally as stated above **Databricks** can be heavily
leveraged for multiple data sources such as, Hive jobs can usually be
run out of the box on Spark, Spark SQL supports vast majority of Hive
query features. Storm is legacy technology and can be replaced with
Spark Streaming or serverless processing. Impala: in Databricks's own
published benchmarks, Databricks outperforms Impala also MapReduce is
legacy technology and can be replaced with Spark.

Security on Cosmos DB can be achieved with combination of various
features available and other Azure security services. For more
information head to
*https://docs.microsoft.com/en-us/azure/cosmos-db/database-security*

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Security requirement                        Azure Cosmos DB\'s security approach
  ------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Network security                            Using an IP firewall is the first layer of protection to secure your database.

  Authorization                               Azure Cosmos DB uses hash-based message authentication code (HMAC) for authorization.

  Users and permissions                       Users and permissionsUsing the primary key for the account, you can create user resources and permission resources per database. A resource token is associated with a permission in a database and determines whether the user has access (read-write, read-only, or no access) to an application resource in the database.

  Active directory integration (Azure RBAC)   You can also provide or restrict access to the Cosmos account, database, container, and offers (throughput) using Access control (IAM) in the Azure portal. IAM provides role-based access control and integrates with Active Directory.

  Protect and isolate sensitive data          All data in the regions listed in What\'s new? is now encrypted at rest.\
                                              \
                                              Personal data and other confidential data can be isolated to specific container and read-write, or read-only access can be limited to specific users.

  Encryption at rest                          All data stored into Azure Cosmos DB is encrypted at rest. Learn more in [Azure Cosmos DB encryption at rest]{.ul}
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

The following screenshot shows how you can use audit logging and
activity logs to monitor your account:

*Image source: Microsoft Docs*

Security in Azure Synapse Analytics can be achieved by using below
methods:

+---------------------------------+-----------------------------------+
| Security requirement            | Azure Synapse Analytics Security  |
|                                 | approach                          |
+=================================+===================================+
| Assess control                  | Regulatory Compliance in Azure    |
|                                 | Policy provides Microsoft created |
|                                 | and managed initiative            |
|                                 | definitions, known as built-ins,  |
|                                 | for the compliance domains and    |
|                                 | security controls related to      |
|                                 | different compliance standards.   |
|                                 | This page lists the compliance    |
|                                 | domains and security controls for |
|                                 | Azure App Configuration. You can  |
|                                 | assign the built-ins for a        |
|                                 | security control individually to  |
|                                 | help make your Azure resources    |
|                                 | compliant with the specific       |
|                                 | standard.                         |
+---------------------------------+-----------------------------------+
| Encryption at rest              | Azure Synapse Analytics offers a  |
|                                 | second layer of encryption for    |
|                                 | the data in your workspace with a |
|                                 | customer-managed key. This key is |
|                                 | safeguarded in your Azure Key     |
|                                 | Vault, which allows you to take   |
|                                 | ownership of key management and   |
|                                 | rotation.                         |
|                                 |                                   |
|                                 | The first layer of encryption for |
|                                 | Azure services is enabled with    |
|                                 | platform-managed keys. By         |
|                                 | default, Azure Disks, and data in |
|                                 | Azure Storage accounts are        |
|                                 | automatically encrypted at rest.  |
+---------------------------------+-----------------------------------+
| KMS                             | The Azure Synapse encryption      |
|                                 | model with customer-managed keys  |
|                                 | involves the workspace accessing  |
|                                 | the keys in Azure Key Vault to    |
|                                 | encrypt and decrypt as needed.    |
|                                 | The keys are made accessible to   |
|                                 | the workspace either through an   |
|                                 | access policy or Azure Key Vault  |
|                                 | RBAC access.                      |
+---------------------------------+-----------------------------------+
| Network Security                | -   #                             |
|                                 | Azure Synapse Analytics IP firewa |
|                                 | ll rules {#azure-synapse-analytic |
|                                 | s-ip-firewall-rules .TOC-Heading} |
|                                 |                                   |
|                                 | -   # Azure Synaps                |
|                                 | e Analytics Managed Virtual Netwo |
|                                 | rk {#azure-synapse-analytics-mana |
|                                 | ged-virtual-network .TOC-Heading} |
|                                 |                                   |
|                                 | -   # Synapse Managed p           |
|                                 | rivate endpoints {#synapse-manage |
|                                 | d-private-endpoints .TOC-Heading} |
|                                 |                                   |
|                                 | -   # Data exfiltration p         |
|                                 | rotection for Azure Synapse Analy |
|                                 | tics workspaces {#data-exfiltrati |
|                                 | on-protection-for-azure-synapse-a |
|                                 | nalytics-workspaces .TOC-Heading} |
|                                 |                                   |
|                                 | -   # Connect                     |
|                                 |  to Azure Synapse Studio using Az |
|                                 | ure Private Link Hubs {#connect-t |
|                                 | o-azure-synapse-studio-using-azur |
|                                 | e-private-link-hubs .TOC-Heading} |
|                                 |                                   |
|                                 | -   # Connect to a secure Azu     |
|                                 | re storage account from your Syna |
|                                 | pse workspace {#connect-to-a-secu |
|                                 | re-azure-storage-account-from-you |
|                                 | r-synapse-workspace .TOC-Heading} |
+---------------------------------+-----------------------------------+
| Authentication and pass-through | With Azure AD authentication, you |
|                                 | can centrally manage user         |
|                                 | identities that have access to    |
|                                 | Azure Synapse to simplify         |
|                                 | permission management.            |
|                                 |                                   |
|                                 | Use Multi-factor AAD              |
|                                 | authentication with Synapse SQL   |
|                                 | (SSMS support for MFA)            |
|                                 |                                   |
|                                 | Optionally one may also choose to |
|                                 | use SQL Authentication to gain    |
|                                 | user access to the data.          |
+---------------------------------+-----------------------------------+
| Access Control                  | Synapse provides a comprehensive  |
|                                 | and fine-grained access control   |
|                                 | system, that integrates:          |
|                                 |                                   |
|                                 | -   # **Azure roles** for         |
|                                 | resource management and access to |
|                                 |  data in storage, {#azure-roles-f |
|                                 | or-resource-management-and-access |
|                                 | -to-data-in-storage .TOC-Heading} |
|                                 |                                   |
|                                 | -   # **Synapse                   |
|                                 | roles** for managing live access  |
|                                 | to code and execution, {#synapse- |
|                                 | roles-for-managing-live-access-to |
|                                 | -code-and-execution .TOC-Heading} |
|                                 |                                   |
|                                 | -   # **                          |
|                                 | SQL roles** for data plane access |
|                                 |  to data in SQL pools, and {#sql- |
|                                 | roles-for-data-plane-access-to-da |
|                                 | ta-in-sql-pools-and .TOC-Heading} |
|                                 |                                   |
|                                 | -   # **Git permission            |
|                                 | s** for source code control, incl |
|                                 | uding continuous integration and  |
|                                 | deployment support. {#git-permiss |
|                                 | ions-for-source-code-control-incl |
|                                 | uding-continuous-integration-and- |
|                                 | deployment-support. .TOC-Heading} |
+---------------------------------+-----------------------------------+

To read more about Security in Synapse Analytics please follow
*https://docs.microsoft.com/en-in/azure/synapse-analytics/security-controls-policy*

###   {#section-40}

###   {#section-41}

###   {#section-42}

### Lift and Shift -- HDInsight

HDInsight is a Hortonworks-derived distribution provided as a first
party service on Azure. It supports the most common Big Data engines,
including MapReduce, Hive on Tez, Hive LLAP, Spark, HBase, Storm, Kafka,
and Microsoft R Server. It is aimed to provide a developer self-managed
experience with optimized developer tooling and monitoring capabilities.

Its Enterprise features include:

-   # Ranger support (Kerberos based Security) {#ranger-support-kerberos-based-security .TOC-Heading}

-   # Log Analytics via OMS {#log-analytics-via-oms .TOC-Heading}

-   # Orchestration via Azure Data Factory {#orchestration-via-azure-data-factory .TOC-Heading}

*Secure and govern cluster with Enterprise Security Package*

The Enterprise Security Package (ESP) supports Active Directory-based
authentication, multiuser support, and role-based access control. With
the ESP option chosen, HDInsight cluster is joined to the Active
Directory domain and the enterprise admin can configure role-based
access control (RBAC) for Apache Hive security by using Apache Ranger.
The admin can also audit the data access by employees and any changes
done to access control policies.

ESP is available on the following cluster types: Apache Hadoop, Apache
Spark, Apache HBase, Apache Kafka, and Interactive Query (Hive LLAP).

*Importing and exporting resource-based policies*

You can export and import policies from the Ranger Admin UI for
migration and cluster resiliency (backups), during recovery operations,
or when moving policies from test clusters to production clusters. You
can export/import a specific subset of policies (such as those that
pertain to specific resources or user/groups) or clone the entire
repository (or multiple repositories) via Ranger Admin UI.

*Interfaces*

You can import and export policies from the Service Manager page:

You can also export policies from the Reports page:

**Filtering**

When exporting from the Reports page, you can apply filters before
saving the file.

**Export Formats**

You can export policies in the following formats:

-   # Excel  {#excel .TOC-Heading}

-   # JSON  {#json .TOC-Heading}

```{=html}
<!-- -->
```
-   # CSV  {#csv .TOC-Heading}

Note: CSV format is not supported for importing policies.

When you export policies from the Service Manager page, the policies are
automatically downloaded in JSON format. If you wish to export in Excel
or CSV format, export the policies from the Reports page dropdown menu.

**Required User Roles**

The Ranger admin user can import and export only Resource & Tag based
policies. The credentials for this user are set in Ranger **Configs \>
Advanced ranger-env** in the fields
labeled **admin_username** (default: *admin*/*admin*).

The Ranger KMS keyadmin user can import and export only KMS policies.
The default credentials for this user are *keyadmin*/*keyadmin*.

**Limitations**

To successfully import policies, use the following database versions:

-   # MariaDB: 10.1.16+  {#mariadb-10.1.16 .TOC-Heading}

-   # MySQL: 5.6.x+  {#mysql-5.6.x .TOC-Heading}

```{=html}
<!-- -->
```
-   # Oracle: 11gR2+  {#oracle-11gr2 .TOC-Heading}

-   # PostgreSQL: 8.4+  {#postgresql-8.4 .TOC-Heading}

-   # MS SQL: 2008 R2+  {#ms-sql-2008-r2 .TOC-Heading}

Partial import is not supported.

### Lift and Shift -- IAAS (INFRASTRUCTURE AS A SERVICE) 

Cloudera Data Hub is a distribution of Hadoop running on Azure Virtual
Machines. It can be deployed through the [Azure marketplace]{.ul}.

Cloudera Data Hub is designed to build a unified enterprise data
platform. Its Enterprise features include:

-   # Full hybrid support & parity with on-premises Cloudera deployments {#full-hybrid-support-parity-with-on-premises-cloudera-deployments .TOC-Heading}

-   # Ranger support (Kerberos-based Security) and fine-grained authorization (Sentry) {#ranger-support-kerberos-based-security-and-fine-grained-authorization-sentry .TOC-Heading}

-   # Widest portfolio of Hadoop technologies {#widest-portfolio-of-hadoop-technologies .TOC-Heading}

-   # Single platform serving multiple applications seamlessly on-premises and on-cloud. {#single-platform-serving-multiple-applications-seamlessly-on-premises-and-on-cloud. .TOC-Heading}

For more information please follow :
*https://docs.cloudera.com/documentation/other/reference-architecture/topics/ra_azure_deployment.html*

## Decision Map/Flowchart

## Ranger - Hbase 

##  {#section-43}

## Ranger -- HDFS

## Ranger -- Hive

## Feature Map & Workaround

  **Feature**                           **Ranger**                             **Azure Cloud**
  ------------------------------------- -------------------------------------- -----------------------------------------------------------------------------------------------------------------------
  Data Access Security                  Apache Ranger Authorization policies   Configure [access control lists ACLs]{.ul} for Azure Data Lake Storage Gen1 and Gen2
                                                                               Enable the [\"Secure transfer required\"]{.ul} property on storage accounts.
                                                                               Configure [Azure Storage firewalls]{.ul} and virtual networks
                                                                               Configure [Azure virtual network service endpoints]{.ul} for Cosmos DB and [Azure SQL DB]{.ul}
                                                                               Ensure that the [Encryption in transit]{.ul} feature is enabled to use TLS and IPSec for intra-cluster communication.
                                                                               Configure [customer-managed keys]{.ul} for Azure Storage encryption
                                                                               Control access to your data by Azure support using [Customer lockbox]{.ul}
  Application and middleware security   Apache Ranger Authorization policies   Integrate with AAD-DS and [Configure ESP]{.ul} or use [HIB for OAuth Authentication]{.ul}
  KMS                                   Ranger Key Management Service          Azure Key Vault
  Audit data collection                 Centralized audit                      Use [Azure Monitor logs]{.ul}

Reference Implementation - ARM Templates

TBD v2

## Pseudocode

TBD v2

## Architectural Guidance

TBD v2

### Patterns & Anti -- Patterns

### Performance Tuning

### HA & DR

# Apache Spark

## Challenges of Spark on premise

## Apache Spark Architecture and Components

## Considerations

## Migration Approach

### Modernization -- Databricks

[Azure
Databricks](https://azure.microsoft.com/en-us/services/databricks/) is a
fast, easy, and collaborative Apache Spark based analytics service.
Engineered by the original creators of Apace Spark, Azure Databricks
provides the latest versions of Apache Spark and allows you to
seamlessly integrate with open-source libraries. You can spin up
clusters and build quickly in a fully managed Apache Spark environment
with the global scale and availability of Azure. Clusters are set up,
configured, and fine-tuned to ensure reliability and performance without
the need for monitoring. Take advantage of autoscaling and
auto-termination to improve total cost of ownership (TCO).

On top of Apache Spark, Azure Databricks offers additional capabilities:

-   # [Photon Engine](https://techcommunity.microsoft.com/t5/analytics-on-azure/turbocharge-azure-databricks-with-photon-powered-delta-engine/ba-p/1694929) - a vectorized query engine that leverages modern CPU architecture to enhance Apache Spark 3.0's performance by up to 20x. {#photon-engine---a-vectorized-query-engine-that-leverages-modern-cpu-architecture-to-enhance-apache-spark-3.0s-performance-by-up-to-20x. .TOC-Heading}

-   # [DBIO Cache](https://docs.microsoft.com/en-us/azure/databricks/delta/optimizations/delta-cache) - Transparent caching of Parquet data on worker local disk {#dbio-cache---transparent-caching-of-parquet-data-on-worker-local-disk .TOC-Heading}

-   # [Skew Join Optimization](https://docs.microsoft.com/en-us/azure/databricks/delta/join-performance/skew-join) {#skew-join-optimization .TOC-Heading}

-   # [Managed Delta Lake](https://docs.microsoft.com/en-us/azure/databricks/delta/) {#managed-delta-lake .TOC-Heading}

-   # [Managed MLflow](https://docs.microsoft.com/en-us/azure/databricks/applications/mlflow/) {#managed-mlflow .TOC-Heading}

The migration of Spark jobs onto Azure Databricks is trivial, and
requires minimal, if any, modifications to scripts. Job scripts can be
imported into Azure Databricks in bulk using the [Workspace
CLI](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/workspace-cli).

### Modernization -- Synapse

### Lift and Shift -- HDInsight

### Lift and Shift -- IAAS 

## Decision Map/Flowchart

[Albero Azure Decision Tree for Data: Spark on
Azure](https://albero.cloud/html/spark.html)

##  {#section-44}

## Feature Map & Workaround

## Reference Implementation - ARM Templates 

TBD v2

## Pseudocode

TBD v2

## Architectural Guidance

TBD v2

### Patterns & Anti -- Patterns

### Performance Tuning

### HA & DR

