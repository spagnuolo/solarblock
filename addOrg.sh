#!/bin/bash
export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/addOrg3
export VERBOSE=false

CLI_TIMEOUT=10
CLI_DELAY=3

# Create crypto material using cryptogen
cryptogen generate --config=addOrg3/org3-crypto.yaml --output="organizations"

# Generate CCP files for Org3
./addOrg3/ccp-generate.sh

# Generate channel configuration transaction
configtxgen -printOrg Org3MSP > organizations/peerOrganizations/org3.example.com/org3.json

# Start Org3 nodes
docker-compose -f addOrg3/docker/docker-compose-org3.yaml up -d 2>&1

# Generate and submit config tx to add Org3
docker exec Org3cli ./scripts/org3-scripts/step1org3.sh "mychannel" $CLI_DELAY $CLI_TIMEOUT $VERBOSE

# Have Org3 peers join network
docker exec Org3cli ./scripts/org3-scripts/step2org3.sh "mychannel" $CLI_DELAY $CLI_TIMEOUT $VERBOSE
