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

<div class="bg-gray-100 w-full h-full rounded-l-lg shadow-lg text-lg">
    {#await promise}
        <p>...waiting</p>
    {:then data}
        {#each data as entry}
            <p>
                {entry["Record"].energyNumber}
                {entry["Record"].seller}
                {entry["Record"].faceValue} kWh
            </p>
        {/each}
    {:catch error}
        <p style="color: red">{error.message}</p>
    {/await}
</div>
