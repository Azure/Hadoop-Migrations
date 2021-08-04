Table of Contents

[Structure of this guide	5](#_Structure_of_this)

>   [Further reading	5](#_Toc68005895)

[Hadoop Architecture & Components	6](#_Toc68005896)

>   [Brief introduction to Apache Hadoop	6](#_Toc68005897)

[Hadoop Distributed File Systems (HDFS)	8](#_Toc68005898)

>   [Common Challenges of an on premise HDFS	8](#_Toc68005899)

>   [HDFS Architecture and Components	9](#_Toc68005900)

>   [Feature Map	11](#_Toc68005901)

>   [Migration Considerations	14](#_Toc68005902)

>   [Migration Approach	15](#_Toc68005903)

>   [HDFS Assessment	15](#_Toc68005904)

>   [Data Transfer	18](#_Toc68005905)

>   [Reference Implementation - ARM Templates	24](#_Toc68005906)

>   [Pseudocode	24](#_Toc68005907)

>   [Architectural Guidance	24](#_Toc68005908)

>   [Patterns & Anti – Patterns	24](#_Toc68005909)

>   [Performance Tuning	24](#_Toc68005910)

[Databricks – Migration	25](#_Toc68005911)

>   [Considerations & Feature Map	25](#_Toc68005912)

>   [Technology Mapping	26](#_Toc68005913)

>   [Migrations Patterns	27](#_Toc68005914)

[HBase	28](#_Toc68005915)

>   [Challenges of HBase on premise	28](#_Toc68005916)

>   [HBase Architecture and Components	28](#_Toc68005917)

>   [Brief introduction to Apache Hbase	28](#_Toc68005918)

>   [Core Concepts	29](#_Toc68005919)

>   [Considerations	31](#_Toc68005920)

>   [Migration Approach	32](#_Toc68005921)

>   [Lift and shift – Azure IaaS	33](#_Toc68005922)

>   [Migrating Apache HBase to Azure Cosmos DB (SQL API)	45](#_Toc68005923)

>   [Modernization – Cosmos DB (SQL API)	45](#_Toc68005924)

[Hive	65](#_Toc68005925)

>   [Challenges of Hive on premise	65](#_Toc68005926)

>   [Hive Architecture and Components	65](#_Toc68005927)

>   [Considerations	66](#_Toc68005928)

>   [Migration Approach	66](#_Toc68005929)

>   [Sizing	69](#_Toc68005930)

>   [Modernization – Databricks	70](#_Toc68005931)

>   [Modernization – Synapse	73](#_Toc68005932)

>   [MPP Architecture	73](#_Toc68005933)

>   [Serverless / Dedicated SQL / Spark Pools	73](#_Toc68005934)

>   [Columnar Table Storage	74](#_Toc68005935)

>   [Polybase and Data Loading options	74](#_Toc68005936)

>   [Distribution Options: - Hash / Round Robin / Replicate	74](#_Toc68005937)

>   [Security	74](#_Toc68005938)

>   [Target Architecture:	74](#_Toc68005939)

>   [Migration approach:	74](#_Toc68005940)

>   [Live migration:	74](#_Toc68005941)

>   [Offline migration:	83](#_Toc68005942)

>   [Post migration checks:	84](#_Toc68005943)

>   [Synapse Optimization Guidance	84](#_Toc68005944)

>   [Lift and Shift – HDInsight	85](#_Toc68005945)

>   [Lift and Shift – IAAS	85](#_Toc68005946)

>   [Decision Map/Flowchart	85](#_Toc68005947)

>   [Feature Map & Workaround	85](#_Toc68005948)

>   [Reference Implementation - ARM Templates	85](#_Toc68005949)

>   [Pseudocode	85](#_Toc68005950)

>   [Architectural Guidance	86](#_Toc68005951)

>   [Patterns & Anti – Patterns	86](#_Toc68005952)

>   [Performance Tuning	86](#_Toc68005953)

>   [HA & DR	86](#_Toc68005954)

[Apache Ranger	86](#_Toc68005955)

>   [Challenges of Ranger on premise	86](#_Toc68005956)

>   [Apache Ranger Architecture and Components	86](#_Toc68005957)

>   [Migration Approach	88](#_Toc68005958)

>   [Modernization – AAD + Databricks	88](#_Toc68005959)

>   [Modernization – AAD + Azure PAAS Services	88](#_Toc68005960)

>   [Lift and Shift – HDInsight	92](#_Toc68005961)

>   [Lift and Shift – IAAS (INFRASTRUCTURE AS A SERVICE)	95](#_Toc68005962)

>   [Decision Map/Flowchart	95](#_Toc68005963)

>   [Ranger - Hbase	96](#_Toc68005964)

>   [Ranger – HDFS	96](#_Toc68005965)

>   [Ranger – Hive	98](#_Toc68005966)

>   [Feature Map & Workaround	98](#_Toc68005967)

>   [Pseudocode	99](#_Toc68005968)

>   [Architectural Guidance	99](#_Toc68005969)

>   [Patterns & Anti – Patterns	99](#_Toc68005970)

>   [Performance Tuning	99](#_Toc68005971)

>   [HA & DR	99](#_Toc68005972)

[Apache Spark	99](#_Toc68005973)

>   [Challenges of Spark on premise	99](#_Toc68005974)

>   [Apache Spark Architecture and Components	100](#_Toc68005975)

>   [Considerations	100](#_Toc68005976)

>   [Migration Approach	100](#_Toc68005977)

>   [Modernization – Databricks	100](#_Toc68005978)

>   [Modernization – Synapse	100](#_Toc68005979)

>   [Lift and Shift – HDInsight	100](#_Toc68005980)

>   [Lift and Shift – IAAS	100](#_Toc68005981)

>   [Decision Map/Flowchart	100](#_Toc68005982)

>   [Feature Map & Workaround	101](#_Toc68005983)

>   [Reference Implementation - ARM Templates	101](#_Toc68005984)

>   [Pseudocode	101](#_Toc68005985)

>   [Architectural Guidance	101](#_Toc68005986)

>   [Patterns & Anti – Patterns	101](#_Toc68005987)

>   [Performance Tuning	101](#_Toc68005988)

>   [HA & DR	101](#_Toc68005989)


## Structure of this guide

This guide recognizes that Hadoop provides an extensive ecosystem of services and frameworks. This guide is not intended to be a definitive document that describes components of the Hadoop ecosystem in detail, or how they are implemented on Azure. Rather, this guide focuses on specific guidance and considerations you can follow to help move your existing data storage – HDFS , Other Cloud Storage like AWS S3 data to Azure.

It is assumed that you already have HDFS deployed in an on-premises datacentre and exploring one of migration targets on Azure – Azure ADLS Gen2 ;

## Early Considerations

For customers new to Azure, we recommend [Enterprise Scale Landing Zone guidance](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/) to build fundamental capabilities so that  and scale in a performant fashion. These capabilities enable customers to land new workloads whilst maintaining a strong policy-driven governance to ensure that the platform and workloads are compliant.

For designing and deploying workloads to Azure, we recommend [Microsoft Azure Well-Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/). It serves as a guide and highlights key areas like scalability, operations, reliability etc. that one must consider and factor-in while building a solution on Azure.

For support on Azure migration , we recommend[ Azure Migration Program](https://gearup.microsoft.com/resources/azure-migration-program-overview) ( AMP) is a centrally managed program to help simplify and accelerate migration and enable customer success. Customers can get the help they need to simplify the journey to the cloud. Wherever they are in their cloud journey, AMP help accelerate progress. AMP offers **proactive guidance and the right mix of expert help** at every stage of the migration journey to ensure they can migrate infrastructure, databases and application workloads with confidence. All customers can access resources and tools such as free migration tools, step-by-step technical guidance, training and help in finding a migration partner.[[DK1\]](#_msocom_1) 

------

Further reading in my opinion is an optional paragraph where reader can find more information around the same topic or next natural steps, whereas this paragraph seems to be important before starting the migration. A different heading such as "planning migration" or "early considerations" seems more appropriate.  [[DK1\]](#_msoanchor_1)
