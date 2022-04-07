# Migration Approach

## Assessment

## Considerations

**HDInsight Spark:**
Azure HDInsight as "A cloud-based service from Microsoft for big data analytics". It is a cloud-based service from Microsoft for big data analytics that helps organizations process large amounts of streaming or historical data.

**Main features from the HDInsight platform:**
* Fully managed
* Variety of services for multiple porpuses
* Open-source analytics service for entreprise companies


HDInsight is a service that is always up and we have to understand deeply the service to be able to configure and tunned , that make the service complex compare with others.Most of HDInsights features are Apache based. There are several cluster types to choose from depending upon your need.
[Azure HDInsight Runtime for Apache Spark 3.1](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/spark-3-1-is-now-generally-available-on-hdinsight/ba-p/3253679)

**Synapse Spark:**
Azure Synapse Analytics takes the best of Azure SQL Data Warehouse and modernizes it by providing more functionalities for the SQL developers such as adding querying with serverless SQL pool, adding machine learning support, embedding Apache Spark natively, providing collaborative notebooks, and offering data integration within a single service. In addition to the languages supported by Apache Spark, Synapse Spark also support C#.

**Synapse Spark Primary Use-Cases**

1. Consolidated type of nodes for starters to pick e.g., Small, Medium, Large node types compared to different node types.

2. Ephemeral Jobs: Synapse spark is built for short term processing and hence all the cluster have a TTL (Time to Live) and are automatically terminated to save costs.

3. Support for both reading and writing into Synapse tables.

4. Built in support for .NET for spark application enables existing user skill set to take advantage of Apache Spark distributed data processing.

![spark-synapse-options](../images/spark-synapse-options.png)

5. Unified security and monitoring features including Managed VNets throughout all workloads with one Azure Synapse workspace

6. Existing spark user to take advantage of Microsoft proprietary optimizations e.g., Hyperspace: An indexing subsystem for Apache Spark.

**Main features from Azure Synapse:**
* Complete T-SQL based analytics
* Hybrid data integration
* Apache Spark integration
HDInsight and Synapse Spark are using the same version of Apache Spark 3.1, that is a good starting point when we try to performa a migration from different platform.
as we are using the same Spark version code and jars will be able to deploy in Synapse easily.

Synapse is consumption-based, and is easier to configurate.Synapse incorporates many other Azure services and is the main plaform for Analytics and Data Orchestration.
[Azure Synapse Runtime for Apache Spark 3.1](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-3-runtime)

### Performance Considerations

Refer to [Optimize Spark jobs for performance - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-performance) for considerations.

## Planning

![image](https://user-images.githubusercontent.com/7907123/159872794-28231510-0642-4ab6-9325-24718fa35ada.png)


## Migration Approach

Azure has several landing targets for Apache Spark. Depending on requirements and product features, customers can choose between Azure Synapse, Azure Databricks and Azure HDInsight.

![image](https://user-images.githubusercontent.com/7907123/159871439-96c68799-e6a1-4495-8abf-c7d679f2e57a.png)

# Migration Scenarios

1. Moving from HDInsight Spark to Synapse Spark.


## Creating an Apache Spark Pool

An Apache Spark pool in your Synapse Workspace provides Spark environment to load data, model process and get faster insights.

Reference Link: [QuickStart: Create a serverless Apache Spark pool using the Azure portal - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/quickstart-create-apache-spark-pool-portal)

### Spark Instances

Spark instances are created when you connect to a Spark pool, create a session, and run a job. As multiple users may have access to a single Spark pool, a new Spark instance is created for each user that connects.

Examples on how the spark pools behave are shown below, Spark pools need to be created based on the usage type.

**Example 1**

* You create a Spark pool called SP1; it has a fixed cluster size of 20 nodes.

* You submit a notebook job, J1 that uses 10 nodes, a Spark instance, SI1 is created to process the job.

* You now submit another job, J2, that uses 10 nodes because there is still capacity in the pool and the instance, the J2, is processed by SI1.

* If J2 had asked for 11 nodes, there would not have been capacity in SP1 or SI1. In this case, if J2 comes from a notebook, then the job will be rejected; if J2 comes from a batch job, then it will be queued.

**Example 2**

* You create a Spark pool call SP2; it has an auto scale enabled 10 – 20 nodes.

* You submit a notebook job, J1 that uses 10 nodes, a Spark instance, SI1, is created to process the job.

* You now submit another job, J2, that uses 10 nodes, because there is still capacity in the pool the instance auto grows to 20 nodes and processes J2.

**Example 3**

* You create a Spark pool called SP1; it has a fixed cluster size of 20 nodes.

* You submit a notebook job, J1 that uses 10 nodes, a Spark instance, SI1 is created to process the job.

* Another user, U2, submits a Job, J3, that uses 10 nodes, a new Spark instance, SI2, is created to process the job.
* You now submit another job, J2, that uses 10 nodes because there's still capacity in the pool and the instance, J2, is processed by SI1.

Reference Link: [Apache Spark core concepts - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-concepts#spark-instances)

>[!NOTE] Each Synapse workspace has a default quota limit at the Workspace level and also at the Spark pool level. These requirements need to be captured during the assessment phase (Infrastructure)

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

HikariCP-2.5.1.jar
HikariCP-java7-2.4.12.jar
JavaEWAH-0.3.2.jar
RoaringBitmap-0.7.45.jar
ST4-4.0.4.jar
accessors-smart-1.2.jar
activation-1.1.1.jar
aircompressor-0.10.jar
animal-sniffer-annotations-1.17.jar
antlr-2.7.7.jar
antlr-runtime-3.4.jar
antlr4-runtime-4.7.jar
aopalliance-1.0.jar
aopalliance-repackaged-2.4.0-b34.jar
apache-log4j-extras-1.2.17.jar
arpack_combined_all-0.1.jar
arrow-format-0.15.1.jar
arrow-memory-0.15.1.jar
arrow-vector-0.15.1.jar
avro-1.8.2.jar
avro-ipc-1.8.2.jar
avro-mapred-1.8.2-hadoop2.jar
aws-java-sdk-bundle-1.11.375.jar
azure-keyvault-core-1.0.0.jar
azure-storage-7.0.1.jar
bcpkix-jdk15on-1.60.jar
bcprov-jdk15on-1.60.jar
bonecp-0.8.0.RELEASE.jar
breeze-macros_2.11-0.13.2.jar
breeze_2.11-0.13.2.jar
calcite-avatica-1.2.0-incubating.jar
calcite-core-1.2.0-incubating.jar
calcite-linq4j-1.2.0-incubating.jar
checker-qual-2.8.1.jar
chill-java-0.9.3.jar
chill_2.11-0.9.3.jar
commons-beanutils-1.9.4.jar
commons-cli-1.2.jar
commons-codec-1.10.jar
commons-collections-3.2.2.jar
commons-compiler-3.0.9.jar
commons-compress-1.8.1.jar
commons-configuration2-2.1.1.jar
commons-crypto-1.0.0.jar
commons-daemon-1.0.13.jar
commons-dbcp-1.4.jar
commons-httpclient-3.1.jar
commons-io-2.4.jar
commons-lang-2.6.jar
commons-lang3-3.5.jar
commons-logging-1.1.3.jar
commons-math3-3.4.1.jar
commons-net-3.1.jar
commons-pool-1.5.4.jar
compress-lzf-1.0.3.jar
core-1.1.2.jar
curator-client-2.12.0.jar
curator-framework-2.12.0.jar
curator-recipes-2.12.0.jar
datanucleus-api-jdo-4.2.1.jar
datanucleus-core-4.1.6.jar
datanucleus-rdbms-4.1.7.jar
derby-10.12.1.1.jar
dnsjava-2.1.7.jar
ehcache-3.3.1.jar
eigenbase-properties-1.1.5.jar
error_prone_annotations-2.3.2.jar
failureaccess-1.0.1.jar
flatbuffers-java-1.9.0.jar
fluent-logger-0.3.4.jar
geronimo-jcache_1.0_spec-1.0-alpha-1.jar
gson-2.2.4.jar
guava-28.0-jre.jar
guice-4.0.jar
guice-servlet-4.0.jar
hadoop-annotations-3.1.1.4.1.8.29.jar
hadoop-auth-3.1.1.4.1.8.29.jar
hadoop-aws-3.1.1.4.1.8.29.jar
hadoop-azure-3.1.1.4.1.8.29.jar
hadoop-client-3.1.1.4.1.8.29.jar
hadoop-common-3.1.1.4.1.8.29.jar
hadoop-hdfs-client-3.1.1.4.1.8.29.jar
hadoop-mapreduce-client-common-3.1.1.4.1.8.29.jar
hadoop-mapreduce-client-core-3.1.1.4.1.8.29.jar
hadoop-mapreduce-client-jobclient-3.1.1.4.1.8.29.jar
hadoop-openstack-3.1.1.4.1.8.29.jar
hadoop-yarn-api-3.1.1.4.1.8.29.jar
hadoop-yarn-client-3.1.1.4.1.8.29.jar
hadoop-yarn-common-3.1.1.4.1.8.29.jar
hadoop-yarn-registry-3.1.1.4.1.8.29.jar
hadoop-yarn-server-common-3.1.1.4.1.8.29.jar
hadoop-yarn-server-web-proxy-3.1.1.4.1.8.29.jar
hdinsight-spark_2_3-1.0.jar
hive-beeline-1.21.2.4.1.8.29.jar
hive-cli-1.21.2.4.1.8.29.jar
hive-exec-1.21.2.4.1.8.29.jar
hive-jdbc-1.21.2.4.1.8.29.jar
hive-metastore-1.21.2.4.1.8.29.jar
hiveref
hk2-api-2.4.0-b34.jar
hk2-locator-2.4.0-b34.jar
hk2-utils-2.4.0-b34.jar
htrace-core4-4.1.0-incubating.jar
httpclient-4.5.6.jar
httpcore-4.4.10.jar
ivy-2.4.0.jar
j2objc-annotations-1.3.jar
jackson-annotations-2.10.0.jar
jackson-core-2.10.0.jar
jackson-core-asl-1.9.13.jar
jackson-databind-2.10.0.jar
jackson-dataformat-cbor-2.10.0.jar
jackson-jaxrs-base-2.10.0.jar
jackson-jaxrs-json-provider-2.10.0.jar
jackson-mapper-asl-1.9.13.jar
jackson-module-jaxb-annotations-2.10.0.jar
jackson-module-paranamer-2.10.0.jar
jackson-module-scala_2.11-2.10.0.jar
jakarta.activation-api-1.2.1.jar
jakarta.xml.bind-api-2.3.2.jar
janino-3.0.9.jar
javassist-3.18.1-GA.jar
javax.annotation-api-1.2.jar
javax.inject-1.jar
javax.inject-2.4.0-b34.jar
javax.jdo-3.2.0-m3.jar
javax.servlet-api-3.1.0.jar
javax.ws.rs-api-2.0.1.jar
javolution-5.5.1.jar
jaxb-api-2.2.11.jar
jcip-annotations-1.0-1.jar
jcl-over-slf4j-1.7.16.jar
jdo-api-3.0.1.jar
jersey-client-2.22.2.jar
jersey-common-2.22.2.jar
jersey-container-servlet-2.22.2.jar
jersey-container-servlet-core-2.22.2.jar
jersey-guava-2.22.2.jar
jersey-media-jaxb-2.22.2.jar
jersey-server-2.22.2.jar
jetty-util-9.3.24.v20180605.jar
jetty-util-ajax-9.3.24.v20180605.jar
jetty-webapp-9.3.24.v20180605.jar
jetty-xml-9.3.24.v20180605.jar
jline-2.14.6.jar
joda-time-2.9.3.jar
jodd-core-3.5.2.jar
jpam-1.1.jar
json-20090211.jar
json-simple-1.1.jar
json-smart-2.3.jar
json4s-ast_2.11-3.5.3.jar
json4s-core_2.11-3.5.3.jar
json4s-jackson_2.11-3.5.3.jar
json4s-scalap_2.11-3.5.3.jar
jsp-api-2.1.jar
jsr305-1.3.9.jar
jta-1.1.jar
jtransforms-2.4.0.jar
jul-to-slf4j-1.7.16.jar
kafka-clients-2.1.1.4.1.8.29.jar
kerb-admin-1.0.1.jar
kerb-client-1.0.1.jar
kerb-common-1.0.1.jar
kerb-core-1.0.1.jar
kerb-crypto-1.0.1.jar
kerb-identity-1.0.1.jar
kerb-server-1.0.1.jar
kerb-simplekdc-1.0.1.jar
kerb-util-1.0.1.jar
kerby-asn1-1.0.1.jar
kerby-config-1.0.1.jar
kerby-pkix-1.0.1.jar
kerby-util-1.0.1.jar
kerby-xdr-1.0.1.jar
kryo-shaded-4.0.2.jar
leveldbjni-all-1.8.jar
libfb303-0.9.3.jar
libthrift-0.12.0.jar
listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar
log4j-1.2.17.jar
lz4-java-1.4.0.jar
machinist_2.11-0.6.1.jar
macro-compat_2.11-1.1.1.jar
mdsdclient-1.0.jar
metrics-core-3.1.5.jar
metrics-graphite-3.1.5.jar
metrics-json-3.1.5.jar
metrics-jvm-3.1.5.jar
microsoft-log4j-etwappender-1.0.jar
minlog-1.3.0.jar
msgpack-0.6.8.jar
mssql-jdbc-6.2.1.jre7.jar
netty-3.9.9.Final.jar
netty-all-4.1.42.Final.jar
nimbus-jose-jwt-4.41.1.jar
objenesis-2.5.1.jar
okhttp-2.7.5.jar
okio-1.6.0.jar
opencsv-2.3.jar
orc-core-1.5.5-nohive.jar
orc-mapreduce-1.5.5-nohive.jar
orc-shims-1.5.5.jar
oro-2.0.8.jar
osgi-resource-locator-1.0.1.jar
paranamer-2.8.jar
parquet-column-1.10.1.jar
parquet-common-1.10.1.jar
parquet-encoding-1.10.1.jar
parquet-format-2.4.0.jar
parquet-hadoop-1.10.1.jar
parquet-hadoop-bundle-1.6.0.jar
parquet-jackson-1.10.1.jar
peregrine-core-0.4-SNAPSHOT.jar
peregrine-spark-0.4-SNAPSHOT.jar
peregrine-tools-0.2.0-SNAPSHOT.jar
protobuf-java-2.5.0.jar
py4j-0.10.7.jar
pyrolite-4.13.jar
re2j-1.1.jar
rolling_upgrade.sh
rubix-bookkeeper-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-core-0.3.0.2.6.99.201-SNAPSHOT-tests.jar
rubix-core-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-hadoop1-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-hadoop2-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-presto-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-rpm-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-spi-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-tests-0.3.0.2.6.99.201-SNAPSHOT-tests.jar
rubix-tests-0.3.0.2.6.99.201-SNAPSHOT.jar
scala-compiler-2.11.12.jar
scala-library-2.11.12.jar
scala-parser-combinators_2.11-1.1.0.jar
scala-reflect-2.11.12.jar
scala-xml_2.11-1.0.5.jar
shapeless_2.11-2.3.2.jar
shims-0.7.45.jar
slf4j-api-1.7.16.jar
slf4j-log4j12-1.7.16.jar
snappy-0.2.jar
snappy-java-1.1.7.3.jar
spark-catalyst_2.11-2.4.4.4.1.8.29.jar
spark-core_2.11-2.4.4.4.1.8.29.jar
spark-enhancement_2.11-2.3.7.jar
spark-graphx_2.11-2.4.4.4.1.8.29.jar
spark-hadoop-cloud_2.11-2.4.4.4.1.8.29.jar
spark-hive-thriftserver_2.11-2.4.4.4.1.8.29.jar
spark-hive_2.11-2.4.4.4.1.8.29.jar
spark-kvstore_2.11-2.4.4.4.1.8.29.jar
spark-launcher_2.11-2.4.4.4.1.8.29.jar
spark-mllib-local_2.11-2.4.4.4.1.8.29.jar
spark-mllib_2.11-2.4.4.4.1.8.29.jar
spark-network-common_2.11-2.4.4.4.1.8.29.jar
spark-network-shuffle_2.11-2.4.4.4.1.8.29.jar
spark-repl_2.11-2.4.4.4.1.8.29.jar
spark-sketch_2.11-2.4.4.4.1.8.29.jar
spark-sql-kafka-0-10_2.11-2.4.4.4.1.8.29.jar
spark-sql_2.11-2.4.4.4.1.8.29.jar
spark-streaming-kafka-0-10-assembly_2.11-2.4.4.4.1.8.29.jar
spark-streaming-kafka-0-10_2.11-2.4.4.4.1.8.29.jar
spark-streaming_2.11-2.4.4.4.1.8.29.jar
spark-tags_2.11-2.4.4.4.1.8.29.jar
spark-unsafe_2.11-2.4.4.4.1.8.29.jar
spark-yarn_2.11-2.4.4.4.1.8.29.jar
spire-macros_2.11-0.13.0.jar
spire_2.11-0.13.0.jar
stax-api-1.0.1.jar
stax2-api-3.1.4.jar
storm
stream-2.7.0.jar
stringtemplate-3.2.1.jar
super-csv-2.2.0.jar
token-provider-1.0.1.jar
transaction-api-1.1.jar
univocity-parsers-2.7.3.jar
validation-api-1.1.0.Final.jar
wildfly-openssl-1.0.7.Final.jar
woodstox-core-5.0.3.jar
xbean-asm6-shaded-4.8.jar
xz-1.5.jar
zookeeper-3.4.6.4.1.8.29.jar
zstd-jni-1.3.2-2.jar
![image](https://user-images.githubusercontent.com/7907123/162150363-8e821bd8-76b6-4b54-9cd2-c3f69b7cb57d.png)


# HDInsight 3.1 Libraries
HikariCP-2.5.1.jar
JLargeArrays-1.5.jar
JTransforms-3.1.jar
RoaringBitmap-0.9.0.jar
ST4-4.0.4.jar
accessors-smart-1.2.jar
activation-1.1.1.jar
aircompressor-0.10.jar
algebra_2.12-2.0.0-M2.jar
animal-sniffer-annotations-1.17.jar
antlr-runtime-3.5.2.jar
antlr4-runtime-4.8-1.jar
aopalliance-1.0.jar
aopalliance-repackaged-2.6.1.jar
apache-log4j-extras-1.2.17.jar
arpack_combined_all-0.1.jar
arrow-format-2.0.0.jar
arrow-memory-core-2.0.0.jar
arrow-memory-netty-2.0.0.jar
arrow-vector-2.0.0.jar
avro-1.8.2.jar
avro-ipc-1.8.2.jar
avro-mapred-1.8.2-hadoop2.jar
aws-java-sdk-bundle-1.11.375.jar
azure-keyvault-core-1.0.0.jar
azure-storage-7.0.1.jar
bcpkix-jdk15on-1.60.jar
bcprov-jdk15on-1.60.jar
bonecp-0.8.0.RELEASE.jar
breeze-macros_2.12-1.0.jar
breeze_2.12-1.0.jar
cats-kernel_2.12-2.0.0-M4.jar
checker-qual-2.8.1.jar
chill-java-0.9.5.jar
chill_2.12-0.9.5.jar
commons-beanutils-1.9.4.jar
commons-cli-1.2.jar
commons-codec-1.10.jar
commons-collections-3.2.2.jar
commons-compiler-3.0.16.jar
commons-compress-1.20.jar
commons-configuration2-2.1.1.jar
commons-crypto-1.1.0.jar
commons-daemon-1.0.13.jar
commons-dbcp-1.4.jar
commons-httpclient-3.1.jar
commons-io-2.5.jar
commons-lang-2.6.jar
commons-lang3-3.10.jar
commons-logging-1.1.3.jar
commons-math3-3.4.1.jar
commons-net-3.1.jar
commons-pool-1.5.4.jar
commons-pool2-2.6.2.jar
commons-text-1.6.jar
compress-lzf-1.0.3.jar
core-1.1.2.jar
curator-client-2.12.0.jar
curator-framework-2.12.0.jar
curator-recipes-2.12.0.jar
datanucleus-api-jdo-4.2.4.jar
datanucleus-core-4.1.6.jar
datanucleus-rdbms-4.1.19.jar
derby-10.12.1.1.jar
dnsjava-2.1.7.jar
dropwizard-metrics-hadoop-metrics2-reporter-0.1.2.jar
ehcache-3.3.1.jar
error_prone_annotations-2.3.2.jar
failureaccess-1.0.1.jar
flatbuffers-java-1.9.0.jar
fluent-logger-0.3.4.jar
geronimo-jcache_1.0_spec-1.0-alpha-1.jar
gson-2.2.4.jar
guava-28.0-jre.jar
guice-4.0.jar
guice-servlet-4.0.jar
hadoop-annotations-3.1.1.5.0.3.25.jar
hadoop-auth-3.1.1.5.0.3.25.jar
hadoop-aws-3.1.1.5.0.3.25.jar
hadoop-azure-3.1.1.5.0.3.25.jar
hadoop-client-3.1.1.5.0.3.25.jar
hadoop-common-3.1.1.5.0.3.25.jar
hadoop-hdfs-client-3.1.1.5.0.3.25.jar
hadoop-mapreduce-client-common-3.1.1.5.0.3.25.jar
hadoop-mapreduce-client-core-3.1.1.5.0.3.25.jar
hadoop-mapreduce-client-jobclient-3.1.1.5.0.3.25.jar
hadoop-openstack-3.1.1.5.0.3.25.jar
hadoop-yarn-api-3.1.1.5.0.3.25.jar
hadoop-yarn-client-3.1.1.5.0.3.25.jar
hadoop-yarn-common-3.1.1.5.0.3.25.jar
hadoop-yarn-registry-3.1.1.5.0.3.25.jar
hadoop-yarn-server-common-3.1.1.5.0.3.25.jar
hadoop-yarn-server-web-proxy-3.1.1.5.0.3.25.jar
hdinsight-spark_3_0-1.0.jar
hive-beeline-2.3.7.jar
hive-cli-2.3.7.jar
hive-common-2.3.7.jar
hive-exec-2.3.7-core.jar
hive-jdbc-2.3.7.jar
hive-llap-common-2.3.7.jar
hive-metastore-2.3.7.jar
hive-serde-2.3.7.jar
hive-service-rpc-3.1.2.jar
hive-shims-0.23-2.3.7.jar
hive-shims-2.3.7.jar
hive-shims-common-2.3.7.jar
hive-shims-scheduler-2.3.7.jar
hive-storage-api-2.7.2.jar
hive-vector-code-gen-2.3.7.jar
hiveref
hk2-api-2.6.1.jar
hk2-locator-2.6.1.jar
hk2-utils-2.6.1.jar
htrace-core4-4.1.0-incubating.jar
httpclient-4.5.6.jar
httpcore-4.4.12.jar
istack-commons-runtime-3.0.8.jar
ivy-2.4.0.jar
j2objc-annotations-1.3.jar
jackson-annotations-2.10.0.jar
jackson-core-2.10.0.jar
jackson-core-asl-1.9.13.jar
jackson-databind-2.10.0.jar
jackson-dataformat-cbor-2.10.0.jar
jackson-jaxrs-base-2.10.0.jar
jackson-jaxrs-json-provider-2.10.0.jar
jackson-mapper-asl-1.9.13.jar
jackson-module-jaxb-annotations-2.10.0.jar
jackson-module-paranamer-2.10.0.jar
jackson-module-scala_2.12-2.10.0.jar
jakarta.activation-api-1.2.1.jar
jakarta.annotation-api-1.3.5.jar
jakarta.inject-2.6.1.jar
jakarta.servlet-api-4.0.3.jar
jakarta.validation-api-2.0.2.jar
jakarta.ws.rs-api-2.1.6.jar
jakarta.xml.bind-api-2.3.2.jar
janino-3.0.16.jar
javassist-3.25.0-GA.jar
javax.inject-1.jar
javax.jdo-3.2.0-m3.jar
javolution-5.5.1.jar
jaxb-api-2.2.11.jar
jaxb-runtime-2.3.2.jar
jcip-annotations-1.0-1.jar
jcl-over-slf4j-1.7.30.jar
jdo-api-3.0.1.jar
jersey-client-2.30.jar
jersey-common-2.30.jar
jersey-container-servlet-2.30.jar
jersey-container-servlet-core-2.30.jar
jersey-entity-filtering-2.30.jar
jersey-hk2-2.30.jar
jersey-media-jaxb-2.30.jar
jersey-media-json-jackson-2.30.jar
jersey-server-2.30.jar
jetty-util-9.4.40.v20210413.jar
jetty-util-ajax-9.4.40.v20210413.jar
jline-2.14.6.jar
joda-time-2.10.5.jar
jodd-core-3.5.2.jar
jpam-1.1.jar
json-1.8.jar
json-20090211.jar
json-simple-1.1.jar
json-smart-2.3.jar
json4s-ast_2.12-3.7.0-M5.jar
json4s-core_2.12-3.7.0-M5.jar
json4s-jackson_2.12-3.7.0-M5.jar
json4s-scalap_2.12-3.7.0-M5.jar
jsp-api-2.1.jar
jsr305-3.0.0.jar
jta-1.1.jar
jul-to-slf4j-1.7.30.jar
kafka-clients-2.4.1.5.0.3.25.jar
kerb-admin-1.0.1.jar
kerb-client-1.0.1.jar
kerb-common-1.0.1.jar
kerb-core-1.0.1.jar
kerb-crypto-1.0.1.jar
kerb-identity-1.0.1.jar
kerb-server-1.0.1.jar
kerb-simplekdc-1.0.1.jar
kerb-util-1.0.1.jar
kerby-asn1-1.0.1.jar
kerby-config-1.0.1.jar
kerby-pkix-1.0.1.jar
kerby-util-1.0.1.jar
kerby-xdr-1.0.1.jar
kryo-shaded-4.0.2.jar
leveldbjni-all-1.8.jar
libfb303-0.9.3.jar
libthrift-0.12.0.jar
listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar
log4j-1.2.17.jar
lz4-java-1.7.1.jar
machinist_2.12-0.6.8.jar
macro-compat_2.12-1.1.1.jar
mdsdclient-1.0.jar
metrics-core-4.1.1.jar
metrics-graphite-4.1.1.jar
metrics-jmx-4.1.1.jar
metrics-json-4.1.1.jar
metrics-jvm-4.1.1.jar
microsoft-log4j-etwappender-1.0.jar
minlog-1.3.0.jar
msgpack-0.6.8.jar
netty-all-4.1.51.Final.jar
nimbus-jose-jwt-4.41.1.jar
objenesis-2.6.jar
okhttp-2.7.5.jar
okio-1.14.0.jar
opencsv-2.3.jar
orc-core-1.5.12.jar
orc-mapreduce-1.5.12.jar
orc-shims-1.5.12.jar
oro-2.0.8.jar
osgi-resource-locator-1.0.3.jar
paranamer-2.8.jar
parquet-column-1.10.1.jar
parquet-common-1.10.1.jar
parquet-encoding-1.10.1.jar
parquet-format-2.4.0.jar
parquet-hadoop-1.10.1.jar
parquet-jackson-1.10.1.jar
peregrine-tools-0.2.0-SNAPSHOT.jar
protobuf-java-2.5.0.jar
py4j-0.10.9.jar
pyrolite-4.30.jar
re2j-1.1.jar
rolling_upgrade.sh
rubix-bookkeeper-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-core-0.3.0.2.6.99.201-SNAPSHOT-tests.jar
rubix-core-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-hadoop1-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-hadoop2-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-presto-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-rpm-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-spi-0.3.0.2.6.99.201-SNAPSHOT.jar
rubix-tests-0.3.0.2.6.99.201-SNAPSHOT-tests.jar
rubix-tests-0.3.0.2.6.99.201-SNAPSHOT.jar
scala-collection-compat_2.12-2.1.1.jar
scala-compiler-2.12.10.jar
scala-library-2.12.10.jar
scala-parser-combinators_2.12-1.1.2.jar
scala-reflect-2.12.10.jar
scala-xml_2.12-1.2.0.jar
shapeless_2.12-2.3.3.jar
shims-0.9.0.jar
slf4j-api-1.7.30.jar
slf4j-log4j12-1.7.16.jar
snappy-java-1.1.8.2.jar
spark-avro_2.12-3.1.2.5.0.3.25.jar
spark-catalyst_2.12-3.1.2.5.0.3.25.jar
spark-core_2.12-3.1.2.5.0.3.25.jar
spark-enhancement_2.12-3.1.2.5.0.3.25.jar
spark-enhancementui_2.12-1.1.0.jar
spark-graphx_2.12-3.1.2.5.0.3.25.jar
spark-hadoop-cloud_2.12-3.1.2.5.0.3.25.jar
spark-hive-thriftserver_2.12-3.1.2.5.0.3.25.jar
spark-hive_2.12-3.1.2.5.0.3.25.jar
spark-kvstore_2.12-3.1.2.5.0.3.25.jar
spark-launcher_2.12-3.1.2.5.0.3.25.jar
spark-microsoft-telemetry_2.12-3.1.2.5.0.3.25.jar
spark-microsoft-tools_2.12-3.1.2.5.0.3.25.jar
spark-mllib-local_2.12-3.1.2.5.0.3.25.jar
spark-mllib_2.12-3.1.2.5.0.3.25.jar
spark-network-common_2.12-3.1.2.5.0.3.25.jar
spark-network-shuffle_2.12-3.1.2.5.0.3.25.jar
spark-repl_2.12-3.1.2.5.0.3.25.jar
spark-sketch_2.12-3.1.2.5.0.3.25.jar
spark-sql-kafka-0-10_2.12-3.1.2.5.0.3.25.jar
spark-sql_2.12-3.1.2.5.0.3.25.jar
spark-streaming-kafka-0-10-assembly_2.12-3.1.2.5.0.3.25.jar
spark-streaming-kafka-0-10_2.12-3.1.2.5.0.3.25.jar
spark-streaming_2.12-3.1.2.5.0.3.25.jar
spark-tags_2.12-3.1.2.5.0.3.25.jar
spark-token-provider-kafka-0-10_2.12-3.1.2.5.0.3.25.jar
spark-unsafe_2.12-3.1.2.5.0.3.25.jar
spark-yarn_2.12-3.1.2.5.0.3.25.jar
spire-macros_2.12-0.17.0-M1.jar
spire-platform_2.12-0.17.0-M1.jar
spire-util_2.12-0.17.0-M1.jar
spire_2.12-0.17.0-M1.jar
stax-api-1.0.1.jar
stax2-api-3.1.4.jar
storm
stream-2.9.6.jar
super-csv-2.2.0.jar
threeten-extra-1.5.0.jar
token-provider-1.0.1.jar
transaction-api-1.1.jar
univocity-parsers-2.9.1.jar
velocity-1.5.jar
wildfly-openssl-1.0.7.Final.jar
woodstox-core-5.0.3.jar
xbean-asm7-shaded-4.15.jar
xz-1.5.jar
zookeeper-3.4.6.5.0.3.25.jar
zstd-jni-1.4.8-1.jar
![image](https://user-images.githubusercontent.com/7907123/162150413-5b3babbd-7426-40d1-b042-40f3312dffd8.png)


# Synapse Spark Libraries

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
