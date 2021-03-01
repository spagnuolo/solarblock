<script lang="ts">
    let promise = getAllSelling();

    async function getAllSelling() {
        const response = await fetch("http://localhost:8080/getSelling");
        const data = await response.json();

        if (response.ok) {
            return data;
        } else {
            throw new Error("Couldn't fetch data.");
        }
    }
</script>

<div class="bg-gray-100 w-full h-full shadow-lg text-lg">
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
                    <tr class="hover:bg-gray-600 hover:text-gray-100">
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
