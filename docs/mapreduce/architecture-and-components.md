## Architecture and Components:

### Introduction to MapReduce:
MapReduce is an open source framework/programming model that supports scalability across multiple servers in a Hadoop cluster. It is one of the key processing of Apache Hadoop. Mapreduce aims at processing structured and unstructured data in HDFS. It processes data from the disk and is suitable for batch processing. This framework has been developed using Java. MapReduce can run queries using the Hive Query Language.


MapReduce performs 2 tasks - Map task and a Reduce task. Programming languages like Python, Ruby , Java etc are supported to create the Map and Reduce tasks. 
       
#### 1. Map task 
Map Task takes the input data and converts it into another set of data, each element is broken into key/value pairs and returns a list of <key, value> pairs. Sorting and Shuffling are 2 key operations applied before sending the output to the Reduce Job

#### 2. Reduce task  
Output of the Map job is fed as input to a reduce job and it combines the key/value pairs into a smaller set of key/value pairs as per the reducer implementation.


Input Data -> Map -> Shuffle and Sort -> Reduce -> Output Data

### MapReduce Classes

There are 2 keys classes implemented in the MapReduce programming model when building MapReduce applications- 
    
1. MapReduce Mapper Class
    Mapper class maps the input key-value pairs to a set of intermediate key-value pairs. These intermediate pairs are associated with a given output key and passed to Reducer
        
        **Method map :** 
        void map(KEYIN key, VALUEIN value, Context context)	This method can be called only once for each key-value in the input split.  Applications should override this method to provide the map implementation
        
    For other methods refer link - http://hadoop.apache.org/docs/current/api/org/apache/hadoop/mapreduce/Mapper.html

2. MapReduce Reducer Class 
    Reducer class reduces the set of intermediate key-value pairs to generate the final output
        
        **Method reduce :**
        void reduce(KEYIN key, Iterable<VALUEIN> values, org.apache.hadoop.mapreduce.Reducer.Context context) 	This method called only once for each key.
        
    For other methods refer link - http://hadoop.apache.org/docs/current/api/org/apache/hadoop/mapreduce/Reducer.html


Hadoop MapReduce architecture comprises of three layers - 

1. Data Storage : Namenode and Datanode , Replication Management : HDFS- Hadoop Distributed File System
2. Management Framework : Scheduler and Application Manager : YARN    
3. API : Map Task and Reduce Task : MapReduce

Apache Spark in Azure Synapse Analytics Architecture includes following three main components:
1. Data Storage : Azure Blob Storage / Data Lake Store
2. Management Framework : YARN
3. API : Spark Core Engine , Spark SQL,Spark MLib , GraphX
For additional details refer link - https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-overview