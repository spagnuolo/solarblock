<script lang="ts">
    import PostButton from "./PostButton.svelte";
    import Table from "./Table.svelte";
    import Transaktion from "./Transaktion.svelte";

    export let credits = 0;

    let txn;
</script>

<!-- left control -->
<div class="bg-gray-200 w-1/3 h-full text-lg shadow-inner svg-bg">
    <div class="m-1 bg-blue-200 rounded-lg">
        <div class="title">Kaufen</div>
        {#if txn}
            <Transaktion {txn} />
            <div class="m-full p-2">
                <PostButton
                    label="Kaufen?"
                    url="/buyEnergy"
                    json={{
                        seller: txn.Record.seller,
                        energyNumber: txn.Record.energyNumber,
                    }}
                />
            </div>
        {:else}
            <p class="p-2 text-center">Wähle ein Angebot aus.</p>
        {/if}
    </div>
    <div class="mx-1 mt-4 p-2 bg-blue-200 text-center rounded-lg">
        <div><b>Credits:</b> {credits}c</div>
    </div>
</div>

<!-- right main window -->
<div class="bg-gray-100 w-full h-full text-lg">
    <div class="title">Markplatz</div>
    <Table bind:txn fetchURL={"/getSelling"} />
</div>

<style lang="postcss">
    .title {
        @apply my-10 text-3xl ml-10;
    }
</style>
