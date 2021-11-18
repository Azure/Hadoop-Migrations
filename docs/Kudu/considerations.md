# Considerations  

* Azure PaaS does not currently have services that support Kudu. Kudu needs to be migrated to other storage platforms.

* Kudu is relatively often used with Impala. In that case, it needs to be considered for its dependency on the destination of Impala. Impala is also not supported on Azure PaaS. See also the Impala migration guide.

* If you need to migrate Kudu metadata to Hive Metastore, make sure that integration with Hive Metastore is enabled. If it is not enabled, you need to understand compatibility and limitations with Hive Metastore. See [Using the Hive Metastore with Kudu](https://kudu.apache.org/docs/hive_metastore.html) in the official Impala documentation for more details.

#### Next step

[Migration Approach](migration-approach.md)

### Further Reading

[Architecture and Components](readme.md)

[Challenges](challenges.md)

[Migration Approach](migration-approach.md)
