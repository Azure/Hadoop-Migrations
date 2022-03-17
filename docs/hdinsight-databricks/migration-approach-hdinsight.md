# Migration Approach

## Assessment

## Considerations

HDInsight Spark:
Azure HDInsight as "A cloud-based service from Microsoft for big data analytics". It is a cloud-based service from Microsoft for big data analytics that helps organizations process large amounts of streaming or historical data.

Main features from the HDInsight platform:
* Fully managed
* Variety of services for multiple porpuses
* Open-source analytics servicefro entreprise companies

Synapse Spark:
Azure Synapse Analytics takes the best of Azure SQL Data Warehouse and modernizes it by providing more functionalities for the SQL developers such as adding querying with serverless SQL pool, adding machine learning support, embedding Apache Spark natively, providing collaborative notebooks, and offering data integration within a single service. In addition to the languages supported by Apache Spark, Synapse Spark also support C#.

Main features from Azure Synapse:
* Complete T-SQL based analytics
* Hybrid data integration
* Apache Spark integration
HDInsight and Synapse Spark are using the same version of Apache Spark 3.1, that is a good starting point when we try to performa a migration from different platform.
as we are using the same Spark version code and jars will be able to deploy in Synapse easily.

[Azure Synapse Runtime for Apache Spark 3.1](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-3-runtime)

[Azure HDInsight Runtime for Apache Spark 3.1](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/spark-3-1-is-now-generally-available-on-hdinsight/ba-p/3253679)


HDInsight is a service that is always up and we have to understand deeply the service to be able to configure and tunned , that make the service complex compare with others.Most of HDInsights features are Apache based. There are several cluster types to choose from depending upon your need.

On the other hand Synapse is consumption-based, and is easier to configurate.Synapse incorporates many other Azure services and is the main plaform for Analytics and Data Orchestration.

## Performance Considerations

Refer to [Optimize Spark jobs for performance - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-performance) for considerations.

## Data Storage

Spark is a processing framework and does not store any data, once the processing is complete an appropriate sink needs to be chosen.

| Use case            | Sink                 | Comment        |
| ------------------- | -------------------- | -------------- |
| Data Warehouse      | Synapse table        |                |
| API and fast access | Cosmos DB            |                |
| Historical Analysis | ADLS Gen2 (Datalake) |                |
| Integration         | EventHub             | Kafka protocol |

## Data Migration

Synapse Spark supports reading multiple different file formats (ORC, Parquet etc.) so use the same migration strategy as on-premises HDFS migration.

Internal migration from Synapse SQL Pool to Synapse Spark Pool is documented in detail at [Import and Export data between serverless Apache Spark pools and SQL pools - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/spark/synapse-spark-sql-pool-import-export)

## Ingesting SQL pool data into a Spark database

1. Create Notebook (default language is pyspark)

2. If we need to read table create in Synapse (sqlpool001.dbo.TaxiTrip)

```sql
%%spark

spark.sql ("CREATE DATABASE IF NOT EXISTS sparknyc")

val df = spark. read. sqlanalytics("sqlpool001.dbo.TaxiTrip")

df. write. mode("overwrite").saveAsTable("sparknyc.taxitrip")
```

3. Now you can use the regular DataFrame operation to perform transformations.

## Ingesting Spark table data into an SQL pool table

1. Create Notebook (default language is pyspark)

2. to create a synapse table, execute as below.

```sql
%%spark

val df = spark.sql ("SELECT * FROM sparknyc. passengerstats")

df. write. sqlanalytics("sqlpool001.dbo.PassengerStats",Constants.INTERNAL)
```

3. Now you can use the regular DataFrame operation to perform transformations.

## Integrating with Pipelines

Reference link for pipeline and data flow: [QuickStart: to load data into dedicated SQL pool using the copy activity - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-copy-activity-load-sql-pool)


There is a new feature which allows some Synapse-HDInsight integrations.

[Share-Hive-Metastore](https://docs.microsoft.com/en-us/azure/hdinsight/share-hive-metastore-with-synapse)

## Planning

## Metadata migration

## Data migration

## Code migration

## Performance benchmarking approach

## Security

## BC-DR

## Further Reading

[Spark Architecture and Components](readme.md)

[Considerations](considerations.md)

[Databricks Migration](databricks-migration.md)
