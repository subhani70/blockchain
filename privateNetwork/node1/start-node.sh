#!/bin/bash
set -e

echo "🚀 Initializing Node 1..."

# Initialize blockchain only if not already initialized
if [ ! -d "./data/geth" ]; then
  echo "⛏️  Running genesis initialization..."
  geth --datadir ./data init /app/genesis.json
fi

echo "🔹 Starting Node 1..."
exec geth --datadir ./data \
  --port 30306 \
  --networkid 1234567 \
  --nat extip:127.0.0.1 \
  --http --http.addr 0.0.0.0 --http.port 8545 \
  --http.api "eth,net,web3,personal,miner,admin" \
  --http.corsdomain "*" \
  --allow-insecure-unlock \
  --unlock 0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5 \
  --password ./password.txt \
  --mine \
  --miner.etherbase 0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5 \
  --ipcpath ~/geth_node1.ipc
