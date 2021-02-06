
'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const yaml = require('js-yaml');
const { Wallets, Gateway } = require('fabric-network');


// Main program function
async function main() {
    const userName = process.argv[2];

    if (!userName) {
        console.log('Please provide an user name.');
        return;
    }
    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet(`../identity/user/${userName}/wallet`);

    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

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
        const contract = await network.getContract('energycontract', 'org.solarnet.solarenergy');

        // queries - solar energy
        console.log('-----------------------------------------------------------------------------------------');
        console.log('****** Submitting solar energy queries ****** \n\n ');

        // 1 asset history
        console.log('1. Query solar energy History orgHaushaltB....');
        console.log('-----------------------------------------------------------------------------------------\n');
        let queryResponse = await contract.evaluateTransaction('queryHistory', 'OrgHaushaltA', '00001');

        let json = JSON.parse(queryResponse.toString());
        console.log(json);
        console.log('\n\n');
        console.log('\n  History query complete.');
        console.log('-----------------------------------------------------------------------------------------\n\n');

        // // 2 asset history
        // console.log('1. Query solar energy History orgHaushaltC....');
        // console.log('-----------------------------------------------------------------------------------------\n');
        // queryResponse = await contract.evaluateTransaction('queryHistory', 'OrgHaushaltC', '00002');

        // json = JSON.parse(queryResponse.toString());
        // console.log(json);
        // console.log('\n\n');
        // console.log('\n  History query complete.');
        // console.log('-----------------------------------------------------------------------------------------\n\n');

        // 2 ownership query
        console.log('2. Query solar energy Ownership.... Energys owned by orgNetzbetreiber');
        console.log('-----------------------------------------------------------------------------------------\n');
        queryResponse = await contract.evaluateTransaction('queryOwner', 'OrgNetzbetreiber');
        json = JSON.parse(queryResponse.toString());
        console.log(json);

        console.log('\n\n');
        console.log('\n  Energy Ownership query complete.');
        console.log('-----------------------------------------------------------------------------------------\n\n');

        // 3 partial key query
        console.log('3. Query solar energy Partial Key.... Energys in org.solarnet.solarenergys namespace and prefixed MagnetoCorp');
        console.log('-----------------------------------------------------------------------------------------\n');
        queryResponse = await contract.evaluateTransaction('queryPartial', 'OrgHaushaltA');

        json = JSON.parse(queryResponse.toString());
        console.log(json);
        console.log('\n\n');

        console.log('\n  Partial Key query complete.');
        console.log('-----------------------------------------------------------------------------------------\n\n');


        // 4 Named query - all BOUGHT energys
        console.log('4. Named Query: ... All energys in org.solarnet.solarenergys that are in current state of BOUGHT');
        console.log('-----------------------------------------------------------------------------------------\n');
        queryResponse = await contract.evaluateTransaction('queryNamed', 'BOUGHT');

        json = JSON.parse(queryResponse.toString());
        console.log(json);
        console.log('\n\n');

        console.log('\n  Named query "BOUGHT" complete.');
        console.log('-----------------------------------------------------------------------------------------\n\n');


        // 5 named query - by value
        console.log('5. Named Query:.... All energys in org.solarnet.solarenergys with faceValue > 4000000');
        console.log('-----------------------------------------------------------------------------------------\n');
        queryResponse = await contract.evaluateTransaction('queryNamed', 'value');

        json = JSON.parse(queryResponse.toString());
        console.log(json);
        console.log('\n\n');

        console.log('\n  Named query by "value" complete.');
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