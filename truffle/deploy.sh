#!/bin/bash

# Truffle Deployment Script for Private PoA Blockchain
# Simple script to deploy smart contracts to your private PoA network

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_poa() {
    echo -e "${CYAN}[PoA]${NC} $1"
}

# Function to check if PoA network is running
check_poa_network() {
    print_status "Checking if PoA network is running..."
    
    # Check if node1 is running on port 8545
    if curl -s -X POST -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
        http://localhost:8545 > /dev/null 2>&1; then
        print_success "PoA Node 1 is running on port 8545"
        return 0
    else
        print_error "PoA Node 1 is not running on port 8545"
        print_warning "Please start your PoA network first:"
        print_warning "  cd ../privateNetwork && ./run-docker.sh"
        return 1
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  deploy          Deploy contracts to Private PoA network"
    echo "  test            Run tests on PoA network"
    echo "  console         Start Truffle console (PoA network)"
    echo "  clean           Clean build artifacts"
    echo "  reset           Reset and redeploy contracts"
    echo "  check-poa       Check if PoA network is running"
    echo "  help            Show this help message"
    echo ""
    echo "Network Information:"
    echo "  PoA Node 1:     localhost:8545 (0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5)"
    echo "  PoA Node 2:     localhost:8546 (0x18073Ba5476b50148ff1f5187a32Afc8F39Eb7Ff)"
    echo ""
    echo "Examples:"
    echo "  $0 deploy       # Deploy contracts to PoA network"
    echo "  $0 test         # Run tests on PoA network"
    echo "  $0 console      # Start Truffle console"
}

# Function to deploy contracts
deploy_contracts() {
    print_poa "Deploying contracts to Private PoA network..."
    
    # Check if PoA network is running
    if ! check_poa_network; then
        exit 1
    fi
    
    print_status "Compiling contracts..."
    npm run compile
    
    print_status "Deploying contracts..."
    npm run migrate
    
    print_success "Deployment completed!"
    print_status "Contract artifacts saved to build/contracts/"
}

# Function to run tests
run_tests() {
    print_poa "Running tests on PoA network..."
    
    # Check if PoA network is running
    if ! check_poa_network; then
        exit 1
    fi
    
    print_status "Running tests..."
    npm run test
    print_success "Tests completed!"
}

# Function to start console
start_console() {
    print_poa "Starting Truffle console (PoA network)..."
    
    # Check if PoA network is running
    if ! check_poa_network; then
        exit 1
    fi
    
    print_warning "Press Ctrl+C to exit the console"
    npm run console
}

# Function to clean build artifacts
clean_build() {
    print_status "Cleaning build artifacts..."
    npm run clean
    print_success "Build artifacts cleaned!"
}

# Function to reset and redeploy
reset_deploy() {
    print_poa "Resetting and redeploying contracts..."
    
    # Check if PoA network is running
    if ! check_poa_network; then
        exit 1
    fi
    
    print_status "Resetting contracts..."
    npm run reset
    
    print_success "Reset and redeployment completed!"
}

# Main script logic
case "${1:-help}" in
    "deploy")
        deploy_contracts
        ;;
    "test")
        run_tests
        ;;
    "console")
        start_console
        ;;
    "clean")
        clean_build
        ;;
    "reset")
        reset_deploy
        ;;
    "check-poa")
        check_poa_network
        ;;
    "help"|*)
        show_usage
        ;;
esac