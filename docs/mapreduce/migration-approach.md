## Migration Approach:

The primary target for MapReduce Jobs is Synapse Spark on Azure. 

The MapReduce jobs can either be 
1. MapReduce Jobs converted to Spark Jobs or
2. If the MapReduce job depends on multiple classes run the MapReduce jobs on Spark with no conversion
		a. Create an RDD of the input data.
		b. Call map with your mapper code. Output key-value pairs.
		c. Call reduceByKey with your reducer code.
    d. Write the resulting RDD to disk.

