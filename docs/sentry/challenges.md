# Sentry Migration Challenges

Common challenges associated with Sentry migrations:

**From RBAC to ABAC**

Sentry is an authorization engine and uses a Rol Base Access Control (RBAC) to manage the accessibility & Authorisation of folders, tables and services inside a hadoop cluster 
where as for example Ranger or other authorization engines use an Attribute Base Access Control (ABAC) to manage the accessibility & Authorisation of folders, tables and services inside a hadoop cluster , this is something difficult to convert from one to the other as we are talking about two different concepts.

Sentry use ACL's to give access to the folder for different users and Ranger+Atlas use the attribute to the type of data and folder to give access to the different users

## Next step

[Additional Third Party tools](considerations.md)

## Further Reading 

[Architecture and Components](architecture-and-components.md)

[Additional Third Party tools](considerations.md)

[Migration Approach](migration-approach.md)
