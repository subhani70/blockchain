# Use official Geth image
FROM ethereum/client-go:latest

# Set working directory
WORKDIR /app

# Install additional tools
RUN apk add --no-cache curl jq

# Copy genesis file
COPY privateblock.json /app/genesis.json

# Create data directories
RUN mkdir -p /app/data/geth /app/data/keystore

# Copy keystore files and passwords
COPY node1/data/keystore/ /app/data/keystore/
COPY node1/password.txt /app/password.txt

# Create startup script
COPY start-node.sh /app/start-node.sh
RUN chmod +x /app/start-node.sh

# Expose ports
EXPOSE 8545 30306

# Set environment variables
ENV NODE_ID=1
ENV HTTP_PORT=8545
ENV P2P_PORT=30306
ENV NETWORK_ID=1234567
ENV UNLOCK_ADDRESS=0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5
ENV MINER_ADDRESS=0xb37937c534fD26E5bF41AD58C83C24d94A1BE6B5

# Start the node
CMD ["/app/start-node.sh"]
