#!/bin/bash
set -e

echo "🚀 Initializing Node 2..."

if [ ! -d "./data/geth" ]; then
  echo "⛏️  Running genesis initialization..."
  geth --datadir ./data init /app/genesis.json
fi

NODE_IP=$(hostname -i | awk '{print $1}')
echo "🌐 Detected container IP: $NODE_IP"

echo "🔹 Starting Node 2..."
exec geth --datadir ./data \
  --port 30307 \
  --networkid 1234567 \
  --nat extip:${NODE_IP} \
  --bootnodes "${BOOTNODE_ENODE}" \
  --http --http.addr 0.0.0.0 --http.port 8546 \
  --http.api "eth,net,web3,personal,miner,admin" \
  --http.corsdomain "*" \
  --allow-insecure-unlock \
  --unlock 0x18073Ba5476b50148ff1f5187a32Afc8F39Eb7Ff \
  --password ./password.txt \
  --ipcpath /app/geth_node2.ipc \
  --authrpc.port 8552
