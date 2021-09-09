## Apache YARN ##

YARN stands for “Yet Another Resource Negotiator“, the fundamental idea of YARN is to split up the functionalities of resource management and job scheduling/monitoring into separate daemons. The idea is to have a global ResourceManager (RM) and per-application ApplicationMaster (AM). An application is either a single job or a DAG of jobs.

The ResourceManager and the NodeManager form the data-computation framework. The ResourceManager is the ultimate authority that arbitrates resources among all the applications in the system. The NodeManager is the per-machine framework agent who is responsible for containers, monitoring their resource usage (cpu, memory, disk, network) and reporting the same to the ResourceManager/Scheduler.

The per-application ApplicationMaster is, in effect, a framework specific library and is tasked with negotiating resources from the ResourceManager and working with the NodeManager(s) to execute and monitor the tasks.

**Yarn Components:**

***Client:*** Applications which request resources to yarn through a mapreduce job.
Resource Manager:Master Yarn daemon , responsible of all mapreduce jobs assignment and management. Whenever it receives a processing request, it forwards it to the corresponding node manager and allocates resources for the completion of the request accordingly. It has two major components:

1. ***Application manager:*** Is the daemon which accepts the applications and request the containers once it know how resources will need,also restarts the Application Manager container if a task fails.

2. ***Scheduler:*** The purpouse of the scheduler is the management of resources share pool among all the jobs, YARN use the Capacity Scheduler and Fair Scheduler to partition the cluster resources using this different queues prioritization.

***Node Manager:*** The main purpouse of the node manager is to keep-up with the resource manager and also, monitors resources usage, performs log management and also kills a container based on directions from the resource manager. It is also responsible for creating the container process and start it on the request of Application master.

***Application Master:*** The application master send a Container which includes all that the applications need for running once the node manager recieve the request from the application master and keeps the comunications to know the status of the application to the resource manager.

***Container:*** Is a container of resources where the applications runs the jobs and contains all the information that require as environment variables, security tokens, dependencies etc...

**Yarn Application workflow**

1. Client submits an application
2. The Resource Manager allocates a container to start the Application Manager
3. The Application Manager registers itself with the Resource Manager
4. The Application Manager negotiates containers from the Resource Manager
5. The Application Manager notifies the Node Manager to launch containers
6. Application code is executed in the container
7. Client contacts Resource Manager/Application Manager to monitor application’s status
8. Once the processing is complete, the Application Manager un-registers with the Resource Manager

![Yarn](https://user-images.githubusercontent.com/7907123/132715866-1ebaf075-9117-4ce2-b374-11dbf507b456.png)


More information: https://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/YARN.html
