
# Apache Kudu Architecture and Components

## Overview
[Apache Kudu](https://kudu.apache.org/) is an open source distributed data storage engine that makes fast analytics on fast and changing data easy.

### Apache Kudu Features

- Apache Kudu combines features similar to the combination of HBase and Parquet, providing a combination of fast inserts/updates and efficient column scans across a single storage layer for HTAP.
- Designed to take advantage of hardware features such as in-memory processing and SSD and SIMD computation, it significantly reduces the query latency of the Hadoop ecosystem's analytics engine.
- Apache Kudu uses the consensus algorithm RAFT to ensure that all writes are persisted by at least two nodes before responding to client requests, maintaining very high system availability. 

## Architecture
![Kudu network architecture](https://kudu.apache.org/docs/images/kudu-architecture-2.png)

Image Source : https://kudu.apache.org/docs/

### Key Components

**Table**
- This is where the data will be stored. The table is divided into segments called tablets.

**Tablet**
- A continuous segment of the table. Certain tablets are replicated to multiple tablet servers, and at any given time, one of these replicas is considered the reader tablet. It can be read from any replica.

**Tablet server**
- Provide the tablet to the client. All tablet servers process read requests, but only readers process write requests. One tablet server is the reader and the other server is elected by the consensus algorithm as a follower replica of that tablet.

**Master (The wording of the official documentation is used as is for technical consistency)**
- Track all tablets, tablet servers, catalog tables, and other metadata related to your cluster. 

#### Next step

[Challenges](challenges.md)

## Further Reading

[Challenges](challenges.md)

[Considerations](considerations.md)

[Migration Approach](migration-approach.md)



