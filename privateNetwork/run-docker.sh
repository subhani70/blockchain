#!/bin/bash

# Script to build and run the dockerized Geth private network

echo "Building and starting Geth private network with Docker Compose..."

# Build and start the services
docker-compose up --build -d

echo "Waiting for nodes to start..."
sleep 10

# Check if nodes are running
echo "Checking node status..."
docker-compose ps

echo ""
echo "Geth nodes are now running:"
echo "Node 1: http://localhost:8545"
echo "Node 2: http://localhost:8546"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f geth-node1"
echo "  docker-compose logs -f geth-node2"
echo ""
echo "To stop the network:"
echo "  docker-compose down"
echo ""
echo "To clean up volumes (WARNING: This will delete blockchain data):"
echo "  docker-compose down -v"
