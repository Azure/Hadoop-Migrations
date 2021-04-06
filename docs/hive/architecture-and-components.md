## Hive Architecture and Components

Apache Hive is a popular data warehouse software that enables you to easily and quickly write SQL-like queries to efficiently extract data from Apache Hadoop.

Hadoop is an open-source framework for storing and processing massive amounts of data. While Hadoop offers many advantages over traditional relational databases, the task of learning and using Hadoop is daunting since it requires SQL queries to be implemented in the MapReduce Java AP.

**Hive Metadata**

Every operation of Hive depends on the definition of metadata that describes the structure of data residing in a Hadoop cluster. Data modelling hive consists of Databases, Tables, Partitions, and Buckets.

**HiveServer2**

is a JDBC interface for applications that want to use it for accessing Hive. This is included with standard analytic tools called Beeline.

 **Hive pattern rules**

A simple syntax used by Hive for matching database objects.

**Hive Client Applications**

Can be access either directly (using its Thrift interface), or indirectly via another client application such as Beeline or HiveServer2.
