
# Apache Sentry

## Overview 

[Apache Sentry](https://sentry.apache.org/) is a granular, role-based authorization module for Hadoop. Sentry provides the ability to control and enforce precise levels of privileges on data for authenticated users and applications on a Hadoop cluster. Sentry currently works out of the box with Apache Hive, Hive Metastore/HCatalog, Apache Solr, Impala and HDFS (limited to Hive table data). Sentry is designed to be a pluggable authorization engine for Hadoop components. It allows you to define authorization rules to validate a user or application’s access requests for Hadoop resources. Sentry is highly modular and can support authorization for a wide variety of data models in Hadoop.


## Migrating Apache Sentry to Azure

Sentry is one of the core components of Hadoop and installed/deployed as part of Apache Hadoop ecosystem.

In the context of Sentry migration to Azure IaaS , Sentry is deployed as part of Hadoop installation on Azure. This is true for the cloudera Hadoop versions. There are some scenarios where Sentry is migrated to Azure independent of Hadoop cluster it manages. because is not part of all the hadoop cluster, what is more common and not deprecated is Apache Ranger

From Azure PaaS migration perspective, Sentry have an equivalent service on Azure that is Azure Active Directory. 

## Next step

[Architecture and Components](architecture-and-components.md)

## Further Reading 

[Challenges](challenges.md)

[Additional Third Party tools](considerations.md)

[Migration Approach](migration-approach.md)
