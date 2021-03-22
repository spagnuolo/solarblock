'use strict';

const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Energy = require('../contract/lib/energy.js');

async function main() {
    const energyAmount = process.argv[2];
    if (!energyAmount) {
        console.log('Please provide how much energy you want to sell');
        return;
    }

    const energyNumber = process.argv[3];
    if (!energyNumber) {
        console.log('Please provide the energyNumber.');
        return;
    }

    const newOwner = process.argv[4];
    if (!newOwner) {
        console.log('Please specify the User for whom you want to create the asset.');
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
        const createResponse = await contract.submitTransaction('create', newOwner, energyNumber, energyAmount);

        console.log('Process create transaction response.' + createResponse);
        let energy = Energy.fromBuffer(createResponse);

        console.log(` ${energy.energyNumber} successfully created for value ${energy.capacity}`);
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
