'use strict';

// Utility class for ledger state
const State = require('../ledger-api/state.js');

/**
 * Credit class extends State Class
 * Class wil be used to represent the abstraction of an virtual wallet containing an abstraction
 * of monetary value within our Systhem
 */
class Credit extends State {

    constructor(obj) {
        super(Credit.getClass(), [obj.owner]);
        Object.assign(this, obj);
    }

    getowner() {
        return this.owner;
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
     * @param {String} owner Organisation that the Wallet belongs to
     * @param {Int} amountOfCredits Credits that the Wallet holds
     * @returns 
     */
    static createInstance(owner, amountOfCredits) {
        return new Credit({ owner, amountOfCredits });
    }

    static getClass() {
        return 'org.solarnet.solarcredit';
    }

}

module.exports = Credit;