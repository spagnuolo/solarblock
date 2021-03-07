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

Nun im Browser das Webinterface unter `localhost:8080` öffnen.

## Links
* [Commercial Paper tutorial](https://hyperledger-fabric.readthedocs.io/en/latest/tutorial/commercial_energy.html#examine-the-commercial-energy-smart-contract)
* [Smart Contracts](chaincode/contract/lib)
* [Chaincode](chaincode/application)
