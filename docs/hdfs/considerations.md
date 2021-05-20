
## Migration Considerations

There are some considerations when planning the migration of HDFS to ADLS. Based on our experience with customer engagements the below have been identified -

- Consider aggregating the data in small     files into a single file when storing in ADLS Gen 2 
- HDFS symlinks - Jobs requiring file     system features like strictly atomic directory renames, fine-grained HDFS     permissions, or HDFS symlinks can only work on HDFS.
- Azure Storage can be geo-replicated.     Although geo-replication gives geographic recovery and data redundancy, a     failover to the geo-replicated location severely impacts the performance,     and it may incur additional costs. The recommendation is to choose the     geo-replication wisely and only if the value of the data is worth the     additional cost.
- If the file     names have common prefixes , the storage treats them as a single partition     and hence if Azure Data Factory is used , all     DMUs write to a single partition.

![Diagram  Description automatically generated](../images/clip_image008.jpg)

- If Azure Data factory is     chosen as an approach for data transfer – scan through each directory     excluding snapshots , check the size of each directory using the hdfs du     command. If there are multiple subfolders and large volume of data - initiate multiple copy activities in     ADF – one per subfolder instead of transferring the entire data in a     directory in a single copy activity

![img](../images/clip_image010.png)

- As part of migration , when interacting with Azure Blob Storage via the Hadoop FileSystem client, there may be instances where the methods may not be supported.  by the AzureNativeFileSystem ie. throws an UnsupportedOperationException. For Eg - append(Path f, int bufferSize, Progressable progress) is an optional operation in AzureNativeFileSystem and is currently is not yet supported
For other issues related to ABFS refer link - https://issues.apache.org/jira/browse/HADOOP-15763

- For requirements where it is needed to connect to ADLS from existing older clusters ( prior to v3.1) backported driver details can be found at the link - https://github.com/Azure/abfs-backport
