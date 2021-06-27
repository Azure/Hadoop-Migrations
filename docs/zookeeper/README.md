# Apache ZooKeeper

## Overview

Apache ZooKeeper (ZK) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications initially usually skimp on them ,which make them brittle in the presence of change and difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications are deployed.

## Migrating Apache ZooKeeper to cloud  

### Migration to Azure IaaS  

Apache ZooKeeper is built to provide coordination between distributed processes and solve challenges associated with distributed applications such as leader election; coordination; race conditions etc.  

Due to the role it plays, it's recommended to keep ZooKeeper close to the distributed application it supports. It's anti-pattern to keep ZooKeeper and the application in separate data centers or separate regions (on Azure). It's preferable to keep latency under "XXXXX" milli-seconds. 

Unless a customer has developed custom/in-house distributed application on-premises, rarely ZooKeeper is deployed in isolation and/or migrated to a different data center or cloud independent of the distributed application it supports. Popular stacks such sa Cloudera; HortonWorks etc. deploy ZooKeeper as part of the deployment so independent migration of ZK is not required.  

In scenarios where customer is deploying vanilla version of Apache HBase, Kafka or an in-house application which relies on ZK, one needs to plan and deploy ZK on Azure IaaS.

### Migration to Azure PaaS  

As highlighted earlier, ZK's role is to provide coordination between distributed processes. Hence, migration of an instance of ZK on its own to Azure PaaS is not a common scenario. However, if you have built an application that relies on ZK, guidance is to deploy ZK on Azure IaaS. Other popular applications such as Kafka, Storm, HBase etc. do have an equivalent Azure PaaS version which transparently takes care of the challenges which ZK solves, hence a separate ZK deployment while migrating to Azure PaaS is not required.  



