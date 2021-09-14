# Migration Approach

## Replatforming to Azure PaaS Services ##
Basically we have two main approaches:

1. Manual Migration from Yarn to the scheduler to use
2. Migrating the Hadoop Yarn configuration file to the compatible engine 


**Yarn Scheduler**

One of the main Yarn components is the Scheduler , where we define all the queue for the hadoops cluster as we can see on the following picture the main queue is root and the childrens will have a portion of the 100% of the resources:

![Yarn-Queues](https://user-images.githubusercontent.com/7907123/133042587-c482f763-7e8c-4587-8c05-df88f0ac9971.png)

For that if we want to migrate Yarn As a PaaS compoenent will be something that we will need to regenerate and replatforming as we do not have any similar services as apache Yarn to manage workload on the cloud.



## Lift & Shift IaaS ##
