docker-compose-up:
	docker compose -f docker-compose-trino.yml up


# docker exec trino sh -c 'find / -name config.properties -o -name node.properties 2>/dev/null'
#  docker logs trino