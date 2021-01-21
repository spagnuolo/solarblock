#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0

function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export FABRIC_CFG_PATH="${DIR}/config"


./net.sh

# Copy the connection profiles so they are in the correct organizations.
cp "${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/connection-orgNetzbetreiber.yaml" "${DIR}/organization/netzbetreiber/gateway/"
cp "${DIR}/organizations/peerOrganizations/orgKunde.example.com/connection-orgKunde.yaml" "${DIR}/organization/kunde/gateway/"

cp ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/signcerts/User1@orgNetzbetreiber.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/keystore/priv_sk

cp ${DIR}/organizations/peerOrganizations/orgKunde.example.com/users/User1@orgKunde.example.com/msp/signcerts/* ${DIR}/organizations/peerOrganizations/orgKunde.example.com/users/User1@orgKunde.example.com/msp/signcerts/User1@orgKunde.example.com-cert.pem
cp ${DIR}/organizations/peerOrganizations/orgKunde.example.com/users/User1@orgKunde.example.com/msp/keystore/* ${DIR}/organizations/peerOrganizations/orgKunde.example.com/users/User1@orgKunde.example.com/msp/keystore/priv_sk

# cd ${DIR}
# ./organization/kunde/configuration/cli/monitordocker.sh net_test