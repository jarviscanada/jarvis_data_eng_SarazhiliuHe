#!/bin/bash

# setup and validate CLI arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
    echo "Error: Illegal number of parameters"
    exit 1
fi

# store resource usage data to variables
vmstat_mb=$(vmstat --unit M)

timestamp=$(vmstat -t | tail -1 | awk -v col1="18" -v col2="19" '{print $(col1), $(col2)}')
memory_free=$(echo "$vmstat_mb" | tail -1 | awk -v col="4" '{print $(col)}')
cpu_idle=$(echo "$vmstat_mb" | tail -1 | awk -v col="15" '{print $(col)}' | xargs)
cpu_kernel=$(echo "$vmstat_mb" | tail -1 | awk -v col="14" '{print $(col)}' | xargs)
disk_io=$(vmstat --unit M -d | tail -1 | awk -v col="10" '{print $(col)}')
disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed 's/M//g' | xargs)

# Subquery to find matching id in host_info table
hostname=$(hostname -f)
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";

# construct the INSERT statement
insert_stmt="INSERT INTO host_usage (\"timestamp\", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
            VALUES('$timestamp', $host_id, $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available)"

# Export password
export PGPASSWORD=$psql_password

# Execute the INSERT statement
psql -h "$psql_host" -p "$psql_port" -d "$db_name"  -U "$psql_user" -c "$insert_stmt"
