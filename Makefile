default: up

heartcheck:
	curl http://localhost:4000/monitoring | jq .

app:
	docker exec -it boilerplate-app bash

up:
	docker-compose up

down:
	docker-compose down -v

tests:
	docker exec -it boilerplate-app /bin/sh -c "MIX_ENV=test mix test"

run:
	docker exec -it boilerplate-app mix phx.server

clean-build:
	rm -rf _build

coveralls:
	docker exec -it boilerplate-app /bin/sh -c "MIX_ENV=test mix coveralls"

credo:
	docker exec -it boilerplate-app mix credo

format:
	docker exec -it boilerplate-app mix format --check-formatted

# GRAPHQL

graphql-query-users-find:
	curl -H 'Content-Type: application/json' -XPOST http://localhost:4000/graphiql -d '{"query":"query($$uuid: UUID4!){user(uuid :$$uuid){uuid, name}}","variables":{"uuid":"${UUID}"}}' | jq .

graphql-query-users-list:
	curl -H 'Content-Type: application/json' -XPOST http://localhost:4000/graphiql -d '{"query": "query users{users{nodes{uuid, name}, hasNextPage, endCursor}}","variables":null,"operationName":"users"}' | jq .

graphql-mutation-users-update:
	curl -H 'Content-Type: application/json' -XPOST http://localhost:4000/graphiql -d '{"query":"mutation($$uuid: UUID4!, $$name:String!){updateUser(uuid: $$uuid, name: $$name){uuid, name}}", "variables":{"uuid":"${UUID}","name":"${NAME}"}}' | jq .

graphql-query-users-search:
	curl -H 'Content-Type: application/json' -XPOST http://localhost:4000/graphiql -d '{"query":"query($$query: String!){usersSearch(query: $$query){nodes{uuid, name}, scrollId}}","variables":{"query":"${QUERY}"}}' | jq .

graphql-mutation-users-remove:
	curl -H 'Content-Type: application/json' -XPOST http://localhost:4000/graphiql -d '{"query":"mutation($$uuid: UUID4!){removeUser(uuid: $$uuid){uuid}}","variables":{"uuid":"${UUID}"}}' | jq .

graphql-mutation-users-create:
	curl -H 'Content-Type: application/json' -XPOST http://localhost:4000/graphiql -d '{"query":"mutation($$name: String!){createUser(name: $$name){uuid,name}}","variables":{"name":"${NAME}"}}' | jq .
