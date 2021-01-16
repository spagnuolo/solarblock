/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for ledger state
const State = require('./../ledger-api/state.js');

// Enumerate solar energy state values
const cpState = {
    SELLING: 1,
    BOUGHT: 2,
};

/**
 * CommercialPaper class extends State class
 * Class will be used by application and smart contract to define a paper
 */
class CommercialPaper extends State {

    constructor(obj) {
        super(CommercialPaper.getClass(), [obj.issuer, obj.energyNumber]);
        Object.assign(this, obj);
    }

    /**
     * Basic getters and setters
    */
    getSeller() {
        return this.issuer;
    }

    setSeller(newIssuer) {
        this.issuer = newIssuer;
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
        this.currentState = cpState.SELLING;
    }

    setBought() {
        this.currentState = cpState.BOUGHT;
    }

    isSelling() {
        return this.currentState === cpState.SELLING;
    }

    isBought() {
        return this.currentState === cpState.BOUGHT;
    }

    static fromBuffer(buffer) {
        return CommercialPaper.deserialize(buffer);
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to solar energy
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, CommercialPaper);
    }

    /**
     * Factory method to create a solar energy object
     */
    static createInstance(issuer, energyNumber, issueDateTime, expiredDateTime, faceValue) {
        return new CommercialPaper({ issuer, energyNumber, issueDateTime, expiredDateTime, faceValue });
    }

    static getClass() {
        return 'org.solarnet.solarenergy';
    }
}

module.exports = CommercialPaper;
