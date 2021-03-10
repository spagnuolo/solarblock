/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Fabric smart contract classes
const { Contract, Context } = require('fabric-contract-api');

// EnergyNet specifc classes
const Energy = require('./energy.js');
const EnergyList = require('./energylist.js');
const QueryUtils = require('./queries.js');

/**
 * A custom context provides easy access to list of all solar energys
 */
class EnergyContext extends Context {

    constructor() {
        super();
        // All energys are held in a list of energys
        this.energyList = new EnergyList(this);
    }

}

/**
 * Define solar energy smart contract by extending Fabric Contract class
 *
 */
class EnergyContract extends Contract {

    constructor() {
        // Unique namespace when multiple contracts per chaincode file
        super('org.solarnet.solarenergy');
    }

    /**
     * Define a custom context for solar energy
    */
    createContext() {
        return new EnergyContext();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be required.
     * @param {Context} ctx the transaction context
     */
    async instantiate(ctx) {
        // No implementation required with this example
        // It could be where data migration is performed, if necessary
        console.log('Instantiate the contract');
    }

    /**
     * Issue solar energy
     *
     * @param {Context} ctx the transaction context
     * @param {String} seller solar energy seller
     * @param {Integer} energyNumber energy number for this seller
     * @param {String} sellDateTime energy sell date
     * @param {String} expiredDateTime energy expired date
     * @param {Integer} faceValue face value of energy
    */


    async sell(ctx, seller, energyNumber, sellDateTime, expiredDateTime, faceValue) {
        let energyKey = Energy.makeKey([seller, energyNumber]);
        let isEnergy = await ctx.energyList.getEnergy(energyKey);

        if (isEnergy) {
            throw new Error('\nPlease use an unique ID: ' + seller + energyNumber + ' has already been used. ');
        }

        // create an instance of the energy
        let energy = Energy.createInstance(seller, energyNumber, sellDateTime, expiredDateTime, parseInt(faceValue));

        // Smart contract, rather than energy, moves energy into SELLING state
        energy.setSelling();

        // save the owner's MSP 
        let mspid = ctx.clientIdentity.getMSPID();
        energy.setOwnerMSP(mspid);

        // Newly selld energy is owned by the seller to begin with (recorded for reporting purposes)
        energy.setOwner(seller);

        // Add the energy to the list of all similar solar energys in the ledger world state
        await ctx.energyList.addEnergy(energy);

        // Must return a serialized energy to caller of smart contract
        return energy;
    }

    /**
     * Buy solar energy
     *
      * @param {Context} ctx the transaction context
      * @param {String} seller solar energy seller
      * @param {Integer} energyNumber energy number for this seller
      * @param {String} currentOwner current owner of energy
      * @param {String} newOwner new owner of energy
      * @param {Integer} price price paid for this energy // transaction input - not written to asset
      * @param {String} purchaseDateTime time energy was purchased (i.e. traded)  // transaction input - not written to asset
     */
    async buy(ctx, seller, energyNumber, newOwner, price, purchaseDateTime) {

        // Retrieve the current energy using key fields provided
        let energyKey = Energy.makeKey([seller, energyNumber]);
        let energy = await ctx.energyList.getEnergy(energyKey);

        // Validate current owner
        if (energy.getOwner() !== seller) {
            throw new Error('\nEnergy ' + seller + energyNumber + ' is not owned by ' + seller);
        }

        // First buy moves state from SELLING to TRANSFER (when running )
        if (energy.isSelling()) {
            energy.setBought();
        } else {
            throw new Error('\nTransaktion ' + seller + energyNumber + ' is not available for sale.');
        }

        // Check energy is not already REDEEMED
        if (energy.isBought()) {
            energy.setOwner(newOwner);
            // save the owner's MSP 
            let mspid = ctx.clientIdentity.getMSPID();
            energy.setOwnerMSP(mspid);
        } else {
            throw new Error('\nEnergy ' + seller + energyNumber + ' is not trading. Current state = ' + energy.getCurrentState());
        }

        // Update the energy
        await ctx.energyList.updateEnergy(energy);
        return energy;
    }

    /**
      *  Buy request:  (2-phase confirmation: solar energy is 'PENDING' subject to completion of transfer by owning org)
      *  Alternative to 'buy' transaction
      *  Note: 'buy_request' puts energy in 'PENDING' state - subject to transfer confirmation [below].
      * 
      * @param {Context} ctx the transaction context
      * @param {String} seller solar energy seller
      * @param {Integer} energyNumber energy number for this seller
      * @param {String} currentOwner current owner of energy
      * @param {String} newOwner new owner of energy                              // transaction input - not written to asset per se - but written to block
      * @param {Integer} price price paid for this energy                         // transaction input - not written to asset per se - but written to block
      * @param {String} purchaseDateTime time energy was requested                // transaction input - ditto.
     */
    async buy_request(ctx, seller, energyNumber, currentOwner, newOwner, price, purchaseDateTime) {


        // Retrieve the current energy using key fields provided
        let energyKey = Energy.makeKey([seller, energyNumber]);
        let energy = await ctx.energyList.getEnergy(energyKey);

        // Validate current owner - this is really information for the user trying the sample, rather than any 'authorisation' check per se FYI
        if (energy.getOwner() !== currentOwner) {
            throw new Error('\nEnergy ' + seller + energyNumber + ' is not owned by ' + currentOwner + ' provided as a paraneter');
        }
        // energy set to 'PENDING' - can only be transferred (confirmed) by identity from owning org (MSP check).
        energy.setPending();

        // Update the energy
        await ctx.energyList.updateEnergy(energy);
        return energy;
    }

    // Query transactions

    /**
     * Query history of a solar energy
     * @param {Context} ctx the transaction context
     * @param {String} seller solar energy seller
     * @param {Integer} energyNumber energy number for this seller
    */
    async queryHistory(ctx, seller, energyNumber) {

        // Get a key to be used for History query

        let query = new QueryUtils(ctx, 'org.solarnet.solarenergy');
        let results = await query.getAssetHistory(seller, energyNumber); // (cpKey);
        return results;

    }

    /**
    * queryOwner solar energy: supply name of owning org, to find list of energys based on owner field
    * @param {Context} ctx the transaction context
    * @param {String} owner solar energy owner
    */
    async queryOwner(ctx, owner) {

        let query = new QueryUtils(ctx, 'org.solarnet.solarenergy');
        let owner_results = await query.queryKeyByOwner(owner);

        return owner_results;
    }

    /**
    * queryPartial solar energy - provide a prefix eg. "DigiBank" will list all energys _selld_ by DigiBank etc etc
    * @param {Context} ctx the transaction context
    * @param {String} prefix asset class prefix (added to energylist namespace) eg. org.solarnet.solarenergyMagnetoCorp asset listing: energys selld by MagnetoCorp.
    */
    async queryPartial(ctx, prefix) {

        let query = new QueryUtils(ctx, 'org.solarnet.solarenergy');
        let partial_results = await query.queryKeyByPartial(prefix);

        return partial_results;
    }

    /**
    * queryAdHoc solar energy - supply a custom mango query
    * eg - as supplied as a param:     
    * ex1:  ["{\"selector\":{\"faceValue\":{\"$lt\":8000000}}}"]
    * ex2:  ["{\"selector\":{\"faceValue\":{\"$gt\":4999999}}}"]
    * 
    * @param {Context} ctx the transaction context
    * @param {String} queryString querystring
    */
    async queryAdhoc(ctx, queryString) {

        let query = new QueryUtils(ctx, 'org.solarnet.solarenergy');
        let querySelector = JSON.parse(queryString);
        let adhoc_results = await query.queryByAdhoc(querySelector);

        return adhoc_results;
    }


    /**
     * queryNamed - supply named query - 'case' statement chooses selector to build (pre-canned for demo purposes)
     * @param {Context} ctx the transaction context
     * @param {String} queryname the 'named' query (built here) - or - the adHoc query string, provided as a parameter
     */
    async queryNamed(ctx, queryname) {
        let querySelector = {};
        switch (queryname) {
            case "SELLING":
                querySelector = { "selector": { "currentState": 1 } };  // 4 = redeemd state
                break;
            case "BOUGHT":
                querySelector = { "selector": { "currentState": 2 } };  // 3 = trading state
                break;
            case "value":
                // may change to provide as a param - fixed value for now in this sample
                querySelector = { "selector": { "faceValue": { "$gt": 4000000 } } };  // to test, sell CommEnergys with faceValue <= or => this figure.
                break;
            default: // else, unknown named query
                throw new Error('invalid named query supplied: ' + queryname + '- please try again ');
        }

        let query = new QueryUtils(ctx, 'org.solarnet.solarenergy');
        let adhoc_results = await query.queryByAdhoc(querySelector);

        return adhoc_results;
    }


    async create_Energy(ctx, owner, energyNumber, sellDateTime , expiredDateTime, faceValue) {
       //checks if ID is taken
        let energyKey = Energy.makeKey([owner, energyNumber]);
        let isEnergy = await ctx.energyList.getEnergy(energyKey);

        if (isEnergy) {
            throw new Error('\nPlease use an unique ID: ' + owner + energyNumber + ' has already been used. ');
        }

        // create an instance of the energy
        let energy = Energy.createInstance(owner, energyNumber, sellDateTime, expiredDateTime, parseInt(faceValue));

        // Smart contract, rather than energy, moves energy into SELLING state
        //energy.setSelling();

        // save the owner's MSP 
        let mspid = ctx.clientIdentity.getMSPID();
        energy.setOwnerMSP(mspid);

        // Newly selld energy is owned by the seller to begin with (recorded for reporting purposes)
        energy.setOwner(owner);

        // Add the energy to the list of all similar solar energys in the ledger world state
        await ctx.energyList.addEnergy(energy);

        // Must return a serialized energy to caller of smart contract
        return energy;
    }

}

module.exports = EnergyContract;
