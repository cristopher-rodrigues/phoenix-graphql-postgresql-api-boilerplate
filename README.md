# Boilerplate [![Build Status](https://travis-ci.com/cristopher-rodrigues/boilerplate-be.svg?token=fnHBQhvUoN1zMVexkAyq&branch=master)](https://travis-ci.com/cristopher-rodrigues/boilerplate-be)

The back-end (service API) component for the Boilerplate.

## Workflow

This project include a couple of nice components on its scaffolding such as:

- [x] [Phoenix](https://phoenixframework.org/)
- [x] [GraphQL](https://graphql.org/)
  - [x] [Absinthe](https://github.com/absinthe-graphql/absinthe)
  - [x] [Subscriptions](https://github.com/absinthe-graphql/absinthe/blob/master/guides/subscriptions.md)
  - [x] [Graphiql](https://hexdocs.pm/absinthe_plug/Absinthe.Plug.GraphiQL.html)
- [x] Data Source
  - [x] [PostgreSQL](https://www.postgresql.org/) (Primary)
  - [x] [Elasticsearch](https://www.elastic.co/) `FTS` (Secondary)
    - [x] [Kibana](https://www.elastic.co/guide/en/kibana/current/dashboard.html)
  - [x] Redis `Cache`
- [x] [Heartcheck](https://github.com/locaweb/heartcheck-elixir)
- [x] [Kafka](https://kafka.apache.org/)
    - [x] [Kafka Ex](https://github.com/kafkaex/kafka_ex)
- [x] [Elixir releases](https://hexdocs.pm/mix/Mix.Tasks.Release.html)
- [x] [Dotenv](https://github.com/avdi/dotenv_elixir)
- [x] Docker
- [x] Kubernetes
  - [x] [k3d](https://github.com/rancher/k3d/)
  - [x] [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets)
  - [ ] HPA
- [x] CI/Travis
- [x] [credo](https://github.com/rrrene/credo)
- [x] Telemetry
- [x] Datadog
- [x] Spandex
- [x] Cors
- [x] Formatter
- [x] Tests
  - [x] Coverage [coveralls](https://github.com/parroty/excoveralls)
  - [x] Factories
  - [x] Mocks [Mox](https://github.com/dashbitco/mox)

General high-level overview 

![high-view](https://user-images.githubusercontent.com/3486950/81603225-63698200-93a4-11ea-8657-6d0fae55c534.png)

## Setup

### Docker

The app is fully wrapped by [Docker](https://www.docker.com/).

### Running

Then you can start the containers:

```sh
make up
```

### Setup Kafka (optional)

If you want to use the FTS (eg. userSearch) follow [these instructions](./kafka/README.md).

Then, run the app

```sh
make run
```

The server will be available by default accessing http://localhost:4000

### Testing

```sh
make tests
```

#### Coverage

```sh
make coveralls
```

### Credo

```sh
make credo
```

### Format

```sh
make format
```

### Running only the App Without Docker

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes without docker running the app itself, but still for services (e.g Databases, Kafka, etc).

### Requirements

*   [asdf](https://github.com/asdf-vm/asdf)
*   [asdf-elixir](https://github.com/asdf-vm/asdf-elixir)
*   [asdf-erlang](https://github.com/asdf-vm/asdf-erlang)
*   [Docker](https://www.docker.com/)

### Installing

Install the versions of elixir and erlang defined at .tool-versions

```sh
asdf install
```

### Environment variables

In the project root dir, create a file `.env.local` (which will override the default `.env`).

```
BOILERPLATE_ELASTIC_URL=http://localhost:9200
BOILERPLATE_TEST_ELASTIC_URL=http://localhost:9200
BOILERPLATE_DATABASE_URL=postgres://user:password@localhost:5435/boilerplate_dev
BOILERPLATE_TEST_DATABASE_URL=postgres://user:password@localhost:5435/boilerplate_test
BOILERPLATE_REDIS_CACHE_URL=redis://localhost:6381/0
BOILERPLATE_TEST_REDIS_CACHE_URL=redis://localhost:6381/1
BOILERPLATE_REDIS_PUBSUB_URL=redis://localhost:6381/2
```

### Running

Start the services (using Docker)

```bash
docker-compose up --scale app=0
```

Download the dependencies

```sh
mix deps.get
```

Start the web server

```sh
mix phx.server
```

The server will be available by default accessing http://localhost:4000

### Testing

```sh
MIX_ENV=test mix test
```

#### Coverage

```sh
MIX_ENV=test mix coveralls
```

### Credo

```sh
mix credo
```

### Format

```sh
mix format --check-formatted
```

## Running tasks on non-dev environments.

Given that the project is using mix releases to create production images, we'll not
be able to run Mix tasks in non-dev environments (staging, production), given Mix
is not available in the images produced for them.

To run any type of task in these environments we need to define a function that runs
that task in `Boilerplate.ReleaseTasks` and in the environment we're able to trigger that
with a command.

For a concrete example, you can run migrations in these environments with the command:

```sh
$ /app/boilerplate/rel/boilerplate/bin/boilerplate eval "Boilerplate.ReleaseTasks.migrate()"
```

The migration task call will basically create the needed indexes on Elasticsearch and prepare its document mapping.

You can check more details on that in the [Phoenix documentation](https://hexdocs.pm/phoenix/releases.html#ecto-migrations-and-custom-commands).

## Environment variables

*   `BOILERPLATE_HOST` - The host that the server generate the internal URL. Ex: `boilerplate.com`
*   `BOILERPLATE_PORT` - The port that the server will start. Ex: `4000`.
*   `BOILERPLATE_ALLOWED_ORIGINS` - Comma separated list of allowed origins used on CORS validation.
*   `BOILERPLATE_SECRET_KEY_BASE` - Key used to sign [phoenix cookie sessions](https://phoenixframework.org/blog/sessions). Ex: `9Gf55vJqIr89bFKq0gHXTlO2iNzP/gyE/jVeLLKn2rAPhH1q2ePO+3wT5VGbZE50`.

**Elasticsearch**

*   `BOILERPLATE_ELASTIC_URL` - The elastic's url. Ex: `localhost:9200`
*   `BOILERPLATE_TEST_ELASTIC_URL` - Url of the Elasticsearch used for tests.
*   `BOILERPLATE_USERS_ELASTIC_INDEX` - The elastic's needed index to store users data. Ex: `postgresql.public.users`
*   `BOILERPLATE_TEST_USERS_ELASTIC_INDEX` - The elastic's needed index to store users data for tests. Ex: `postgresql.public.users-test`
*   `BOILERPLATE_USERS_ELASTIC_DOCUMENT` - The elastic's users document. Ex: `users`
*   `BOILERPLATE_TEST_USERS_ELASTIC_DOCUMENT` - The elastic's users document for test. Ex: `users-test`.
*   `BOILERPLATE_ELASTIC_SEED_FILE` - The used file to bulk index users. Ex: `data/seed.json`
*   `BOILERPLATE_ELASTIC_DEFAULT_SIZE` - Default page limit size for elastic queries. Ex: `10`

**Datadog**

*   `BOILERPLATE_DATADOG_PORT` - Port of the datadog agent REST API. Ex: `8126`.
*   `BOILERPLATE_DATADOG_HOST` - Host of the datadog agent. Ex: `localhost`.
*   `BOILERPLATE_ENABLE_DATADOG` - Feature flag to enable database. Set it to `true` to enable datadog tracing and metrics.
*   `BOILERPLATE_DATADOG_UDP_PORT` - Port of the datadog agent UDP API. Ex: `8125`.
*   `BOILERPLATE_DATADOG_SERVICE_NAME` - Service name used by Datadog. Ex: `users_staging`.
*   `BOILERPLATE_DATADOG_ENVIRONMENT_NAME` - Datadog environment name. Ex: `staging`, `production`.
*   `BOILERPLATE_SPANDEX_BATCH_SIZE` - Number of traces send in each batch to datadog. Ex: `100`.
*   `BOILERPLATE_SPANDEX_SYNC_THRESHOLD` - How many simultaneous HTTP pushes will be going to Datadog. Ex: `100`.

**PostgreSQL**
*   `BOILERPLATE_DATABASE_URL` - The primary datasource, PostgreSQL URL. Ex: `postgres://user:password@postgresql:5432/boilerplate_dev`
*   `BOILERPLATE_TEST_DATABASE_URL` - The primary datasource, PostgreSQL URL for tests. Ex: `postgres://user:password@postgresql:5432/boilerplate_test`

**Redis**
*   `BOILERPLATE_REDIS_CACHE_URL` - The Cache URL used for cache purpose. Ex: `redis://redis:6379/0`
*   `BOILERPLATE_TEST_REDIS_CACHE_URL` - The Cache URL used for cache purpose in test environment. Ex: `redis://redis:6379/1`
HOSTNAME=boilerplate_dev
*   `BOILERPLATE_REDIS_PUBSUB_URL` - The Cache URL used for [phoenix pubsub](https://github.com/phoenixframework/phoenix_pubsub_redis). Ex: `redis://redis:6379/2`

### Variable naming standard

The naming scheme must include `BOILERPLATE`, the name of the service and the variable name itself.
For example: ```BOILERPLATE_FOO=bar```

The idea is to avoid naming collisions in the Kubernetes environment.

## Dotenv

The dotenv will override the env vars in the following order (highest defined variable overrides lower):

| Hierarchy Priority | Filename              | Environment      | Should I `.gitignore`it? | Notes                                             |
| ------------------ | --------------------- | ---------------- | ------------------------ | ------------------------------------------------- |
| 1st (highest)      | `.env.local.$MIX_ENV` | dev/test/prod    | Yes!                     | Local overrides of environment-specific settings. |
| 2nd                | `.env.$MIX_ENV`       | dev/test/prod    | No.                      | Overrides of environment-specific settings.       |
| 3rd                | `.env.local`          | All Environments | Yes!                     | Local overrides                                   |
| Last               | `.env`                | All Environments | No.                      | The Original®                                     |

**Note**: `$MIX_ENV` refers to the environment of the build, as `dev`, `test` and `prod`. Ex: `.env.local.test` will be loaded only when the environment is `test`.

## HeartCheck

By running

```bash
make heartcheck
```

You should be able to see something like:

```json
[
  {
    "elastic": {
      "status": "ok"
    },
    "time": 9.703
  },
  {
    "database": {
      "status": "ok"
    },
    "time": 8.188
  },
  {
    "cache_redis": {
      "status": "ok"
    },
    "time": 3.817
  }
]
```

## GraphQL

### Creating a User

```sh
NAME=John make graphql-mutation-users-create
```

```sh
NAME="John Lennon" make graphql-mutation-users-create
```

### Finding a User

```sh
UUID=USER_UUID make graphql-query-users-find
```

### Listing Users

```sh
make graphql-query-users-list
```

### Updating a User

```sh
UUID=USER_UUID NAME="John Wick" make graphql-mutation-users-update
```

### Searching Users

```sh
QUERY=oh make graphql-query-users-search
```

### Removing a User

```sh
UUID=USER_UUID make graphql-mutation-users-remove
```

If you prefer, having the server running go to `http://localhost:4000/graphiql` in your prefered browser.

## Kubernetes

For Infra and Kubernetes info, please check [this](k8s/README.md)

## Kafka

This boilerplate also includes a secondary data-source for FTS purposes (Elasticsearch).
Behind the scenes it's a CDC replication from the primary data-source (PostgreSQL) through the usage of Kafka connenct
Source <> Sink ingesting the Elasticsearch.

In order to make it works you need to perform a simple setup which you can find the instructions [here](./kafka/README.md).

## Kibana Dashboard

For more info [access](elasticsearch/kibana/README.md)

## Front-end app

The Front-end React app for this project can be found [here](https://github.com/cristopher-rodrigues/phoenix-graphql-postgresql-api-boilerplate-fe).
