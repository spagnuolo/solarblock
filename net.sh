#!/bin/bash
export PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false


# Delete old aritfacts, if any.
if [ -d "organizations/peerOrganizations" ]; then
  rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
fi

MAX_RETRY=5
CLI_DELAY=3
CHANNEL_NAME="mychannel"

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

docker ps -a

scripts/createChannel.sh $CHANNEL_NAME $CLI_DELAY $MAX_RETRY $VERBOSE
