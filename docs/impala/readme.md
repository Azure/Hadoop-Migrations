# Impala Architecture and Components

## Overview

Impala is an MPP (Massive Parallel Processing) query execution engine that runs on a number of systems in the Hadoop cluster. Unlike traditional storage systems, impala is decoupled from its storage engine. It has three main components namely, Impala daemon (Impalad), Impala Statestore, and Impala metadata or metastore.

The Impala Daemon

Daemon is the core Impala component is the Impala, represented by the impalad process. key functions that an Impala daemon performs are:

    • Reads/writes to data files.

    • Accepts queries transmitted from the impala-shell command, Hue, JDBC, or ODBC.

    • Query Parallelization and distribution  wok across the cluster.

    • Transmits  query results back to the central coordinator

The Impala Statestore

StateStore checks on the health of all Impala daemons in a cluster, and continuously transmits its findings to each of those daemons. It is physically represented by a daemon process named StateStored. It broadcasts metadata to coordinators.

The Impala Catalog Service

The Catalog Service relays the metadata changes from Impala SQL statements to all the Impala daemons in a cluster. It is physically represented by a daemon process named Catalogd.
The catalog service avoids the need to issue REFRESH and INVALIDATE METADATA statements when the metadata changes are performed by statements issued through Impala.
### Further Reading

[Challenges](challenges.md)

[Migration Approach](migration-approach.md)
