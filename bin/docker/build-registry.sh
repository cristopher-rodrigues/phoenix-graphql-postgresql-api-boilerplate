#!/bin/bash

docker build --no-cache -t cristopherrodrigues/phoenix-graphql-postgresql-api-boilerplate:latest .
docker push cristopherrodrigues/phoenix-graphql-postgresql-api-boilerplate
