# DID Wallet Backend - Docker Setup

This document explains how to run the DID Wallet Backend using Docker.

## Prerequisites

- Docker and Docker Compose installed
- Access to a blockchain network (Ethereum-compatible)
- Deployed EthrDIDRegistry contract address
- Private key for backend operations

## Quick Start

1. **Configure Environment**
   ```bash
   cp env.docker.example .env
   # Edit .env with your configuration
   ```

2. **Start the Backend**
   ```bash
   ./start-docker.sh
   ```

3. **Access the API**
   - Backend: http://localhost:5000
   - Health check: http://localhost:5000/health

## Manual Docker Commands

### Build and Run
```bash
# Build the image
docker build -t did-wallet-backend .

# Run the container
docker run -d \
  --name did-wallet-backend \
  -p 5000:5000 \
  -e RPC_URL=http://13.232.1.197:8545 \
  -e CHAIN_ID=1337 \
  -e REGISTRY_ADDRESS=0xYourRegistryAddress \
  -e PRIVATE_KEY=0xYourPrivateKey \
  did-wallet-backend
```

### Using Docker Compose
```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f backend

# Stop services
docker-compose down
```

## Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `NODE_ENV` | Node environment | `production` | No |
| `PORT` | Server port | `5000` | No |
| `RPC_URL` | Blockchain RPC URL | `http://13.232.1.197:8545` | Yes |
| `CHAIN_ID` | Blockchain chain ID | `1337` | Yes |
| `REGISTRY_ADDRESS` | EthrDIDRegistry contract address | - | Yes |
| `PRIVATE_KEY` | Private key for transactions | - | Yes |
| `NETWORK_NAME` | Network name for DID resolution | `VoltusWave` | No |

## API Endpoints

- `GET /` - Service information
- `GET /health` - Health check
- `POST /create-did` - Create a new DID
- `GET /resolve-did/:did` - Resolve a DID document
- `POST /store-vc` - Store a verifiable credential
- `GET /list-vc` - List stored credentials
- `POST /create-vp` - Create a verifiable presentation
- `POST /verify-vc` - Verify a verifiable credential
- `POST /verify-vp` - Verify a verifiable presentation

## Troubleshooting

### Service Won't Start
1. Check if Docker is running: `docker info`
2. Verify environment variables in `.env`
3. Check logs: `docker-compose logs backend`

### Connection Issues
1. Verify RPC_URL is accessible from container
2. Check if blockchain node is running
3. Verify REGISTRY_ADDRESS is correct

### Health Check Fails
1. Check if port 5000 is available
2. Verify all required environment variables are set
3. Check application logs for errors

## Development

### Debug Mode
```bash
# Run with debug script
docker run -it --rm \
  -v $(pwd):/app \
  -w /app \
  node:18-alpine \
  sh -c "npm install && node debug-did.js"
```

### Hot Reload (Development)
```bash
# Mount source code for development
docker run -d \
  --name did-wallet-backend-dev \
  -p 5000:5000 \
  -v $(pwd)/src:/app/src \
  -e NODE_ENV=development \
  did-wallet-backend \
  npm run dev
```

## Security Notes

- Never commit `.env` files to version control
- Use dedicated private keys for backend services
- Regularly rotate private keys
- Consider using Docker secrets for production deployments
- Run containers as non-root user (already configured)

## Production Deployment

1. Use environment-specific configuration
2. Set up proper logging and monitoring
3. Configure reverse proxy (nginx/traefik)
4. Use Docker secrets for sensitive data
5. Set up health checks and auto-restart policies
6. Consider using Docker Swarm or Kubernetes for orchestration
