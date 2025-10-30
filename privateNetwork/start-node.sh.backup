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
    echo "Node 2: Waiting for Node 1 to be ready..."
    
    # Wait for node1 to be available (max 60 seconds)
    for i in {1..60}; do
        if curl -s -X POST http://geth-node1:8545 \
            -H "Content-Type: application/json" \
            --data '{"jsonrpc":"2.0","method":"net_version","id":1}' > /dev/null 2>&1; then
            echo "Node 1 is ready!"
            break
        fi
        echo "Waiting for Node 1... ($i/60)"
        sleep 1
    done
    
    # Get the enode from node1 dynamically
    echo "Fetching enode from Node 1..."
    ENODE_RESPONSE=$(curl -s -X POST http://geth-node1:8545 \
        -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}')
    
    DYNAMIC_ENODE=$(echo $ENODE_RESPONSE | jq -r '.result.enode' | sed 's/@[^:]*:/@geth-node1:/')
    
    if [ ! -z "$DYNAMIC_ENODE" ] && [ "$DYNAMIC_ENODE" != "null" ]; then
        echo "Using dynamic enode: $DYNAMIC_ENODE"
        BOOTNODE_TO_USE=$DYNAMIC_ENODE
    else
        echo "Failed to get enode dynamically, using provided BOOTNODE_URL"
        BOOTNODE_TO_USE=$BOOTNODE_URL
    fi
    
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
      --bootnodes $BOOTNODE_TO_USE
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