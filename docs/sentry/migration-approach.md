# Migration Approach

Azure has several landing targets for Apache Sentry. Depending on requirements and product features, App Service and Azure Functions:
https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization

Landing Targets for Apache Sentry on Azure

![Sentry](https://user-images.githubusercontent.com/7907123/122371706-5b452400-cf60-11eb-89be-01fb4899d924.png)

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


