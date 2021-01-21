# solarblock
## Install
...

## Run

Das Fabric-Netzwerk starten mit:

```bash
network-starter.sh
```

Smart-Contracts aus `organization\netzbetreiber\contract\lib` deployen mit:

```bash
cc.sh
```


User erstellen und Chaincode ausführen mit:
```bash
cd organization/kunde/application
npm install # einmalig nodejs Abhängigkeiten downloaden
node enrollUser.js # wallet anlegen
node sell.js # chaincode
```

```bash
cd organization/netzbetreiber/application
npm install
node enrollUser.js
node buy.js # chaincode
node redeem.js # chaincode
```

## Links
* [solar energy tutorial](https://hyperledger-fabric.readthedocs.io/en/latest/tutorial/commercial_energy.html#examine-the-commercial-energy-smart-contract)
* [Smart Contracts](organization/netzbetreiber/contract/lib)
* [Chaincode](organization/kunde/application)
