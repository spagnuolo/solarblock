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
        newOwner: "",
    };
</script>

<!-- Main form -->
<div
    class="svg-bg bg-gray-200 w-full h-full text-lg shadow-inner flex justify-center overflow-hidden"
>
    <div class="w-full lg:w-1/2 p-2">
        <div class="p-2 bg-blue-200 rounded-lg">
            <div class="my-2 text-3xl">Erstelle Energie</div>
            <div />
            <input
                placeholder="Kapazität in kWh, bspw. 120"
                bind:value={postBody.capacity}
            />
            <select bind:value={postBody.newOwner}>
                <option value="" selected disabled
                    >Wähle die Organisation des neuen Besitzers</option
                >
                {#each organisation as org}
                    <option value={org}>{org}</option>
                {/each}
            </select>
            <PostButton label="Create" url="/createEnergy" json={postBody} />
        </div>
    </div>
</div>

<style>
    input,
    select {
        @apply block w-full my-2 p-4 bg-white hover:bg-gray-100 rounded text-right appearance-none;
    }
</style>
