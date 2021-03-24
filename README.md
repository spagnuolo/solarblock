# solarblock
## Install
*TODO*

## Run

Das Fabric-Netzwerk starten mit:

```bash
./up.sh
```

Smart-Contracts aus `organization\chaincode\contract\lib` deployen mit:

```bash
./cc.sh
```

Dieses Skript installiert die *Version 1* der Smart-Contracts auf allen Peers.
Um eine neue Version der Smart-Contracts zu installieren kann `cc.sh` ebenfalls verwendet werden.
Die neue Version muss immer ein Inkrement (Current_Version + 1)
des aktuellen Smart-Contracts sein.

```bash
./cc.sh 2 # Version 2
```


User erstellen und Chaincode ausführen mit:
```bash
cd organization/*/application
npm install # einmalig nodejs Abhängigkeiten downloaden
node enrollUser.js # wallet anlegen
node sell.js 500 00001 # chaincode
```

## Build the web interface
```bash
cd frontend
npm install
npm run build
```

## Backend API Server
Backend API Server für das Webinterface starten:
```bash
cd organization/*/application
node server.js
```

Nun im Browser das Webinterface unter `localhost:8000` öffnen.

## Links
* [Commercial Paper tutorial](https://hyperledger-fabric.readthedocs.io/en/latest/tutorial/commercial_energy.html#examine-the-commercial-energy-smart-contract)
* [Smart Contracts](chaincode/contract/lib)
* [Chaincode](chaincode/application)

## Hyperledger Explorer (using Docker)

Nach dem Start des Netzwerks (nach der Ausführung `./up.sh`) , kopiere manuell den privaten Schlüssel (`private_sk`) aus `organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp/keystore/private_sk`. 

Füge den in `connection-profile/solar-network.json` an der Stelle `private_sk` ein.
```bash
"OrgNetzbetreiberMSP": {
	"mspid": "OrgNetzbetreiberMSP",
		"adminPrivateKey": {
			"path": "/tmp/crypto/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp/keystore/private_sk"
```
Dann um die Hyperledger Explorer zu starten:
```bash
cd hyperledger-explorer
docker-compose up -d
```
Hyperledger Explorer  sollte richtig eingerichtet sein und kann nun im Browser das Webinterface unter `localhost:8080` zugegriffen werden.
Wenn es dazu auffordert, sich anzumelden, dann mit:

username: ganymedeAdmin

password: ganymedeAdminPw

Um die Hyperledger Explorer zu stoppen:
```bash
docker-compose down -v
```
## Anmerkung für Hyperledger Explorer

* Wenn eine Konfiguration (innerhalb `hyperledger-explorer` Ordner ) geändert werden muss, muss aber auch Hyperledger Exlorer gestoppt und neu gestartet werden.

* Hyperledger Explorer ist nur möglich nach dem Start des Netzwerks (nach der Ausführung `./up.sh`).

* Wenn Hyperledger Exlorer nicht starten kann, führt 
`docker logs explorer.mynetwork.com` aus, um die Fehlermeldung zu lesen.