# Apache YARN

YARN (Yet Another Resource Negotiator) is responsible for managing resources and job schedules in Hadoop. YARN is the resource management framework that enables arbitrary applications to share the same compute resources to access a common pool of data in a distributed file system.  

YARN provides open source resource management for Hadoop, so you can move beyond batch processing and open up your data to a diverse set of workloads, including interactive SQL, advanced modeling, and real-time streaming.

## Migrating Apache YARN to Azure  

YARN doesn't have an equivalent service on Azure. It's primary role is resource management for Hadoop ecosystem and in case of PaaS (or modernization) migration path, the function played by YARN is abstracted from customers and managed by Azure platform itself.  

For IaaS (or lift and shift) migrations to Azure, YARN is migrated across along with Hadoop ecosystem. It's one of the core components of Hadoop along with HDFS and it gets deployed as part of Hadoop installation. This is true for both open source and proprietary versions of Hadoop.  
