<script lang="ts">
    import PostButton from "./PostButton.svelte";
    import Table from "./Table.svelte";
    import Transaktion from "./Transaktion.svelte";

    let txn;
</script>

<!-- left control -->
<div class="bg-gray-200 w-1/3 h-full text-lg shadow-inner svg-bg">
    <div class="m-1 bg-blue-200 rounded-lg">
        <div class="title">Kaufen</div>
        {#if txn}
            <Transaktion bind:txn />
            <div class="m-full p-2">
                <PostButton
                    label="Kaufen?"
                    url="http://localhost:8000/buyEnergy"
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
</div>

<!-- right main window -->
<div class="bg-gray-100 w-full h-full text-lg">
    <div class="title">Markplatz</div>
    <Table bind:txn fetchURL={"http://localhost:8000/getSelling"} />
</div>

<style lang="postcss">
    .title {
        @apply my-10 text-3xl ml-10;
    }
</style>
