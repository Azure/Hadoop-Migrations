package sample

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions.window

import java.sql.Timestamp

object SparkStreamingEventhubToADLSSample {
  val spark = SparkSession
    .builder
    .appName("SparkStreamingEventhubToADLSSample")
    .getOrCreate()

  spark.sparkContext.hadoopConfiguration.set("fs.azure.account.auth.type.msftnikoadlsgen2storage.dfs.core.windows.net", "OAuth")
  spark.sparkContext.hadoopConfiguration.set("fs.azure.account.oauth.provider.type.msftnikoadlsgen2storage.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
  spark.sparkContext.hadoopConfiguration.set("fs.azure.account.oauth2.client.id.msftnikoadlsgen2storage.dfs.core.windows.net", "85cb701f-a86f-4e91-b83e-xxx")
  spark.sparkContext.hadoopConfiguration.set("fs.azure.account.oauth2.client.secret.msftnikoadlsgen2storage.dfs.core.windows.net", "~Rz7Q~yiIzmo-1jDpnW~fq")
  spark.sparkContext.hadoopConfiguration.set("fs.azure.account.oauth2.client.endpoint.msftnikoadlsgen2storage.dfs.core.windows.net", "https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-xxx/oauth2/token")

  import spark.implicits._

  val TOPIC = "demo"
  val BOOTSTRAP_SERVERS = "azureeventhub.servicebus.windows.net:9093"
  val EH_SASL = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://azureeventhub.servicebus.windows.net/;SharedAccessKeyName=readwrite;SharedAccessKey=q7p4xBTC1W8gWXlxxxU+RKdCLi2Sc0=\";"

  val lines = spark.readStream
    .format("kafka")
    .option("subscribe", TOPIC)
    .option("kafka.bootstrap.servers", BOOTSTRAP_SERVERS)
    .option("kafka.sasl.mechanism", "PLAIN")
    .option("kafka.security.protocol", "SASL_SSL")
    .option("kafka.sasl.jaas.config", EH_SASL)
    .option("kafka.request.timeout.ms", "60000")
    .option("kafka.session.timeout.ms", "60000")
    .option("failOnDataLoss", "false")
    .load()

  // Split the lines into (word, timestamp)
  val wordsDF = lines.selectExpr("cast(value as string) value", "timestamp").as[(String, Timestamp)].flatMap(line =>
    line._1.split(" ").map(word => (word, line._2))
  ).toDF("word", "timestamp")

  // Generate running word count
  val windowedCounts = wordsDF
    .withWatermark("timestamp", "1 minutes")
    .groupBy(
      window($"timestamp", "1 minutes", "30 seconds"), $"word"
    ).count()

  //  Start the stream.
  //  Use the checkpoint_path location to keep a record of all files that
  //    have already been uploaded to the upload_path location.
  //  For those that have been uploaded since the last check,
  //  write the newly-uploaded files' data to the write_path location.
  val result = windowedCounts.writeStream
    .format("parquet")
    .outputMode("append")
    .option("checkpointLocation", "abfss://spark@msftadlsgen2storage.dfs.core.windows.net/checkpoint/")
    .start("abfss://spark@msftadlsgen2storage.dfs.core.windows.net/store/")

  result.awaitTermination()
}
