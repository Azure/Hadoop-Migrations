package sample

import com.databricks.spark.sql.perf.tpcds.TPCDS
import org.apache.spark.sql.{SQLContext, SparkSession}
import org.apache.spark.{SparkConf, SparkContext}

//class Tpcds_custom_Queries extends Benchmark {
//
//  import ExecutionMode._
//
//  val queryNames = Seq(
//    "q1"
//  )
//
//  val tpcds2_4Queries = queryNames.map { queryName =>
//    val queryContent: String = IOUtils.toString(
//      getClass().getClassLoader().getResourceAsStream(s"tpcds_2_4/$queryName.sql"))
//    Query(queryName + "-v2.4", queryContent, description = "TPCDS 2.4 Query",
//      executionMode = CollectResults)
//  }
//
//  val tpcds2_4QueriesMap = tpcds2_4Queries.map(q => q.name.split("-").get(0) -> q).toMap
//}

object SparkPerf {
  def main(args: Array[String]): Unit = {

    val spark = SparkSession
      .builder()
      .appName("SparkPerf")
      .enableHiveSupport()
      .getOrCreate()

    val sqlContext = spark.sqlContext

    val tpcds = new TPCDS(sqlContext = sqlContext)
//    val q = new Tpcds_custom_Queries()
    val databaseName = "tpcds" // name of database with TPCDS data.
    sqlContext.sql(s"use $databaseName")
    val resultLocation = "abfs://tpcds@msftnikoadlsgen2storage.dfs.core.windows.net/tpcds_results/synapse/large" // place to write results
    val iterations = 1 // how many iterations of queries to run.
    val queries = tpcds.tpcds2_4Queries // queries to run.
    val timeout = 24 * 60 * 60 // timeout, in seconds.
    // Run:
    val experiment = tpcds.runExperiment(
      queries,
      iterations = iterations,
      resultLocation = resultLocation,
      forkThread = true)
    experiment.waitForFinish(timeout)
  }
}
