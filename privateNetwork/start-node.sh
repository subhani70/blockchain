#!/bin/bash

# Initialize the blockchain if not already done
if [ ! -f "/app/data/geth/chaindata/CURRENT" ]; then
    echo "Initializing blockchain with genesis file..."
    geth --datadir /app/data init /app/genesis.json
fi

# Start the Geth node
echo "Starting Geth node $NODE_ID..."

# Check if this is node2 with bootnode
if [ "$NODE_ID" = "2" ]; then
    # Node 2 without mining, with bootnode
    geth --datadir /app/data \
      --port $P2P_PORT \
      --networkid $NETWORK_ID \
      --nat extip:0.0.0.0 \
      --http --http.addr 0.0.0.0 --http.port $HTTP_PORT \
      --http.api eth,net,web3,personal,miner,admin \
      --http.corsdomain '*' \
      --allow-insecure-unlock \
      --unlock $UNLOCK_ADDRESS \
      --password /app/password.txt \
      --ipcpath /tmp/geth_node$NODE_ID.ipc \
      --bootnodes $BOOTNODE_URL
else
    # Node 1 with mining
    geth --datadir /app/data \
      --port $P2P_PORT \
      --networkid $NETWORK_ID \
      --nat extip:0.0.0.0 \
      --http --http.addr 0.0.0.0 --http.port $HTTP_PORT \
      --http.api eth,net,web3,personal,miner,admin \
      --http.corsdomain '*' \
      --allow-insecure-unlock \
      --unlock $UNLOCK_ADDRESS \
      --password /app/password.txt \
      --ipcpath /tmp/geth_node$NODE_ID.ipc \
      --mine \
      --miner.etherbase $MINER_ADDRESS
fi