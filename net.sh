#!/bin/bash
export PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

# Delete old aritfacts, if any.
if [ -d "organizations/peerOrganizations" ]; then
  rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
fi

# Create crypto keys and Orgs.
cryptogen generate --config=./organizations/cryptogen/crypto-config-orgNetzbetreiber.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orgKunde.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# Generate CCP files for Org1 and Org2
./organizations/ccp-generate.sh

# Create consortium.
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block

# Create and start containers.
docker-compose -f "docker/docker-compose-test-net.yaml" up -d 2>&1

# Print all running container.
docker ps -a

# create system channel
./network.sh createChannel

# Deploy Chaincode
./scripts/deployCC.sh

# add OrgHaushaltA
./addOrg.sh
