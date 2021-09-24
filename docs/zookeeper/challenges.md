# Zookeeper Challenges

1. For the Quorum we need atleast 3 nodes as 2 node are not enough- to handle single failure
2. Is necesary to Ensemble of odd number of nodes.
3. In this case more is not better Suggested Production cluster size is 3 or 5 

This is very important to choose and monitor the Active/passive NameNode for HDFS as we can see in the following diagram, zookeeper is monitoring constantly the heath stattus of the NamesNodes when are in HA:

![Zookeeper Failovercontroller](https://user-images.githubusercontent.com/7907123/134647046-6ee32464-af17-4197-ac3f-ec956902031e.png)


## Next step

[Migration Approach](migration-approach.md)

## Further Reading 

[Challenges](challenges.md)

[Considerations](considerations.md)

[Architecture and Components](architecture-and-components.md)
