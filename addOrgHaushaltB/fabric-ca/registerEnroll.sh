

function createOrgHaushaltB {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/orgHaushaltB.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11254 --caname ca-orgHaushaltB --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11254-ca-orgHaushaltB.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11254-ca-orgHaushaltB.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11254-ca-orgHaushaltB.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11254-ca-orgHaushaltB.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-orgHaushaltB --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-orgHaushaltB --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orgHaushaltB --id.name orgHaushaltBadmin --id.secret orgHaushaltBadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null

	mkdir -p ../organizations/peerOrganizations/orgHaushaltB.example.com/peers
  mkdir -p ../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11254 --caname ca-orgHaushaltB -M ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/msp --csr.hosts peer0.orgHaushaltB.example.com --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11254 --caname ca-orgHaushaltB -M ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls --enrollment.profile tls --csr.hosts peer0.orgHaushaltB.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/tlsca/tlsca.orgHaushaltB.example.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/ca
  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/peers/peer0.orgHaushaltB.example.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/ca/ca.orgHaushaltB.example.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/orgHaushaltB.example.com/users
  mkdir -p ../organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11254 --caname ca-orgHaushaltB -M ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/users/User1@orgHaushaltB.example.com/msp/config.yaml

  mkdir -p ../organizations/peerOrganizations/orgHaushaltB.example.com/users/Admin@orgHaushaltB.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orgHaushaltBadmin:orgHaushaltBadminpw@localhost:11254 --caname ca-orgHaushaltB -M ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/users/Admin@orgHaushaltB.example.com/msp --tls.certfiles ${PWD}/fabric-ca/orgHaushaltB/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/orgHaushaltB.example.com/users/Admin@orgHaushaltB.example.com/msp/config.yaml

}
