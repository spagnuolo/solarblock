#!/bin/bash
export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}/addOrgHaushaltB
export VERBOSE=false

CLI_TIMEOUT=10
CLI_DELAY=3

# Create crypto material using cryptogen
cryptogen generate --config=addOrgHaushaltB/orgHaushaltB-crypto.yaml --output="organizations"

# Generate CCP files for OrgHaushaltB
./addOrgHaushaltB/ccp-generate.sh

# Generate channel configuration transaction
configtxgen -printOrg OrgHaushaltBMSP > organizations/peerOrganizations/orgHaushaltB.example.com/orgHaushaltB.json

# Start OrgHaushaltB nodes
docker-compose -f addOrgHaushaltB/docker/docker-compose-orgHaushaltB.yaml up -d 2>&1

# Generate and submit config tx to add OrgHaushaltB
docker exec OrgHaushaltBcli ./scripts/orgHaushaltB-scripts/step1orgHaushaltB.sh "mychannel" $CLI_DELAY $CLI_TIMEOUT $VERBOSE

# Have OrgHaushaltB peers join network
docker exec OrgHaushaltBcli ./scripts/orgHaushaltB-scripts/step2orgHaushaltB.sh "mychannel" $CLI_DELAY $CLI_TIMEOUT $VERBOSE
