/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

/*
 * This application has 6 basic steps:
 * 1. Select an identity from a wallet
 * 2. Connect to network gateway
 * 3. Access PaperNet network
 * 4. Construct request to buy (buy_request) solar energy
 * 5. Submit transaction
 * 6. Process response
 */

'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const CommercialPaper = require('../../kunde/contract/lib/paper.js');


// Main program function
async function main() {

    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet('../identity/user/giuliano/wallet');


    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    // Main try/catch block
    try {

        // Specify userName for network access
        const userName = 'giuliano';

        // Load connection profile; will be used to locate a gateway
        let connectionProfile = yaml.safeLoad(fs.readFileSync('../gateway/connection-orgNetzbetreiber.yaml', 'utf8'));

        // Set connection options; identity and wallet
        let connectionOptions = {
            identity: userName,
            wallet: wallet,
            discovery: { enabled: true, asLocalhost: true }

        };

        // Connect to gateway using application specified parameters
        console.log('Connect to Fabric gateway.');

        await gateway.connect(connectionProfile, connectionOptions);

        // Access PaperNet network
        console.log('Use network channel: mychannel.');

        const network = await gateway.getNetwork('mychannel');

        // Get addressability to solar energy contract
        console.log('Use org.solarnet.solarenergy smart contract.');

        const contract = await network.getContract('papercontract', 'org.solarnet.solarenergy');

        // request to buy solar energy using buy_request / transfer two-part transaction
        console.log('Submit solar energy buy_request transaction.');

        const buyResponse = await contract.submitTransaction('buy_request', 'MagnetoCorp', '00001', 'MagnetoCorp', 'DigiBank', '4900000', '2020-05-31');

        // process response
        console.log('Process buy_request transaction response.');

        let paper = CommercialPaper.fromBuffer(buyResponse);

        console.log(`${paper.issuer} solar energy : ${paper.eneryNumber} has been provisionally purchased : the transfer must now be completed by paper owner`);
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

    console.log('Buy_request program complete.');

}).catch((e) => {

    console.log('Buy_request program exception.');
    console.log(e);
    console.log(e.stack);
    process.exit(-1);

});
