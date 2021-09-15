# Migration Approach

## Replatforming to Azure PaaS Services ##
Basically we have two main approaches:

1. Manual Migration from Yarn to the scheduler to use
2. Migrating the Hadoop Yarn configuration file to the compatible engine 


**Yarn Scheduler**

One of the main Yarn components is the Scheduler , where we define all the queue for the hadoops cluster as we can see on the following picture the main queue is root and the childrens will have a portion of the 100% of the resources:

![Yarn-Queues](https://user-images.githubusercontent.com/7907123/133262862-e252993d-3d0d-409d-a232-a4c0f6b1c0f1.png)

For that if we want to migrate Yarn as a PaaS component will be something that we will need to regenerate and replatforming as we do not have any similar services as apache Yarn to manage workload on the cloud.



## Lift & Shift IaaS ##

once we have an up and running hadoop cluster on Azure IaaS we can regenereate the same queues that we have on the on-premise cluster via the Yarn-Queue UI
