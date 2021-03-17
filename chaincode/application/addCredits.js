'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Credit = require('../contract/lib/credit.js');


async function main() {

    const creditHolder = process.argv[2];
    if (!creditHolder) {
        console.log('Please provide the creditHolder.');
        return;
    }

    const creditID = process.argv[3];
    if (!creditID) {
        console.log('Please provide the creditID.');
        return;
    }

    const amountOfCreditsToAdd = process.argv[4];
    if (!amountOfCreditsToAdd) {
        console.log('Please provide the amount of Credits to add to the Wallet.');
        return;
    }


    let connectionProfile = yaml.safeLoad(fs.readFileSync('../gateway/connection.yaml', 'utf8'));
    const organization = connectionProfile.client.organization;
    const userName = 'user' + organization;

    const wallet = await Wallets.newFileSystemWallet(`../identity/user/${userName}/wallet`);
    const gateway = new Gateway();

    let connectionOptions = {
        identity: userName,
        wallet: wallet,
        discovery: { enabled: true, asLocalhost: true }

    };

    try {
        console.log('Connect to Fabric gateway.');
        await gateway.connect(connectionProfile, connectionOptions);

        console.log('Use network channel: mychannel.');
        const network = await gateway.getNetwork('mychannel');

        console.log('Use org.solarnet.solarenergy smart contract.');
        const contract = await network.getContract('energycontract', 'org.solarnet.solarenergy');

        console.log('Submit add Credit transaction.');
        const addCredit = await contract.submitTransaction('addCredits', creditHolder, creditID, amountOfCreditsToAdd);

        console.log('Process addCredit transaction response.');
        let credit = Credit.fromBuffer(addCredit);

        console.log(`${amountOfCreditsToAdd} was added to ${credit.creditID}, it now contains ${credit.amountOfCredits}`);
        console.log('Transaction complete.');

    } catch (error) {
        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);

    } finally {
        console.log('Disconnect from Fabric gateway.');
        gateway.disconnect();
    }
}
main().then(() => {
    console.log('Buy program complete.');
}).catch((e) => {
    console.log('Buy program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
});
