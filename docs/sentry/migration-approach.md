# Migration Approach

Azure has several landing targets for Apache Sentry. Depending on requirements and product features.

Landing Targets for Apache Sentry on Azure

![Sentry](https://user-images.githubusercontent.com/7907123/122224778-bae5f580-ceb4-11eb-9d38-aef6ff871fbe.png)

# Sentry to Ranger

Currently there is only a way to migrate Sentry RBAC policies to Ranger ABAC policies, but is under the path of a third-party vendor.

https://docs.cloudera.com/cdp-private-cloud/latest/upgrade-cdh/topics/cdpdc-sentry-pre-upgrade-migration-to-ranger.html


# Ranger to Databricks

Some companies are migrating Ranger Policies to databricks cluster using an intermediate solution:

https://www.immuta.com/articles/migrating-from-apache-ranger-to-immuta-on-databricks/

