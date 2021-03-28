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

    async nextID() {
        let id = await this.ctx.stub.getState('energyID');

        if (!id || id.length === 0) {
            // If the buffer is empty: init id with 1.
            id = '1';
        }

        // Increment ID by one.
        await this.ctx.stub.putState('energyID', Buffer.from(String(Number(id) + 1)));

        // Return padded string like: "00001".
        return String(id).padStart(5, '0');
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
