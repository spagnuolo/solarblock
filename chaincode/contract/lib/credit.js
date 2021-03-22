'use strict';

// Utility class for ledger state
const State = require('../ledger-api/state.js');

// Enumerate credit Wallet state values
const energyState = {
    neutral: 0,
};


/**
 * Credit class extends State Class
 * Class wil be used to represent the abstraction of an virtual wallet containing an abstraction
 * of monetary value within our Systhem
 */
class Credit extends State{

    constructor(obj) {
        super(Credit.getClass(), [obj.organization]);
        Object.assign(this, obj);
    }

    getOrganization() {
        return this.organization;
    }

    getAmount() {
        return this.amountOfCredits;
    }

    setAmount(newAmountOfCredits) {
        this.amountOfCredits = newAmountOfCredits;
    }


    //Buffermethods

    static fromBuffer(buffer) {
        return Credit.deserialize(buffer);
    }

    toBuffer() {
        return Credit.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to Credits
     * @param {Buffer} data to form back into the object
     */
     static deserialize(data) {
        return State.deserializeClass(data, Credit);
    }

    /**
     * 
     * @param {String} organization Organisation that the Wallet belongs to
     * @param {Int} creditID  Unique Identifier of the Wallet
     * @param {Int} amountOfCredits Credits that the Wallet holds
     * @returns 
     */
     static createInstance(organization,  amountOfCredits) {
        return new Credit({ organization,  amountOfCredits});
    }

    static getClass() {
        return 'org.solarnet.solarenergy';
    }

}

module.exports = Credit;