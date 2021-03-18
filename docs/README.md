> Hadoop Migration Guide v1.0

**\
**

# Table of Contents {#table-of-contents .TOC-Heading}

[Structure of this guide 5](#structure-of-this-guide)

[Further reading 5](#further-reading)

[Hadoop Architecture & Components 6](#hadoop-architecture-components)

[Brief introduction to Apache Hadoop
6](#brief-introduction-to-apache-hadoop)

[Hadoop Distributed File Systems (HDFS)
7](#hadoop-distributed-file-systems-hdfs)

[Challenges of an on premise HDFS 7](#challenges-of-an-on-premise-hdfs)

[HDFS Architecture and Components 7](#hdfs-architecture-and-components)

[Considerations 9](#considerations)

[Migration Approach 10](#migration-approach)

[On premise Assessment 10](#on-premise-assessment)

[Data Extraction 12](#data-extraction)

[Data Migration 12](#data-migration)

[Data Validation 15](#data-validation)

[Feature Map & Workaround 15](#feature-map-workaround)

[Reference Implementation - ARM Templates
18](#reference-implementation---arm-templates)

[Pseudocode 18](#pseudocode)

[Architectural Guidance 18](#architectural-guidance)

[Patterns & Anti -- Patterns 18](#patterns-anti-patterns)

[Performance Tuning 18](#performance-tuning)

[HA & DR 18](#ha-dr)

[HBase 18](#hbase)

[Challenges of HBase on premise 18](#challenges-of-hbase-on-premise)

[HBase Architecture and Components
18](#hbase-architecture-and-components)

[Considerations 18](#considerations-1)

[Migration Approach 18](#migration-approach-1)

[Modernization 18](#modernization)

[Lift and Shift -- HDInsight 18](#lift-and-shift-hdinsight)

[Lift and Shift -- IAAS 18](#lift-and-shift-iaas)

[Decision Map/Flowchart 18](#decision-mapflowchart)

[Feature Map & Workaround 18](#feature-map-workaround-1)

[Reference Implementation - ARM Templates
19](#reference-implementation---arm-templates-1)

[Pseudocode 19](#pseudocode-1)

[Architectural Guidance 19](#architectural-guidance-1)

[Patterns & Anti -- Patterns 19](#patterns-anti-patterns-1)

[Performance Tuning 19](#performance-tuning-1)

[HA & DR 19](#ha-dr-1)

[Hive 19](#hive)

[Challenges of Hive on premise 19](#challenges-of-hive-on-premise)

[Hive Architecture and Components 19](#hive-architecture-and-components)

[Considerations 19](#considerations-2)

[Migration Approach 19](#migration-approach-2)

[Modernization -- Databricks 19](#modernization-databricks)

[Modernization -- Synapse 19](#modernization-synapse)

[Lift and Shift -- HDInsight 19](#lift-and-shift-hdinsight-1)

[Lift and Shift -- IAAS 19](#lift-and-shift-iaas-1)

[Decision Map/Flowchart 20](#decision-mapflowchart-1)

[Feature Map & Workaround 20](#feature-map-workaround-2)

[Reference Implementation - ARM Templates
20](#reference-implementation---arm-templates-2)

[Pseudocode 20](#pseudocode-2)

[Architectural Guidance 20](#architectural-guidance-2)

[Patterns & Anti -- Patterns 20](#patterns-anti-patterns-2)

[Performance Tuning 20](#performance-tuning-2)

[HA & DR 20](#ha-dr-2)

[Apache Ranger 20](#apache-ranger)

[Challenges of Ranger on premise 20](#challenges-of-ranger-on-premise)

[Apache Ranger Architecture and Components
21](#apache-ranger-architecture-and-components)

[Considerations 21](#considerations-3)

[Migration Approach 21](#migration-approach-3)

[Modernization -- AAD + Azure PAAS Services
21](#modernization-aad-azure-paas-services)

[Modernization -- AAD + Synapse 21](#modernization-aad-synapse)

[Lift and Shift -- HDInsight 21](#lift-and-shift-hdinsight-2)

[Lift and Shift -- IAAS 21](#lift-and-shift-iaas-2)

[Decision Map/Flowchart 21](#decision-mapflowchart-2)

[Feature Map & Workaround 21](#feature-map-workaround-3)

[Reference Implementation - ARM Templates
21](#reference-implementation---arm-templates-3)

[Pseudocode 21](#pseudocode-3)

[Architectural Guidance 21](#architectural-guidance-3)

[Patterns & Anti -- Patterns 21](#patterns-anti-patterns-3)

[Performance Tuning 21](#performance-tuning-3)

[HA & DR 21](#ha-dr-3)

[Apache Spark 21](#apache-spark)

[Challenges of Spark on premise 21](#challenges-of-spark-on-premise)

[Apache Spark Architecture and Components
21](#apache-spark-architecture-and-components)

[Considerations 21](#considerations-4)

[Migration Approach 22](#migration-approach-4)

[Modernization -- Databricks 22](#modernization-databricks-1)

[Modernization -- Synapse 22](#modernization-synapse-1)

[Lift and Shift -- HDInsight 22](#lift-and-shift-hdinsight-3)

[Lift and Shift -- IAAS 22](#lift-and-shift-iaas-3)

[Decision Map/Flowchart 22](#decision-mapflowchart-3)

[Feature Map & Workaround 22](#feature-map-workaround-4)

[Reference Implementation - ARM Templates
22](#reference-implementation---arm-templates-4)

[Pseudocode 22](#pseudocode-4)

[Architectural Guidance 22](#architectural-guidance-4)

[Patterns & Anti -- Patterns 22](#patterns-anti-patterns-4)

[Performance Tuning 22](#performance-tuning-4)

[HA & DR 22](#ha-dr-4)

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
by simply adding commodity servers . The key components of an Hadoop
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

![](C:\docs\images\media\image1.png){width="6.131944444444445in"
height="4.443669072615923in"}

Reference : <https://gearup.microsoft.com/resources/azure-migration>

# Hadoop Distributed File Systems (HDFS)

HDFS is the file system component of Hadoop. While the interface to HDFS
is patterned after the UNIX file system, faithfulness to standards was
sacrificed in favor of improved performance for the applications at
hand. HDFS stores file system metadata and application data separately.

-   As in other distributed file systems, like PVFS, Lustre and GFS,
    HDFS stores metadata on a dedicated server, called the NameNode.

-   Application data are stored on other servers called DataNodes.

-   All servers are fully connected and communicate with each other
    using TCP-based protocols. Unlike Lustre and PVFS, the DataNodes in
    HDFS do not use data protection mechanisms such as RAID to make the
    data durable.

-   Instead, like GFS, the file content is replicated on multiple
    DataNodes for reliability. While ensuring data durability, this
    strategy has the added advantage that data transfer bandwidth is
    multiplied, and there are more opportunities for locating
    computation near the needed data.

## Challenges of an on premise HDFS 

-   Frequent HDFS version upgrades

-   The amount of data stored on HDFS keeps growing

-   Limiting the number of small files that filter through the system
    . - Because NameNode loads all file metadata in memory, storing
    small files increases memory pressure on the NameNode. In addition,
    small files lead to an increase of read RPC calls for accessing the
    same amount of data when clients are reading the files, as well as
    an increase in RPC calls when files are generated.

-   Multiple teams require a large percentage of stored data, making it
    impossible to split clusters by use case or organization without
    duplications and in turn decreasing efficiency while increasing
    costs.

-   Ability to scale our HDFS without compromising the UX--- the
    performance and throughput of
    the [NameNode](https://wiki.apache.org/hadoop/NameNode), the
    directory tree of all files in the system that tracks where data
    files are kept.

-   All metadata is stored in the NameNode, client requests to an HDFS
    cluster must first pass through it.

-   A
    single [ReadWriteLock](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.html) on
    the NameNode namespace limits the maximum throughput the NameNode
    can support because any write request will exclusively hold
    the write lock and force any other requests to wait in the queue.

## HDFS Architecture and Components

Hadoop Distributed Filesystem (HDFS) - a Java-based file system that
provides scalable and reliable data storage designed to span large
clusters of commodity servers

-   **Namenode**: The master node. It manages access to files on the
    system and also manages the namespace of the file system.

    -   The HDFS namespace is a hierarchy of files and directories.

    -   Files and directories are represented on the NameNode by inodes,
        which record attributes like permissions, modification and
        access times, namespace and disk space quotas.

    -   The file content is split into large blocks (typically 128
        megabytes, but user selectable file-by-file) and each block of
        the file is independently replicated at multiple DataNodes
        (typically three, but user selectable file-by-file).

    -   The NameNode maintains the namespace tree and the mapping of
        file blocks to DataNodes (the physical location of file data).

    -   An HDFS client wanting to read a file first contacts the
        NameNode for the locations of data blocks comprising the file
        and then reads block contents from the DataNode closest to the
        client.

    -   When writing data, the client requests the NameNode to nominate
        a suite of three DataNodes to host the block replicas.

    -   The client then writes data to the DataNodes in a pipeline
        fashion. The current design has a single NameNode for each
        cluster.

    -   The cluster can have thousands of DataNodes and tens of
        thousands of HDFS clients per cluster, as each DataNode may
        execute multiple application tasks concurrently.

    -   HDFS keeps the entire namespace in RAM.

    -   The inode data and the list of blocks belonging to each file
        comprise the metadata of the name system called the image.

    -   The persistent record of the image stored in the local host's
        native files system is called a checkpoint.

    -   The NameNode also stores the modification log of the image
        called the journal in the local host's native file system.

    -   During restarts the NameNode restores the namespace by reading
        the namespace and replaying the journal. The locations of block
        replicas may change over time and are not part of the persistent
        checkpoint.

```{=html}
<!-- -->
```
-   **DataNode**: The slave node. It performs read/write operations on
    the file system as well as block operations such as creation,
    deletion, and replication.

    -   Each block replica on a DataNode is represented by two files in
        the local host's native file system.

    -   The first file contains the data itself and the second file is
        block's metadata including checksums for the block data and the
        block's generation stamp.

    -   The size of the data file equals the actual length of the block
        and does not require extra space to round it up to the nominal
        block size as in traditional file systems.

    -   Thus, if a block is half full it needs only half of the space of
        the full block on the local drive.

    -   A DataNode that is newly initialized and without any namespace
        ID is permitted to join the cluster and receive the cluster's
        namespace ID. After the handshake the DataNode registers with
        the NameNode. DataNodes persistently store their unique storage
        IDs.

    -   The storage ID is an internal identifier of the DataNode, which
        makes it recognizable even if it is restarted with a different
        IP address or port. The storage ID is assigned to the DataNode
        when it registers with the NameNode for the first time and never
        changes after that.

    -   A DataNode identifies block replicas in its possession to the
        NameNode by sending a block report. A block report contains the
        block id, the generation stamp and the length for each block
        replica the server hosts.

-   **HDFS Client** User applications access the file system using the
    HDFS client, a code library that exports the HDFS file system
    interface.

    -   Similar to most conventional file systems, HDFS supports
        operations to read, write and delete files, and operations to
        create and delete directories.

    -   The user references files and directories by paths in the
        namespace. The user application generally does not need to know
        that file system metadata and storage are on different servers,
        or that blocks have multiple replicas.

    -   When an application reads a file, the HDFS client first asks the
        NameNode for the list of DataNodes that host replicas of the
        blocks of the file. It then contacts a DataNode directly and
        requests the transfer of the desired block.

    -   When a client writes, it first asks the NameNode to choose
        DataNodes to host replicas of the first block of the file. The
        client organizes a pipeline from node-to-node and sends the
        data.

    -   Unlike conventional file systems, HDFS provides an API that
        exposes the locations of a file blocks. This allows applications
        like the MapReduce framework to schedule a task to where the
        data are located, thus improving the read performance. It also
        allows an application to **set the replication factor of a
        file.** By default a file's replication factor is three. For
        critical files or files which are accessed very often, having a
        higher replication factor improves their tolerance against
        faults and increase their read bandwidth.

-   Block: The unit of storage. A file is broken up into blocks, and
    different blocks are stored on different data nodes as per
    instructions of the namenode.

## Considerations

-   Don't store small, frequently-queried tables in HDFS, especially not
    if they consist of thousands of files.ed tables in HDFS

-   HDFS symlinks - Jobs requiring file system features like strictly
    atomic directory renames, fine-grained HDFS permissions, or HDFS
    symlinks can only work on HDFS

-   Azure Storage can be geo-replicated. Although geo-replication gives
    geographic recovery and data redundancy, a failover to the
    geo-replicated location severely impacts the performance, and it may
    incur additional costs. The recommendation is to choose the
    geo-replication wisely and only if the value of the data is worth
    the additional cost.

-   If the file names have common prefixes , the storage treats them as
    a single partition and hence if ADF is used , all DMUs write to a
    single partition.

-   ![](C:\docs\images\media\image2.png){width="4.888888888888889in"
    height="1.7569444444444444in"}

## 

## 

## 

## Migration Approach

### On premise Assessment

On premises assessment scripts can be run to plan what data is to be
migrated to the Azure Storage account. The below decision flow helps
decide the criteria and appropriate scripts can be run to get the data/
metrics. Tools like Unravel can support in getting the metrics.

###  Data Extraction

Based on the identified strategy for data migration identify the data
sets to be copied.

###  Data Migration

## 

Pre-checks prior to migration

1.  Plan the number of storage accounts needed

2.  Availability Requirements

3.  Check for corrupted/missing blocks

4.  Check if NFS is enabled

5.  Check if snapshots are needed

Data Transfer

<https://docs.microsoft.com/en-us/azure/storage/common/storage-choose-data-transfer-solution>

### Data Validation

## Feature Map & Workaround

##  

Core functionality of Hadoop Distributed File System and Azure Data Lake
Storage Gen2 comparison map is as follows:

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
| **Large Data Sets**  |                      | Applications that    |
|                      |                      | run on HDFS have     |
|                      |                      | large data sets. A   |
|                      |                      | typical file in HDFS |
|                      |                      | is gigabytes to      |
|                      |                      | terabytes in size.   |
|                      |                      | Thus, HDFS is tuned  |
|                      |                      | to support large     |
|                      |                      | files. It should     |
|                      |                      | provide high         |
|                      |                      | aggregate data       |
|                      |                      | bandwidth and scale  |
|                      |                      | to hundreds of nodes |
|                      |                      | in a single cluster. |
|                      |                      | It should support    |
|                      |                      | tens of millions of  |
|                      |                      | files in a single    |
|                      |                      | instance.            |
+----------------------+----------------------+----------------------+
| **Simple Coherency   |                      | HDFS applications    |
| Model**              |                      | need a               |
|                      |                      | write-once-read-many |
|                      |                      | access model for     |
|                      |                      | files. A file once   |
|                      |                      | created, written,    |
|                      |                      | and closed need not  |
|                      |                      | be changed except    |
|                      |                      | for appends and      |
|                      |                      | truncates. Appending |
|                      |                      | the content to the   |
|                      |                      | end of the files is  |
|                      |                      | supported but cannot |
|                      |                      | be updated at        |
|                      |                      | arbitrary point.     |
|                      |                      | This assumption      |
|                      |                      | simplifies data      |
|                      |                      | coherency issues and |
|                      |                      | enables high         |
|                      |                      | throughput data      |
|                      |                      | access. A MapReduce  |
|                      |                      | application or a web |
|                      |                      | crawler application  |
|                      |                      | fits perfectly with  |
|                      |                      | this model.          |
+----------------------+----------------------+----------------------+
| **Metadata**         | Metadata in Azure    | The NameNode is the  |
|                      | can be stored in     | arbitrator and       |
|                      | Azure Purview        | repository for all   |
|                      |                      | HDFS metadata.       |
+----------------------+----------------------+----------------------+
| **Block Size**       |                      | HDFS stores the data |
|                      |                      | in the form of the   |
|                      |                      | block where the size |
|                      |                      | of each data block   |
|                      |                      | is 128MB in size     |
|                      |                      | which is             |
|                      |                      | configurable means   |
|                      |                      | you can change it    |
|                      |                      | according to your    |
|                      |                      | requirement          |
|                      |                      | in                   |
|                      |                      | *hdfs-site.xml* file |
|                      |                      | in your Hadoop       |
|                      |                      | directory.           |
+----------------------+----------------------+----------------------+
| **File Format**      |                      |                      |
+----------------------+----------------------+----------------------+
| **Consistency        |                      |                      |
| Model**              |                      |                      |
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
| **Permission         |                      | Permissions for an   |
| inheritance**        |                      | item are stored on   |
|                      |                      | the item itself. In  |
|                      |                      | other words,         |
|                      |                      | permissions for an   |
|                      |                      | item cannot be       |
|                      |                      | inherited from the   |
|                      |                      | parent items if the  |
|                      |                      | permissions are set  |
|                      |                      | after the child item |
|                      |                      | has already been     |
|                      |                      | created.             |
|                      |                      |                      |
|                      |                      | Permissions are only |
|                      |                      | inherited if default |
|                      |                      | permissions have     |
|                      |                      | been set on the      |
|                      |                      | parent items before  |
|                      |                      | the child items have |
|                      |                      | been created.        |
+----------------------+----------------------+----------------------+
| **Data Replication** |                      | By default a file's  |
|                      |                      | replication factor   |
|                      |                      | is three. For        |
|                      |                      | critical files or    |
|                      |                      | files which are      |
|                      |                      | accessed very often, |
|                      |                      | having a higher      |
|                      |                      | replication factor   |
|                      |                      | improves their       |
|                      |                      | tolerance against    |
|                      |                      | faults and increase  |
|                      |                      | their read bandwidth |
+----------------------+----------------------+----------------------+
| **Sticky bit**       | The Sticky bit can   | In the context of    |
|                      | be set on            | Data Lake Storage    |
|                      | directories,         | Gen2, it is unlikely |
|                      | preventing anyone    | that the sticky bit  |
|                      | except the           | will be needed. In   |
|                      | superuser, directory | summary, if the      |
|                      | owner or file owner  | sticky bit is        |
|                      | from deleting or     | enabled on a         |
|                      | moving the files     | directory, a child   |
|                      | within the           | item can only be     |
|                      | directory.           | deleted or renamed   |
|                      |                      | by the child item\'s |
|                      | Setting the sticky   | owning user.         |
|                      | bit for a file has   |                      |
|                      | no effect.           | The sticky bit       |
|                      |                      | isn\'t shown in the  |
|                      |                      | Azure portal.        |
+----------------------+----------------------+----------------------+
| **The mask**         |                      | Mask limits access   |
|                      |                      | for named users, the |
|                      |                      | owning group, and    |
|                      |                      | named groups.        |
|                      |                      |                      |
|                      |                      | For a new Data Lake  |
|                      |                      | Storage Gen2         |
|                      |                      | container, the mask  |
|                      |                      | for the access ACL   |
|                      |                      | of the root          |
|                      |                      | directory (\"/\")    |
|                      |                      | defaults to 750 for  |
|                      |                      | directories          |
|                      |                      | and 640 for files.   |
|                      |                      | The following table  |
|                      |                      | shows the symbolic   |
|                      |                      | notation of these    |
|                      |                      | permission levels.   |
+----------------------+----------------------+----------------------+
| **Checksum**         |                      |                      |
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

### HA & DR

# HBase 

## Challenges of HBase on premise

## HBase Architecture and Components

## Considerations

## Migration Approach

### Modernization

### Lift and Shift -- HDInsight

### Lift and Shift -- IAAS 

## Decision Map/Flowchart

## 

## Feature Map & Workaround

Core functionality of HBase and Azure Cosmos DB comparison map is as
follows -

  **Feature**   **HBase**   **Azure Cosmos DB**
  ------------- ----------- ---------------------
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            

## Reference Implementation - ARM Templates 

TBD v2

## Pseudocode

TBD v2

## Architectural Guidance

TBD v2

### Patterns & Anti -- Patterns

### Performance Tuning

### HA & DR

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

You can [export all table
metadata](https://docs.microsoft.com/en-us/azure/databricks/kb/metastore/create-table-ddl-for-metastore)
from Hive to the Databricks default or external metastore:

1.  Use the Apache Spark Catalog API to list the tables in the databases
    contained in the metastore.

2.  Use the SHOW CREATE TABLE statement to generate the DDLs and store
    them in a file.

3.  Use the file to import the table DDLs into the external metastore.

#### Hive Data & Job Assets Migration

Once the Hive metastore have been migrated over, the actual data
residing in Hive can be migrated.

There are several tools available for the data migration:

-   [Azure Data
    Factory](https://docs.microsoft.com/en-us/azure/data-factory/connector-hive)
    -- connect directly to Hive and copy data, in a parallelized manner,
    to ADLS or [Databricks Delta
    Lake](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-databricks-delta-lake)
    (big data solution)

-   Connect to Hive via [ODBC/JDBC
    driver](https://docs.microsoft.com/en-us/azure/databricks/integrations/bi/jdbc-odbc-bi)
    and copy to Hive storing in Azure (small data option)

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

## 

## Feature Map & Workaround

Core functionality of HIVE and Azure Synapse comparison map is as
follows -

  **Feature**   **Hive**   **Synapse**
  ------------- ---------- -------------
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           

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

## Challenges of Ranger on premise

## Apache Ranger Architecture and Components

## Considerations

## Migration Approach

### Modernization -- AAD + Azure PAAS Services

### Modernization -- AAD + Synapse

### Lift and Shift -- HDInsight

### Lift and Shift -- IAAS 

## Decision Map/Flowchart

## 

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

-   [Photon
    Engine](https://techcommunity.microsoft.com/t5/analytics-on-azure/turbocharge-azure-databricks-with-photon-powered-delta-engine/ba-p/1694929) -
    a vectorized query engine that leverages modern CPU architecture to
    enhance Apache Spark 3.0's performance by up to 20x.

-   [DBIO
    Cache](https://docs.microsoft.com/en-us/azure/databricks/delta/optimizations/delta-cache) -
    Transparent caching of Parquet data on local disk

-   [Skew Join
    Optimization](https://docs.microsoft.com/en-us/azure/databricks/delta/join-performance/skew-join)

-   [Managed Delta
    Lake](https://docs.microsoft.com/en-us/azure/databricks/delta/)

-   [Managed
    MLflow](https://docs.microsoft.com/en-us/azure/databricks/applications/mlflow/)

The migration of Spark jobs onto Azure Databricks is trivial, and
requires minimal, if any, modifications to scripts. Job scripts can be
imported into Azure Databricks in bulk using the [Workspace
CLI](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/workspace-cli).

### Modernization -- Synapse

### Lift and Shift -- HDInsight

### Lift and Shift -- IAAS 

## Decision Map/Flowchart

## 

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
