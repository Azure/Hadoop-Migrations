# Challenges of Sentry on premise  

Common challenges associated with Sentry migrations:

**From Sentry to Ranger**
As Sentry use a Rol Base Access Control (RBAC) in order to manage the accessibility  the folder of HDFS in this case and Ranger use a Atributte Base Access Control (ABAC) to manage the accessibility to the folder of HDFS, this is something difficult to convert from one to the other.

Sentry use ACL's in order to give access to the folder for different users and Ranger+Atlas use atribute to the type of data and folder to give access to the differents users
