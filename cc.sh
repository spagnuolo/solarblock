#!/bin/bash

# Exit on first error, print all commands.
set -ev
set -o pipefail

cd organization/kunde
source iamorgkunde.sh
peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label cp_0
peer lifecycle chaincode install cp.tar.gz
peer lifecycle chaincode queryinstalled

a=$(peer lifecycle chaincode queryinstalled)
tmp=${a#*ID:}   # remove prefix ending in "ID:"
b=${tmp%,*}   # remove suffix starting with ","
echo ${b}

export PACKAGE_ID=${b}
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v 0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA


cd ../netzbetreiber
source iamorgnetzbetreiber.sh
peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label cp_0
peer lifecycle chaincode install cp.tar.gz
peer lifecycle chaincode queryinstalled

a=$(peer lifecycle chaincode queryinstalled)
tmp=${a#*ID:}   # remove prefix ending in "ID:"
b=${tmp%,*}   # remove suffix starting with ","
echo ${b}

export PACKAGE_ID=${b}
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v 0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA



peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --peerAddresses localhost:7051 --tlsRootCertFiles ${PEER0_ORGNETZBETREIBER_CA} --peerAddresses localhost:9051 --tlsRootCertFiles ${PEER0_ORGKUNDE_CA} --channelID mychannel --name energycontract -v 0 --sequence 1 --tls --cafile $ORDERER_CA --waitForEvent
docker ps
