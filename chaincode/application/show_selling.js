'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');


async function main() {
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

        console.log('All energys in org.solarnet.solarenergys that are in current state of SELLING');
        console.log('-----------------------------------------------------------------------------------------\n');
        let queryResponse = await contract.evaluateTransaction('queryNamed', 'SELLING');

        let json = JSON.parse(queryResponse.toString());
        console.log(json);
        console.log('\n\n');

        console.log('\n  Named query "SELLING" complete.');
        console.log('-----------------------------------------------------------------------------------------\n\n');

    } catch (error) {
        console.log(`Error processing transaction. ${error}`);
        console.log(error.stack);

    } finally {
        // Disconnect from the gateway
        console.log('Disconnect from Fabric gateway.');
        gateway.disconnect();
    }
}


main().then(() => {
    console.log('Query program complete.');

}).catch((e) => {
    console.log('Query program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
});