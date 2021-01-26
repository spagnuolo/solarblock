#!/bin/bash

function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
# set -ev
# set -o pipefail

# Where am I?
cd .
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export FABRIC_CFG_PATH="${DIR}/config"

./net.sh

# Copy the connection profiles so they are in the correct organizations.
cp "${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/connection-orgNetzbetreiber.yaml" "${DIR}/organization/netzbetreiber/gateway/connection.yaml"
cp "${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/connection-orgHaushaltA.yaml" "${DIR}/organization/haushalt_a/gateway/connection.yaml"
cp "${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/connection-orgHaushaltB.yaml" "${DIR}/organization/haushalt_b/gateway/connection.yaml"
cp "${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/connection-orgHaushaltC.yaml" "${DIR}/organization/haushalt_c/gateway/connection.yaml"


cp ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/signcerts/User1@orgNetzbetreiber.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/keystore/priv_sk

cp ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/signcerts/User1@orgHaushaltA.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/keystore/priv_sk

cp ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/signcerts/User1@orgHaushaltB.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/keystore/priv_sk

cp ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/signcerts/User1@orgHaushaltC.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/keystore/priv_sk
