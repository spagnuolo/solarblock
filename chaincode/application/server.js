'use strict';

const express = require('express');
const cors = require('cors');

const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Energy = require('../contract/lib/energy.js');


let gateway;
let contract;
let organization;

// Exit Server on ENTER.
const readline = require('readline').createInterface({
    input: process.stdin,
    output: process.stdout
});

readline.question('Press ENTER to exit server.\n\n', () => {
    console.log('Exit server.');
    readline.close();
    gateway.disconnect();
    process.exit(0);
});

// Connect to fabric network.
async function connection() {
    const connectionProfile = yaml.safeLoad(fs.readFileSync('../gateway/connection.yaml', 'utf8'));
    organization = connectionProfile.client.organization;
    const userName = 'user' + organization;

    const wallet = await Wallets.newFileSystemWallet(`../identity/user/${userName}/wallet`);
    gateway = new Gateway();

    const connectionOptions = {
        identity: userName,
        wallet: wallet,
        discovery: { enabled: true, asLocalhost: true }

    };

    try {
        await gateway.connect(connectionProfile, connectionOptions);
        const network = await gateway.getNetwork('mychannel');
        contract = await network.getContract('energycontract', 'org.solarnet.solarenergy');
    } catch (error) {
        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);
    }
}

connection().then(() => {
    console.log('Connection to fabric completed.');
}).catch((e) => {
    console.log('Connection to fabric exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
});


// API
const api = express();
api.use(cors({ origin: "http://localhost:5000" })); // Allow requests from frontend dev server.
api.use(express.static('../public'));
api.use(express.json());

api.get('/getSelling', (request, response) => {
    contract.evaluateTransaction('queryNamed', 'SELLING').then((queryResponse) => {
        let data = JSON.parse(queryResponse.toString());
        response.json(data);
    });
});

api.get('/getOwn', (request, response) => {
    contract.evaluateTransaction('queryOwner', organization).then((queryResponse) => {
        let data = JSON.parse(queryResponse.toString());
        response.json(data);
    });
});

api.get('/getOwnSelling', (request, response) => {
    let querySelector = `{"selector":{"owner":"${organization}", "currentState": 1}}`;
    contract.evaluateTransaction('queryAdhoc', querySelector).then((queryResponse) => {
        let data = JSON.parse(queryResponse.toString());
        response.json(data);
    }).catch((error) => {
        console.log(error);
        response.send(error);
    });
});

api.post('/sellEnergy', (request, response) => {
    console.log('/sellEnergy JSON:', request.body);
    let txnParams = [
        'sell',
        organization,
        request.body.energyNumber,
        new Date().toUTCString(),
        '2021-03-31',
        request.body.faceValue
    ];

    contract.submitTransaction(...txnParams).then((buyResponse) => {
        let energy = Energy.fromBuffer(buyResponse);
        let msg = `${energy.seller} solar energy : ${energy.energyNumber} successfully purchased by ${energy.owner}`;
        response.json({ msg });
    }).catch((error) => {
        let msg = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ msg });
    });
});

api.post('/buyEnergy', (request, response) => {
    console.log('/buyEnergy JSON:', request.body);

    contract.submitTransaction('buy', request.body.seller, request.body.energyNumber, organization, 'price', 'purchaseDateTime').then((buyResponse) => {
        let energy = Energy.fromBuffer(buyResponse);
        let msg = `${energy.seller} solar energy : ${energy.energyNumber} successfully purchased by ${energy.owner}`;
        response.json({ msg });
    }).catch((error) => {
        let msg = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ msg });
    });
});


let server = api.listen(8080, () => {
    let port = server.address().port;
    console.log(`Server listening at http://localhost:${port}`);
});
