# Apache HDFS to ADLS Gen2 migration lab

Hands-on lab to migrate data from HDFS to ADLS Gen2 using Distcp command and Azure Data Factory.

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

## 3. Set up HDFS Folder Structure and load sample data

After deploying HDInsight , set up a HDFS Folder structure and import sample data.
<Need to add commands>
### Create HDFS Folder Structure
Connect to HDInsight HeadNode with SSH and use the following `<TBC>` command to create a `Contact` folder .

```bash
    
   <TBD>
exit
```

### Upload sample data
Download Sample Data from [here](data/Contacts.txt) and upload it to your HDInsight's Blob storage.

### Import data into HDFS

Convert sample data to StoreFile for bulk import into HBase.


Check if the data is loaded. If the data is loaded correctly in the Contacts table, the `scan` command will output all the data.

```bash
hdfs list

```



## 6. Cleanup resources

When the lab is complete, delete the used resources as follows.

```bash
az group delete --name $resourceGroupName
```
