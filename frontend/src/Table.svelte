<script lang="ts">
    export let txn;
    export let fetchURL = "http://localhost:8000/getOwn";

    let transactions;
    let promise = getRequest();
    async function getRequest() {
        const response = await fetch(fetchURL);
        transactions = await response.json();

        if (response.ok) {
            return transactions;
        } else {
            throw new Error("Couldn't fetch data.");
        }
    }

    const chooseTransaction = (index) => {
        txn = transactions[index];
    };
</script>

{#await promise}
    <p class="text-center">...laden</p>
{:then data}
    <table class="table-auto w-full">
        <thead>
            <tr>
                <th><abbr title="Position">Pos</abbr></th>
                <th>ID</th>
                <th>Menge</th>
                <th>Besitzer</th>
                <th>Verkäufer</th>
                <th>Datum</th>
            </tr>
        </thead>

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
                    <td>{entry["Record"].capacity} kWh</td>
                    <td>{entry["Record"].owner}</td>
                    <td>{entry["Record"].seller}</td>
                    <td>{entry["Record"].sellDateTime}</td>
                </tr>
            {/each}
        </tbody>
        <tfoot>
            <!-- <tr>
                <th><abbr title="Position">Pos</abbr></th>
                <th>ID</th>
                <th>Menge</th>
                <th>Besitzer</th>
                <th>Verkäufer</th>
                <th>Datum</th>
            </tr> -->
        </tfoot>
    </table>
{:catch error}
    <p class="bg-red-600 text-gray-100 text-center">{error.message}</p>
{/await}
