#!/bin/bash

echo "Setting up and enforcing environment limits..."

# Create cgroup directories
mkdir -p /sys/fs/cgroup/{cpu,memory}/vos/

# Set default CPU and memory limits (can be overridden per-user)
echo "1000000" > /sys/fs/cgroup/cpu/vos/cpu.cfs_period_us
echo "100000" > /sys/fs/cgroup/cpu/vos/cpu.cfs_quota_us  # Default 10% CPU
echo "1G" > /sys/fs/cgroup/memory/vos/memory.limit_in_bytes

while IFS=: read -r username cpu mem; do
    [[ -z "$username" || "$username" =~ ^# ]] && continue
    
    # Convert percentage to absolute values
    cpu_quota=$((cpu * 1000))  # Convert % to microseconds
    mem_limit=$((mem * 10))M   # Convert % to MB (assuming 1GB total)
    
    # Create user-specific cgroups
    mkdir -p "/sys/fs/cgroup/cpu/vos/$username"
    mkdir -p "/sys/fs/cgroup/memory/vos/$username"
    
    # Set limits
    echo "$cpu_quota" > "/sys/fs/cgroup/cpu/vos/$username/cpu.cfs_quota_us"
    echo "$mem_limit" > "/sys/fs/cgroup/memory/vos/$username/memory.limit_in_bytes"
    
    # Add user processes to cgroups
    for pid in $(ps -u "$username" -o pid=); do
        echo "$pid" > "/sys/fs/cgroup/cpu/vos/$username/tasks"
        echo "$pid" > "/sys/fs/cgroup/memory/vos/$username/tasks"
    done
    
    echo "[$username] Enforced limits - CPU: ${cpu}%, Memory: ${mem}%"
done < /vos/config/limits.conf

mkdir -p /vos/fs/{etc,var,home}
echo "Containerized Virtual OS v1.1" > /vos/fs/etc/os-release

echo "Environment setup complete with enforced limits."
