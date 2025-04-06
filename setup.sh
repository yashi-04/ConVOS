#!/bin/bash

echo "Building Containerized Virtual OS image..."
docker build -t vos:latest .

echo -e "\nStarting Containerized Virtual OS container..."
docker run -it --rm \
    --name vos \
    --cpus 1.0 \
    --memory 1g \
    --hostname vos-container \
    vos:latest
