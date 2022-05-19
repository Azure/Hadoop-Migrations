# Migration Approach

## Assessment
### Basic information
For basic information about cluster configuration, please refer to the following documentation:

- [Metadata assessment](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/hive/migration-approach.md#metadata)
- [Planning and Sizing for Azure Compute & Storage](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/hbase/migration-approach.md#lift-and-shift-migration-to-azure-iaas)


- Spark version
- Python, Scala, Java, R? version
- Current network/security configuration

## Considerations

**HDInsight Spark:**
Azure HDInsight as "A cloud-based service from Microsoft for big data analytics". It is a cloud-based service from Microsoft for big data analytics that helps organizations process large amounts of streaming or historical data.

**Main features from the HDInsight platform:**
* Fully managed
* Variety of services for multiple porpuses
* Open-source analytics service for entreprise companies


HDInsight is a service that is always up and we have to understand deeply the service to be able to configure and tunned, that make the service complex compare with others. Most of HDInsight features are Apache based. There are several cluster types to choose from depending upon your need.
[Azure HDInsight Runtime for Apache Spark 3.1](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/spark-3-1-is-now-generally-available-on-hdinsight/ba-p/3253679)

**Synapse Spark:**

Azure Synapse Analytics takes the best of Azure SQL Data Warehouse and modernizes it by providing more functionalities for the SQL developers such as adding querying with serverless SQL pool, adding machine learning support, embedding Apache Spark natively, providing collaborative notebooks, and offering data integration within a single service. In addition to the languages supported by Apache Spark, Synapse Spark also support C#.

**Synapse Spark Primary Use-Cases**

Please refer to [Synapse Spark Primary Use-Cases](../spark/migration-approach.md#synapse-spark-primary-use-cases) for the primary use cases of Synapse Spark.

**Main features from Azure Synapse:**
* Complete T-SQL based analytics
* Hybrid data integration
* Apache Spark integration
HDInsight and Synapse Spark are using the same version of Apache Spark 3.1, that is a good starting point when we try to performa a migration from different platform.
as we are using the same Spark version code and jars will be able to deploy in Synapse easily.

Synapse is consumption-based, and is easier to configurate.Synapse incorporates many other Azure services and is the main plaform for Analytics and Data Orchestration.
[Azure Synapse Runtime for Apache Spark 3.1](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-3-runtime)

### Networking Considerations
The networking options available for HDInsight and Synapse Spark Pool are different, so it's important to understand the differences when planning your migration.

**The main networking options available in HDInsight**

|Option|Notes|
|---|---|
|[Virtual Network](https://docs.microsoft.com/azure/hdinsight/hdinsight-virtual-network-architecture)|HDInsight clusters can be deployed within virtual networks. Users can control the virtual network, such as by applying NSG rules, deploying NVA, etc.|
|[Private Link](https://docs.microsoft.com/azure/hdinsight/hdinsight-private-link)|HDInsight's Private Link is used to make private connections to HDInsight clusters over the Microsoft backbone network. Communication with cluster-dependent resources (storage, metastore, KeyValut, etc.) can also be configured by adding a Private Link connection with the cluster.|

**The main networking options available in Synapse Spark Pool**

|Option|Notes|
|---|---|
|[Managed Virtual Network](https://docs.microsoft.com/azure/synapse-analytics/security/synapse-workspace-managed-vnet)|Synapse workspaces can be associated with virtual networks. This virtual network is managed by Azure Synapse, so users can't control it like a normal virtual network, for example by applying their own NSG rules.|
|[Private Endpoint](https://docs.microsoft.com/azure/synapse-analytics/security/how-to-connect-to-workspace-with-private-links)|An endpoint for connecting to the Synapse workspace. The following three types of target sub resources can be selected. Sql --For executing SQL queries in the Dedicated SQL Pool, SqlOnDemand --For executing SQL queries in Serverless SQL Pool, Dev --For accessing everything in the workspace|
|[Managed Private Endpoint](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-managed-private-endpoints)|Deployed within a managed virtual network. Endpoint for Synapse to connect privately to Azure resources.|
|[Private Link Hub](https://docs.microsoft.com/azure/synapse-analytics/security/synapse-private-link-hubs)|For connecting to Azure Synapse Studio from a virtual network using a private link.|

### Performance Considerations

Refer to [Optimize Spark jobs for performance - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-performance) for considerations.

### Job Scheduling Considerations

There are also differences in job management between HDInsight and Synapse Spark Pool. It is important to understand the difference between them.

Both HDInsight and Synapse Spark Pool use [YARN](https://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/YARN.html) as their job scheduler. YARN can be [controlled by the user on HDInsight](https://docs.microsoft.com/azure/hdinsight/hdinsight-troubleshoot-yarn). For instance, setting various parameters, getting logs using yarn command, managing queues, setting using REST API and collecting metrics, etc,. [Synapse Spark Pool](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-overview#spark-pool-architecture) also uses YARN as a cluster manager. Therefore, the mechanism for job execution and resource management is the same. However, Synapse Spark Pool does not open an interface for users to directly manage YARN and does not need to be managed by users like HDInsight. Also, Synapse Spark Pool is not designed for multi-user use on a single cluster. See [Q&A] (https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-faq#can-i-run-a-multi-user-spark-cluster-in-azure-synapse-analytics-) for more detail and solutions.


## Migration Approach

The following steps can be used as a migration approach.


![image](https://user-images.githubusercontent.com/7907123/159871439-96c68799-e6a1-4495-8abf-c7d679f2e57a.png)

# Migration Scenarios

1. Moving from HDInsight Spark to Synapse Spark.


## Creating an Apache Spark Pool

An Apache Spark pool in your Synapse Workspace provides Spark environment to load data, model process and get faster insights.
Spark instances are created when you connect to a Spark pool, create a session, and run a job. As multiple users may have access to a single Spark pool, a new Spark instance is created for each user that connects. Please refer to [Creating an Apache Spark Pool](../spark/migration-approach.md#creating-an-apache-spark-pool).

## Set up Linked service with external HDInsight Hive Meta Store (HMS)
**Shared Metadata**
Azure Synapse Analytics allows the different workspace computational engines to share databases and Parquet-backed tables between Apache Spark pools and other External Metasotres. More information is available from the below link: 

[External metadata tables - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-external-metastore)

## Metadata migration from External to Manage Metastore
**Shared Metadata**
Once we have conected to the External HDInsight Metastore moved the external to a Manage tables:
Reference: [Shared metadata tables - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/metadata/table)

## Data Migration:
Synapse Spark supports reading multiple different file formats (ORC, Parquet etc.) so use the same migration strategy as on-premises HDFS migration.

### Migrate HDFS Store to Azure Data Lake Storage Gen2

The key challenge for customers with existing on-premises Hadoop clusters that wish to migrate to Azure (or exist in a hybrid environment) is the movement of the existing dataset. The dataset may be very large, which likely rules out online transfer. Transfer volume can be solved by using Azure Data Box as a physical appliance to 'ship' the data to Azure.

This set of scripts provides specific support for moving big data analytics datasets from an on-premises HDFS cluster to ADLS Gen2 using a variety of Hadoop and custom tooling.

### Selecting a data transfer solution
Answer the following questions to help select a data transfer solution:

* **Is your available network bandwidth limited or non-existent, and you want to transfer large datasets?**

If yes, see: [Scenario 1: Transfer large datasets with no or low network bandwidth.](https://docs.microsoft.com/en-us/azure/storage/common/storage-solution-large-dataset-low-network)

* **Do you want to transfer large datasets over network and you have a moderate to high network bandwidth?**

If yes, see: [Scenario 2: Transfer large datasets with moderate to high network bandwidth.](https://docs.microsoft.com/en-us/azure/storage/common/storage-solution-large-dataset-moderate-high-network)

* **Do you want to occasionally transfer just a few files over the network?**

If yes, see [Scenario 3: Transfer small datasets with limited to moderate network bandwidth.](https://docs.microsoft.com/en-us/azure/storage/common/storage-solution-small-dataset-low-moderate-network)

* **Are you looking for point-in-time data transfer at regular intervals?**

If yes, use the scripted/programmatic options outlined in [Scenario 4: Periodic data transfers.](https://docs.microsoft.com/en-us/azure/storage/common/storage-solution-periodic-data-transfer)

* **Are you looking for on-going, continuous data transfer?**

If yes, use the options in [Scenario 4: Periodic data transfers.](https://docs.microsoft.com/en-us/azure/storage/common/storage-solution-periodic-data-transfer)

More information on the following link : [Data Transfer Solution | Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/common/storage-choose-data-transfer-solution?toc=/azure/storage/blobs/toc.json) 

### Data Migration Summary:

Spark is a processing framework and does not store any data, once the processing is complete an appropriate sink needs to be chosen.


**AZcopy data from HDFS to ADLS**
You can see more details in the following repository:[Import and Export data between HDInsight HDFS to Synapse ADLS - AZcopy| Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)

**Distcp data from HDFS to ADLS**
You can see more details in the following repository:[Import and Export data between HDInsight HDFS to Synapse ADLS - Distcp| Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-distcp)

**ADF from HDFS to ADLS**
You can see more details in the following repository:[Import and Export data between HDInsight HDFS to Synapse ADLS - ADF| Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/connector-hdfs?tabs=data-factory)

**Data Movement Library data from HDFS to ADLS**
You can see more details in the following repository:[Import and Export data between HDInsight HDFS to Synapse ADLS - ADF| Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-data-movement-library)

**DataBox data from HDFS to ADLS**
You can see more details in the following repository:[Import and Export data between HDInsight HDFS to Synapse ADLS - Data Box| Microsoft Docs](https://github.com/Azure/databox-adls-loader)

### Size vs Bandwith Diagram

![image](https://user-images.githubusercontent.com/7907123/159869475-73ef93fc-3a07-467f-994a-0f352a635f4b.png)
Image source : https://docs.microsoft.com/azure/storage/common/storage-choose-data-transfer-solution

### Summary table


| HDInsight         | Synapse               | Scenario               | Tool        |Reference Links|
| ------------------- | -------------------- | -------------------- | --------------  |--------------|
| HDFS      | ADLS       | Small Datasets-Low Bandwith              |      AZcopy           |[Import and Export data between HDInsight HDFS to Synapse ADLS - AZcopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)|
| HDFS      | ADLS       | Small Datasets-High Bandwith             |      Distcp           |[Import and Export data between HDInsight HDFS to Synapse ADLS - Distcp](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-distcp)|
| HDFS      | ADLS       | Big Datasets-High Bandwith       |      ADF           |[Import and Export data between HDInsight HDFS to Synapse ADLS - ADF](https://docs.microsoft.com/en-us/azure/data-factory/connector-hdfs?tabs=data-factory)|
| HDFS      | ADLS       | Big Datasets-High Bandwith       |      Data Movement Library           |[Import and Export data between HDInsight HDFS to Synapse ADLS - Data Library Movement](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-data-movement-library)|
| HDFS      | ADLS       | Big Datasets-Low Bandwith       |      DataBox           |[Import and Export data between HDInsight HDFS to Synapse ADLS - DataBox](https://github.com/Azure/databox-adls-loader)|

## Code migration
In order to migrate all the notebooks/code that we have in other environments customers will need to use the import button, when creates a new notbook as we can see in the following picture:

![image](https://user-images.githubusercontent.com/7907123/159870008-247c21d3-bb7e-45c2-8d66-2256456bb23c.png)

Then depending of the Spark version you should perform the commented changes that this link shows:

[Spark 2.4 to 3.0](https://spark.apache.org/docs/latest/sql-migration-guide.html#upgrading-from-spark-sql-24-to-30)

[Spark 3.0 to 3.1](https://spark.apache.org/docs/latest/sql-migration-guide.html#upgrading-from-spark-sql-30-to-31)

[Spark 3.1 to 3.2](https://spark.apache.org/docs/latest/sql-migration-guide.html#upgrading-from-spark-sql-31-to-32)

# HDInsight 2.4 Libraries

![image](https://user-images.githubusercontent.com/7907123/162150363-8e821bd8-76b6-4b54-9cd2-c3f69b7cb57d.png)

# HDInsight 3.1 Libraries

![image](https://user-images.githubusercontent.com/7907123/162150413-5b3babbd-7426-40d1-b042-40f3312dffd8.png)

# Synapse Spark 2.4 Libraries
[Spark libraries - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-24-runtime)

# Synapse Spark 3.1 Libraries

[Spark libraries - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-3-runtime)

## Monitoring

Reference link for monitoring Spark application: [Monitor Apache Spark applications using Synapse Studio - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/monitoring/apache-spark-applications)

## Performance benchmarking approach

[Apache Spark in Azure Synapse - Performance Update](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/apache-spark-in-azure-synapse-performance-update/ba-p/2243534)

### Performance Optimization

[Optimize Apache Spark jobs in Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-performance)

## Security

Security is a joint responsibility of you and your database provider. HDInsight and Azure Synapse have slightly different scope of customer control. We recommend that you consider migrating your system's security implementation using the following checklist.

|Security area|HDInsight|Synapse|
|----|----|----|
|Data Protection|You can configure Azure Storage firewalls and virtual networks to configure target access control list ACLs. This allows you to protect access to your storage. |Same as HDInsight.|
||By enabling the `Secure transfer required` property on the storage account, storage account can be configured to accept only requests from secure connections.|Same as HDInsight.|
||HDInsight supports multiple types of encryption. Server-side encryption (SSE) used to encrypt OS and data disks. Encryption on the host with a platform managed key for temporary disks. Save encryption using customer-managed keys available for data and temporary discs. |You can set storage encryption as well. Apache Spark pools are analytics engines that run directly on Azure Data Lake Gen2 (ALDS Gen2) or Azure Blob Storage. These analytics runtimes have no persistent storage and use Azure Storage encryption technology to protect their data. |
|Access Control|HDInsight uses your Azure AD account to manage your resources. You can integrate with Azure RBAC and use Azure AD roles to restrict access. HDInsight uses Apache Ranger to give you more control over permissions. |Azure Synapse has [Synapse Role-Based Access Control (RBAC) Roles](https://docs.microsoft.com/azure/synapse-analytics/security/synapse-workspace-) that manages various aspects of Synapse Studio. understand-what-role-you-need) is also included. Leverage these built-in roles to assign permissions to users, groups, or other security her principals and manage users.|
||You can use Apache Ranger to create and manage fine-grained access control and data obfuscation policies for files, folders, databases, tables, rows, and columns. |Spark Pool supports table-level access control.|
|Authentication|Azure AD is used as the default identity and access management service. Configure an Azure HDInsight cluster with the Enterprise Security Package (ESP). You can connect these clusters to your domain so that users can authenticate with them using their domain credentials. |Synapse Apache Spark pool only supports Azure AD authentication.|
||Service Principal and Managed Identity are supported|Multi-factor authentication and managed identities are fully supported in Azure Synapse, dedicated SQL pools (formerly SQL DW), serverless SQL pools, and Apache Spark pools. |
|Network Security|Perimeter security is achieved using virtual networks. You can create a cluster in a virtual network and use a network security group (NSG) to limit access to the virtual network. |You can use Synapse's Managed Virtual Network to associate Synapse Workspace with a Virtual Network to control access from the outside.|
||Use Azure Private Link to enable private access to HDInsight from your virtual network without going through the internet. You can use Azure Private Link to access Synapse Workspace from a virtual network without going through the internet. |You can use Azure Private Link to access Synapse Workspace from a virtual network without going through the internet.|
||You can use Azure Firewall to protect your applications and services from potentially malicious traffic from the Internet and other external locations. |You can use managed VNets and workspace-level network isolation to protect services at the network level.|
|Threat Protection|All Azure services, including PaaS services such as zure Synapse, are protected by DDoS basic protection to mitigate malicious attacks (active traffic monitoring, constant detection, automatic attack mitigation). |Same as HDInsight|
||HDInsight does not natively support Defender and uses ClamAV. However, when using ESP for HDInsight, you can use some of the built-in threat detection capabilities of Microsoft Defender for Cloud. You can also enable Microsoft Defender for the VMs associated with HDInsight. |As one of the options available in Microsoft Defender for Cloud, Microsoft Defender for SQL extends the Defender for Cloud security package to protect your database. You can detect and mitigate potential database vulnerabilities by detecting anomalous activity that can pose a potential threat to your database. Specifically, it continuously monitors the database for the following items:|

References

- [Overview of enterprise security in Azure HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/domain-joined/hdinsight-security-overview)
- [Azure security baseline for HDInsight](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/hdinsight-security-baseline)
- [Azure Synapse Analytics security white paper: Introduction](https://docs.microsoft.com/ja-jp/azure/synapse-analytics/guidance/security-white-paper-introduction)


## BC-DR

## Further Reading

[Spark Architecture and Components](readme.md)

[Considerations](considerations.md)

[Databricks Migration](databricks-migration.md)
