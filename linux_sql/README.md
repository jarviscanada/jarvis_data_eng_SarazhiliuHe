# Linux Cluster Monitoring Agent
## psql_docker.sh

A shell script to provision and manages a PostgreSQL instance using Docker.
It allows users to easily create, start, and stop a local PostgreSQL container for development.

### Usage
- Creates a PostgreSQL Docker container with the given username and password.
```bash
  ./psql_docker.sh create <db_username> <db_password>
```
- Starts the container if it exists.
```bash
  ./psql_docker.sh start
```
- Stops the container if it exists.
```bash
  ./psql_docker.sh stop
```
### Troubleshooting

- If you get a "permission denied" error:
  - check the file permissions `ls -l psql_docker.sh`
  - Add execute permission to the file `chmod +x psql_docker.sh`
  
