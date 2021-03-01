<script lang="ts">
    let transactions = null;
    let promise = getAllSelling();
    async function getAllSelling() {
        const response = await fetch("http://localhost:8080/getSelling");
        transactions = await response.json();

        if (response.ok) {
            return transactions;
        } else {
            throw new Error("Couldn't fetch data.");
        }
    }

    let txn = null;
    const chooseTransaction = (index) => {
        txn = transactions[index];
    };
</script>

<!-- left control -->
<div class="bg-gray-200 md:w-1/4 h-full">
    {#if txn}
        <p>{txn.Key}</p>
        <p>{txn.Record.class}</p>
        <p>{txn.Record.currentState}</p>
        <p>{txn.Record.energyNumber}</p>
        <p>{txn.Record.expiredDateTime}</p>
        <p>{txn.Record.faceValue}</p>
        <p>{txn.Record.mspid}</p>
        <p>{txn.Record.owner}</p>
        <p>{txn.Record.sellDateTime}</p>
        <p>{txn.Record.seller}</p>
    {/if}
</div>

<!-- right main window -->
<div class="bg-gray-100 w-full h-full shadow-lg text-lg">
    <div class="my-10 text-3xl ml-10">Markplatz</div>
    {#await promise}
        <p>...waiting</p>
    {:then data}
        <table class="table-auto w-full">
            <thead>
                <tr>
                    <th><abbr title="Position">Pos</abbr></th>
                    <th>ID</th>
                    <th>Menge</th>
                    <th>Verkäufer</th>
                    <th>Datum</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                    <th><abbr title="Position">Pos</abbr></th>
                    <th>ID</th>
                    <th>Menge</th>
                    <th>Verkäufer</th>
                    <th>Datum</th>
                </tr>
            </tfoot>
            <tbody class="text-center">
                {#each data as entry, i}
                    <tr
                        class="{''} hover:bg-gray-600 hover:text-gray-100 cursor-pointer active:bg-blue-500"
                        on:click={() => {
                            chooseTransaction(i);
                        }}
                    >
                        <th>{i + 1}</th>
                        <td>{entry["Record"].energyNumber}</td>
                        <td>{entry["Record"].faceValue} kWh</td>
                        <td>{entry["Record"].seller}</td>
                        <td>{entry["Record"].sellDateTime}</td>
                    </tr>
                {/each}
            </tbody>
        </table>
    {:catch error}
        <p class="bg-red-600 text-gray-100 m-auto">{error.message}</p>
    {/await}
</div>
