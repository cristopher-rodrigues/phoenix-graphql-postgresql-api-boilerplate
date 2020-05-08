# Kafka

## Primary PostgreSQL Data Source

Through [Debezium](https://debezium.io/documentation/reference/1.0/connectors/postgresql.html) 
this Source connector collects the [logical replication CDC)](postgresql.org/docs/current/logical-replication-architecture.html) where in this particular we made usage of [WAL](https://github.com/eulerto/wal2json).

## Secondary Elasticsearch Data Source

Once, we have the [data out](https://www.confluent.io/blog/turning-the-database-inside-out-with-apache-samza/) backed into Kafka, we now can make the data movement in a fashion and frictionless manner.

Through the oficial Confluent's [Elasticsearch sink](https://docs.confluent.io/current/connect/kafka-connect-elasticsearch/index.html) the data is being replicated from the source topic directly to the secondary data-source.

High level overview on how the replication works in a wide E2E view.

![image](https://user-images.githubusercontent.com/3486950/81482340-b01a5500-920c-11ea-9dc9-b38fc7e8bb89.png)

### Setup the Environment

Assuming you already ran the `docker-compose`.

```bash
make setup
```

Make sure the connectors are running

```bash
make connectors-status
```

## Users

Run the users-consumer to follow the messages being sent by the Source Connector to the "source" topic.

```bash
make users-consumer
```

In another terminal window, produce some changes on the Source Database by calling the GraphQL API to insert/update users:

```bash
NAME=John make users-create-mutation
```

You should be able to see new messages appering on the consumer

Make sure the data is being sent to Elasticsearch as well.

```bash
make users-search
```

## Lenses Dashboard

You can access the Lenses Dashboard to follow in a visual manner the Kafka components including the connectors by accessing [fast-data-dev](http://localhost:3030/kafka-connect-ui/#/cluster/fast-data-dev).
