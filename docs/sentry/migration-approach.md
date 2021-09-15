

# Migration Approach

## Replatforming to Azure PaaS Services ##

Azure has several landing targets for Apache Sentry. Depending on requirements and product features, App Service and Azure Functions:
https://docs.microsoft.com/azure/app-service/overview-authentication-authorization

**Access Control Methods** 

*ABAC*
Attribute-based access control (ABAC) is an authorization system that defines access based on attributes associated with security principals, resources, and environment. With ABAC, you can grant a security principal access to a resource base on attributes.

*RBAC*
Access management for cloud resources is a critical function for any organization that is using the cloud. Role-based access control (RBAC) helps you manage who has access to resources, what they can do with those resources, and what areas they have access to based on Roles

Landing Targets for Apache Sentry on Azure


![Sentry](https://user-images.githubusercontent.com/7907123/132818412-f2f22608-7dc9-4a9b-b26f-c18571634ba9.png)


**Migration to Azure Active Directory (RBAC)**
Sentry is the authorization method for the Hadoop cluster and is base on ACL's and Role Base Access Control (RBAC) and as the Azure method for authorization is Azure Active Directory which is base on RBAC the migration approach is direct.

First what we can do is to get all the sentry policies following this procedure:
https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=61309948

Once we have all the policies  and as we do not have an automatic procedure , we can do a manual migration, following the steps on this documentation:
https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=current

**Migration to Ranger**

As Ranger and Sentry were the main service for the authorization layer for most of the hadoop clusters is common to migrate from Sentry to Ranger as Sentry is a deprecated service is common and HDInsights use Ranger

Currently there is only a way to migrate Sentry RBAC policies to Ranger ABAC policies, but is under the path of a third-party vendor.

https://docs.cloudera.com/cdp-private-cloud/latest/upgrade-cdh/topics/cdpdc-sentry-pre-upgrade-migration-to-ranger.html


**Migration to Databricks**

The authentication method of Azure Databricks is Azure Active Directory (AAD) which actually is using a RBAC as authorization system, where we define the access granularity for the world of tables and folders defining the Row-level and column permissions. 

This access control is base on the AAD and the databricks ACL's, as Sentry use ACL's as Databricks this will be an advantage to migrate the service. 

Some companies are migrating Ranger Policies to databricks cluster using an intermediate solution:

https://www.immuta.com/articles/migrating-from-apache-ranger-to-immuta-on-databricks/

**Migration to CosmosDB**

Cosmos DB use Active directory integration (Azure RBAC)	You can also provide or restrict access to the Cosmos account, database, container, and offers (throughput) using Access control (IAM) in the Azure portal. IAM provides role-based access control and integrates with Active Directory.

**Migration to  HDInsight from Ranger**

The main Authorization service of HDInsights is Ranger and to migrate the same service from one cluster to another we can do as follow:

*Using the API*

In order to migrate all policies from a Ranger cluster to another cluster we should get all the policies and export it one by one as follows:

1.Export policies from CDP/HDP cluster:
```console
  http://<ranger_address>:6080/service/plugins/policies/download/<clustername>_hadoop
```
2.Import ranger policies one by one to HDInsight 
```console  
  curl -iv -u <user>:<password> -d @<policy payload> -H "Content-Type: application/json" -X POST http://<RANGER-Host>:6080/service/public/api/policy/
```  
*Using the UI*

We can use the import/export button on the Ranger UI in order to export and import all the ranger policies as we can see on the following pictures

![image](https://user-images.githubusercontent.com/7907123/125410503-3906c080-e3bd-11eb-9026-758cf6b1e81c.png)
![image](https://user-images.githubusercontent.com/7907123/125410524-3efca180-e3bd-11eb-939f-0042e67cf096.png)


More detail on the following documentation:[Import-Export Ranger Policies](https://cwiki.apache.org/confluence/display/RANGER/User+Guide+For+Import-Export)


**Summary Table:**

| Migration Service                      | Manual Migration                       | Automatic Migration | Third-Party Tool |
| ----------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |------------------------------------------------------------ |
| HDInsights                         |      + |     +* |     + |
| Databricks                             |     + |     - |      + |
| CosmosDB |     + |     - |      - |
| Active directory integration (Azure RBAC) |     + |     - |      - |

(*) Doing a Previous migration to Ranger

## Further Reading 

[Sentry Architecture and Components](readme.md)

[Challenges](challenges.md)

[Additional Third Party tools](considerations.md)
