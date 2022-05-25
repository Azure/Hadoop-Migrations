package sample

import org.apache.spark.sql.SparkSession

/**
 * Executes a roll up-style query against Apache logs.
 *
 */
object SparkLogQuery {
  val nginxLogs = List(
    """202.173.10.31 - [18/Aug/2018:21:16:28 +0800] \"GET / HTTP/1.1\" 404 312 \"http://www.sdf.sdf\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36\"""".stripMargin.stripLineEnd,
    """159.32.1.34 - [18/Aug/2018:21:16:28 +0800] \"GET / HTTP/1.1\" 200 12590 \"http://www.azure.com\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36\"""".stripMargin.stripLineEnd,
    """159.32.1.34 - [18/Aug/2018:21:16:28 +0800] \"GET / HTTP/1.1\" 200 12590 \"http://www.azure.com\" \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36\"""".stripMargin.stripLineEnd
  )

  def main(args: Array[String]) {
    val spark = SparkSession
      .builder()
      .appName("Spark Scala Example")
      .getOrCreate()

    val sparkContext = spark.sparkContext
    val dataSet = sparkContext.parallelize(nginxLogs)

    val nginxLogRegex = {
      """([^ ]*) ([^ ]*) (\[.*\]) (\\\".*?\\\") (-|[0-9]*) (-|[0-9]*) (\\\".*?\\\") (\\\".*?\\\")""".r
    }

    /** Tracks the total query count and number of aggregate bytes for a particular group. */
    class Stats(val count: Int, val numBytes: Int) extends Serializable {
      def merge(other: Stats): Stats = new Stats(count + other.count, numBytes + other.numBytes)

      override def toString: String = "bytes=%s\tn=%s".format(numBytes, count)
    }

    def extractKey(line: String): (String, String, String, String) = {
      nginxLogRegex.findFirstIn(line) match {
        case Some(nginxLogRegex(remote_addr, remote_user, time_local, request, status, body_bytes_sent, http_referer, http_user_agent)) =>
          if (remote_addr != "\"-\"") (remote_addr, status, body_bytes_sent, http_user_agent)
          else (null, null, null, null)
        case _ => (null, null, null, null)
      }
    }

    def extractStats(line: String): Stats = {
      nginxLogRegex.findFirstIn(line) match {
        case Some(nginxLogRegex(remote_addr, remote_user, time_local, request, status, body_bytes_sent, http_referer, http_user_agent)) =>
          new Stats(1, body_bytes_sent.toInt)
        case _ => new Stats(1, 0)
      }
    }

    /**
     * Sample Output:
     * The result will be recorded the remote address and user agent, then output the aggregated body size in bytes and appearance of the records
     * (159.32.1.34,200,12590,\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36\")	bytes=25180	n=2
       (202.173.10.31,404,312,\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36\")	bytes=312	n=1
     */
    dataSet.map(line => (extractKey(line), extractStats(line)))
      .reduceByKey((a, b) => a.merge(b))
      .collect().foreach {
      case (user, query) => println("%s\t%s".format(user, query))
    }

    sparkContext.stop()
  }
}
