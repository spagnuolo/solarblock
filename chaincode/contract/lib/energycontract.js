'use strict';

const { Contract, Context } = require('fabric-contract-api');
const Energy = require('./energy.js');
const EnergyList = require('./energylist.js');
const CreditWallets = require('./creditwallets.js');
const QueryUtils = require('./queries.js');

class EnergyContext extends Context {
    constructor() {
        super();
        this.energyList = new EnergyList(this);
        this.creditWallets = new CreditWallets(this);
    }
}

class EnergyContract extends Contract {
    constructor() {
        // Unique namespace when multiple contracts per chaincode file
        super('org.solarnet.solarenergy');
    }

    createContext() {
        return new EnergyContext();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be required.
     * @param {Context} ctx the transaction context
     */
    async instantiate(ctx) {
        // Gurantee that this method is only called once!
        let initialized = await ctx.stub.getState('isInitialized');
        if (String(initialized) === 'initialized') throw new Error('\ninstantiate may only be called once.');
        await ctx.stub.putState('isInitialized', Buffer.from('initialized'));

        // Init credit wallets
        await ctx.creditWallets.init();
    }

    /**
     * @param {Context} ctx the transaction context
     */
    async getCredits(ctx) {
        let organization = ctx.clientIdentity.getMSPID().replace("MSP", "");
        return ctx.creditWallets.getCredits(organization);
    }

    /**
     * Creat new energy. Only the "Netzbetreiber" is allowed to use this function.
     * @param {Context} ctx contracts of the transaction
     * @param {String} owner organisation for whom the i.r. Netzbetreiber
     * @param {String} capacity 
     * @returns 
     */
    async create(ctx, owner, capacity) {
        if (ctx.clientIdentity.getMSPID() !== 'OrgNetzbetreiberMSP') {
            throw new Error('\nNo permission to create energy.');
        }

        // Create an instance of the energy.
        let energyNumber = await ctx.energyList.nextID();
        let energy = Energy.createInstance(owner, energyNumber, '-', '-', Number(capacity));

        // Set new owner.
        energy.setOwnerMSP(owner + 'MSP');
        energy.setOwner(owner);

        // Add the energy to the list in the ledger world state.
        await ctx.energyList.addEnergy(energy);

        // Must return a serialized energy to caller of smart contract.
        return energy;
    }

    /**
     * Creat new energy. Only the "Netzbetreiber" is allowed to use this function.
     * @param {Context} ctx contracts of the transaction
     * @param {String} owner organization for whom the i.r. Netzbetreiber
     * @param {String} energyNumber unique identifyer of the asset
     * @param {String} splitAmount 
     * @returns 
     */
    async split(ctx, owner, energyNumber, splitAmount) {
        // Is the caller the owner of this asset?
        let organization = ctx.clientIdentity.getMSPID().replace("MSP", "");
        if (organization !== owner) {
            throw new Error("\nYou don't own this asset.");
        }

        // Get energy and check if energy asset exists.
        let energyKey = Energy.makeKey([energyNumber]);
        let energy = await ctx.energyList.getEnergy(energyKey);
        if (!energy) {
            throw new Error('\nThere is no ' + owner + energyNumber + ' energy asset.');
        }

        // Can I split by splitAmount?
        let amount = Math.abs(Number(splitAmount));
        let rest = energy.getCapacity() - amount;
        if (rest <= 0) {
            throw new Error(`\n Can't split ${energy.getCapacity()} by ${splitAmount}!`);
        }

        // Reduce asset by requested amount.
        energy.setCapacity(rest);
        await ctx.energyList.updateEnergy(energy);

        // Create new asset with split amount
        let nextEnergyNumber = await ctx.energyList.nextID();
        let splitedEnergy = Energy.createInstance(owner, nextEnergyNumber, '-', '-', amount);
        splitedEnergy.setOwnerMSP(owner + 'MSP');
        splitedEnergy.setOwner(owner);
        await ctx.energyList.addEnergy(splitedEnergy);

        // Return a serialized energy to caller of smart contract.
        return splitedEnergy;
    }

    /**
     * Sell solar energy.
     *
     * @param {Context} ctx the transaction context
     * @param {String} seller solar energy seller
     * @param {String} energyNumber energy number for this seller
     * @param {String} price face value of energy
     */
    async sell(ctx, seller, energyNumber, price) {
        let energyKey = Energy.makeKey([energyNumber]);
        let energy = await ctx.energyList.getEnergy(energyKey);

        if (!energy) {
            throw new Error('\nThis asset does not exist: ' + seller + energyNumber);
        }

        // Get org out of context.
        let organisation = ctx.clientIdentity.getMSPID().replace("MSP", "");
        if (organisation !== seller) {
            throw new Error("\nYou don't own this asset.");
        }

        // Smart contract, rather than energy, moves energy into SELLING state.
        energy.setSelling();
        energy.setSellDateTime(new Date().toUTCString());
        energy.setPrice(Math.abs(Number(price)));
        await ctx.energyList.updateEnergy(energy);

        // Must return a serialized energy to caller of smart contract.
        return energy;
    }

    /**
     * Buy solar energy
     *
     * @param {Context} ctx the transaction context
     * @param {Integer} energyNumber energy number for this seller
     * @param {String} newOwner new owner of energy
     */
    async buy(ctx, energyNumber) {
        // Get new owner from context.
        let newOwner = ctx.clientIdentity.getMSPID().replace("MSP", "");

        // Retrieve the current energy using key fields provided.
        let energyKey = Energy.makeKey([energyNumber]);
        let energy = await ctx.energyList.getEnergy(energyKey);

        // Credit check.
        let price = Number(energy.getPrice());
        let newOwnerCredits = await ctx.creditWallets.getCredits(newOwner);

        console.log(`${newOwnerCredits} - ${price}`);
        if (newOwnerCredits < price) {
            throw new Error("\nYou don't have enough balance to make this purchase");
        }

        // First buy moves state from SELLING to BOUGHT.
        if (energy.isSelling()) {
            energy.setBought();
        } else {
            throw new Error('\nTransaktion ' + energyNumber + ' is not available for sale.');
        }

        // Add price to seller.
        let seller = energy.getOwner();
        await ctx.creditWallets.addCredits(seller, price);

        // Subract price from newOwner.
        await ctx.creditWallets.addCredits(newOwner, -price);

        // Transfer energy asset.
        energy.setOwner(newOwner);
        energy.setOwnerMSP(ctx.clientIdentity.getMSPID());

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
    async buyRequest(ctx, seller, energyNumber, currentOwner, newOwner, price, purchaseDateTime) {
        // Retrieve the current energy using key fields provided
        let energyKey = Energy.makeKey([energyNumber]);
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
    * ex1:  ["{\"selector\":{\"capacity\":{\"$lt\":8000000}}}"]
    * ex2:  ["{\"selector\":{\"capacity\":{\"$gt\":4999999}}}"]
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
                querySelector = { "selector": { "capacity": { "$gt": 4000000 } } };  // to test, sell CommEnergys with capacity <= or => this figure.
                break;
            default: // else, unknown named query
                throw new Error('invalid named query supplied: ' + queryname + '- please try again ');
        }

        let query = new QueryUtils(ctx, 'org.solarnet.solarenergy');
        let adhoc_results = await query.queryByAdhoc(querySelector);

        return adhoc_results;
    }
}

module.exports = EnergyContract;
