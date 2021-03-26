'use strict';

// REST API.
const express = require('express');
const cors = require('cors');

// Handle files.
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

// Fabric Network.
const FabricCAServices = require('fabric-ca-client');
const { Wallets, Gateway } = require('fabric-network');
const Energy = require('./contract/lib/energy.js');

// Globals.
let gateway;
let contract;
let organization;
let peer;

// Connect to fabric network.
async function connection() {
    const connectionProfile = yaml.safeLoad(fs.readFileSync('./gateway/connection.yaml', 'utf8'));
    organization = connectionProfile.client.organization;
    peer = connectionProfile.organizations[organization].peers[0];
    const mspid = connectionProfile.organizations[organization].mspid;
    const certificateAuthority = Object.keys(connectionProfile.certificateAuthorities)[0]

    // Change url to work inside docker network.
    const caInfo = connectionProfile.certificateAuthorities[certificateAuthority];
    connectionProfile.peers[peer].url = connectionProfile.peers[peer].url.replace('localhost', peer);
    caInfo.url = caInfo.url.replace('localhost', caInfo.caName);

    // Create a new CA client for interacting with the CA.
    const caTLSCACerts = caInfo.tlsCACerts.pem;
    const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);

    const userName = 'user' + organization;
    const walletPath = path.join(process.cwd(), `./identity/user/${userName}/wallet`);
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    // Check to see if we've already enrolled the admin user.
    const userExists = await wallet.get(userName);
    if (!userExists) {
        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'user1', enrollmentSecret: 'user1pw' });
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: mspid,
            type: 'X.509',
        };
        await wallet.put(userName, x509Identity);
        console.log(`Successfully enrolled client user "${userName}" and imported it into the wallet`);
    }

    gateway = new Gateway();

    const connectionOptions = {
        identity: userName,
        wallet: wallet,
        discovery: { enabled: true, asLocalhost: false }
    };

    try {
        await gateway.connect(connectionProfile, connectionOptions);
        const network = await gateway.getNetwork('public-channel');
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

// API
const api = express();
api.use(cors({ origin: "http://localhost:5000" })); // Allow requests from frontend dev server.
api.use(express.static('./public'));
api.use(express.json());

// GET methods.
api.get('/init', (request, response) => {
    contract.submitTransaction('instantiate').then(() => {
        response.json({ message: "Solarblock initialized." });
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

api.get('/getInfo', (request, response) => {
    response.json({ organization, peer });
});

api.get('/getCredits', (request, response) => {
    contract.evaluateTransaction('getCredits').then((queryResponse) => {
        let data = JSON.parse(queryResponse.toString());
        response.json(data);
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

api.get('/getSelling', (request, response) => {
    contract.evaluateTransaction('queryNamed', 'SELLING').then((queryResponse) => {
        let data = JSON.parse(queryResponse.toString());
        response.json(data);
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

api.get('/getOwn', (request, response) => {
    contract.evaluateTransaction('queryOwner', organization).then((queryResponse) => {
        let data = JSON.parse(queryResponse.toString());
        response.json(data);
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

api.get('/getOwnSelling', (request, response) => {
    let querySelector = `{"selector":{"owner":"${organization}", "currentState": 1}}`;
    contract.evaluateTransaction('queryAdhoc', querySelector).then((queryResponse) => {
        let data = JSON.parse(queryResponse.toString());
        response.json(data);
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

// POST methods.
api.post('/createEnergy', (request, response) => {
    console.log('/createEnergy JSON:', request.body);
    let transactionParameters = [
        'create',
        request.body.newOwner,
        request.body.capacity,
    ];

    contract.submitTransaction(...transactionParameters).then((createResponse) => {
        let energy = Energy.fromBuffer(createResponse);
        let message = `${energy.seller} solar energy : ${energy.energyNumber} successfully created.`;
        response.json({ message });
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

api.post('/splitEnergy', (request, response) => {
    console.log('/splitEnergy JSON:', request.body);
    let transactionParameters = [
        'split',
        request.body.owner,
        request.body.energyNumber,
        request.body.splitAmount,
    ];

    contract.submitTransaction(...transactionParameters).then((splitResponse) => {
        let energy = Energy.fromBuffer(splitResponse);
        let message = `${energy.seller} solar energy : ${energy.energyNumber} successfully splited.`;
        response.json({ message });
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

api.post('/sellEnergy', (request, response) => {
    console.log('/sellEnergy JSON:', request.body);
    let transactionParameters = [
        'sell',
        organization,
        request.body.energyNumber,
        request.body.credits
    ];

    contract.submitTransaction(...transactionParameters).then((sellResponse) => {
        let energy = Energy.fromBuffer(sellResponse);
        let message = `${energy.seller} solar energy : ${energy.energyNumber} successfully offered by ${energy.owner}`;
        response.json({ message });
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

api.post('/buyEnergy', (request, response) => {
    console.log('/buyEnergy JSON:', request.body);
    let transactionParameters = [
        'buy',
        request.body.energyNumber,
    ];

    contract.submitTransaction(...transactionParameters).then((buyResponse) => {
        let energy = Energy.fromBuffer(buyResponse);
        let message = `${energy.seller} solar energy : ${energy.energyNumber} successfully purchased by ${energy.owner}`;
        response.json({ message });
    }).catch((error) => {
        let message = `Error processing transaction. ${error}`;
        console.log(error.stack);
        response.json({ message });
    });
});

let server = api.listen(8000, () => {
    let port = server.address().port;
    console.log(`Server listening at http://localhost:${port}`);
});
