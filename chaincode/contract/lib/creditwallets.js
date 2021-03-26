'use strict';

class CreditWallets {
    constructor(ctx) {
        this.ctx = ctx;
    }

    async init() {
        let wallets = [
            {
                org: 'OrgNetzbetreiber',
                credits: 200,
            },
            {
                org: 'OrgHaushaltA',
                credits: 100,
            },
            {
                org: 'OrgHaushaltB',
                credits: 100,
            },
            {
                org: 'OrgHaushaltC',
                credits: 100,
            },
        ];

        for (let wallet of wallets) {
            await this.addWallet(wallet);
        }
    }

    // Is also updateWallet.
    async addWallet(wallet) {
        await this.ctx.stub.putState(wallet.org, Buffer.from(JSON.stringify(wallet)));
    }

    async getWallet(organization) {
        let buffer = await this.ctx.stub.getState(organization);
        return JSON.parse(buffer.toString());
    }

    async addCredits(organization, credits) {
        let wallet = await this.getWallet(organization);
        wallet.credits = wallet.credits + credits;
        await this.addWallet(wallet);
    }

    async getCredits(organization) {
        let wallet = await this.getWallet(organization);
        return wallet.credits;
    }

    async setCredits(organization, credits) {
        let wallet = await this.getWallet(organization);
        wallet.credits = credits;
        await this.addWallet(wallet);
    }
}

module.exports = CreditWallets;
