'use strict';

// Utility class for ledger state
const State = require('./../ledger-api/state.js');

// Enumerate solar energy state values
const energyState = {
    SELLING: 1,
    BOUGHT: 2,
};

/**
 * Energy class extends State class
 * Class will be used by application and smart contract to define a energy
 */
class Energy extends State {

    constructor(obj) {
        super(Energy.getClass(), [obj.energyNumber]);
        Object.assign(this, obj);
    }

    getSeller() {
        return this.seller;
    }

    setSeller(newIssuer) {
        this.seller = newIssuer;
    }

    getCapacity() {
        return this.capacity;
    }

    setCapacity(newCapacity) {
        this.capacity = newCapacity;
    }

    getPrice() {
        return this.price;
    }

    setPrice(newPrice) {
        this.price = newPrice;
    }

    getSellDateTime() {
        return this.sellDateTime;
    }

    setSellDateTime(newSellDateTime) {
        this.sellDateTime = newSellDateTime;
    }

    getOwner() {
        return this.owner;
    }

    setOwnerMSP(mspid) {
        this.mspid = mspid;
    }

    getOwnerMSP() {
        return this.mspid;
    }

    setOwner(newOwner) {
        this.owner = newOwner;
    }

    /**
     * Useful methods to encapsulate solar energy states
     */
    setSelling() {
        this.currentState = energyState.SELLING;
    }

    setBought() {
        this.currentState = energyState.BOUGHT;
    }

    isSelling() {
        return this.currentState === energyState.SELLING;
    }

    isBought() {
        return this.currentState === energyState.BOUGHT;
    }

    static fromBuffer(buffer) {
        return Energy.deserialize(buffer);
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to solar energy
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, Energy);
    }

    /**
     * Factory method to create a solar energy object
     */
    static createInstance(seller, energyNumber, sellDateTime, expiredDateTime, capacity) {
        return new Energy({ seller, energyNumber, sellDateTime, expiredDateTime, capacity });
    }

    static getClass() {
        return 'org.solarnet.solarenergy';
    }
}

module.exports = Energy;
