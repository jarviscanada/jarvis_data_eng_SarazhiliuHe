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

# store hardware specifications to variables
hostname=$(hostname -f)
lscpu_out=$(lscpu)

cpu_number=$(echo "$lscpu_out" | grep "^CPU(s):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | grep "Architecture:" | awk '{print $2}')
cpu_model=$(echo "$lscpu_out" | grep "Model name:" | cut -d ':' -f 2 | xargs)
cpu_mhz=$(grep "cpu MHz" /proc/cpuinfo | head -n 1 | awk '{print $4}' | xargs)
l2_cache=$(echo "$lscpu_out" | grep "L2 cache:" | awk '{print $3}' | sed 's/K//g' | xargs)
total_mem=$(grep "MemTotal" /proc/meminfo | awk '{print $2}' | xargs)

timestamp=$(date '+%F %T')

# construct the INSERT statement
insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, \"timestamp\", total_mem)
            VALUES('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache', '$timestamp', '$total_mem')"

# Export password
export PGPASSWORD=$psql_password

# Execute the INSERT statement
psql -h "$psql_host" -p "$psql_port" -d "$db_name"  -U "$psql_user" -c "$insert_stmt"
