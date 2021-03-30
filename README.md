**General disclaimer: DO NOT COPY - UNDER DEVELOPMENT - MS INTERNAL ONLY** \
&nbsp;

# Hadoop Platform migration to Azure

**Contributors: Namrata Maheshwary, Ram Yerrabotu, Daman Kaur, Hideo Takagi, Amanjeet Singh, Raja N, Ram Baskaran, Pawan Hosatti, Ben Sadeghi, Danny Liu, Nagaraj Seeplapudur Venkatesan.**

*IMPORTANT - This documentation is currently private preview and the main branch will be updated once a week. Update schedule TBD.*

## Brief introduction to Apache Hadoop 

Hadoop  provides a distributed file system and a framework for the analysis and transformation of very large data sets using the MapReduce paradigm. An important characteristic of Hadoop is the partitioning of data and computation across many (thousands) of hosts, and executing application computations in parallel close to their data. A Hadoop cluster scales computation capacity, storage capacity and IO bandwidth by simply adding commodity hardware.  The key components of an Hadoop system include-   


 
|Component | Description|
|----------|-----------|
|HDFS |Distributed File System |
|MapReduce |Distributed computation framework |
|HBase     |Column-oriented table service |
|Pig       |Dataflow language and parallel execution framework |
|Hive      |Datawarehouse infrastructure |
|Zookeeper |Distributed coordination service |
|Chukwa    |System for collecting management data |
|Avro      |Data serialization system |



This guide recognizes that Hadoop provides an extensive ecosystem of services and frameworks. This guide is not intended to be a definitive document that describes components of the Hadoop ecosystem in detail, or how they are implemented on Azure. Rather, this guide focuses on specific guidance and considerations you can follow to help move your existing data storage -- HDFS , Other Cloud Storage like AWS S3 data to Azure.
 


### Applications

- [Hadoop Distributed File System](docs/hdfs/architecture-and-components.md)
- [Apache HBase](docs/hbase/architecture-and-components.md)
- [Apache Hive](docs/hive/architecture-and-components.md)
- [Apache Spark](docs/spark/architecture-and-components.md)
- [Apache Ranger](docs/ranger/architecture-and-components.md)

### Flowcharts

- [Choosing landing target for Apache HBase](docs/images/flowchart-hbase-azure-landing-targets.png)
- [Choosing storage for Apache HBase on Azure](docs/flowchart-hbase-azure-storage-options.png)


### Business Continuity and Disaster Recovery (BC-DR)  



### Glossary of Terms and Acronyms

- [Glossary of Terms and Acronyms](docs/appendix/glossary.md)

### Deployment Templates

### Performance Tuning  

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
