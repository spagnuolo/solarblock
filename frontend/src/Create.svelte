<script lang="ts">
    import PostButton from "./PostButton.svelte";
    let organisation = [
        "OrgHaushaltA",
        "OrgHaushaltB",
        "OrgHaushaltC",
        "OrgNetzbetreiber",
    ];

    let postBody = {
        capacity: "",
        energyNumber: "",
        newOwner: "",
    };
</script>

<!-- Main form -->
<div
    class="svg-bg bg-gray-200 w-full h-full text-lg shadow-inner flex justify-center overflow-hidden"
>
    <div class="w-full lg:w-1/2 p-2">
        <div class="my-10 text-3xl">Erstelle Energie</div>
        <div />
        <input
            placeholder="Kapazität in kWh, bspw. 120"
            bind:value={postBody.capacity}
        />
        <input
            placeholder="Energie ID, bspw. 00042"
            bind:value={postBody.energyNumber}
        />
        <select bind:value={postBody.newOwner}>
            <option value="" selected disabled
                >Wähle die Organisation des neuen Besitzers</option
            >
            {#each organisation as org}
                <option value={org}>{org}</option>
            {/each}
        </select>
        <PostButton
            label="Create"
            url="http://localhost:8000/createEnergy"
            json={postBody}
        />
    </div>
</div>

<style>
    input,
    select {
        @apply block w-full my-2 p-4 bg-white hover:bg-gray-100 rounded text-right appearance-none;
    }
</style>
