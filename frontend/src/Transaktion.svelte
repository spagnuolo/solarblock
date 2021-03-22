<script lang="ts">
    export let txn = {
        Key: "",
        Record: {
            class: "",
            currentState: "",
            energyNumber: "",
            expiredDateTime: "",
            capacity: "",
            mspid: "",
            owner: "",
            sellDateTime: "",
            seller: "",
        },
    };

    const state = ["NEUTRAL", "SELLING", "BOUGHT"];
</script>

<table class="w-full">
    <tr>
        <th>ID:</th>
        <td>{txn.Record.energyNumber}</td>
    </tr>
    <tr>
        <th>Preis:</th>
        <td>0 Credits</td>
    </tr>
    <tr>
        <th>Status:</th>
        <td>{state[txn.Record.currentState]}</td>
    </tr>
    <tr>
        <th>Menge:</th>
        <td>{txn.Record.capacity} kWh</td>
    </tr>
    <tr>
        <th>Besiztzer:</th>
        <td>{txn.Record.owner}</td>
    </tr>
</table>

<style>
    th {
        @apply text-right pr-2;
    }
</style>
