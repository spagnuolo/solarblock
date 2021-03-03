<script lang="ts">
    export let txn;
</script>

<table class="w-full text-left mx-1">
    <tr>
        <th>Key:</th>
        <td>{txn.Key}</td>
    </tr>
    <tr>
        <th>class:</th>
        <td>{txn.Record.class}</td>
    </tr>
    <tr>
        <th>currentState:</th>
        <td>{txn.Record.currentState}</td>
    </tr>
    <tr>
        <th>energyNumber:</th>
        <td>{txn.Record.energyNumber}</td>
    </tr>
    <tr>
        <th>expiredDateTime:</th>
        <td>{txn.Record.expiredDateTime}</td>
    </tr>
    <tr>
        <th>faceValue:</th>
        <td>{txn.Record.faceValue}</td>
    </tr>
    <tr>
        <th>mspid:</th>
        <td>{txn.Record.mspid}</td>
    </tr>
    <tr>
        <th>owner:</th>
        <td>{txn.Record.owner}</td>
    </tr>
    <tr>
        <th>sellDateTime:</th>
        <td>{txn.Record.sellDateTime}</td>
    </tr>
    <tr>
        <th>seller:</th>
        <td>{txn.Record.seller}</td>
    </tr>
</table>
