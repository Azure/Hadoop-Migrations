# Considerations  

* If HBase IaaS migration is your first workload on Azure, we strongly recommend investing time and effort in building a strong foundation for workloads hosted on Azure by leveraging Cloud Adoption Framework enterprise-scale landing zone (ESLZ) guidance. Enterprise-scale is an architectural approach and a reference implementation that enables effective construction and operationalization of landing zones on Azure, at scale. This approach aligns with the [Azure roadmap and the Cloud Adoption Framework for Azure](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/architecture).  

* We strongly recommend all workloads deployed on Azure must be designed and deployed in alignment with [Well-Architected Framework](https://docs.microsoft.com/azure/architecture/framework/). The Azure Well-Architected Framework is a set of guiding tenets that can be used to improve the quality of a workload. The framework consists of five pillars of architecture excellence: Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security.  

* While designing and choosing Azure compute and storage, individual service limits must be factored-in. Compute and Storage have limits and these have an implication of sizing of infrastructure for a data-intensive application such as HBase. [Azure scale-limits](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits) should be considered when planning HBase deployment on Azure VMs and storage.  

* Subscription should be used as a unit of scale and more instances of a service must be used to scale-out and go beyond limits associated with a single instance of a service. Taking from Cloud Adoption Framework enterprise-scale design principles, we use subscription as a unit of management and scale aligned with business needs and priorities to support business areas and portfolio owners to accelerate application migrations and new application development. Subscriptions should be provided to business units to support the design, development, and testing of new workloads and migration of workloads.

* Apache HBase allows customers to use different types of storage options for caching and persistent storage. This must be considered while designing Apache HBase solutions on Azure.  

* There is a level of performance optimization and right-sizing of infrastructure involved post-migration to Azure IaaS. Reason is that performance of HBase is dictated by size of infrastructure deployed; choice of storage; and distribution of Regions. Even though we are focusing on lift & shift scenario, Azure infrastructure is fundamentally different to on-premises and there are Azure features and limits that one must consider to meet performance requirements.  


## Next step

[Migration Approach](migration-approach.md)

### Further Reading

Refer to the below sections to read more about Migration approach for Hbase

[Architecture and Components](readme.md)

[Challenges](challenges.md)

[Migration Approach](migration-approach.md)

