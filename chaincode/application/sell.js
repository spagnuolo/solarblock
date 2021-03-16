/*
 * This application has 6 basic steps:
 * 1. Select an identity from a wallet
 * 2. Connect to network gateway
 * 3. Access EnergyNet network
 * 4. Construct request to sell solar energy
 * 5. Submit transaction
 * 6. Process response
 */

'use strict';
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Energy = require('../contract/lib/energy.js');

async function main() {
    const energyNumber = process.argv[2];
    if (!energyNumber) {
        console.log('Please provide the energyNumber.');
        return;
    }

    const price = process.argv[3];
    if (!price) {
        console.log('Please provide for how much you want to sell the energy.');
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

        console.log('Submit solar energy sell transaction.');

        const sellResponse = await contract.submitTransaction('sell', organization, energyNumber, price);

        console.log('Process sell transaction response.' + sellResponse);
        let energy = Energy.fromBuffer(sellResponse);

        console.log(`${energy.seller} solar energy : ${energy.energyNumber} successfully sell for value ${energy.faceValue}`);
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
    console.log('Issue program complete.');
}).catch((e) => {
    console.log('Issue program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
});
