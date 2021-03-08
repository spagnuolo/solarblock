<script lang="ts">
    import PostButton from "./PostButton.svelte";
    import Table from "./Table.svelte";
    import Transaktion from "./Transaktion.svelte";

    let txn;
</script>

<!-- left control -->
<div class="bg-gray-200 w-1/4 h-full text-lg shadow-inner">
    <div class="title">Kaufen</div>
    {#if txn}
        <Transaktion bind:txn />
        <div class="m-full p-2">
            <PostButton
                label="Kaufen?"
                url="http://localhost:8080/buyEnergy"
                json={{
                    seller: txn.Record.seller,
                    energyNumber: txn.Record.energyNumber,
                }}
            />
        </div>
    {:else}
        <p class="bg-blue-300 text-center">Wähle ein Angebot aus.</p>
    {/if}
</div>

<!-- right main window -->
<div class="bg-gray-100 w-full h-full text-lg">
    <div class="title">Markplatz</div>
    <Table bind:txn fetchURL={"http://localhost:8080/getSelling"} />
</div>

<style lang="postcss">
    .title {
        @apply my-10 text-3xl ml-10;
    }
</style>
