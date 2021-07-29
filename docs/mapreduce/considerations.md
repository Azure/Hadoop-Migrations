## Migration Considerations

There are some considerations when planning the migration of MapReduce Jobs. Based on our experience with customer engagements the below have been identified -
- Spark Partitions
          
          Number of files (ideally equal size) = Number of Spark Partitions
          
          Number of Spark Partitions in execution = Number of available cores
      
          Recommended # of partitions should be 3 to 4 times of available cores

          Fewer partitions than available cores
          
          Data volume is very low - scale down cluster might save cost
          
          Data is skewed - repartition on field which has even data distribution or use salt (randomization)

          More partitions than available cores - In this case, scaling cluster up will have better performance

          Repartition: If you are increasing the number of partitions use repartition() (performing full shuffle)

          Coalesce: If you are decreasing the number of partitions use coalesce() (minimizes shuffles)
- Avoid creating too many small partitions with small files
- Minimize number of files to be processed by way of partition elimination / partition pruning
- Consider using caching for repetitive work  - avoid repeating common processing
- Explicitly broadcast a small/medium size dataset to avoid shuffling 
- Consider data being stored (temporary or permanent persistence) in ADLS (hierarchical enabled) than blob storage
- Use spark.read.synapsesql instead of jdbc wherever applicable - ensure use of fast connector
- When reducing number of partitions, use coalesce instead of repartitions
- Execution Optimization - Look for number of stages in the job - see if these numbers can be minimized  - explain vs explain(true) and DAG in Spark UI - higher number of stages indicate higher number of data shuffling across nodes
