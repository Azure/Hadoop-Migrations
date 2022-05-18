# Additional Third-party tools

## Privecera

Privacera helps enterprises leverage data efficiently by providing a centralized platform built natively on top of Apache Ranger. This enables, monitors, and manages data security within Hadoop and cloud services for highly scalable data access and associated policy management.
For more information visit <https://docs.privacera.com>.

## MLens

MLens is an accelerator toolkit from Knowledge Lens which enables automated workload migration from Hadoop- Cloudera or Hortonworks distributions to Databricks. They provide one-time migration utilities to migrate policy data intelligently to Azure Service.
For more information visit <https://www.knowledgelens.com/Products/MLens/>

## Immuta

The Immuta platform solves the problem of access and governance by providing a single, unified access point for data across an organization and ensuring that all restrictions placed on data are dynamically enforced through the platform. This unification creates efficient digital data exchanges and provides complete visibility of policy enforcement and monitoring. Immuta has several access patterns some which include Azure Synapse and Databricks.
For more information visit <https://www.immuta.com/capabilities/data-access-governance/>

# Open source tools

## Project RaPTor - Ranger Policy Translator Tool

The intended purpose of the [Ranger Policy Translation Tool](https://github.com/hurtn/ranger-migration#readme) is to periodically synchronise resource-based Apache RangerTM policies with Azure Datalake Storage (ADLS) ACLs. This can be used either as a one-off migration from Ranger resource-based policies to ADLS ACLs or as a continuous sychronisation mechanism. 
For those using HDInsight Enterprise Security Package (ESP), the security principals (users and groups) in Ranger will usually linked to Azure Active Directory (AAD) identities, but for those using non AAD based identities you will need to ensure there is a corresponding user principal name (UPN) in AAD which can be associated with the storage ACL.

[Previous](considerations.md)   [Next](migration-approach.md)

