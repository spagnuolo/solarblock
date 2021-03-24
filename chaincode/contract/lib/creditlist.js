/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('./../ledger-api/statelist.js');

const Credit = require('./credit.js');

class CreditList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.solarnet.solarcredit');
        this.use(Credit);
    }

    async addCredit(credit) {
        return this.addState(credit);
    }

    async getCredit(creditKey) {
        return this.getState(creditKey);
    }

    async updateCredit(credit) {
        return this.updateState(credit);
    }

}

module.exports = CreditList;