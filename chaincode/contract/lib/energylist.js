/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('./../ledger-api/statelist.js');

const Energy = require('./energy.js');

class EnergyList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.solarnet.solarenergy');
        this.use(Energy);
    }

    async addEnergy(energy) {
        return this.addState(energy);
    }

    async getEnergy(energyKey) {
        return this.getState(energyKey);
    }

    async updateEnergy(energy) {
        return this.updateState(energy);
    }
}


module.exports = EnergyList;
