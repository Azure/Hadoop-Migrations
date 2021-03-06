# Apache Ranger Architecture and Components

There are components involved in the authorization process:

**Sentry Server**: The Sentry RPC server manages the authorization metadata. It supports interface to securely retrieve and manipulate the metadata;

**Data Engine:** This is a data processing application such as Hive or Impala that needs to authorize access to data or metadata resources. The data engine loads the Sentry plugin and all client requests for accessing resources are intercepted and routed to the Sentry plugin for validation;

**Sentry Plugin:** The Sentry plugin runs in the data engine. It offers interfaces to manipulate authorization metadata stored in the Sentry server, and includes the authorization policy engine that evaluates access requests using the authorization metadata retrieved from the server.

**Key Concepts:**

- 	***Authentication*** - Verifying credentials to reliably identify a user

- 	***Authorization*** - Limiting the user’s access to a given resource

- 	***User*** - Individual identified by underlying authentication system

- 	***Group*** - A set of users, maintained by the authentication system

- 	***Privilege*** - An instruction or rule that allows access to an object

- 	***Role*** - A set of privileges; a template to combine multiple access rules

- 	***Authorization models*** - Defines the objects to be subject to authorization rules and the granularity of actions allowed. For example, in the SQL model, the objects can be databases or tables, and the actions are SELECT, INSERT, CREATE and so on. For the Search model, the objects are indexes, collections and documents; the access modes are query, update and so on.

**Role-Based Access Control**
 
Role-based access control (RBAC) is a powerful mechanism to manage authorization for a large set of users and data objects in a typical enterprise. New data objects get added or removed, users join, move, or leave organisations all the time. RBAC makes managing this a lot easier. Hence, as an extension of the discussed previously, if Carol joins the Finance Department, all you need to do is add her to the

finance-department group in AD. This will give Carol access to data from the Sales and Customer tables.

**Sentry Integration with the Hadoop Ecosystem**

![Hadoop Stack - Sentry (1)](https://user-images.githubusercontent.com/7907123/135984745-4948d600-547a-4dd1-a587-8b4602c77461.png)


Information from:https://cwiki.apache.org/confluence/display/SENTRY/Sentry+Tutorial#SentryTutorial-ArchitectureOverview


## Next step

[Challenges](challenges.md)

## Further Reading 

[Architecture and Components](architecture-and-components.md)

[Additional Third Party tools](considerations.md)

[Migration Approach](migration-approach.md)
