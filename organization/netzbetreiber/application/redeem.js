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
 * 4. Construct request to issue solar energy
 * 5. Submit transaction
 * 6. Process response
 */

'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');
const CommercialPaper = require('../contract/lib/paper.js');


// Main program function
async function main() {

  // A wallet stores a collection of identities for use
  const wallet = await Wallets.newFileSystemWallet('../identity/user/giuliano/wallet');


  // A gateway defines the peers used to access Fabric networks
  const gateway = new Gateway();

  // Main try/catch block
  try {

    // Specify userName for network access
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

    // redeem solar energy
    console.log('Submit solar energy redeem transaction.');

    const redeemResponse = await contract.submitTransaction('redeem', 'MagnetoCorp', '00001', 'DigiBank', 'OrgKundeMSP', '2020-11-30');

    // process response
    console.log('Process redeem transaction response.');

    let paper = CommercialPaper.fromBuffer(redeemResponse);

    console.log(`${paper.issuer} solar energy : ${paper.eneryNumber} successfully redeemed with ${paper.owner}`);

    console.log('Transaction complete.');

  } catch (error) {

    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);

  } finally {

    // Disconnect from the gateway
    console.log('Disconnect from Fabric gateway.')
    gateway.disconnect();

  }
}
main().then(() => {

  console.log('Redeem program complete.');

}).catch((e) => {

  console.log('Redeem program exception.');
  console.log(e);
  console.log(e.stack);
  process.exit(-1);

});
