# Migration Approach

Azure has several landing targets for Apache Kudu. Depending on requirements and product features, customers can choose between Azure IaaS, HDInsight, Synapse or Azure Databricks.  

Landing Targets for Apache Kudu on Azure

![Landing Targets for Apache Kudu on Azure](../images/flowchart-kudu-azure-landing-targets.png)

- [Lift and shift migration to Azure IaaS](#lift-and-shift-migration-to-azure-iaas)
- [Migration to HDInsight Interactive Hive Cluster](#migration-to-hdinsight-interactive-hive-cluster)
- [Migration to Synapse/Databricks with Delta Lake](#migration-to-synapsedatabricks-with-delta-lake)
- [Migration to Synapse + Synapse Link for Cosmos DB](#migration-to-synapse--synapse-link-for-cosmos-db)

## Lift and shift migration to Azure IaaS

## Migration to HDInsight
HDInsight does not support running Apache Kudu Cluster. Use supported storage (Blob or ADLS) and choose the appropriate file format (Parquet, ORC, etc) for your workload.
See [Guide to Migrating Big Data Workloads to Azure HDInsight](https://azure.microsoft.com/resources/migrating-big-data-workloads-hdinsight/), a comprehensive migration guide for HDInsight for more information.

## Migration to Synapse/Databricks with Delta Lake
- Introduction of Delta Lake with synapse documentation
- export kudu to parquet
- convert parquet to delta

- Synapse (Convert to Delta)
- https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-delta-lake-format
- 
- Databricks
- https://docs.microsoft.com/en-us/azure/databricks/delta/porting
- https://docs.microsoft.com/en-us/azure/databricks/sql/language-manual/delta-convert-to-delta

## Migration to Synapse + Synapse Link for Cosmos DB

- Introduction of Synapse Link for Cosmos DB
- If you are using Kudu for HTAP

## Further Reading


[Architecture and Components](readme.md)

[Challenges](challenges.md)

[Considerations](considerations.md)
