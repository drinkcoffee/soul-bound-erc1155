#!/bin/bash

# Load the .env file if it exists
if [ -f .env ]
then
  set -a; source .env; set +a
fi

if [ -z "${IMMUTABLE_NETWORK}" ]; then
    echo "Error: IMMUTABLE_NETWORK variable is not set"
    exit 1
fi
if [[ $IMMUTABLE_NETWORK -eq 1 ]]
then
    echo Immutable zkEVM Mainnet Configuration
    IMMUTABLE_RPC=https://rpc.immutable.com
    BLOCKSCOUT_URI=https://explorer.immutable.com/api?
else
    echo Immutable zkEVM Testnet Configuration
    IMMUTABLE_RPC=https://rpc.testnet.immutable.com
    BLOCKSCOUT_URI=https://explorer.testnet.immutable.com/api?
fi
if [ -z "${BLOCKSCOUT_APIKEY}" ]; then
    echo "Error: BLOCKSCOUT_APIKEY environment variable is not set"
    exit 1
fi

if [ "$HARDWARE_WALLET" = "ledger" ] || [ "$HARDWARE_WALLET" = "trezor" ]; then
    echo " with ${HARDWARE_WALLET} Hardware Wallet"
    if [ -z "${HD_PATH}" ]; then
        echo "Error: HD_PATH environment variable is not set"
        exit 1
    fi
else
    echo " with a raw private key"
    if [ -z "${PRIVATE_KEY}" ]; then
        echo "Error: PRIVATE_KEY environment variable is not set"
        exit 1
    fi
fi

if [ -z "${FUNCTION_TO_EXECUTE}" ]; then
    echo "Error: FUNCTION_TO_EXECUTE variable is not set"
    exit 1
fi


echo "Configuration"
echo " IMMUTABLE_RPC: $IMMUTABLE_RPC"
echo " BLOCKSCOUT_APIKEY: $BLOCKSCOUT_APIKEY"
echo " BLOCKSCOUT_URI: $BLOCKSCOUT_URI"
if [ "${HARDWARE_WALLET}" = "ledger" ] || [ "${HARDWARE_WALLET}" = "trezor" ]; then
    echo Hardware type: ${HARDWARE_WALLET}
    echo HD_PATH: $HD_PATH
else
    echo " PRIVATE_KEY: <not echoed for your security>" # $PRIVATE_KEY
fi
echo " Function to execute: $FUNCTION_TO_EXECUTE"

# NOTE WELL ---------------------------------------------
# Add resume option if the script fails part way through:
#     --resume \
# To record the transactions but not execute them, remove the --broadcast line.
# NOTE WELL ---------------------------------------------
if [ "${HARDWARE_WALLET}" = "ledger" ] || [ "${HARDWARE_WALLET}" = "trezor" ]; then
    forge script --rpc-url $IMMUTABLE_RPC \
        --priority-gas-price 10000000000 \
        --with-gas-price     10000000100 \
        -vvv \
        --broadcast \
        --optimize \
        --verify \
        --verifier blockscout \
        --verifier-url $BLOCKSCOUT_URI$BLOCKSCOUT_APIKEY \
        --sig "$FUNCTION_TO_EXECUTE" \
        --$HARDWARE_WALLET \
        --hd-paths "$HD_PATH" \
        script/ExampleERC1155Soulbound.s.sol:ExampleERC1155SoulboundScript
else
    forge script --rpc-url $IMMUTABLE_RPC \
        --priority-gas-price 10000000000 \
        --with-gas-price     10000000100 \
        -vvv \
        --broadcast \
        --optimize \
        --verify \
        --verifier blockscout \
        --verifier-url $BLOCKSCOUT_URI$BLOCKSCOUT_APIKEY \
        --sig "$FUNCTION_TO_EXECUTE" \
        --private-key $PRIVATE_KEY \
        script/ExampleERC1155Soulbound.s.sol:ExampleERC1155SoulboundScript
fi
