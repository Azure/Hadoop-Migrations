# Migration Approach

ZK is a synchornization service designed to solve challenges such as leader election, race conditions etc. associated with distributed applications. As an open-source coordination service for distributed applications, it exposes a simple set of primitives that distributed applications can build upon to implement higher level services for synchronization, configuration maintenance, and groups and naming.

## Lift and shift migration  

ZK is a coordination service, and customers will almost always migrate ZooKeeper along with the distributed application (Kafka, Storm etc.) it supports.

### **Planning and Sizing for Azure Compute & Storage**

For production deployment, we recommend deploying ZK on dedicated Azure VMs. Dedicated in this context is referring to a VM which is not running any other workload other than ZK. The emphasis on dedicated VMs is due to the fact that ZK provides high durability guarantees. To be able to deliver it, we want to avoid a deployment where it might run into contentions for resources such as compute, memory, networking or storage.

Another important factor to design and size ZK deployment is to factor-in the nature of use-cases and applications it supports. If an ensemble is supporting multiple applications, one might consider deploying multiple ensembles of ZK nodes to support each individual application. Example - Some large deployments have separate ZK ensemble to support HBase and Kafka. 

An ensemble of 5 virtual machines with following specs is a good starting point:

- **A minimum of 8 vCores**. Whilst ZK is not compute intensive however it's sensitive to context switching. If your ZK ensemble is supporting multiple distributed applications (HBase, Kafka etc.), one should consider the impact of this. ZK shouldn't have to wait for compute to become available.
  
- **8-16 GB memory**. ZK is not memory intensive application, however swapping must be avoided. 
  
- **Standard SSD storage** with separate disks to store ZK snapshots and logs. In terms of size, a minimum of 64GB per disk is a good starting point in an enteprise deployment setting.

Translating these requirements to Azure compute and storage, following VMs are a good fit for ZK role:  

- **A-series VMs** with minimum of 8 vCores and 16 GB+ memory. However, these do not support premium storage.  
  
- **Dsv4-series** with support for premium storage. Standard_D8s_v4 is a good spec for a ZK node which does support premium storage.  

[Clustered multi-server setup guidance](https://zookeeper.apache.org/doc/r3.1.2/zookeeperAdmin.html#sc_zkMulitServerSetup)  

## PaaS migration for ZooKeeper

There is no equivalent service for ZooKeeper on Azure; however, the capabilities ZK provides and function it plays in supporting distributed applications are natively built-in to Azure PaaS. For example, if one migrates Apache Kafka to Azure Event Hubs, there is no need to plan for ZooKeeper migration because it's capabilities and functions are built-in to Event Hubs. This is true for PaaS migrations for following PaaS migrations:  

- Apache Kafka to Azure Event Hubs or Azure HDI Kafka

- Apache HBase to Azure Cosmos DB  or Azure HDI HBase

- Apache Storm to Azure Stream Analytics

- Apache Solr to Azure Search  

- Apache Hive to Azure Synapse or Azure HDI Hive