# Azure HDInsight Spark and Azure Databricks to Azure Synapse Analytics Spark Pool Migration Guide

This document provides an end-to-end guide for migrating Azure HDInsight Spark clusters and Azure Databricks workloads to the Azure Synapse Analytics Spark Pool.

## Overview

### Azure HDInsight
[Azure HDInsight](https://docs.microsoft.com/azure/hdinsight/hdinsight-overview) is an open source enterprise managed analytics service in the cloud.HDInsight can use open source frameworks such as Hadoop, Apache Spark, Apache Hive, Apache Kafka, Apache HBase, Apache Storm, R. These frameworks cover a wide range of scenarios, including Extract/Transform/Load (ETL), data warehousing, machine learning, and IoT. For this guide, Spark is targeted as the source workload. Please refer to [each guides](https://aka.ms/ehma) for other components.

### Azure Databricks
[Azure Databricks](https://docs.microsoft.com/azure/databricks/scenarios/what-is-azure-databricks) is an analysis platform optimized for Apache Spark for Azure. Incorporates an integrated end-to-end machine learning environment such as an interactive workspace that enables collaboration between data engineers, data scientists, and machine learning engineers, as well as provides management services for tracking experiments, training models, developing and managing features, and delivering features and models.

### Azure Synapse Analytics
[Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/overview-what-is) is a data analytics platform that integrates data warehouses and big data systems. In the past, building a data analysis platform required connecting components such as databases, ETL, and machine learning. Azure Synapse tightly integrates the necessary solutions such as SQL Server technology used in enterprise data warehouses, Spark technology used for big data, Pipelines for ETL and ELT, and machine learning with Azure ML. This guide mainly introduces Spark Pool as a migration target.
