#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

source scriptUtils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORGNETZBETREIBER_CA=${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt
export PEER0_ORGHAUSHALTA_CA=${PWD}/organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/ca.crt
export PEER0_ORGHAUSHALTB_CA=${PWD}/organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/ca.crt
export PEER0_ORGHAUSHALTC_CA=${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="OrgNetzbetreiberMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORGNETZBETREIBER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="OrgHaushaltAMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORGHAUSHALTA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/orgHaushaltA.example.com/users/Admin@orgHaushaltA.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="OrgHaushaltBMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORGHAUSHALTB_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/orgHaushaltB.example.com/users/Admin@orgHaushaltB.example.com/msp
    export CORE_PEER_ADDRESS=localhost:19051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="OrgHaushaltCMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORGHAUSHALTC_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/users/Admin@orgHaushaltC.example.com/msp
    export CORE_PEER_ADDRESS=localhost:18051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
