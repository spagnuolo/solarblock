#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
PEER0_ORGNETZBETREIBER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt
PEER0_ORGKUNDE_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt
PEER0_ORG3_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  CORE_PEER_LOCALMSPID="OrdererMSP"
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  ORG=$1
  if [ $ORG -eq 1 ]; then
    CORE_PEER_LOCALMSPID="OrgNetzbetreiberMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORGNETZBETREIBER_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp
    CORE_PEER_ADDRESS=peer0.orgNetzbetreiber.example.com:7051
  elif [ $ORG -eq 2 ]; then
    CORE_PEER_LOCALMSPID="OrgKundeMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORGKUNDE_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgKunde.example.com/users/Admin@orgKunde.example.com/msp
    CORE_PEER_ADDRESS=peer0.orgKunde.example.com:9051
  elif [ $ORG -eq 3 ]; then
    CORE_PEER_LOCALMSPID="OrgHaushaltAMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/orgHaushaltA.example.com/users/Admin@orgHaushaltA.example.com/msp
    CORE_PEER_ADDRESS=peer0.orgHaushaltA.example.com:11051
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo $'\e[1;31m'!!!!!!!!!!!!!!! $2 !!!!!!!!!!!!!!!!$'\e[0m'
    echo
    exit 1
  fi
}
