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

# Read password from the secret file
ACCOUNT_PASSWORD=$(cat /run/secrets/account_password)

# Start rupx with all the necessary parameters
exec /app/rupx \
    --networkid ${NETWORK_ID:-499} \
    --syncmode "full" \
    --gcmode "archive" \
    --http \
    --http.addr "0.0.0.0" \
    --http.port 8545 \
    --http.api "${HTTP_API:-eth,web3,net,debug,txpool,personal}" \
    --http.corsdomain "${HTTP_CORSDOMAIN:-*}" \
    --http.vhosts "${HTTP_VHOSTS:-*}" \
    --ws \
    --ws.addr "0.0.0.0" \
    --ws.port 8546 \
    --ws.api "${WS_API:-eth,web3,net,debug,txpool,personal}" \
    --mine \
    --miner.etherbase "${MINER_ETHERBASE}" \
    --unlock "${UNLOCK_ACCOUNT}" \
    --password <(echo "$ACCOUNT_PASSWORD") \
    --allow-insecure-unlock \
    --keystore "/root/.rupaya/keystore" \
    --rpc.allow-unprotected-txs \
    --verbosity ${VERBOSITY:-3} \
    console