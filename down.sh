COMPOSE_FILE_BASE=docker/docker-compose-test-net.yaml
COMPOSE_FILE_COUCH=docker/docker-compose-couch.yaml
COMPOSE_FILE_CA=docker/docker-compose-ca.yaml
COMPOSE_FILE_COUCH_ORG3=addOrg3/docker/docker-compose-couch-org3.yaml
COMPOSE_FILE_ORG3=addOrg3/docker/docker-compose-org3.yaml

docker kill cliDigiBank cliMagnetoCorp logspout || true

docker-compose -f $COMPOSE_FILE_BASE -f $COMPOSE_FILE_COUCH -f $COMPOSE_FILE_CA down --volumes --remove-orphans
# docker-compose -f $COMPOSE_FILE_COUCH_ORG3 -f $COMPOSE_FILE_ORG3 down --volumes --remove-orphans

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
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/orgKunde/msp organizations/fabric-ca/orgKunde/tls-cert.pem organizations/fabric-ca/orgKunde/ca-cert.pem organizations/fabric-ca/orgKunde/IssuerPublicKey organizations/fabric-ca/orgKunde/IssuerRevocationPublicKey organizations/fabric-ca/orgKunde/fabric-ca-server.db'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf organizations/fabric-ca/ordererOrg/msp organizations/fabric-ca/ordererOrg/tls-cert.pem organizations/fabric-ca/ordererOrg/ca-cert.pem organizations/fabric-ca/ordererOrg/IssuerPublicKey organizations/fabric-ca/ordererOrg/IssuerRevocationPublicKey organizations/fabric-ca/ordererOrg/fabric-ca-server.db'
# docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf addOrg3/fabric-ca/org3/msp addOrg3/fabric-ca/org3/tls-cert.pem addOrg3/fabric-ca/org3/ca-cert.pem addOrg3/fabric-ca/org3/IssuerPublicKey addOrg3/fabric-ca/org3/IssuerRevocationPublicKey addOrg3/fabric-ca/org3/fabric-ca-server.db'
docker run --rm -v $(pwd):/data busybox sh -c 'cd /data && rm -rf channel-artifacts log.txt *.tar.gz'

rm organization/kunde/identity/user/viet/wallet/viet.id
rm organization/netzbetreiber/identity/user/giuliano/wallet/giuliano.id
