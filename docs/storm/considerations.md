# Considerations  

* Storm is based on real-time event processing and at-least-once processing. By using [Trident](https://storm.apache.org/releases/current/Trident-API-Overview.html), microbatch processing and exactly once processing can be guaranteed. Because you can use different levels of message processing on Storm, carefully review the business requirements for stream processing to determine what level of assurance you need. 

* In this migration guide, migration targets other than Lift and Shift to Azure Virtual Machine are not targeted for Storm. While Azure HDInsight 3.6 allowed you to choose Storm Cluster, Azure HDInsight 4.0 does not offer Storm, and as a result you will have to move to other streaming data platforms in the future. Therefore, for any migration other than Lift and Shift, you should plan your application migration. 

* Due to the characteristics of business and systems, it is often difficult for stream processing to have a long downtime. If you can't tolerate a long outage, you need to plan well for online migration. 

* If you are migrating Storm to any service on Azure, consider migrating its data source system (for example, a message queuing service like Kafka) to Azure. If the service is located in a different location or network than Azure, its connectivity, latency, etc. need to be carefully considered. 