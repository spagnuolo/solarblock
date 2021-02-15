#!/bin/bash

CC_VERSION=${1:-"1"}

#Copy the energy contract to every organisations
\cp -r "chaincode/contract" "organization/haushalt_a/"
\cp -r "chaincode/contract" "organization/haushalt_b/"
\cp -r "chaincode/contract" "organization/haushalt_c/"
\cp -r "chaincode/contract" "organization/netzbetreiber/"

\cp -r "chaincode/application" "organization/haushalt_a/"
\cp -r "chaincode/application" "organization/haushalt_b/"
\cp -r "chaincode/application" "organization/haushalt_c/"
\cp -r "chaincode/application" "organization/netzbetreiber/"

cd organization/haushalt_a
source iamorghaushalta.sh
peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label "solar_$CC_VERSION"
peer lifecycle chaincode install cp.tar.gz
peer lifecycle chaincode queryinstalled

PACKAGE_ID=$(peer lifecycle chaincode queryinstalled -O json | grep -Po "solar_$CC_VERSION:[[:alnum:]]*")
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA


cd ../netzbetreiber
source iamorgnetzbetreiber.sh
peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label "solar_$CC_VERSION"
peer lifecycle chaincode install cp.tar.gz
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA


cd ../haushalt_b
source iamorghaushaltb.sh
peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label "solar_$CC_VERSION"
peer lifecycle chaincode install cp.tar.gz
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA


cd ../haushalt_c
source iamorghaushaltc.sh
peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label "solar_$CC_VERSION"
peer lifecycle chaincode install cp.tar.gz
peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID mychannel --name energycontract -v $CC_VERSION --package-id $PACKAGE_ID --sequence $CC_VERSION --tls --cafile $ORDERER_CA


peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --peerAddresses localhost:7051 --tlsRootCertFiles ${PEER0_ORGNETZBETREIBER_CA} --peerAddresses localhost:9051 --tlsRootCertFiles ${PEER0_ORGHAUSHALTA_CA} --peerAddresses localhost:18051 --tlsRootCertFiles ${PEER0_ORGHAUSHALTC_CA} --peerAddresses localhost:19051 --tlsRootCertFiles ${PEER0_ORGHAUSHALTB_CA} --channelID mychannel --name energycontract -v $CC_VERSION --sequence $CC_VERSION --tls --cafile $ORDERER_CA --waitForEvent
