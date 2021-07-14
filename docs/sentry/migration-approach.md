
# Migration Approach

Azure has several landing targets for Apache Sentry. Depending on requirements and product features, App Service and Azure Functions:
https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization

Landing Targets for Apache Sentry on Azure

![Sentry](https://user-images.githubusercontent.com/7907123/125590459-1324bfb6-7d6e-4fec-b9ea-edf2b346b207.png)


| Migration Service                      | Manual Migration                       | Automatic Migration | Third-Party Tool |
| ----------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |------------------------------------------------------------ |
| HDInsights                         |      + |     + |     + |
| Databricks                             |     + |     - |      + |
| Active directory integration (Azure RBAC) |     + |     - |      - |



# Sentry to Azure RBAC
Curretly we do not have any Automatic procedure, but we can do a manual migration, following the steps on this documentation:
https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=current

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

