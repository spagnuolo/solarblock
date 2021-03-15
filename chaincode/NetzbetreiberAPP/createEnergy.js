/*
This Method takes in three parameteers from the console
1. The amount of energy to be created
2. Unique ID to create of the asset
3. User for whom should be created
 */

'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
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
        // checks that only Netzbetreiber can execute createResponse
        if(userName != 'userOrgNetzbetreiber'){
            console.log('Only Netzbetreiber can create energy');
            return false;
        }

        console.log('Connect to Fabric gateway.');
        await gateway.connect(connectionProfile, connectionOptions);

        console.log('Use network channel: mychannel.');
        const network = await gateway.getNetwork('mychannel');

        console.log('Use org.solarnet.solarenergy smart contract.');
        const contract = await network.getContract('energycontract');

        console.log('Submit solar energy create transaction.');
        let now = new Date().toUTCString();
    
        //execute Enegery creation and print response
        const createResponse = await contract.submitTransaction('create_Energy', organization, energyNumber, now, '2021-02-25', energyAmount, wallet);
        
        if(createResponse === false){
            return;
        }

        console.log('Process create transaction response.' + createResponse);
        let energy = Energy.fromBuffer(createResponse);

        console.log(` ${energy.energyNumber} successfully created for value ${energy.faceValue}`);
        //execute the transfer of newly created energy to final destination and print response
        const transferResponse = await contract.submitTransaction('transferEnergy',organization, energyNumber, newOwner);
        energy = Energy.fromBuffer(transferResponse);

        console.log(` ${energy.energyNumber} succesfully tranfered to ${energy.owner} `);
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
