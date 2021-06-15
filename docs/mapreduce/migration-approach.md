## Migration Approach:

The primary target for MapReduce Jobs is Synapse Spark on Azure. 

There are 2 approaches to move the MapReduce jobs to Azure - 
1. MapReduce Jobs converted to Spark Jobs or
2. If the MapReduce job depends on multiple classes run the MapReduce jobs on Spark with no conversion
		a. Create an RDD of the input data.
		b. Call map with your mapper code. Output key-value pairs.
		c. Call reduceByKey with your reducer code.
    d. Write the resulting RDD to disk.

### Choosing the execution model
Hadoop Mapreduce uses on Disk processing model (disk based parallelization) -  batch processing model. Spark leverages in-memory processing and has different execution models . Choose the execution model for Spark which is in memory - batch , interactive or near real - time based on the requirement. 


### Programming language support
Map Reduce supports programming languages- Java / Ruby / Python
Spark is written in Scala Programming Language and runs on Java Virtual Machine (JVM) environment.Spark provides an API in Scala, Python, and Java in order to interact with Spark. It also provides APIs in R language.

### Key features in MapReduce and Spark 


#### Key features of Mapper and Reducer include

• The objects have a lifecycle that spans many map() and reduce() invocations. Support for setup() and cleanup() method is provided that can be used to take actions before or after a batch of records is processed.

• Operate only on key-value pairs

• A Reducer reduces values per key only

• Produces an output of 0 or more key-value pairs for every input

• Hadoop Java programs  consist of below classes - 
1. Mapper class 

2. Reducer class 
	
3. Driver class

#### Key features Spark

• Resilient Distributed Datasets - Resilient Distributed Dataset or RDD is the key concept in Spark framework and Spark stores data in RDD on different partitions. 

• RDD also exposes two operations -  map() and reduce()  - however these are not a direct analog of Hadoop’s Mapper or Reducer APIs.

• Key RDD Operations to reproduce MapReduce behaviour 

	groupByKey([numPartitions])	When called on a dataset of (K, V) pairs, returns a dataset of (K, Iterable<V>) pairs.

Note: If you are grouping in order to perform an aggregation (such as a sum or average) over each key, using reduceByKey or aggregateByKey will yield much better performance.
Note: By default, the level of parallelism in the output depends on the number of partitions of the parent RDD. You can pass an optional numPartitions argument to set a different number of tasks.
	
	reduceByKey(func, [numPartitions])	When called on a dataset of (K, V) pairs, returns a dataset of (K, V) pairs where the values for each key are aggregated using the given reduce function func, which must be of type (V,V) => V. 
Like in groupByKey, the number of reduce tasks is configurable through an optional second argument.





	**Example - WordLength** 
	
	Hadoop Mapper Class

	public class WordLengthMapper
    	extends Mapper<LongWritable,Text,IntWritable,IntWritable> {
  	@Override
  		protected void map(LongWritable wordNumber, Text word, Context context)
      		throws IOException, InterruptedException {
    			context.write(new IntWritable(word.getLength()), new IntWritable(1));
  		}
	}
-- output of this mapper is a (key,value) pair -- (word length , 1)


	Spark equivalent

	words.map(word => (word.length, 1))
		In Spark RDD output is a tuple - (wordlength,1)
		In Spark, the input is an RDD of Strings only, not of key-value pairs
	
The result of the map() operation above is an RDD of (Int,Int) tuple


	Hadoop Reducer

	public class WordLengthReducer
    	extends Reducer<IntWritable,IntWritable,IntWritable,IntWritable> {
  	@Override
  		protected void reduce(IntWritable length, Iterable<IntWritable> counts, Context context)
      		throws IOException, InterruptedException {
    		int sum = 0;
    		for (IntWritable count : counts) {
      			sum += count.get();
    		}
    		context.write(length, new IntWritable(sum));
  		}
	}
	
	Spark equivalent

	val lengthCounts = lines.map(line => (line.length, 1)).reduceByKey(_ + _)
