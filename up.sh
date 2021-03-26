#!/bin/bash

function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Where am I?
cd .
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# export FABRIC_CFG_PATH="${DIR}/config"

export PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false


# Delete old aritfacts, if any.
if [ -d "organizations/peerOrganizations" ]; then
  rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
fi

MAX_RETRY=5
CLI_DELAY=3
CHANNEL_NAME="public-channel"

COMPOSE_FILE_BASE=docker/docker-compose-test-net.yaml
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml

docker-compose -f $COMPOSE_FILE_CA up -d 2>&1

. organizations/fabric-ca/registerEnroll.sh

while :
  do
    if [ ! -f "organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem" ]; then
      sleep 1
    else
      break
    fi
  done

createorgNetzbetreiber
createorgHaushaltA
createorgHaushaltB
createorgHaushaltC
createOrderer

./organizations/ccp-generate.sh

configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block


COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"
COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_COUCH}"
docker-compose ${COMPOSE_FILES} up -d 2>&1


scripts/createChannel.sh $CHANNEL_NAME $CLI_DELAY $MAX_RETRY $VERBOSE


cp ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/signcerts/User1@orgNetzbetreiber.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/keystore/priv_sk

cp ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/signcerts/User1@orgHaushaltA.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/keystore/priv_sk

cp ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/signcerts/User1@orgHaushaltB.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/keystore/priv_sk

cp ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/signcerts/User1@orgHaushaltC.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/keystore/priv_sk

docker ps -a
