# solarblock
## Install
TODO

## Run

Das Fabric-Netzwerk starten mit:

```bash
network-starter.sh
```

Smart-Contracts aus `organization\chaincode\contract\lib` deployen mit:

```bash
cc.sh
```


User erstellen und Chaincode ausführen mit:
```bash
cd organization/haushalt_a/application
npm install # einmalig nodejs Abhängigkeiten downloaden
node enrollUser.js viet # wallet anlegen
node sell.js viet # chaincode
```


## Links
* [Commercial Paper tutorial](https://hyperledger-fabric.readthedocs.io/en/latest/tutorial/commercial_energy.html#examine-the-commercial-energy-smart-contract)
* [Smart Contracts](chaincode/contract/lib)
* [Chaincode](chaincode/application)
