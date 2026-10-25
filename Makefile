docker-compose-up:
	docker compose -f docker-compose-trino.yml up


# docker exec trino sh -c 'find / -name config.properties -o -name node.properties 2>/dev/null'
#  docker logs trino
# docker exec -it trino trino   --server http://localhost:8080   --user admin   --execute "SHOW SCHEMAS FROM postgresql"
