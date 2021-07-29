## Performance Considerations

Refer to [Optimize Spark jobs for performance - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-performance) for considerations.

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

Internal migration from Synapse SQL Pool to Synapse Spark Pool is documented in detail at [Import and Export data between serverless Apache Spark pools and SQL pools - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/synapse-spark-sql-pool-import-export)

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
