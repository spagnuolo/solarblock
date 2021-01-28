'use strict';

const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const yaml = require('js-yaml');
const path = require('path');

async function main() {
    try {
        const userName = process.argv[2];
        if (!userName) {
            console.log('Please provide an user name.');
            return;
        }

        // load the network configuration
        let connectionProfile = yaml.safeLoad(fs.readFileSync('../gateway/connection.yaml', 'utf8'));
        const organization = connectionProfile.client.organization;
        const mspid = connectionProfile.organizations[organization].mspid;
        const certificateAuthority = Object.keys(connectionProfile.certificateAuthorities)[0]

        // Create a new CA client for interacting with the CA.
        const caInfo = connectionProfile.certificateAuthorities[certificateAuthority];
        const caTLSCACerts = caInfo.tlsCACerts.pem;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), `../identity/user/${userName}/wallet`);
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the admin user.
        const userExists = await wallet.get(userName);
        if (userExists) {
            console.log('An identity for the client user "user1" already exists in the wallet');
            return;
        }

        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'user1', enrollmentSecret: 'user1pw' });
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: mspid,
            type: 'X.509',
        };
        await wallet.put(userName, x509Identity);
        console.log(`Successfully enrolled client user "${userName}" and imported it into the wallet`);
    } catch (error) {
        console.error(`Failed to enroll client user: ${error}`);
        process.exit(1);
    }
}

main();
