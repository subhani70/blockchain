#!/bin/bash

# Initialize the blockchain if not already done
if [ ! -f "/app/data/geth/chaindata/CURRENT" ]; then
    echo "Initializing blockchain with genesis file..."
    geth --datadir /app/data init /app/genesis.json
fi

# Start the Geth node
echo "Starting Geth node $NODE_ID..."
geth --datadir /app/data \
  --port $P2P_PORT \
  --networkid $NETWORK_ID \
  --http --http.addr 0.0.0.0 --http.port $HTTP_PORT \
  --http.api "eth,net,web3,personal,miner,admin" \
  --http.corsdomain "*" \
  --allow-insecure-unlock \
  --unlock $UNLOCK_ADDRESS \
  --password /app/password.txt \
  --mine \
  --miner.etherbase $MINER_ADDRESS \
  --ipcpath /tmp/geth_node$NODE_ID.ipc
