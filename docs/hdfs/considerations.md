
## Migration Considerations[[HT16\]](#_msocom_16) 

There are some considerations when planning the migration of HDFS to ADLS. Based on our experience with customer engagements the below have been identified -

[[DK17\]](#_msocom_17)

- Consider aggregating the data in small     files into a single file when storing in ADLS Gen 2 
- HDFS symlinks - Jobs requiring file     system features like strictly atomic directory renames, fine-grained HDFS     permissions, or HDFS symlinks can only work on HDFS.
- Azure Storage can be geo-replicated.     Although geo-replication gives geographic recovery and data redundancy, a     failover to the geo-replicated location severely impacts the performance,     and it may incur additional costs. The recommendation is to choose the     geo-replication wisely and only if the value of the data is worth the     additional cost.
- If the file     names have common prefixes , the storage treats them as a single partition     and hence if Azure Data Factory[[HT18\]](#_msocom_18) is used , all     DMUs write to a single partition.

![Diagram  Description automatically generated](..\images\clip_image008.jpg)

- If Azure Data factory is     chosen as an approach for data transfer – scan through each directory     excluding snapshots , check the size of each directory using the hdfs du     command. If there are multiple subfolders and large volume of data - initiate multiple copy activities in     ADF – one per subfolder instead of transferring the entire data in a     directory in a single copy activity

![img](..\images\clip_image010.png)