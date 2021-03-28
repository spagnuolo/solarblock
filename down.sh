COMPOSE_FILE_BASE=docker/docker-compose-test-net.yaml
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml

cd .
docker container stop guiNetzbetreiber guiHaushaltA guiHaushaltB guiHaushaltC
docker-compose -f $COMPOSE_FILE_BASE -f $COMPOSE_FILE_COUCH -f $COMPOSE_FILE_CA down --volumes --remove-orphans

CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
  echo "No container found"
else
  docker rm -f $CONTAINER_IDS
fi

DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
  echo "No images found"
else
  docker rmi -f $DOCKER_IMAGE_IDS
fi

docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf system-genesis-block/*.block organizations/peerOrganizations organizations/ordererOrganizations'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/orgNetzbetreiber/msp organizations/fabric-ca/orgNetzbetreiber/tls-cert.pem organizations/fabric-ca/orgNetzbetreiber/ca-cert.pem organizations/fabric-ca/orgNetzbetreiber/IssuerPublicKey organizations/fabric-ca/orgNetzbetreiber/IssuerRevocationPublicKey organizations/fabric-ca/orgNetzbetreiber/fabric-ca-server.db'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/orgHaushaltA/msp organizations/fabric-ca/orgHaushaltA/tls-cert.pem organizations/fabric-ca/orgHaushaltA/ca-cert.pem organizations/fabric-ca/orgHaushaltA/IssuerPublicKey organizations/fabric-ca/orgHaushaltA/IssuerRevocationPublicKey organizations/fabric-ca/orgHaushaltA/fabric-ca-server.db'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/orgHaushaltB/msp organizations/fabric-ca/orgHaushaltB/tls-cert.pem organizations/fabric-ca/orgHaushaltB/ca-cert.pem organizations/fabric-ca/orgHaushaltB/IssuerPublicKey organizations/fabric-ca/orgHaushaltB/IssuerRevocationPublicKey organizations/fabric-ca/orgHaushaltB/fabric-ca-server.db'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/orgHaushaltC/msp organizations/fabric-ca/orgHaushaltC/tls-cert.pem organizations/fabric-ca/orgHaushaltC/ca-cert.pem organizations/fabric-ca/orgHaushaltC/IssuerPublicKey organizations/fabric-ca/orgHaushaltC/IssuerRevocationPublicKey organizations/fabric-ca/orgHaushaltC/fabric-ca-server.db'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/ordererOrg/msp organizations/fabric-ca/ordererOrg/tls-cert.pem organizations/fabric-ca/ordererOrg/ca-cert.pem organizations/fabric-ca/ordererOrg/IssuerPublicKey organizations/fabric-ca/ordererOrg/IssuerRevocationPublicKey organizations/fabric-ca/ordererOrg/fabric-ca-server.db'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf channel-artifacts log.txt *.tar.gz'

rm -rf chaincode/application/identity/user/*

