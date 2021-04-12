**General disclaimer: DO NOT COPY - UNDER DEVELOPMENT - MS INTERNAL ONLY** \
&nbsp;

# Hadoop Platform migration to Azure

**Contributors: Namrata Maheshwary, Ram Yerrabotu, Daman Kaur, Hideo Takagi, Amanjeet Singh, Raja N, Ram Baskaran, Pawan Hosatti, Ben Sadeghi, Sunil Sattiraju, Danny Liu, Nagaraj Seeplapudur Venkatesan.**

*IMPORTANT - This documentation is currently private preview and the main branch will be updated once a week. Update schedule TBD.*

## Brief introduction to Apache Hadoop 

Hadoop  provides a distributed file system and a framework for the analysis and transformation of very large data sets using the MapReduce paradigm. An important characteristic of Hadoop is the partitioning of data and computation across many (thousands) of hosts, and executing application computations in parallel close to their data. A Hadoop cluster scales computation capacity, storage capacity and IO bandwidth by simply adding commodity hardware.  The key components of an Hadoop system include-   


 
|Component | Description|
|----------|-----------|
|[Apache HDFS](docs/hdfs/architecture-and-components.md) |Distributed File System |
|[Apache HBase](docs/hbase/architecture-and-components.md)      |Column-oriented table service |
|[Apache Hive](docs/hive/architecture-and-components.md)      |Datawarehouse infrastructure |
|[Apache Spark](docs/spark/architecture-and-components.md)     |Data processing Framework |
|[Apache Ranger](docs/ranger/architecture-and-components.md)    |Frame work to monitor and manage Data secuirty |
|MapReduce |Distributed computation framework |
|Pig       |Dataflow language and parallel execution framework |
|Zookeeper |Distributed coordination service |
|Chukwa    |System for collecting management data |
|Avro      |Data serialization system |



This guide recognizes that Hadoop provides an extensive ecosystem of services and frameworks. This guide is not intended to be a definitive document that describes components of the Hadoop ecosystem in detail, or how they are implemented on Azure. Rather, this guide focuses on specific guidance and considerations you can follow to help move your existing data storage -- HDFS , Other Cloud Storage like AWS S3 data to Azure.
 

### Flowcharts

- [Choosing landing target for Apache HBase](/docs/images/flowchart-hbase-azure-landing-targets.png)
- [Choosing storage for Apache HBase on Azure](docs/images/flowchart-hbase-azure-storage-options.png)

### End State Reference Architecture

#### Target States 


![image](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/images/Target_state.png)


- **Lift and Shift(IaaS)**  

The following pattern presents a point of view on how to deploy OSS on Azure IaaS with a tight integration back to a customer's on-premises systems such as Active Directory; Domain Controller; DNS etc. The deployment follows Enterprise Scale Landing Zone guidance from Microsoft where management capabilities such as monitoring; security; governance; networking etc. are hosted within a management subscription. The workloads (all IaaS-based) are hosted in a separate subscription. ESLZ guidance is covered in details [here](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture#landing-zone-in-enterprise-scale).  


![image](docs/images/azure%20iaas%20target%20state%20v2.jpg)  

1. On-premises AD will synchronize with Azure AD (AAD) using AD Connect hosted on-premises.  

2. ExpressRoute provides secure and private network connectivity between on-premises and Azure.  

3. Management (or hub) subscription provides networking and management capabilities for the deployment. This pattern is in line with [Enterprise Scale Landing Zones (ESLZ) guidance from Microsoft](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/architecture#landing-zone-in-enterprise-scale).  

4. The services hosted inside hub subscription provide network connectivity and management capabilities.  

   - **NTP (hosted on Azure VM)** is required to keep the clocks across all the virtual machines synchornized. In the context of various applications (such as HBase, ZooKeeper etc.), it is recommended that you run a Network Time Protocol (NTP) service, or another time-synchronization mechanism on your cluster and that all nodes look to the same service for time synchronization. Instructions for setting up NTP on Linux are available [here](https://tldp.org/LDP/sag/html/basic-ntp-config.html).  

   - **[Azure Network Watcher](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview)** provides tools to monitor, diagnose, view metrics, and enable or disable logs for resources in an Azure virtual network. Network Watcher is designed to monitor and repair the network health of IaaS (Infrastructure-as-a-Service) products which includes Virtual Machines, Virtual Networks, Application Gateways, Load balancers, etc.  

   - **[Azure Advisor](https://docs.microsoft.com/en-us/azure/advisor/advisor-overview)** analyzes your resource configuration and usage telemetry and then recommends solutions that can help you improve the cost effectiveness, performance, Reliability (formerly called High availability), and security of your Azure resources.

   - **[Azure Monitor](https://docs.microsoft.com/en-gb/azure/azure-monitor/overview)** provides a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. This information helps you understand how your applications are performing and proactively identify issues affecting them and the resources they depend on.

   - **[Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace)** is a unique environment for Azure Monitor log data. Each workspace has its own data repository and configuration, and data sources and solutions are configured to store their data in a particular workspace. You require a Log Analytics workspace if you intend on collecting data from the following sources:  

     - Azure resources in your subscription  
     - On-premises computers monitored by System Center Operations Manager  
     - Device collections from Configuration Manager  
     - Diagnostics or log data from Azure storage  

   - **[Azure DevOps Self-Hosted Agent](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops)** hosted on Azure VM Scale-Sets (VMSS) gives you flexibility over the size and the image of machines on which agents run. You specify a virtual machine scale set, a number of agents to keep on standby, a maximum number of virtual machines in the scale set, and Azure Pipelines manages the scaling of your agents for you.  

5. **[Azure Active Directory (AAD)](https://docs.microsoft.com/en-au/azure/active-directory/fundamentals/active-directory-whatis)** tenant is synchronized with on-premises AD via [AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/how-to-connect-sync-whatis) (1).  

6. **[Azure AD Domain Services (AAD DS)](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/synchronization)** provides LDAP and Kerberos capabilities on Azure. When you first deploy Azure AD DS, an automatic one-way synchronization is configured and started to replicate the objects from Azure AD. This one-way synchronization continues to run in the background to keep the Azure AD DS managed domain up-to-date with any changes from Azure AD. No synchronization occurs from Azure AD DS back to Azure AD.  

7. Services such as **[Azure DNS](https://docs.microsoft.com/en-us/azure/dns/private-dns-overview)**,**[Azure Security Center](https://docs.microsoft.com/en-us/azure/security-center/security-center-introduction)** and **[Azure Key Vault](https://docs.microsoft.com/en-au/azure/key-vault/general/basic-concepts)** sit inside the management subscription and provide service/IP address resolution; unified infrastructure security management system and certificate/key management capabilities resptively.

8. **[Virtual Network Peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)** provides connectivity between VNETs deployed in two subscriptions - management (hub) and workload (spoke).  

9. In line with ESLZ, **Workload subscription** is used for hosting application workloads.

10. **[ADLS Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)** is a set of capabilities dedicated to big data analytics, built on Azure Blob storage. In context of big data workloads, ADLS Gen2 can be used as secondary storage for Hadoop. Data written to ADLS Gen2 can be consumed by other Azure services independent of Hadoop framework.  

11. **Big data workloads** are hosted on a set of independent Azure virtual machines. Please refer to guidance for [Hadoop](/docs/hdfs/migration-approach.md), [HBase](/docs/hbase/migration-approach.md), [Hive](/docs/hive/migration-approach.md), [Ranger](/docs/ranger/migration-approach.md)and [Spark](/docs/spark/migration-approach.md) on Azure IaaS for more information.

12. **[Azure DevOps Services](https://docs.microsoft.com/en-us/azure/devops/user-guide/alm-devops-features?view=azure-devops)** is a SaaS offering from Microsoft and provides an integrated set of services and tools to manage your software projects, from planning and development through testing and deployment.
    
-  **Modernize(Azure Synapse Analytics & Azure Databricks)**

![image](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/images/end_State_architecture_Modernize.png)


- **Lift and Shift(HDInsight)**

![image](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/images/Hdinight%20end%20state.png)


For more information Refer the GearUp link: <https://gearup.microsoft.com/resources/azure-hdinsight>




### Glossary of Terms and Acronyms

- [Glossary of Terms and Acronyms](docs/appendix/glossary.md)



## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

This repo is adhering to Microsoft documentation standards. Please make sure that you use Visual Studio Code for alterations and have the [Azure Docs Extension](https://marketplace.visualstudio.com/items?itemName=docsmsft.docs-authoring-pack) installed. Please refer to [Docs Authoring Pack for VS Code](https://docs.microsoft.com/contribute/how-to-write-docs-auth-pack) on how to use this extension and the [Microsoft Writing Style Guide](https://docs.microsoft.com/style-guide/welcome/).
