
# Migration Approach

Azure has several landing targets for Apache Sentry. Depending on requirements and product features, App Service and Azure Functions:
https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization

# Authorization Methods 

## ABAC
Attribute-based access control (ABAC) is an authorization system that defines access based on attributes associated with security principals, resources, and environment. With ABAC, you can grant a security principal access to a resource based on attributes.

## RBAC
Access management for cloud resources is a critical function for any organization that is using the cloud. Role-based access control (RBAC) helps you manage who has access to resources, what they can do with those resources, and what areas they have access to based on Roles

Landing Targets for Apache Sentry on Azure

![Sentry](https://user-images.githubusercontent.com/7907123/122378499-4bc8d980-cf66-11eb-95f5-b7373d15116b.png)

# Sentry to Ranger

Currently there is only a way to migrate Sentry RBAC policies to Ranger ABAC policies, but is under the path of a third-party vendor.

https://docs.cloudera.com/cdp-private-cloud/latest/upgrade-cdh/topics/cdpdc-sentry-pre-upgrade-migration-to-ranger.html


# Ranger to Databricks

Some companies are migrating Ranger Policies to databricks cluster using an intermediate solution:

https://www.immuta.com/articles/migrating-from-apache-ranger-to-immuta-on-databricks/

# Ranger from CDP/HDP to HDInsight 

In order to migrate all policies from a Ranger cluster to another cluster we should get all the policies and exporte it one by one as follows:

1.Export policies from CDP/HDP cluster:
```console
  http://<ranger_address>:6080/service/plugins/policies/download/<clustername>_hadoop
```
2.Import ranger policies one by one to HDInsight 
```console  
  curl -iv -u <user>:<password> -d @<policy payload> -H "Content-Type: application/json" -X POST http://<RANGER-Host>:6080/service/public/api/policy/
```  
On the other hand we can use the import/export button on the Ranger UI
![image](https://user-images.githubusercontent.com/7907123/125410503-3906c080-e3bd-11eb-9026-758cf6b1e81c.png)
![image](https://user-images.githubusercontent.com/7907123/125410524-3efca180-e3bd-11eb-939f-0042e67cf096.png)


More detail on the following documentation:[Import-Export Ranger Policies](https://cwiki.apache.org/confluence/display/RANGER/User+Guide+For+Import-Export)

