#!/bin/bash

CC_VERSION=${1:-"1"}

#Copy the energy contract to every organisations
\cp -r "chaincode/contract" "chaincode/application/"



cd ./scripts
source iamorgnetzbetreiber.sh
peer lifecycle chaincode package solarblock.tar.gz --lang node --path ./../chaincode/contract --label "solar_$CC_VERSION"
peer lifecycle chaincode install solarblock.tar.gz

PACKAGE_ID=$(peer lifecycle chaincode queryinstalled -O json | grep -Po "solar_$CC_VERSION:[[:alnum:]]*")
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA

source iamorghaushalta.sh
peer lifecycle chaincode install solarblock.tar.gz
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA

source iamorghaushaltb.sh
peer lifecycle chaincode install solarblock.tar.gz
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA

source iamorghaushaltc.sh
peer lifecycle chaincode install solarblock.tar.gz
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA

peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --peerAddresses localhost:7051 --tlsRootCertFiles ${PEER0_ORGNETZBETREIBER_CA} --peerAddresses localhost:9051 --tlsRootCertFiles ${PEER0_ORGHAUSHALTA_CA} --peerAddresses localhost:18051 --tlsRootCertFiles ${PEER0_ORGHAUSHALTC_CA} --peerAddresses localhost:19051 --tlsRootCertFiles ${PEER0_ORGHAUSHALTB_CA} --channelID mychannel --name energycontract -v $CC_VERSION --sequence $CC_VERSION --tls --cafile $ORDERER_CA --waitForEvent

rm solarblock.tar.gz
