#!/bin/bash

# Build the project
echo "Building the project..."
docker build -t hns_doh:test .

# Start the container
echo "Starting the container..."
docker run -p 1234:80 --name hns_doh hns_doh:test

# Remove the container
echo "Removing the container..."
docker rm -f hns_doh