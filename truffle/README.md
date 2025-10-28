# Truffle Setup for Private PoA Blockchain

This directory contains a simplified Truffle setup for deploying the EthrDIDRegistry smart contract to your private PoA blockchain network.

## Quick Start

### Prerequisites
- Node.js (v14 or higher)
- Private PoA blockchain running (see `../privateNetwork/README.md`)

### Basic Usage

1. **Start Private PoA Network** (Required)
   ```bash
   cd ../privateNetwork
   ./run-docker.sh
   ```

2. **Install Dependencies**
   ```bash
   cd ../truffle
   npm install
   ```

3. **Deploy Contracts**
   ```bash
   ./deploy.sh deploy
   ```
   This will:
   - Check if PoA network is running
   - Compile smart contracts
   - Deploy contracts to your private PoA blockchain
   - Output deployment information

## Available Commands

| Command | Description |
|---------|-------------|
| `./deploy.sh deploy` | Deploy contracts to PoA network |
| `./deploy.sh test` | Run tests on PoA network |
| `./deploy.sh console` | Start Truffle console |
| `./deploy.sh clean` | Clean build artifacts |
| `./deploy.sh reset` | Reset and redeploy contracts |
| `./deploy.sh check-poa` | Check if PoA network is running |

## Manual Commands

If you prefer using npm scripts directly:

```bash
# Compile contracts
npm run compile

# Deploy to PoA network
npm run migrate

# Run tests
npm run test

# Start console
npm run console

# Clean build artifacts
npm run clean

# Reset and redeploy
npm run reset
```

## Network Configuration

### PoA Network Details
- **Node 1**: `localhost:8545` (Primary)
- **Node 2**: `localhost:8546` (Alternative)
- **Network ID**: `1234567`
- **Chain ID**: `1234567`
- **Gas Limit**: `8,000,000`
- **Gas Price**: `2 gwei`

### Account Information
- **Node 1 Account**: `0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5`
- **Node 2 Account**: `0x18073Ba5476b50148ff1f5187a32Afc8F39Eb7Ff`

## Project Structure

```
truffle/
├── contracts/
│   └── EthrDIDRegistry.sol    # Main smart contract
├── migrations/
│   └── 2_deploy_contracts.js  # Deployment script
├── build/                      # Compiled contracts (generated)
├── test/                       # Test files
├── package.json               # Dependencies and scripts
├── truffle-config.js         # Network configuration
├── deploy.sh                 # Deployment script
└── README.md                 # This file
```

## Troubleshooting

### Common Issues

1. **PoA network not running**: 
   ```bash
   ./deploy.sh check-poa
   # If not running, start it with:
   cd ../privateNetwork && ./run-docker.sh
   ```

2. **Port conflicts**: Ensure ports 8545 and 8546 are available

3. **Build failures**: Clean and rebuild:
   ```bash
   ./deploy.sh clean
   ./deploy.sh deploy
   ```

### Debug Commands

```bash
# Check PoA network status
./deploy.sh check-poa

# Check Node 1 status
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8545

# Check Node 2 status
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8546
```

## Development Workflow

1. **Make changes** to smart contracts in `contracts/`
2. **Test locally** with `./deploy.sh test`
3. **Deploy to PoA** with `./deploy.sh deploy`
4. **Interact with contracts** using `./deploy.sh console`

## Security Notes

- The PoA network configuration includes hardcoded account addresses
- In production, consider using environment variables for sensitive data
- The private keys are stored in the PoA network keystore files

## Integration with Private Network

This setup is designed to work seamlessly with your private PoA network:

1. **Start the PoA network** using the scripts in `../privateNetwork/`
2. **Deploy contracts** using this Truffle setup
3. **Interact with contracts** through the deployed addresses

The setup automatically detects if your PoA network is running and provides clear error messages if it's not available.