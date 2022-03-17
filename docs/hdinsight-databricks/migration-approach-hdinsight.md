# Migration Approach

## Assessment

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


## Considerations
HDInsight and Synapse Spark are using the same version of Apache Spark 3.1, that is a good starting point when we try to performa a migration from different platform.
as we are using the same Spark version code and jars will be able to deploy in Synapse easily.


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
