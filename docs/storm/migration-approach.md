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

Storm Spout and Stream Analytics Input
|Storm Spout|Stream Analytics Input|Description|
|--|--|--|
|Kafka|N/A|Can connect to Apache Kafka for Event Hubs.|
|HDFS|N/A|Stream Analytics cannot consume HDFS data directly. Configure the Blob Storage or Data Lake Storage Gen2 to contain the required data. |
|Azure Event Hub|Azure Event Hub||
|N/A|Azure IoT Hub||
|N/A|Azure Blob Storage||
|N/A|Azure Data Lake Storage Gen2||

Storm Bolt and Stream Analytics Output
|Storm Bolt|Stream Analytics Output|Description|
|--|--|--|
|Kafka|N/A|Can connect to Apache Kafka for Event Hubs.|
|HDFS|N/A|Stream Analytics cannot output data directly to HDFS. Design to output to Blob Storage or Data Lake Storage Gen2. Or output to HDFS with custom code via Azure Functions etc.|
|HBase|N/A|Can be output to HBase with custom code via Azure Functions.|
|Hive|N/A|Can be output to Hive table with custom code via Azure Functions. |
|Cassandra|N/A|Can be output to Cassandra with custom code via Azure Functions.|
|Solr|N/A|Can be output to Solr with custom code via Azure Functions.|
|MongoDB|N/A|Can be output to MongoDB with custom code via Azure Functions.|
|Elasticsearch|N/A|Can be output to Elasticsearch with custom code via Azure Functions.|
|N/A|Azure Data Lake Storage Gen1||
|N/A|Azure SQL Database||
|N/A|Azure Synapse Analytics||
|N/A|Azure Blob Storage||
|Azure Event Hubs|Azure Event Hubs||
|N/A|Power BI||
|N/A|Azure Table storage||
|N/A|Azure Service Bus queues||
|N/A|Azure Service Bus topics||
|N/A|Azure Cosmos DB||
|N/A|Azure Functions||


### Architecture

For more information on Apache Storm architecture and components, see [Storm architecture and components](./architecture-and-conponents). 

Stream Analytics is a PaaS type service, so users do not need to be aware of internal components or infrastructure. As shown in the figure below, it can be configured by arranging it for analysis and conversion processing in the pipeline of streaming data and defining Input / Query / Output. 

![Stream Analytics pipeline](../images/stream-analytics-e2e-pipeline.png)

Image source : https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction

Storm provides a fail-fast, fault-tolerant system with Numbus, ZooKeeper, and Supervisor configurations. Stream Analytics is a fully managed service that implements ingenuity to improve the fault tolerance of internal components. As a result, users can check their availability based on SLAs. See [SLA for Azure Stream Analytics](https://azure.microsoft.com/en-us/support/legal/sla/stream-analytics/v1_0/) for more information. 

### Event delivery guarantee 

The basic abstraction of Apache Storm provides At-least-once processing guarantee. This is the same guarantee as when using a queuing system. The message will only be played in the event of a failure. Exactly-once can be achieved with the higher abstraction Trident API.

Stream Analytics guarantees Exactly-once processing. And, depending on the output destination, it guarantees Exactly-once delivery or At-least-once delivery. Exactly-once delivery is guaranteed when you use the following as the output destination. This is because the Stream Analytics output adapter writes output events transactionally.

- Cosmos DB
- SQL
- Azure Table

From the above, you can see that when it comes to event handling and delivery assurance, migrating from Storm to Stream Analytics will provide the same or better level. However, please note that At-least-once tends to have better performance than Exactly-once.

詳細は[Event Delivery Guarantees](https://docs.microsoft.com/en-us/stream-analytics-query/event-delivery-guarantees-azure-stream-analytics)を参照してください。

### Real-time vs Micro-batch

Storm provides a model to handle each event. All records received are processed as soon as they arrive. Stream Analytics applications must wait momentarily to collect each micro-batch of an event before sending it for processing. In contrast, the real-time application used by Storm Core handles each event immediately. However, Stream Analytics has a streaming latency of less than a few seconds. The advantage of the microbatch approach is the streamlining of data processing and aggregation calculations.

![Real-time vs Micro-batch](../images/real-time-vs-micro-batch.png)

Storm is based on real-time event processing and at-least-once processing. By using Trident, microbatch processing and exactly once processing can be guaranteed. Because you can use different levels of message processing on Storm, carefully review the business requirements for stream processing to determine what level of assurance you need.

### Stream Grouping
Stormは

		○ Shuffle grouping
		○ Fields grouping
		○ Partial Key grouping
		○ All grouping
		○ Global grouping
		○ None grouping
		○ Direct grouping
		○ Local or shuffle grouping
Custom

Lookup table

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
