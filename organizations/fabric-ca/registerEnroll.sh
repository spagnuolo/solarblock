#!/bin/bash

source scriptUtils.sh

function createorgNetzbetreiber() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/orgNetzbetreiber.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-orgNetzbetreiber --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgNetzbetreiber.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgNetzbetreiber.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgNetzbetreiber.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-orgNetzbetreiber.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-orgNetzbetreiber --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-orgNetzbetreiber --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-orgNetzbetreiber --id.name orgNetzbetreiberadmin --id.secret orgNetzbetreiberadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/orgNetzbetreiber.example.com/peers
  mkdir -p organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-orgNetzbetreiber -M ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/msp --csr.hosts peer0.orgNetzbetreiber.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-orgNetzbetreiber -M ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgNetzbetreiber.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/tlsca/tlsca.orgNetzbetreiber.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/ca/ca.orgNetzbetreiber.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/orgNetzbetreiber.example.com/users
  mkdir -p organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-orgNetzbetreiber -M ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/User1@orgNetzbetreiber.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://orgNetzbetreiberadmin:orgNetzbetreiberadminpw@localhost:7054 --caname ca-orgNetzbetreiber -M ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp/config.yaml

}

function createorgKunde() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/orgKunde.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgKunde.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-orgKunde --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgKunde.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgKunde.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgKunde.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-orgKunde.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/orgKunde.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-orgKunde --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-orgKunde --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-orgKunde --id.name orgKundeadmin --id.secret orgKundeadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/orgKunde.example.com/peers
  mkdir -p organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-orgKunde -M ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/msp --csr.hosts peer0.orgKunde.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-orgKunde -M ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgKunde.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/orgKunde.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgKunde.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/orgKunde.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgKunde.example.com/tlsca/tlsca.orgKunde.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/orgKunde.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgKunde.example.com/ca/ca.orgKunde.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/orgKunde.example.com/users
  mkdir -p organizations/peerOrganizations/orgKunde.example.com/users/User1@orgKunde.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-orgKunde -M ${PWD}/organizations/peerOrganizations/orgKunde.example.com/users/User1@orgKunde.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgKunde.example.com/users/User1@orgKunde.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/orgKunde.example.com/users/Admin@orgKunde.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://orgKundeadmin:orgKundeadminpw@localhost:8054 --caname ca-orgKunde -M ${PWD}/organizations/peerOrganizations/orgKunde.example.com/users/Admin@orgKunde.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgKunde/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgKunde.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgKunde.example.com/users/Admin@orgKunde.example.com/msp/config.yaml

} 

function createorgHaushaltC() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/orgHaushaltC.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:18054 --caname ca-orgHaushaltC --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-orgHaushaltC.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-orgHaushaltC.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-orgHaushaltC.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-18054-ca-orgHaushaltC.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-orgHaushaltC --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-orgHaushaltC --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-orgHaushaltC --id.name orgHaushaltCadmin --id.secret orgHaushaltCadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/orgHaushaltC.example.com/peers
  mkdir -p organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:18054 --caname ca-orgHaushaltC -M ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/msp --csr.hosts peer0.orgHaushaltC.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:18054 --caname ca-orgHaushaltC -M ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgHaushaltC.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/tlsca/tlsca.orgHaushaltC.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/peers/peer0.orgHaushaltC.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/ca/ca.orgHaushaltC.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/orgHaushaltC.example.com/users
  mkdir -p organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:18054 --caname ca-orgHaushaltC -M ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/users/User1@orgHaushaltC.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/orgHaushaltC.example.com/users/Admin@orgHaushaltC.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://orgHaushaltCadmin:orgHaushaltCadminpw@localhost:18054 --caname ca-orgHaushaltC -M ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/users/Admin@orgHaushaltC.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/orgHaushaltC/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/orgHaushaltC.example.com/users/Admin@orgHaushaltC.example.com/msp/config.yaml

}

function createOrderer() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/example.com/orderers
  mkdir -p organizations/ordererOrganizations/example.com/orderers/example.com

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com

  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}
