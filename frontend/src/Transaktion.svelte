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
            price: "",
        },
    };

    const state = ["NEUTRAL", "SELLING", "BOUGHT"];
</script>

<table class="w-full">
    <tr>
        <th class="text-right pr-2">ID:</th>
        <td>{txn.Record.energyNumber}</td>
    </tr>
    <tr>
        <th class="text-right pr-2">Preis:</th>
        <td>{txn.Record.price} Credits</td>
    </tr>
    <tr>
        <th class="text-right pr-2">Status:</th>
        <td>{state[txn.Record.currentState]}</td>
    </tr>
    <tr>
        <th class="text-right pr-2">Menge:</th>
        <td>{txn.Record.capacity} kWh</td>
    </tr>
    <tr>
        <th class="text-right pr-2">Besiztzer:</th>
        <td>{txn.Record.owner}</td>
    </tr>
</table>
