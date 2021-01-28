/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

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

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const Energy = require('../contract/lib/energy.js');

// Main program function
async function main() {
    // Specify userName for network access
    // const userName = 'viet.seller@kunde.com';
    const userName = process.argv[2];
    if (!userName) {
        console.log('Please provide an user name.');
        return;
    }
    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet(`../identity/user/${userName}/wallet`);

    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    // Main try/catch block
    try {
        // Load connection profile; will be used to locate a gateway
        let connectionProfile = yaml.safeLoad(fs.readFileSync('../gateway/connection.yaml', 'utf8'));

        // Set connection options; identity and wallet
        let connectionOptions = {
            identity: userName,
            wallet: wallet,
            discovery: { enabled: true, asLocalhost: true }
        };

        // Connect to gateway using application specified parameters
        console.log('Connect to Fabric gateway.');

        await gateway.connect(connectionProfile, connectionOptions);

        // Access EnergyNet network
        console.log('Use network channel: mychannel.');

        const network = await gateway.getNetwork('mychannel');

        // Get addressability to solar energy contract
        console.log('Use org.solarnet.solarenergy smart contract.');

        const contract = await network.getContract('energycontract');

        // sell solar energy
        console.log('Submit solar energy sell transaction.');

        const organization = connectionProfile.client.organization;
        const sellResponse = await contract.submitTransaction('sell', organization, '00001', '2021-01-25', '2021-02-25', '500kWh');

        // process response
        console.log('Process sell transaction response.' + sellResponse);

        let energy = Energy.fromBuffer(sellResponse);

        console.log(`${energy.seller} solar energy : ${energy.energyNumber} successfully sell for value ${energy.faceValue}`);
        console.log('Transaction complete.');

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

    console.log('Issue program complete.');

}).catch((e) => {

    console.log('Issue program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);

});
