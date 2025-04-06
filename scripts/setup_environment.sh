#!/bin/bash

echo "Setting up environment limits..."

while IFS=: read -r username cpu mem; do
    [[ -z "$username" || "$username" =~ ^# ]] && continue
    echo "[$username] CPU: ${cpu}%, Memory: ${mem}%"
done < /vos/config/limits.conf

mkdir -p /vos/fs/{etc,var,home}
echo "Containerized Virtual OS v1.0" > /vos/fs/etc/os-release

echo "Environment setup complete."
