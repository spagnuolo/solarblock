#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG="Netzbetreiber"
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/orgNetzbetreiber.example.com/tlsca/tlsca.orgNetzbetreiber.example.com-cert.pem
CAPEM=organizations/peerOrganizations/orgNetzbetreiber.example.com/ca/ca.orgNetzbetreiber.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgNetzbetreiber.example.com/connection-orgNetzbetreiber.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgNetzbetreiber.example.com/connection-orgNetzbetreiber.yaml

ORG="Kunde"
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/orgKunde.example.com/tlsca/tlsca.orgKunde.example.com-cert.pem
CAPEM=organizations/peerOrganizations/orgKunde.example.com/ca/ca.orgKunde.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgKunde.example.com/connection-orgKunde.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgKunde.example.com/connection-orgKunde.yaml

ORG="HaushaltB"
P0PORT=19051
CAPORT=19054
PEERPEM=organizations/peerOrganizations/orgHaushaltB.example.com/tlsca/tlsca.orgHaushaltB.example.com-cert.pem
CAPEM=organizations/peerOrganizations/orgHaushaltB.example.com/ca/ca.orgHaushaltB.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgHaushaltB.example.com/connection-orgHaushaltB.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgHaushaltB.example.com/connection-orgHaushaltB.yaml

ORG="HaushaltC"
P0PORT=18051
CAPORT=18054
PEERPEM=organizations/peerOrganizations/orgHaushaltC.example.com/tlsca/tlsca.orgHaushaltC.example.com-cert.pem
CAPEM=organizations/peerOrganizations/orgHaushaltC.example.com/ca/ca.orgHaushaltC.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgHaushaltC.example.com/connection-orgHaushaltC.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/orgHaushaltC.example.com/connection-orgHaushaltC.yaml
