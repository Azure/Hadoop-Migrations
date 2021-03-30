#Migration Approach 
small change
##Modernization – Databricks 

Azure Databricks is a fast, easy, and collaborative Apache Spark based analytics service. Engineered by the original creators of Apace Spark, Azure Databricks provides the latest versions of Apache Spark and allows you to seamlessly integrate with open-source libraries. You can spin up clusters and build quickly in a fully managed Apache Spark environment with the global scale and availability of Azure. Clusters are set up, configured, and fine-tuned to ensure reliability and performance without the need for monitoring. Take advantage of autoscaling and auto-termination to improve total cost of ownership (TCO). 

On top of Apache Spark, Azure Databricks offers additional capabilities: 

	-Photon Engine - a vectorized query engine that leverages modern CPU architecture to enhance Apache Spark 3.0’s performance by up to 20x. 

	-DBIO Cache - Transparent caching of Parquet data on worker local disk 

	-Skew Join Optimization 

	-Managed Delta Lake 

	-Managed MLflow 

The migration of Spark jobs onto Azure Databricks is trivial, and requires minimal, if any, modifications to scripts. Job scripts can be imported into Azure Databricks in bulk using the Workspace CLI.  

##Modernization – Synapse 

##Lift and Shift – HDInsight 

##Lift and Shift – IAAS  