FROM postgres:17

# SQL scripts in this directory run automatically on first database initialization.
COPY init/ /docker-entrypoint-initdb.d/
