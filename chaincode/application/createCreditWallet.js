'use strict';

const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Credit = require('../contract/lib/credit.js');

async function main() {
    const newOwner
     = process.argv[2];
    if (!newOwner
        ) {
        console.log('Please provide how much energy you want to sell');
        return;
    }

    const creditWalletId = process.argv[3];
    if (!creditWalletId) {
        console.log('Please provide the creditWalletId.');
        return;
    }

    const initialCreditValue = process.argv[4];
    if (!initialCreditValue ) {
        console.log('Please provide the creditWalletId.');
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
        const contract = await network.getContract('energycontract');

        console.log('Submit solar energy create transaction.');
        const createResponse = await contract.submitTransaction('createCreditWallet', newOwner, creditWalletId, initialCreditValue );
    

        console.log('Process create Wallet transaction response.' + createResponse);
        let credit = Credit.fromBuffer(createResponse);

        console.log(` ${credit.creditWalletId} successfully created for value ${credit.amountOfCredits}`);
        console.log('Transaction completed')

    } catch (error) {
        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);

    } finally {
        console.log('Disconnect from Fabric gateway.');
        gateway.disconnect();
    }
}
main().then(() => {
    console.log('Issue program complete.');
}).catch((e) => {
    console.log('Issue program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
});
