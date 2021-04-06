## Architecture and Components:

### Introduction to Spark and Synapse Spark:

Apache Spark is open-source tool for processing large amounts of structured, semi-structured data across multiple nodes (worker nodes). One of the primary advantages of using spark is due the speed (in-memory) computing and support for different programming languages like Python, R, Java, Scala, and ability to run SQL queries. Spark API automatically splits the tasks into multiple tasks regardless of the programming language.

The core architecture for spark is scalable and ­if you need more processing power you add more nodes to the clusters and reduce/decrease the nodes when not in use. Spark is processing framework and the data is stored on high performance distributed storage like HDFS or ADLS Gen2. This de-coupled (storage and analytics) makes it ideal for organization to save costs when moving to cloud compared to always on on-premises Hadoop cluster. Apache spark has many built in libraries for building transformation and support wide range of storage formats like Parquet, Orc, text (csv, json) etc.

### Spark Driver Node:

Spark driver node is the primary entry point and the controller and when a job is sent to Driver node spark context is initiated and tasks are sent to worker nodes for processing. Driver node is also responsible for the cluster management and autoscaling.

### Spark Worker Node (Executor Nodes):

Spark executor nodes register themselves to Driver node and performs tasks sent and returns the results.

### Spark Deployment Modes:

Currently Spark support deployment on YARN cluster, Mesos, Kubernetes and Standalone modes.

### Spark API interactions:

Jupyter type notebooks are used to interact with spark clusters and multiple language support is provided by the jupyter “magics”. The notebooks also allow for in-line visualizations and handle cron based scheduling of jobs.

### Data processing:

Spark core data structure is called dataframe and provides connectors to read from several data sources and convert in dataframe. Once the dataframe is created you can use Spark api to perform transformation

Example:

df = spark.sql('select * from table1')

df.select('col1', 'col2')

​    .filter(df['col3'] == 'VAL')

​    .groupBy('col4')

### Synapse Spark:

Azure Synapse Analytics takes the best of Azure SQL Data Warehouse and modernizes it by providing more functionalities for the SQL developers, adding querying with serverless SQL pool, adding machine learning support, embedding Apache Spark natively, providing collaborative notebooks, and offering data integration within a single service. In addition to the languages supported by Apache Spark, Synapse Spark also support C#.

### Summary

·    Apache Spark has several connectors to read and write data. The primary usage is for data engineers and data scientist to perform ETL/ELT at scale and train/build machine learning models.

·    Decoupled storage and processing architecture enables autoscaling and can scale to petabyte data processing.

·    Synapse Spark is built for individual users to run ad-hoc processing on Synapse tables with ability to read/write to ADLS Gen2.

·    Synapse Spark makes the entry barrier easy for someone new to Spark by providing opinionated cluster types (Small, Medium, Large etc.) and are ephemeral in nature. 