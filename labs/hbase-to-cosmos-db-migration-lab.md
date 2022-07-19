# Apache HBase to Azure Cosmos DB SQL API migration lab

Hands-on lab to migrate data from HBase to Cosmos DB SQL API using Apache Spark.

## 1. Deploy HDInsight 4.0 HBase 2.1 cluster

Set up the environment required for this lab. This lab uses HDInsight 4.0 HBase 2.1 cluster as the data source and Cosmos DB SQL API as the migration target.

### Create resource groups and VNet

Create a resource group for ths lab.

```bash
#!/bin/bash

export ResourceGroupName="<HDI Resource Group Name>"
export location="<Location Name>"

# Create Reource Groups
az group create --name $resourceGroupName --location $location
```

### Create Storage account

Next, create a Blob storage for HDInsight.

```bash
export clusterName=<Cluster Name>
export AZURE_STORAGE_ACCOUNT=<Storage Account Name>
export httpCredential='<Password>'
export sshCredentials='<Password>'

export AZURE_STORAGE_CONTAINER=$clusterName
export clusterSizeInNodes=1
export clusterVersion=4.0
export clusterType=hbase
export componentVersion=hbase=2.1

# Note: kind BlobStorage is not available as the default storage account.
az storage account create \
    --name $AZURE_STORAGE_ACCOUNT \
    --resource-group $resourceGroupName \
    --https-only true \
    --kind StorageV2 \
    --location $location \
    --sku Standard_LRS

# Export primary key of Storage Account
export storageAccountKey=$(az storage account keys list \
    --account-name $AZURE_STORAGE_ACCOUNT \
    --resource-group $resourceGroupName \
    --query [0].value -o tsv)

# Create blob container
az storage container create \
    --name $AZURE_STORAGE_CONTAINER \
    --account-key $storageAccountKey \
    --account-name $AZURE_STORAGE_ACCOUNT
```

### Create HDInsight cluster

Deploy the HDInsight 4.0 HBase 2.1 cluster.

```bash
az hdinsight create \
    --name $clusterName \
    --resource-group $resourceGroupName \
    --type $clusterType \
    --component-version $componentVersion \
    --http-password $httpCredential \
    --http-user admin \
    --location $location \
    --workernode-count $clusterSizeInNodes \
    --headnode-size "Standard_D4_v2" \
    --workernode-size "Standard_D4_v2" \
    --ssh-password $sshCredentials \
    --ssh-user sshuser \
    --storage-account $AZURE_STORAGE_ACCOUNT \
    --storage-account-key $storageAccountKey \
    --storage-container $AZURE_STORAGE_CONTAINER \
    --version $clusterVersion
```

## 2. Deploy Cosmos DB SQL API

Deploy Cosmos DB SQL API account.

```bash
# Variables for Cosmos DB SQL API resources
accountName="<Account Name>"
databaseName='<Database Name>'

# Create a Cosmos account for SQL API
az cosmosdb create \
    -n $accountName \
    -g $resourceGroupName \
    --locations regionName=$location
```

Create a database in the Cosmos DB account

```bash
# Create a SQL API database
az cosmosdb sql database create \
    -a $accountName \
    -g $resourceGroupName \
    -n $databaseName
```

Create a container. The container name will be `Contacts` and the partition key will be `/officeAddress` according to the data for this lab.

```bash
# Create a new Container
containerName='Contacts'
partitionKey='/officeAddress'
throughput=400

az cosmosdb sql container create \
    -a $accountName -g $resourceGroupName \
    -d $databaseName -n $containerName \
    -p $partitionKey --throughput $throughput
```

## 3. Set up HBase table and sample data

After deploying HDInsight and Cosmos DB, set up a HBase table and import sample data.

### Create HBase table
Connect to HDInsight HeadNode with SSH and use the following `hbase shell` command to create a `Contact` table and column families named `Personal` and `Office`.

```bash
hbase shell
create 'Contacts', 'Personal', 'Office'
exit
```

### Upload sample data
Download Sample Data from [here](data/Contacts.txt) and upload it to your HDInsight's Blob storage.

### Import data into HBase

Convert sample data to StoreFile for bulk import into HBase.

```bash
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.columns="HBASE_ROW_KEY,Personal:Name,Personal:Phone,Office:Phone,Office:Address" -Dimporttsv.bulk.output="/example/data/storeDataFileOutput" Contacts /Contacts.txt
```

Load StoreFile into HBase table.

```bash
hbase org.apache.hadoop.hbase.mapreduce.LoadIncrementalHFiles /example/data/storeDataFileOutput Contacts
```

Check if the data is loaded. If the data is loaded correctly in the Contacts table, the `scan` command will output all the data.

```bash
hbase shell
list
scan ‘Contacts’
```

## 4. Prepare Spark Connectors for Cosmos DB and HBase

### Prepare Spark Cosmos DB Connector

Download the required version of Spark Cosmos DB Connector by referring to the URL below. This lab will use Spark 2.4, so download the connector for Spark 2.

- [Azure Cosmos DB Apache Spark 2 OLTP Connector for Core (SQL) API](https://docs.microsoft.com/azure/cosmos-db/sql/sql-api-sdk-java-spark)
- [Azure Cosmos DB Apache Spark 3 OLTP Connector for Core (SQL) API](https://docs.microsoft.com/azure/cosmos-db/sql/sql-api-sdk-java-spark-v3)

Upload the downloaded jar file to any folder of HDInsight's HeadNode.

### Prepare Spark HBase Connector

Then build and install the Spark HBase Connector.

If the mvn command is not installed on your HeadNode, install it with the following command.

```bash
apt-get install mvn
```

Clone the repository and switch to branch 2.4 for Spark 2.4.

```bash
git clone https://github.com/hortonworks-spark/shc
cd shc
git checkout branch-2.4
```

Build to create a jar file.

```bash
mvn clean package -DskipTests
```

Copy hbase-site.xml to Spark configuration directory so that Spark can load the HBase settings.

```bash
sudo cp /etc/hbase/conf/hbase-site.xml /etc/spark2/conf/
```

## 5. Data migration from HBase to Cosmos DB SQL API using Spark

Start Spark Shell with created jar file and the Cosmos DB Spark Connector.


```bash
spark-shell --jars <Path to Spark HBase Connector Jar>,/usr/hdp/current/hbase-client/lib/shaded-clients/*,<Path to Cosmos DB Spark Connector Jar>
```

Once the Spark shell is up, run the Scala code as follows:

Import libraries needed to load data from HBase.

```Scala
// Import libraries
import org.apache.spark.sql.{SQLContext, _}
import org.apache.spark.sql.execution.datasources.hbase._
import org.apache.spark.{SparkConf, SparkContext}
import spark.sqlContext.implicits._
```

Defines the Spark catalog schema for HBase tables. Where the namespace is `default` and the table name is `Contacts`. The row key is specified as the key. Columns, column families, and columns are mapped to Spark catalog.

```scala
// define a catalog for the Contacts table you created in HBase
def catalog = s"""{
    |"table":{"namespace":"default", "name":"Contacts"},
    |"rowkey":"key",
    |"columns":{
    |"rowkey":{"cf":"rowkey", "col":"key", "type":"string"},
    |"officeAddress":{"cf":"Office", "col":"Address", "type":"string"},
    |"officePhone":{"cf":"Office", "col":"Phone", "type":"string"},
    |"personalName":{"cf":"Personal", "col":"Name", "type":"string"},
    |"personalPhone":{"cf":"Personal", "col":"Phone", "type":"string"}
    |}
|}""".stripMargin
```

Next, define a method to get the data from the HBase `Contacts` table as a DataFrame.

```Scala
def withCatalog(cat: String): DataFrame = {
    spark.sqlContext
    .read
    .options(Map(HBaseTableCatalog.tableCatalog->cat))
    .format("org.apache.spark.sql.execution.datasources.hbase")
    .load()
 }
```

Create a DataFrame using the defined method.

```Scala
val df = withCatalog(catalog)
```

Then import the libraries needed to use the Cosmos DB Spark connector.

```Scala
import com.microsoft.azure.cosmosdb.spark.schema._
import com.microsoft.azure.cosmosdb.spark._
import com.microsoft.azure.cosmosdb.spark.config.Config
```

Make settings to write data to Cosmos DB.

```Scala
val writeConfig = Config(Map("Endpoint" -> "https://<Cosmos Account Name>.documents.azure.com:443/", "Masterkey" -> "<Master Key>", "Database" -> "<Database Name>", "Collection" -> "Contacts", "Upsert" -> "true"))
```

Write DataFrame data to Azure Cosmos DB.

```Scala
import org.apache.spark.sql.SaveMode
df.write.mode(SaveMode.Overwrite).cosmosDB(writeConfig)
```

## 6. Cleanup resources

When the lab is complete, delete the used resources as follows.

```bash
az group delete --name $resourceGroupName
```
