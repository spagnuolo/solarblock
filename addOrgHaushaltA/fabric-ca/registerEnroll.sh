

function createOrgHaushaltA {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/orgHaushaltA.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-orgHaushaltA --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orgHaushaltA.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orgHaushaltA.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orgHaushaltA.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orgHaushaltA.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-orgHaushaltA --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-orgHaushaltA --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orgHaushaltA --id.name orgHaushaltAadmin --id.secret orgHaushaltAadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null

	mkdir -p ../organizations/peerOrganizations/orgHaushaltA.example.com/peers
  mkdir -p ../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-orgHaushaltA -M ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/msp --csr.hosts peer0.orgHaushaltA.example.com --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-orgHaushaltA -M ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgHaushaltA.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/tlsca/tlsca.orgHaushaltA.example.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/ca
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/peers/peer0.orgHaushaltA.example.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/ca/ca.orgHaushaltA.example.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/orgHaushaltA.example.com/users
  mkdir -p ../organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-orgHaushaltA -M ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/users/User1@orgHaushaltA.example.com/msp/config.yaml

  mkdir -p ../organizations/peerOrganizations/orgHaushaltA.example.com/users/Admin@orgHaushaltA.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orgHaushaltAadmin:orgHaushaltAadminpw@localhost:11054 --caname ca-orgHaushaltA -M ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/users/Admin@orgHaushaltA.example.com/msp --tls.certfiles ${PWD}/fabric-ca/orgHaushaltA/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/orgHaushaltA.example.com/users/Admin@orgHaushaltA.example.com/msp/config.yaml

}