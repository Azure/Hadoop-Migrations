# Apache ZooKeeper  

## Overview  

Apache ZooKeeper (ZK) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these features are used in some form or another by distributed applications. ZK incorporates these functions/features so that distributed applications do not have to worry about implementation details on how to solve these challenges within the application.  

Distributed applications such as Apache Kafka, Apache HBase etc. rely on ZK for addressing challenges associated with distributed applications such as race conditions; leader election etc.

The find out more about the motivation behind ZooKeeper and its applications, please check [Apache ZooKeeper](https://zookeeper.apache.org/doc/current/zookeeperOver.html). It covers ZooKeeper in detail and the motivation behind it.  

![zookeeper](https://user-images.githubusercontent.com/7907123/134483156-c6c8ae3a-25f5-446a-b1f0-9e748420f37a.png)

Example architecture with Kafka

![Kafka with Zookeeper](https://user-images.githubusercontent.com/7907123/134483257-0b69061a-7a94-4e3c-9e44-5fc5c446acd8.png)

## Next step

[Considerations](considerations.md)

## Further Reading 

[Migration Approach](migration-approach.md)

[Challenges](challenges.md)

[Architecture and Components](architecture-and-components.md)




