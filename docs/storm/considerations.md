# Considerations  

* When migrating Sqoop to Azure, if your data source remains on-premises, you need to consider its connectivity. You can establish a VPN connection over the Internet between Azure and your existing on-premises network, or you can use ExpressRoute to make a private connection.

* When migrating to HDInsight, you need to carefully consider your Sqoop version. HDInsight supports Sqoop1, so if you are using Sqoop2 in your on-premises environment, you will need to replace it with Sqoop1 on HDInsight or keep Sqoop2 independent. 

* When migrating to Data Factory, you need to consider the output format. Data Factory does not support SquenceFile as an output format. Therefore, if you are using SequenceFile as the output format for Sqoop, you need to ensure that subsequent processing is available in different formats (Text, Avro, Parquet, JSON, ORC). Or you can take advantage of Spark to convert file format to SequenceFile.