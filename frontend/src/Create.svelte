<script lang="ts">
    import PostButton from "./PostButton.svelte";
    let postBody = {
        capacity: "",
        energyNumber: "",
        newOwner: "",
    };
</script>

<!-- left control -->
<div class="bg-gray-200 w-1/3 h-full text-lg shadow-inner">
    <div class="m-full p-2">
        <div class="my-10 text-3xl ml-10">Erstelle Energie</div>
        <div />
        <input
            class="w-full my-2 p-4 bg-gray-300 hover:bg-gray-100 rounded text-right appearance-none"
            placeholder="Kapazität, bspw. 120 kWh"
            bind:value={postBody.capacity}
            min="0"
        />
        <input
            class="w-full my-2 p-4 bg-gray-300 hover:bg-gray-100 rounded text-right appearance-none"
            placeholder="Energie ID, bspw. 00042"
            bind:value={postBody.energyNumber}
        />
        <input
            class="w-full my-2 p-4 bg-gray-300 hover:bg-gray-100 rounded text-right appearance-none"
            placeholder="Organisation des neuen Besitzers"
            bind:value={postBody.newOwner}
        />
        <PostButton
            label="Create"
            url="http://localhost:8000/createEnergy"
            json={postBody}
        />
    </div>
</div>
