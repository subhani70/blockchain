#!/bin/bash
set -e

echo "🚀 Initializing Node 2..."

# Initialize blockchain only if not already initialized
if [ ! -d "./data/geth" ]; then
  echo "⛏️  Running genesis initialization..."
  geth --datadir ./data init /app/genesis.json
fi

# Get container's IP from Docker overlay network
NODE_IP=$(hostname -i | awk '{print $1}')
echo "🌐 Detected container IP: $NODE_IP"

echo "🔹 Starting Node 2..."
exec geth --datadir ./data \
  --port 30307 \
  --networkid 1234567 \
  --bootnodes "enode://125a5acdfe482d13ddd97ce510b70d374550b4919563f13def8f8e651888d8acd550726b2d1dec27dd0b591713ec34e7dcf22f2a7d8514c0a9e63428ffdaf640@geth-node1:30306" \
  --nat extip:$NODE_IP \
  --http --http.addr 0.0.0.0 --http.port 8546 \
  --http.api "eth,net,web3,personal,miner,admin" \
  --http.corsdomain "*" \
  --allow-insecure-unlock \
  --unlock 0x18073Ba5476b50148ff1f5187a32Afc8F39Eb7Ff \
  --password ./password.txt \
  --ipcpath /app/geth_node2.ipc \
  --authrpc.port 8552