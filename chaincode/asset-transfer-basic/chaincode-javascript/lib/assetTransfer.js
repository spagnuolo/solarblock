/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class AssetTransfer extends Contract {
    // To create InitLedger: 
    // 1. Bring the network up and createChannel with : ./network.sh up createChannel und ./network.sh deployCC -ccn basic -ccl javascript
    // 2. Interacting with the network 
    // export PATH=${PWD}/bin:$PATH
    // export FABRIC_CFG_PATH=$PWD/config/
    // # Environment variables for Org1
    // export CORE_PEER_TLS_ENABLED=true
    // export CORE_PEER_LOCALMSPID="OrgNetzbetreiberMSP"
    // export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt
    // export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/users/Admin@orgNetzbetreiber.example.com/msp
    // export CORE_PEER_ADDRESS=localhost:7051
    // Command to initialize  : peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgNetzbetreiber.example.com/peers/peer0.orgNetzbetreiber.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/orgKunde.example.com/peers/peer0.orgKunde.example.com/tls/ca.crt -c '{"function":"InitLedger","Args":[]}'
    // REMEMBER: Chaincodes are invoked when a network member wants to transfer or change an asset on the ledger(like InitLedger,CreateAsset,UpdateAsset,DeleteAsset and pass the appropriate parameters in Args).
    // To QUERY ReadAsset,AssetExists,GetAllAssets use chaincode query: .e.g. chaincode query  peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}' 

    async InitLedger(ctx) {
        const assets = [
            {
                ID: 'asset1',
                Owner: 'Viet',
                Electricity: 300,
            },
            {
                ID: 'asset2',
                Owner: 'Markus',
                Electricity: 250,
            },
            {
                ID: 'asset3',
                Owner: 'Henry',
                Electricity: 350,
            },
            {
                ID: 'asset4',
                Owner: 'Giuliano',
                Electricity: 300,
            },
        ];

        for (const asset of assets) {
            asset.docType = 'asset';
            await ctx.stub.putState(asset.ID, Buffer.from(JSON.stringify(asset)));
            console.info(`Asset ${asset.ID} initialized`);
        }
    }

    // CreateAsset issues a new asset to the world state with given details.
    async CreateAsset(ctx, id, owner, electricity) {
        const asset = {
            ID: id,
            Owner: owner,
            Electricity: electricity,
        };
        ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
        return JSON.stringify(asset);
    }

    // ReadAsset returns the asset stored in the world state with given id.
    async ReadAsset(ctx, id) {
        const assetJSON = await ctx.stub.getState(id); // get the asset from chaincode state
        if (!assetJSON || assetJSON.length === 0) {
            throw new Error(`The asset ${id} does not exist`);
        }
        return assetJSON.toString();
    }

    // UpdateAsset updates an existing asset in the world state with provided parameters.
    async UpdateAsset(ctx, id, owner, electricity) {
        const exists = await this.AssetExists(ctx, id);
        if (!exists) {
            throw new Error(`The asset ${id} does not exist`);
        }

        // overwriting original asset with new asset
        const updatedAsset = {
            ID: id,
            Owner: owner,
            Electricity: electricity,
        };
        return ctx.stub.putState(id, Buffer.from(JSON.stringify(updatedAsset)));
    }

    // DeleteAsset deletes an given asset from the world state.
    async DeleteAsset(ctx, id) {
        const exists = await this.AssetExists(ctx, id);
        if (!exists) {
            throw new Error(`The asset ${id} does not exist`);
        }
        return ctx.stub.deleteState(id);
    }

    // AssetExists returns true when asset with given ID exists in world state.
    async AssetExists(ctx, id) {
        const assetJSON = await ctx.stub.getState(id);
        return assetJSON && assetJSON.length > 0;
    }

    // TransferAsset updates the owner field of asset with given id in the world state.
    async TransferAsset(ctx, id, newOwner) {
        const assetString = await this.ReadAsset(ctx, id);
        const asset = JSON.parse(assetString);
        asset.Owner = newOwner;
        return ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
    }

    // GetAllAssets returns all assets found in the world state.
    async GetAllAssets(ctx) {
        const allResults = [];
        // range query with empty string for startKey and endKey does an open-ended query of all assets in the chaincode namespace.
        const iterator = await ctx.stub.getStateByRange('', '');
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: result.value.key, Record: record });
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }


}

module.exports = AssetTransfer;
