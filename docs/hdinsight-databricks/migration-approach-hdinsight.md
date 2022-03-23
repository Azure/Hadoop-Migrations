# Migration Approach

## Assessment

## Considerations

**HDInsight Spark:**
Azure HDInsight as "A cloud-based service from Microsoft for big data analytics". It is a cloud-based service from Microsoft for big data analytics that helps organizations process large amounts of streaming or historical data.

**Main features from the HDInsight platform:**
* Fully managed
* Variety of services for multiple porpuses
* Open-source analytics service for entreprise companies


HDInsight is a service that is always up and we have to understand deeply the service to be able to configure and tunned , that make the service complex compare with others.Most of HDInsights features are Apache based. There are several cluster types to choose from depending upon your need.
[Azure HDInsight Runtime for Apache Spark 3.1](https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/spark-3-1-is-now-generally-available-on-hdinsight/ba-p/3253679)

**Synapse Spark:**
Azure Synapse Analytics takes the best of Azure SQL Data Warehouse and modernizes it by providing more functionalities for the SQL developers such as adding querying with serverless SQL pool, adding machine learning support, embedding Apache Spark natively, providing collaborative notebooks, and offering data integration within a single service. In addition to the languages supported by Apache Spark, Synapse Spark also support C#.

**Synapse Spark Primary Use-Cases**

1. Consolidated type of nodes for starters to pick e.g., Small, Medium, Large node types compared to different node types.

2. Ephemeral Jobs: Synapse spark is built for short term processing and hence all the cluster have a TTL (Time to Live) and are automatically terminated to save costs.

3. Support for both reading and writing into Synapse tables.

4. Built in support for .NET for spark application enables existing user skill set to take advantage of Apache Spark distributed data processing.

![spark-synapse-options](../images/spark-synapse-options.png)

5. Unified security and monitoring features including Managed VNets throughout all workloads with one Azure Synapse workspace

6. Existing spark user to take advantage of Microsoft proprietary optimizations e.g., Hyperspace: An indexing subsystem for Apache Spark.

**Main features from Azure Synapse:**
* Complete T-SQL based analytics
* Hybrid data integration
* Apache Spark integration
HDInsight and Synapse Spark are using the same version of Apache Spark 3.1, that is a good starting point when we try to performa a migration from different platform.
as we are using the same Spark version code and jars will be able to deploy in Synapse easily.

Synapse is consumption-based, and is easier to configurate.Synapse incorporates many other Azure services and is the main plaform for Analytics and Data Orchestration.
[Azure Synapse Runtime for Apache Spark 3.1](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-3-runtime)

### Performance Considerations

Refer to [Optimize Spark jobs for performance - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-performance) for considerations.

## Planning

![image](https://user-images.githubusercontent.com/7907123/159463342-43cc4701-c901-414f-8752-f0f08eaead0d.png)

## Migration Approach

Azure has several landing targets for Apache Spark. Depending on requirements and product features, customers can choose between Azure Synapse, Azure Databricks and Azure HDInsight.

![image](https://user-images.githubusercontent.com/7907123/159687313-b5436dda-3ce5-4702-8f0f-dc5e2a334bc0.png)

### Migration Scenarios

1. Moving from HDInsight Spark to Synapse Spark.


### Creating an Apache Spark Pool

An Apache Spark pool in your Synapse Workspace provides Spark environment to load data, model process and get faster insights.

Reference Link: [QuickStart: Create a serverless Apache Spark pool using the Azure portal - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/quickstart-create-apache-spark-pool-portal)

### Spark Instances

Spark instances are created when you connect to a Spark pool, create a session, and run a job. As multiple users may have access to a single Spark pool, a new Spark instance is created for each user that connects.

Examples on how the spark pools behave are shown below, Spark pools need to be created based on the usage type.

**Example 1**

* You create a Spark pool called SP1; it has a fixed cluster size of 20 nodes.

* You submit a notebook job, J1 that uses 10 nodes, a Spark instance, SI1 is created to process the job.

* You now submit another job, J2, that uses 10 nodes because there is still capacity in the pool and the instance, the J2, is processed by SI1.

* If J2 had asked for 11 nodes, there would not have been capacity in SP1 or SI1. In this case, if J2 comes from a notebook, then the job will be rejected; if J2 comes from a batch job, then it will be queued.

**Example 2**

* You create a Spark pool call SP2; it has an auto scale enabled 10 – 20 nodes.

* You submit a notebook job, J1 that uses 10 nodes, a Spark instance, SI1, is created to process the job.

* You now submit another job, J2, that uses 10 nodes, because there is still capacity in the pool the instance auto grows to 20 nodes and processes J2.

**Example 3**

* You create a Spark pool called SP1; it has a fixed cluster size of 20 nodes.

* You submit a notebook job, J1 that uses 10 nodes, a Spark instance, SI1 is created to process the job.

* Another user, U2, submits a Job, J3, that uses 10 nodes, a new Spark instance, SI2, is created to process the job.
* You now submit another job, J2, that uses 10 nodes because there's still capacity in the pool and the instance, J2, is processed by SI1.

Reference Link: [Apache Spark core concepts - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-concepts#spark-instances)

>[!NOTE] Each Synapse workspace has a default quota limit at the Workspace level and also at the Spark pool level. These requirements need to be captured during the assessment phase (Infrastructure)

### Data Storage:

Spark is a processing framework and does not store any data, once the processing is complete an appropriate sink needs to be chosen.

| HDInsight         | Synapse               | Comment        |Reference Links|
| ------------------- | -------------------- | --------------  |--------------|
| HDFS      | ADLS       |                 | [Import and Export data between HDInsight HDFS to Synapse ADLS | Microsoft Docs](https://github.com/Azure/databox-adls-loader)       |


### Data Migration:

Synapse Spark supports reading multiple different file formats (ORC, Parquet etc.) so use the same migration strategy as on-premises HDFS migration.

#### Migrate HDFS Store to Azure Data Lake Storage Gen2

The key challenge for customers with existing on-premises Hadoop clusters that wish to migrate to Azure (or exist in a hybrid environment) is the movement of the existing dataset. The dataset may be very large, which likely rules out online transfer. Transfer volume can be solved by using Azure Data Box as a physical appliance to 'ship' the data to Azure.

This set of scripts provides specific support for moving big data analytics datasets from an on-premises HDFS cluster to ADLS Gen2 using a variety of Hadoop and custom tooling.

###### Prerequisites

The mechanism to copy data from an on-premise HDFS cluster to ADLS Gen2 relies on the following:

1. A Hadoop cluster containing the source data to be migrated.
2. A Hadoop cluster running in Azure (eg. HDInsight, etc.).
3. An [Azure Data Box device](https://azure.microsoft.com/services/storage/databox/). 

    - [Order your Data Box](https://docs.microsoft.com/azure/databox/data-box-deploy-ordered). While ordering your Box, remember to choose a storage account that **doesn't** have hierarchical namespaces enabled on it. This is because Data Box does not yet support direct ingestion into Azure Data Lake Storage Gen2. You will need to copy into a storage account and then do a second copy into the ADLS Gen2 account. Instructions for this are given in the steps below.
    - [Cable and connect your Data Box](https://docs.microsoft.com/azure/databox/data-box-deploy-set-up) to an on-premises network.
4. A head or edge node on the above cluster that you can SSH onto with `python` (>= 2.7 or 3) installed with `pip`.

##### Process - Overview

1. Clone this repo on the on-premise Hadoop cluster
2. Use the Hadoop tool `distcp` to copy data from the source HDFS cluster to the Data Box
3. Ship the Data Box to Azure and have the data loaded into a non-HNS enabled Storage Account
4. Use a data transfer tool to copy data from the non-HNS enabled Storage Account to the HNS-enabled ADLS Gen2 account
5. Translate and copy permissions from the HDFS cluster to the ADLS Gen2 account using the supplied scripts

##### Step 1 - Clone Github repository to download required scripts

1. On the on-premise Hadoop cluster edge or head node, execute the following command to clone this Github repo. This will download the necessary scripts to the local computer:
    ```bash
    git clone https://github.com/Azure/databox-adls-loader.git
    cd databox-adls-loader
    ```
2. Ensure that the `jq` package is installed. Eg. For Ubuntu:
    ```bash
    sudo apt-get install jq
    ``` 
3. Install the `requests` python package:
    ```bash
    pip install requests
    ```
4. Set execute permissions on the required scripts
    ```bash
    chmod +x *.py *.sh
    ```
5. (Optional) If the WASB driver is not in the standard `CLASSPATH` set a shell variable `azjars` to point to the `hadoop-azure` and the `*azure-storage*` jar files. These files are under the Hadoop installation directory (You can check if these files exist by using this command `ls -l $<hadoop_install_dir>/share/hadoop/tools/lib/ | grep azure` where `<hadoop_install_dir>` is the directory where you have installed Hadoop). Use the full paths. Eg:

    ```
    azjars=$hadoop_install_dir/share/hadoop/tools/lib/hadoop-azure-2.6.0-cdh5.14.0.jar
    azjars=$azjars,$hadoop_install_dir/share/hadoop/tools/lib/microsoft-windowsazure-storage-sdk-0.6.0.jar
    ```

6. [Create a service principal & grant 'Storage Blobs Data Owner' role membership](https://docs.microsoft.com/azure/storage/common/storage-auth-aad-rbac-portal). Record the client id & secret, so that these values can be used to authenticate to the ADLS Gen2 account in the steps below.


##### Step 2 - Distcp data from HDFS to Data Box

1. Setup the Data Box onto the on-premise network following instructions here: [Cable and connect your Data Box](https://docs.microsoft.com/azure/databox/data-box-deploy-set-up)
2. Use cluster management tools to add the Data Box DNS name to every node's `/etc/hosts` file
3. (Optional) If the size of data you wish to migrate exceeds the size of a single Data Box you will need to split the copies over multiple Data Box instances. To generate a list of files that should be copied, run the following script from the previously cloned Github repo (note the elevated permissions):

    ```bash
    sudo -u hdfs ./generate-file-list.py [-h] [-s DATABOX_SIZE] [-b FILELIST_BASENAME]
                        [-f LOG_CONFIG] [-l LOG_FILE]
                        [-v {DEBUG,INFO,WARNING,ERROR}]
                        path

    where:
    positional arguments:
    path                  The base HDFS path to process.

    optional arguments:
    -h, --help            show this help message and exit
    -s DATABOX_SIZE, --databox-size DATABOX_SIZE
                            The size of each Data Box in bytes.
    -b FILELIST_BASENAME, --filelist-basename FILELIST_BASENAME
                            The base name for the output filelists. Lists will be
                            named basename1, basename2, ... .
    -f LOG_CONFIG, --log-config LOG_CONFIG
                            The name of a configuration file for logging.
    -l LOG_FILE, --log-file LOG_FILE
                            Name of file to have log output written to (default is
                            stdout/stderr)
    -v {DEBUG,INFO,WARNING,ERROR}, --log-level {DEBUG,INFO,WARNING,ERROR}
                            Level of log information to output. Default is 'INFO'.
    ````

4. Any filelist files that were generated in the previous step must be copied to HDFS to be accessible in the `distcp` job. Use the following command to copy the files:

    ```bash
    hadoop fs -copyFromLocal {filelist_pattern} /[hdfs directory]
    ```

5. When using `distcp` to copy files from the on-premise Hadoop cluster to the Data Box, some directories will need to be excluded (they generally contain state information to keep the cluster running and so are not important to copy). The `distcp` tool supports a mechanism to exclude files & directories by specifying a series of regular expressions (1 per line) that exclude matching paths. On the on-premise Hadoop cluster where you will be initiating the `distcp` job, create a file with the list of directories to exclude, similar to the following:

    ```
    .*ranger/audit.*
    .*/hbase/data/WALs.*
    ```

6. Create the storage container on the Data Box that you want to use for data copy. You should also specify a destination directory as part of this command. This could be a dummy destination directory at this point.

    ```
    hadoop fs [-libjars $azjars] \
    -D fs.AbstractFileSystem.wasb.Impl=org.apache.hadoop.fs.azure.Wasb \
    -D fs.azure.account.key.{databox_blob_service_endpoint}={account_key} \
    -mkdir -p  wasb://{container_name}@{databox_blob_service_endpoint}/[destination_dir]
    ```

7. Run a list command to ensure that your container and directory were created.

    ```
    hadoop fs [-libjars $azjars] \
    -D fs.AbstractFileSystem.wasb.Impl=org.apache.hadoop.fs.azure.Wasb \
    -D fs.azure.account.key.{databox_blob_service_endpoint}={account_key} \
    -ls -R  wasb://{container_name}@{databox_blob_service_endpoint}/
    ```

8. Run the following [distcp](https://hadoop.apache.org/docs/current/hadoop-distcp/DistCp.html) job to copy data and metadata from HDFS to Data Box. Note that we need to elevate to HDFS super-user permissions to avoid missing data due to lack of permissions:

    ```bash
    sudo -u hdfs \
    hadoop distcp [-libjars $azjars] \
    -D fs.AbstractFileSystem.wasb.Impl=org.apache.hadoop.fs.azure.Wasb \
    -D fs.azure.account.key.{databox_blob_service_endpoint}={account_key} \
    -filters {exclusion_filelist_file} \
    [-f filelist_file | /[source directory]] wasb://{container_name}@{databox_blob_service_endpoint}/[path]
    ```

   The following example shows how the `distcp` command is used to copy data.
   
    ```
    sudo -u hdfs \
    hadoop distcp -libjars $azjars \
    -D fs.AbstractFileSystem.wasb.Impl=org.apache.hadoop.fs.azure.Wasb \
    -D fs.azure.account.key.mystorageaccount.blob.mydataboxno.microsoftdatabox.com=myaccountkey \
    -filter ./exclusions.lst -f /tmp/copylist1 -m 4 \
    wasb://hdfscontainer@mystorageaccount.blob.mydataboxno.microsoftdatabox.com/data
   ```
  
    To improve the copy speed:
    - Try changing the number of mappers. (The above example uses `m` = 4 mappers.)
    - Try running mutliple `distcp` in parallel.
    - Remember that large files perform better than small files.       

##### Step 3 - Ship the Data Box to Microsoft

Follow these steps to prepare and ship the Data Box device to Microsoft.

1. After the data copy is complete, run [Prepare to ship](https://docs.microsoft.com/azure/databox/data-box-deploy-copy-data-via-rest) on your Data Box. After the device preparation is complete, download the BOM files. You will use these BOM or manifest files later to verify the data uploaded to Azure. Shut down the device and remove the cables. 
2.	Schedule a pickup with UPS to [Ship your Data Box back to Azure](https://docs.microsoft.com/azure/databox/data-box-deploy-picked-up). 
3.	After Microsoft receives your device, it is connected to the network datacenter and data is uploaded to the storage account you specified (with Hierarchical Namespace disabled) when you ordered the Data Box. Verify against the BOM files that all your data is uploaded to Azure. You can now move this data to a Data Lake Storage Gen2 storage account.

##### Step 4 - Move the data onto your Data Lake Storage Gen2 storage account

To most efficiently perform analytics operations on your data in Azure, you will need to copy the data to a storage account with the [Hierarchical Namespace](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-namespace) enabled - an Azure Data Lake Storage Gen2 account.

You can do this in 2 ways. 

- Use [Azure Data Factory to move data to ADLS Gen2](https://docs.microsoft.com/azure/data-factory/load-azure-data-lake-storage-gen2). You will have to specify **Azure Blob Storage** as the source.

- Use your Azure-based Hadoop cluster. You can run this DistCp command:

    ```bash
    hadoop distcp -Dfs.azure.account.key.{source_account}.dfs.windows.net={source_account_key} abfs://{source_container}@{source_account}.dfs.windows.net/[path] abfs://{dest_container}@{dest_account}.dfs.windows.net/[path]
    ```

This command copies both data and metadata from your storage account into your Data Lake Storage Gen2 storage account.

##### Step 5 - Copy and map identities and permissions from HDFS to ADLS Gen2

1. On the on-premise Hadoop cluster, execute the following Bash command to generate a list of copied 
files with their permissions (depending on the number of files in HDFS, this command may take a long time to run):

    ```bash
    sudo -u hdfs ./copy-acls.sh -s /[hdfs_path] > ./filelist.json
    ```

2. Generate the list of unique identities that need to be mapped to AAD-based identities:

    ```bash
    ./copy-acls.py -s ./filelist.json -i id_map.json -g
    ```

3. Using a text editor open the generated `id_map.json` file. For each JSON object in the file, update the `target` attribute (either an AAD User Principal Name (UPN) or objectId (OID)) with the mapped identity. Once complete save the file for use in the next step.

4. Run the following script to apply permissions to the copied data in the ADLS Gen2 account. Note that the credentials for the service principal created during the Step 1 above should be specified here:

    ```bash
    ./copy-acls.py -s ./filelist.json -i ./id_map.json  -A adlsgen2hnswestus2 -C databox1 --dest-spn-id {spn_client_id} --dest-spn-secret {spn_secret}
    ```
You can see more details in the following repository:[Import and Export data between HDInsight HDFS to Synapse ADLS | Microsoft Docs](https://github.com/Azure/databox-adls-loader)

## Metadata migration
**Shared Metadata**
Azure Synapse Analytics allows the different workspace computational engines to share databases and Parquet-backed tables between Apache Spark pools and other External Metasotres. More information is available from the below link: 

[External metadata tables - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-external-metastore)

Also we are able to share an external metastore:
Reference: [Shared metadata tables - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/metadata/table)
## Code migration
In order to migrate all the notebooks/code that we have in other environments we will need to use the import button, when we create a new notbook as we can see in the following picture:

![image](https://user-images.githubusercontent.com/7907123/159435877-74220752-0794-41bf-9b2e-136d3a853739.png)

Then depending of the Spark version you should perform the commented changes that this link shows:

[Spark 2.4 to 3.0](https://spark.apache.org/docs/latest/sql-migration-guide.html#upgrading-from-spark-sql-24-to-30)

[Spark 3.0 to 3.1](https://spark.apache.org/docs/latest/sql-migration-guide.html#upgrading-from-spark-sql-30-to-31)

[Spark 3.1 to 3.2](https://spark.apache.org/docs/latest/sql-migration-guide.html#upgrading-from-spark-sql-31-to-32)

## Monitoring

Reference link for monitoring Spark application: [Monitor Apache Spark applications using Synapse Studio - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/azure/synapse-analytics/monitoring/apache-spark-applications)

## Performance benchmarking approach

## Security

## BC-DR

## Further Reading

[Spark Architecture and Components](readme.md)

[Considerations](considerations.md)

[Databricks Migration](databricks-migration.md)
