'use strict';

const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Energy = require('./contract/lib/energy.js');

async function main() {
    const energyNumber = process.argv[2];
    if (!energyNumber) {
        console.log('Please provide the energyNumber.');
        return;
    }

    const splitAmount = process.argv[3];
    if (!splitAmount) {
        console.log('Please provide for how much you want to split the energy.');
        return;
    }

    let connectionProfile = yaml.safeLoad(fs.readFileSync('./gateway/connection.yaml', 'utf8'));
    const organization = connectionProfile.client.organization;
    const userName = 'user' + organization;

    const wallet = await Wallets.newFileSystemWallet(`./identity/user/${userName}/wallet`);
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

        console.log('Submit solar energy split transaction.');

        const splitResponse = await contract.submitTransaction('split', organization, energyNumber, splitAmount);

        console.log('Process split transaction response.' + splitResponse);
        let energy = Energy.fromBuffer(splitResponse);

        console.log(`${energy.owner} solar energy : ${energy.energyNumber} successfully split for value ${energy.capacity}`);
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
