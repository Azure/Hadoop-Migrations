## Apache Yarn Considerations ##
As Yarn is the Resource Manager of Hadoop we will need to consider the following things:
  
  1. Jobs are running manage by Yarn
  2. All the Queues for the differents jobs are definied into Yarn UI
  3. The Capacity Scheduler is part of the Yarn Service
  4. We can write YARN Applications on a hadoop cluster
  5. ResourceManager HA
  6. Depending of the flexibility of our cluster all jobs could run in all machine but in some cases we will need to use the Node Labels in order to choose specific nodes for specific jobs
  7. The Yarn capacity Scheduler mode , most of the times the configuration of yarn will be on Fair Scheduler mode and other times could be in FIFO mode

## Next step

[Migration Approach](migration-approach.md)

## Further Reading 

[Architecture and Components](architecture-and-components.md)

[Challenges](challenges.md)

[Considerations](considerations.md)

