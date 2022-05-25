## How to generate TPC-DS data for Spark

This section we will explain how to use [spark-sql-perf]() and [tpcds-kit]() to generate `tpcds` data for running Spark performance benchmark.

First, we will create a `HDInsight` cluster with Spark 3.1 with Scala 2.12.*. 

If not `sbt` installed, please install it properlly

```aidl
sudo apt-get update
sudo apt-get install apt-transport-https curl gnupg -yqq
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo -H gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
sudo chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg
sudo apt-get update
sudo apt-get install sbt
```

### TPCDS-KIT
1. Download and build `tpcds-kit`
   
   ```aidl
    sudo apt-get install gcc make flex bison byacc git
    cd /tmp/
    git clone https://github.com/databricks/tpcds-kit.git
    cd tpcds-kit/tools
    make OS=LINUX
   ```
2. Distribute `tpcds` toolkit to ALL worker nodes in hdinsight cluster

   ```aidl
    scp -r tpcds-kit/ <worker-node-ip>:~
    ```
   
3. Download and build `spark-sql-perf` framework

    ```
   git clone https://github.com/databricks/spark-sql-perf
    cd spark-sql-perf
   ```
   *Please make sure your spark version and scala version is matched the version in spark-sql-perf*
   
    After downloading the raw files, you may need to modify the version number in `build.sbt` file. For example, 

    ```
   scalaVersion := "2.12.10"

   sparkVersion := "3.1.2"
   ```
   
    Then we could start building the `spark-sql-perf` framework by follow command

    ```
   sbt +package
   ```
   
4. Create `gendata.scala` file to generate `tpcds` data

    You could change the parameter provided in the scala file to meet your benchmark goal, for example, you may change the scala factor to 1000 stands for 1TB to expand your testing scope.

    ```aidl
    import com.databricks.spark.sql.perf.tpcds.TPCDSTables

    // Note: Declare "sqlContext" for Spark 2.x version
    val sqlContext = new org.apache.spark.sql.SQLContext(sc)
    
    // Note: If you are using ADLS Gen2, the format shoule be like "abfs://<container>@<storageaccount>.dfs.core.windows/net/<folder>"
    val rootDir = "abfs://tpcds@msftnikoadlsgen2storage.dfs.core.windows.net/data/100G"
    
    val databaseName = "tpcds" // name of database to create.
    val scaleFactor = "100" // scaleFactor defines the size of the dataset to generate (in GB).
    val format = "parquet" // valid spark format like parquet "parquet".
    // Run:
    val tables = new TPCDSTables(sqlContext,
    dsdgenDir = "/tmp/tpcds-kit/tools", // location of dsdgen
    scaleFactor = scaleFactor,
    useDoubleForDecimal = false, // true to replace DecimalType with DoubleType
    useStringForDate = false) // true to replace DateType with StringType
    
    
    tables.genData(
    location = rootDir,
    format = format,
    overwrite = true, // overwrite the data that is already there
    partitionTables = true, // create the partitioned fact tables
    clusterByPartitionColumns = true, // shuffle to get partitions coalesced into single files.
    filterOutNullPartitionValues = false, // true to filter out the partition with NULL key value
    tableFilter = "", // "" means generate all tables
    numPartitions = 20) // how many dsdgen partitions to run - number of input tasks.
    
    // Create the specified database
    sql(s"create database $databaseName")
    // Create metastore tables in a specified database for your data.
    // Once tables are created, the current database will be switched to the specified database.
    tables.createExternalTables(rootDir, "parquet", databaseName, overwrite = true, discoverPartitions = true)
    // Or, if you want to create temporary tables
    // tables.createTemporaryTables(location, format)
    
    // For CBO only, gather statistics on all columns:
    // tables.analyzeTables(databaseName, analyzeColumns = true)
    ```
   
7. Once we have finished building the `spark-sql-perf`, start running the data generation process

    ```
   spark-shell --jars ~/spark-sql-perf/target/scala-2.12/spark-sql-perf_2.12-0.5.1-SNAPSHOT.jar \
            --driver-class-path scala-logging-slf4j_2.10-2.1.2.jar:scala-logging-api_2.11-2.1.2.jar \
            --master yarn \
            --num-executors 4 \
            --executor-memory 4g \
            --executor-cores 2 \
            --driver-memory 8g \
            --driver-cores 4 \
            -i ~/gendata.scala
   ```
   
    *Note: Tune --executor-memory , --num-executors and --executor-cores to make sure no OOM happens.*

    *Note: If we just need to generate 1G data, reduce "numPartitions" in above gendata.scala to reduce the overhead of too many tasks.*

8. Confirm the data files and tables are created

    It should create `24` tables and data stored in `ADLS Gen2`

    Check Hive tables in `spark-shell`

    ```
   scala> spark.sqlContext.tables().show()
    +--------+--------------------+-----------+
    |database|           tableName|isTemporary|
    +--------+--------------------+-----------+
    |   tpcds|         call_center|      false|
    |   tpcds|        catalog_page|      false|
    |   tpcds|     catalog_returns|      false|
    |   tpcds|       catalog_sales|      false|
    |   tpcds|            customer|      false|
    |   tpcds|    customer_address|      false|
    |   tpcds|customer_demograp...|      false|
    |   tpcds|            date_dim|      false|
    |   tpcds|household_demogra...|      false|
    |   tpcds|         income_band|      false|
    |   tpcds|           inventory|      false|
    |   tpcds|                item|      false|
    |   tpcds|           promotion|      false|
    |   tpcds|              reason|      false|
    |   tpcds|           ship_mode|      false|
    |   tpcds|               store|      false|
    |   tpcds|       store_returns|      false|
    |   tpcds|         store_sales|      false|
    |   tpcds|            time_dim|      false|
    |   tpcds|           warehouse|      false|
    +--------+--------------------+-----------+
    only showing top 20 rows
   ```
