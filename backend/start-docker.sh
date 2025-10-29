#!/bin/bash

# ============================================
# Docker Startup Script for DID Wallet Backend
# ============================================

set -e

echo "🚀 Starting DID Wallet Backend with Docker..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from example..."
    if [ -f env.docker.example ]; then
        cp env.docker.example .env
        echo "📝 Please edit .env file with your configuration before running again."
        echo "   Required: REGISTRY_ADDRESS and PRIVATE_KEY"
        exit 1
    else
        echo "❌ env.docker.example not found. Please create .env file manually."
        exit 1
    fi
fi

# Load environment variables
source .env

# Validate required environment variables
if [ -z "$REGISTRY_ADDRESS" ] || [ "$REGISTRY_ADDRESS" = "0xYourRegistryAddressHere" ]; then
    echo "❌ REGISTRY_ADDRESS not set in .env file"
    exit 1
fi

if [ -z "$PRIVATE_KEY" ] || [ "$PRIVATE_KEY" = "0xYourPrivateKeyHere" ]; then
    echo "❌ PRIVATE_KEY not set in .env file"
    exit 1
fi

echo "✅ Environment configuration validated"

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t did-wallet-backend .

# Stop and remove existing container if it exists
echo "🧹 Cleaning up existing container..."
docker-compose down 2>/dev/null || true

# Start the services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for the service to be healthy
echo "⏳ Waiting for service to be healthy..."
timeout=60
counter=0

while [ $counter -lt $timeout ]; do
    if docker-compose ps | grep -q "Up (healthy)"; then
        echo "✅ Service is healthy!"
        break
    fi
    
    if docker-compose ps | grep -q "Exit"; then
        echo "❌ Service failed to start. Checking logs..."
        docker-compose logs backend
        exit 1
    fi
    
    echo -n "."
    sleep 1
    counter=$((counter + 1))
done

if [ $counter -eq $timeout ]; then
    echo "❌ Service did not become healthy within $timeout seconds"
    echo "📋 Checking logs..."
    docker-compose logs backend
    exit 1
fi

# Show service status
echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "🌐 Backend API is running at:"
echo "   http://localhost:5000"
echo "   Health check: http://localhost:5000/health"
echo ""
echo "📋 Available endpoints:"
echo "   POST /create-did"
echo "   GET  /resolve-did/:did"
echo "   POST /store-vc"
echo "   GET  /list-vc"
echo "   POST /create-vp"
echo "   POST /verify-vc"
echo "   POST /verify-vp"
echo ""
echo "📝 To view logs: docker-compose logs -f backend"
echo "🛑 To stop: docker-compose down"
echo ""
