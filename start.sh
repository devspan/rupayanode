#!/bin/bash

# Function to check if the genesis block is already initialized
is_genesis_initialized() {
    if [ -d "/root/.rupaya/geth" ]; then
        return 0  # Genesis is initialized
    else
        return 1  # Genesis is not initialized
    fi
}

# Initialize genesis if not already done
if ! is_genesis_initialized; then
    echo "Initializing genesis block..."
    /app/rupx init /app/rupayamainnet.json
    if [ $? -ne 0 ]; then
        echo "Failed to initialize genesis block. Exiting."
        exit 1
    fi
    echo "Genesis block initialized successfully."
else
    echo "Genesis block already initialized. Skipping initialization."
fi

# Write the password to a file
echo "$ACCOUNT_PASSWORD" > /tmp/account_password

# Attempt to unlock the account
echo "Attempting to unlock account $UNLOCK_ACCOUNT..."
/app/rupx --datadir /root/.rupaya account unlock "$UNLOCK_ACCOUNT" --password /tmp/account_password

if [ $? -ne 0 ]; then
    echo "Failed to unlock account. Please check your account address and password."
    exit 1
fi

echo "Account unlocked successfully."

# Start rupx with all the necessary parameters
exec /app/rupx \
    --datadir=/root/.rupaya \
    --networkid=${NETWORK_ID:-499} \
    --syncmode=full \
    --gcmode=archive \
    --http \
    --http.addr=0.0.0.0 \
    --http.port=8545 \
    --http.api=${HTTP_API:-eth,net,web3} \
    --http.corsdomain=${HTTP_CORSDOMAIN:-https://*.rupaya.io} \
    --http.vhosts=${HTTP_VHOSTS:-rupaya.io,*.rupaya.io} \
    --ws \
    --ws.addr=0.0.0.0 \
    --ws.port=8546 \
    --ws.api=${WS_API:-eth,net,web3} \
    --mine \
    --miner.etherbase=${MINER_ETHERBASE} \
    --unlock=${UNLOCK_ACCOUNT} \
    --password=/tmp/account_password \
    --allow-insecure-unlock \
    --verbosity=${VERBOSITY:-3}