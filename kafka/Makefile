users-consumer:
	docker exec -it kafka kafka-avro-console-consumer --topic postgresql.public.users  \
	--bootstrap-server kafka:9092 \
	--property schema.registry.url=http://kafka:8081 \
	--property print.key=true \
	--key-deserializer=org.apache.kafka.common.serialization.StringDeserializer \
	--from-beginning

users-search:
	curl http://localhost:9200/postgresql.public.users/_search |  jq '.'

users-search:
	curl http://localhost:9200/postgresql.public.users/_search |  jq '.'

users-create-mutation:
	curl -XPOST -H 'content-type: application/json' \
		http://localhost:4000/graphiql -d \
		'{"query":"mutation{\n  createUser(name:\"${NAME}\"){\n    uuid\n    name\n  }\n}","variables":null}'

connectors-status:
	curl -s http://localhost:3030/api/kafka-connect/connectors/boilerplate-postgresql-source/status | jq '.' && \
		curl -s http://localhost:3030/api/kafka-connect/connectors/boilerplate-elasticsearch-sink/status | jq '.'

connectors-register: 
	curl -X POST \
		http://localhost:3030/api/kafka-connect/connectors \
		-H 'Content-Type: application/json' \
		-H 'Accept: application/json' \
		-d @./boilerplate-postgresql-source.json && \
			curl -X POST \
				http://localhost:3030/api/kafka-connect/connectors \
				-H 'Content-Type: application/json' \
				-H 'Accept: application/json' \
				-d @./boilerplate-elasticsearch-sink.json

setup:
	./bin/retry.sh "curl -I -s http://localhost:3030/api/kafka-connect | grep '200 OK' " && make connectors-register
