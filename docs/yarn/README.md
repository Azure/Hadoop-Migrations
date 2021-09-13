# Apache YARN

YARN (Yet Another Resource Negotiator) is responsible for managing resources and job schedules in Hadoop. YARN is the resource management framework that enables arbitrary applications to share the same compute resources to access a common pool of data in a distributed file system.  

YARN provides open source resource management for Hadoop, so you can move beyond batch processing and open up your data to a diverse set of workloads, including interactive SQL, advanced modeling, and real-time streaming.

**Migrating Apache YARN to Azure** 

YARN is one of the core components of Hadoop and installed/deployed as part of Apache Hadoop ecosystem.

In the context of **YARN migration to Azure IaaS**, YARN is deployed as part of Hadoop installation on Azure. This is true for all versions of Hadoop (open-source; Hortonworks or Cloudera). There are no scenarios where YARN is migrated to Azure independent of Hadoop cluster it manages.

From **Azure PaaS** migration perspective, YARN doesn't have an equivalent service on Azure. The reason is that it's a supporting application whose primary function is to manage resources and the functions played by it are abstracted by Azure platform when one migrates Hadoop ecosystem to Azure PaaS.  
