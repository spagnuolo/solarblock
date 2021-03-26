<script lang="ts">
    import PostButton from "./PostButton.svelte";
    import Table from "./Table.svelte";
    import Transaktion from "./Transaktion.svelte";

    export let credits = 0;

    let txn;
    let splitAmount = "";
    let balance = 0;
</script>

<!-- left control -->
<div class="bg-gray-200 w-1/3 h-full text-lg shadow-inner svg-bg">
    <div class="m-1 bg-blue-200 rounded-lg">
        <div class="title">Energie Info</div>
        {#if txn}
            <Transaktion {txn} />
            <div class="m-full p-2">
                <input
                    class="block w-full my-2 -mb-2 p-2 bg-white hover:bg-gray-100 rounded text-center appearance-none"
                    placeholder="Energie aufspalten, bspw. 100"
                    bind:value={splitAmount}
                />
                <PostButton
                    label="Splitten"
                    url="/splitEnergy"
                    json={{
                        owner: txn.Record.owner,
                        energyNumber: txn.Record.energyNumber,
                        splitAmount,
                    }}
                    active={Number(splitAmount) ? true : false}
                />
                <input
                    class="block w-full my-2 -mb-2 p-2 bg-white hover:bg-gray-100 rounded text-center appearance-none"
                    placeholder="Verkaufswert in Credits, bspw. 3"
                    bind:value={credits}
                />
                <PostButton
                    label="Verkaufen"
                    url="/sellEnergy"
                    json={{
                        energyNumber: txn.Record.energyNumber,
                        credits,
                    }}
                />
            </div>
        {:else}
            <p class="p-2 text-center">Wähle einen Eintrag aus.</p>
        {/if}
    </div>
    <div class="mx-1 mt-4 p-2 bg-blue-200 text-center rounded-lg">
        <div><b>Credits:</b> {credits}c</div>
        <div><b>Energiebalance:</b> {balance} kWh</div>
    </div>
</div>

<!-- right main window -->
<div class="bg-gray-100 w-full h-full text-lg">
    <div class="title">Meine Energie</div>
    <Table bind:txn bind:sum={balance} fetchURL={"/getOwn"} />

    <div class="title">Energie die ich verkaufe</div>
    <Table bind:txn fetchURL={"/getOwnSelling"} />
</div>

<style lang="postcss">
    .title {
        @apply my-10 text-3xl ml-10;
    }
</style>
