# Challenges of Sentry on-premise  

Common challenges associated with Sentry migrations:

## From Sentry to Ranger

As Sentry uses a Rol Base Access Control (RBAC) to manage the accessibility of the folder of HDFS in this case and Ranger uses an Attribute Base Access Control (ABAC) to manage the accessibility to the folder of HDFS, this is something difficult to convert from one to the other.

Sentry use ACL's to give access to the folder for different users and Ranger+Atlas use the attribute to the type of data and folder to give access to the different users
