# Migration Approach

Azure has several landing targets for Apache Storm. Depending on requirements and product features, customers can choose between Azure IaaS, Azure HDInsight, Azure Stream Analytics or Azure Fuctions.

Landing Targets for Apache Storm on Azure

![Landing Targets for Apache Storm on Azure](../images/flowchart-storm-azure-landing-targets.png)

- [Lift and shift migration to Azure IaaS](#lift-and-shift-migration-to-azure-iaas)
- [Migration to Spark Streaming on Azure HDInsight or Azure Databricks](#migration-to-spark-streaming-on-azure-hdinsight-or-azure-databricks)
- [Migration to Azure Stream Analytics](#migration-to-azure-stream-analytics)
- [Migration to Azure Functions](#migration-to-azure-functions)

See [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/stream-processing) for a detailed comparison of stream processing technology in Azure. 

## Lift and shift migration to Azure IaaS  

### Planning

## Migration to Spark Streaming on Azure HDInsight or Azure Databricks

### Planning

### Migration

## Migration to Azure Stream Analytics

Azure Stream Analytics is a real-time analytics and complex event processing engine for large amounts of streaming data. Stream Analytics consists of inputs, queries, and outputs. With just a few clicks, you can connect to an input source for streaming data, enter a query, and connect to an output destination to create an end-to-end pipeline. Queries can easily filter, sort, aggregate, and join streaming data over a period of time using SQL-based queries. The SQL language can also be extended with JavaScript and C # user-defined functions (UDFs). 

When choosing Stream Analytics, also see [Cases where Stream Analytics is suitable and cases where other technologies are used](https://docs.microsoft.com/en-us/azure/stream-analytics/streaming-technologies). 


### Difference between Storm and Stream Analytics 

#### Storm Topology and Stream Analytics

|Storm Topoloby|Stream Analytics|
|--------------|----------------|
|Tuple|Event|
|Spout|Input|
|Bolt|Query, Output|


#### Connectors
The following is a comparison of Storm's typical connector and Stream Analytics Input / Output. 

|Storm||Stream Analytics||Description|
|--|--|--|--|--|
|Spout|Kafka|Input|N/A|Can connect to Apache Kafka for Event Hubs.|
||HDFS||N/A|Stream Analytics cannot consume HDFS data directly. Configure the Blob Storage or Data Lake Storage Gen2 to contain the required data. |
||Azure Event Hub||Azure Event Hub||
||N/A||Azure IoT Hub||
||N/A||Azure Blob Storage||
||N/A||Azure Data Lake Storage Gen2||
|Bolt|Kafka|Output|N/A|Can connect to Apache Kafka for Event Hubs.|
||HDFS||N/A|Stream Analytics cannot output data directly to HDFS. Design to output to Blob Storage or Data Lake Storage Gen2. Or output to HDFS with custom code via Azure Functions etc.|
||HBase||N/A|Can be output to HBase with custom code via Azure Functions.|
||Hive||N/A|Can be output to Hive table with custom code via Azure Functions. |
||Cassandra||N/A|Can be output to Cassandra with custom code via Azure Functions.|
||Solr||N/A|Can be output to Solr with custom code via Azure Functions.|
||MongoDB||N/A|Can be output to MongoDB with custom code via Azure Functions.|
||Elasticsearch||N/A|Can be output to Elasticsearch with custom code via Azure Functions.|
||N/A||Azure Data Lake Storage Gen1||
||N/A||Azure SQL Database||
||N/A||Azure Synapse Analytics||
||N/A||Azure Blob Storage||
||Azure Event Hubs||Azure Event Hubs||
||N/A||Power BI||
||N/A||Azure Table storage||
||N/A||Azure Service Bus queues||
||N/A||Azure Service Bus topics||
||N/A||Azure Cosmos DB||
||N/A||Azure Functions||


### Architecture

For more information on Apache Storm architecture and components, see [Storm architecture and components](./architecture-and-conponents). 

Stream Analytics is a PaaS type service, so users do not need to be aware of internal components or infrastructure. As shown in the figure below, it can be configured by arranging it for analysis and conversion processing in the pipeline of streaming data and defining Input / Query / Output. 

![Stream Analytics pipeline](../images/stream-analytics-e2e-pipeline.png)

Image source : https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction

Storm provides a fail-fast, fault-tolerant system with Numbus, ZooKeeper, and Supervisor configurations. Stream Analytics is a fully managed service that implements ingenuity to improve the fault tolerance of internal components. As a result, users can check their availability based on SLAs. See [SLA for Azure Stream Analytics](https://azure.microsoft.com/en-us/support/legal/sla/stream-analytics/v1_0/) for more information. 

### Event delivery guarantee 
Stream Analytics guarantees Exactly-once processing.

Micro-batch vs real-time

Lookup table

Stream Grouping
Reliability
windowing
Performance consideration
-Streaming Units
-Partitions
-Stream Analytics Cluster

Language

2. Migration
    a. Identify topologies need to be migrated
    b. 
    c. 
3. Security
    a. Firewall/OS level Security
    b. Authentication and Authorization
    VNET
4. Monitoring
High Availability


### Planning

### Migration

## Migration to Azure Functions

### Planning

### Migration
