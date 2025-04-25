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
  
## ddl.sql
A SQL script used to create and initialize the schema 
for a PostgreSQL database `host_agent`.

- Create a table to store hardware specifications: `host_info`
  - CPU number, architecture, model, Mhz, L2_cache, total memory
- Create a table to resource usage data: `host_usage`
  - CPU Idle, Kernel, disk I/O, disk available, free memory

### Usage
```bash
psql -h localhost -U postgres -d host_agent -f ./ddl.sql
```

## Monitoring Agent
- `host_info.sh`: a script to collect hardware specification data and insert the data into the psql instance. 
- `host_usage.sh`: a script to collect server usage data and insert the data into the psql database.

### Usage
- hardware specification data
```bash
./host_info.sh psql_host psql_port db_name psql_user psql_password
```
- resource usage data
```bash
./host_usage.sh psql_host psql_port db_name psql_user psql_password
```